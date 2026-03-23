import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'create_account_viewmodel.dart';
import 'package:go_router/go_router.dart';
import '../../../core/session/app_session.dart';

class CreateAccountView extends StatelessWidget {
  const CreateAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateAccountViewModel(),
      child: const _CreateAccountBody(),
    );
  }
}

class _CreateAccountBody extends StatelessWidget {
  const _CreateAccountBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateAccountViewModel>();
    final phone = context.watch<AppSession>().phoneNumber;
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

            const SizedBox(height: 30),

            const Text(
              "Create Account",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Your mobile has been registered\nEnter the below details to continue",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 40),

            /// NAME INPUT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text("Enter Your Name"),

                  const SizedBox(height: 8),

                  TextField(
                    decoration: InputDecoration(
                      hintText: "Name",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onChanged: (value) {
                      vm.updateName(value);
                    },
                  ),
                ],
              ),
            ),

            const Spacer(),

            /// TERMS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Checkbox(
                    value: vm.isChecked,
                    onChanged: vm.toggleCheck,
                  ),
                  const Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: "By registering, you agree to ",
                        children: [
                          TextSpan(
                            text: "terms & conditions",
                            style: TextStyle(color: Colors.orange),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

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

                  /// REGISTER
                  Expanded(
                    child: GestureDetector(
                      onTap: vm.isLoading
                          ? null
                          : () async {

                              if (!vm.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Complete all fields"),
                                  ),
                                );
                                return;
                              }

                              bool success = await vm.register();

                              if (success) {
                              
                                context.go('/biometric');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Account Created"),
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
                                  "Register",
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