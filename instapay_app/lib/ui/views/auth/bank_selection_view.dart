import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bank_selection_viewmodel.dart';
import 'package:go_router/go_router.dart';
import '../../../core/session/app_session.dart';

class BankSelectionView extends StatelessWidget {
  const BankSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BankSelectionViewModel(),
      child: const _BankSelectionBody(),
    );
  }
}

class _BankSelectionBody extends StatelessWidget {
  const _BankSelectionBody();

  @override
  Widget build(BuildContext context) {

    final phone = context.watch<AppSession>().phoneNumber;

    final vm = context.watch<BankSelectionViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          children: [

            /// TOP BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => context.go('/home'),
                    child: const Text(
                      "Skip to Home",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),

            /// LOGO
            const Text(
              "INSTAPAY",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5A2D82),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Select your Bank",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Your mobile number +20$phone must be registered at your bank.",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 20),

            /// SEARCH
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: vm.search,
                decoration: InputDecoration(
                  hintText: "Search for specific bank name",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// BANK LIST
            Expanded(
              child: ListView.builder(
                itemCount: vm.filteredBanks.length,
                itemBuilder: (context, index) {
                  final bank = vm.filteredBanks[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    child: GestureDetector(
                      onTap: () {
                          final session = context.read<AppSession>();

                          session.setBank(bank);  

                          context.go('/card');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.account_balance,
                                color: Colors.orange),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                bank,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}