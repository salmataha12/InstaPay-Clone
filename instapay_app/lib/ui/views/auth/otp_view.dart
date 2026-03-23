import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'otp_viewmodel.dart';
import 'package:go_router/go_router.dart';
import '../../../core/session/app_session.dart';

class OtpView extends StatelessWidget {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OtpViewModel(),
      child: const _OtpBody(),
    );
  }
}

class _OtpBody extends StatefulWidget {
  const _OtpBody();

  @override
  State<_OtpBody> createState() => _OtpBodyState();
}

class _OtpBodyState extends State<_OtpBody> {
  final List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());

  @override
  Widget build(BuildContext context) {

    
    final phone = context.watch<AppSession>().phoneNumber;

    final vm = context.watch<OtpViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [

              const SizedBox(height: 30),

              /// TITLE
              const Text(
                "Enter Verification Code",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 10),

              Text(
                "Enter the 6-digit code sent to +20$phone",
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 40),

              /// OTP INPUT
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    child: TextField(
                      controller: controllers[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: "",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(context).nextFocus();
                        }

                        String code =
                            controllers.map((e) => e.text).join();
                        vm.updateOtp(code);
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 30),

              /// TIMER / RESEND
              vm.canResend
                  ? TextButton(
                      onPressed: vm.resendOtp,
                      child: const Text("Resend Code"),
                    )
                  : Text(
                      "Resend in ${vm.secondsRemaining}s",
                      style: const TextStyle(color: Colors.grey),
                    ),

              const Spacer(),

              /// VERIFY BUTTON
              GestureDetector(
                onTap: vm.isLoading
                    ? null
                    : () async {
                        bool success = await vm.verifyOtp();

                        if (success) {

                         
                          context.go('/create-account');

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Verification Successful")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Invalid OTP")),
                          );
                        }
                      },
                child: Container(
                  height: 60,
                  width: double.infinity,
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
                            "Verify",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}