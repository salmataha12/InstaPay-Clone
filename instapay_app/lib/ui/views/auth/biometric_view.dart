import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'biometric_viewmodel.dart';
import 'package:go_router/go_router.dart';

class BiometricView extends StatelessWidget {
  const BiometricView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BiometricViewModel()..checkBiometricAvailability(),
      child: const _BiometricBody(),
    );
  }
}

class _BiometricBody extends StatelessWidget {
  const _BiometricBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BiometricViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          children: [

            const SizedBox(height: 20),

            const Text(
              "Welcome to",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),

            const SizedBox(height: 6),

            const Text(
              "INSTAPAY",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5A2D82),
              ),
            ),

            const SizedBox(height: 60),

            /// ICONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.fingerprint, size: 80, color: Color(0xFFFF7A00)),
                Icon(Icons.face, size: 80, color: Color(0xFFFF7A00)),
            ],
            ),

            const SizedBox(height: 40),

            const Text(
              "Your Safety and Security is Always Important",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "For your safety and security, we are going to use your mobile device default security to unlock the app and login",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),

            const Spacer(),

            /// FALLBACK PIN INPUT
            if (!vm.isBiometricAvailable)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const Text(
                      "Biometric not available. Please enter your 6-digit PIN:",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: 6,
                      decoration: InputDecoration(
                        hintText: "Enter PIN",
                        filled: true,
                        fillColor: Colors.white,
                        errorText: vm.errorMsg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onChanged: (value) {
                        vm.updatePin(value);
                      },
                    ),
                  ],
                ),
              ),

            /// BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: GestureDetector(
                onTap: vm.isAuthenticating
                    ? null
                    : () async {

                        bool success = await vm.authenticate();

                        if (success) {
                          context.go('/bank');
                        } else if (vm.errorMsg == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Authentication failed"),
                            ),
                          );
                        }
                      },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF7B2FF7),
                        Color(0xFF5A2D82),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: vm.isAuthenticating
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Proceed",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}