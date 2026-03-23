import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'signup_viewmodel.dart';
import 'package:go_router/go_router.dart';
import '../../../core/session/app_session.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignupViewModel(),
      child: const _SignUpBody(),
    );
  }
}

class _SignUpBody extends StatelessWidget {
  const _SignUpBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SignupViewModel>();

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

            const SizedBox(height: 40),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Select Mobile Number Linked To Your Bank",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// SIM CARD
            GestureDetector(
              onTap: () => vm.selectSim(1),
              child: Container(
                width: 140,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: vm.selectedSim == 1
                        ? const Color(0xFFFF7A00)
                        : Colors.grey.shade300,
                    width: 2,
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFF7A00).withOpacity(0.2),
                      ),
                      child: const Icon(
                        Icons.sim_card,
                        color: Color(0xFFFF7A00),
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "SIM 01",
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// PHONE INPUT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Enter your mobile number",
                  prefixText: "+20 ",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onChanged: (value) {
                  vm.updatePhone(value);
                },
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Note that:",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "To complete the registration process, an SMS will be sent to verify your mobile number",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),

            const Spacer(),

            /// BUTTONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [

                  /// BACK
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.purple.shade100,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => context.pop(),
                    ),
                  ),

                  const SizedBox(width: 15),

                  /// VERIFY BUTTON
                  Expanded(
                    child: GestureDetector(
                      onTap: vm.isLoading
                          ? null
                          : () async {

                              if (!vm.isValidEgyptianNumber()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Enter a valid Egyptian number"),
                                  ),
                                );
                                return;
                              }

                              bool success = await vm.sendOTP();

                              if (success) {

                                ///  SAVE PHONE IN SESSION
                                final session = context.read<AppSession>();
                                session.setPhone(vm.phoneNumber);

                                /// NAVIGATE
                                context.go('/otp');

                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Verification failed"),
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
                          child: vm.isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  "Verify Number",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}