import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'home_viewmodel.dart';
import '../../widgets/transaction_tile.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: const _HomeBody(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SingleChildScrollView(
        child: Column(
          children: [

            /// HEADER — exact same style as Send Money
            SizedBox(
              width: double.infinity,
              height: 160,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Purple gradient — identical to SendView
                  Container(
                    width: double.infinity,
                    height: 160,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF7B2FF7),
                          Color(0xFF9B59F5),
                          Color(0xFFB06EF8),
                        ],
                      ),
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
                    ),
                  ),
                  // Large orange circle — top-RIGHT (same as SendView)
                  Positioned(
                    top: -30,
                    right: -20,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35).withOpacity(0.75),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Smaller orange circle — right inset (same as SendView)
                  Positioned(
                    top: -10,
                    right: 60,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF8C42).withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Content overlay (greeting + icons)
                  Positioned.fill(
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  vm.getGreeting(),
                                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  vm.userName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => context.push('/transactions'),
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.white24,
                                    child: Icon(Icons.history, color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Stack(
                                  children: [
                                    const CircleAvatar(
                                      backgroundColor: Colors.white24,
                                      child: Icon(Icons.notifications, color: Colors.white),
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.orange,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Text(
                                          "8",
                                          style: TextStyle(fontSize: 10, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),


            const SizedBox(height: 20),

            /// 🔸 PAY BILLS IMAGE (ADDED)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/images/pay_bills.png',  // Add your image in assets
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// 🔸 DOT
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(height: 20),

            /// ACCOUNTS HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Accounts"),
                  Text("Manage", style: TextStyle(color: Colors.orange)),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// ACCOUNT CARD
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      const Icon(Icons.account_balance, color: Colors.orange),
                      const SizedBox(width: 10),
                      Expanded(child: Text(vm.account)),
                    ],
                  ),

                  const SizedBox(height: 5),

                  Text(
                    vm.accountType,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 15),

                  /// ACTIONS ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _AccountAction(Icons.qr_code, "QR Code"),
                      _AccountAction(Icons.share, "Link"),
                      _AccountAction(Icons.account_balance_wallet, "Balance"),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            ///  DOT
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(height: 20),

            /// SERVICES HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Services"),
                  Text("View All", style: TextStyle(color: Colors.orange)),
                ],
              ),
            ),

            const SizedBox(height: 15),

            /// SERVICES GRID (MODIFIED)
            GridView.builder(
              itemCount: vm.services.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final service = vm.services[index];

                return GestureDetector(
                  onTap: () {
                    final title = service["title"];
                    if (title == "Send Money") {
                      context.push('/send');
                    } else if (title == "Collect Money") {
                      context.push('/collect');
                    } else if (title == "Bill Payment") {
                      context.push('/bills');
                    } else if (title == "Transactions History") {
                      context.push('/transactions');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(service["icon"], color: Colors.orange),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        service["title"],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  ), 
                ); 
              },
            ),

            const SizedBox(height: 25),

            /// TRANSACTIONS HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Last Transactions"),
                  GestureDetector(
                    onTap: () => context.push('/transactions'),
                    child: const Text("View All", style: TextStyle(color: Colors.orange)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// TRANSACTIONS LIST 
            ListView.builder(
              itemCount: vm.transactions.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final tx = vm.transactions[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: TransactionTile(tx: tx, showBackground: true),
                );
              },
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _AccountAction extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AccountAction(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange, size: 20),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}