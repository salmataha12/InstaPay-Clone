import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/session/app_session.dart';
import 'transfer_success_viewmodel.dart';

class TransferSuccessView extends StatelessWidget {
  final Map<String, dynamic> transferData;

  const TransferSuccessView({super.key, required this.transferData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransferSuccessViewModel(),
      child: _TransferSuccessBody(transferData: transferData),
    );
  }
}

class _TransferSuccessBody extends StatelessWidget {
  final Map<String, dynamic> transferData;

  const _TransferSuccessBody({required this.transferData});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TransferSuccessViewModel>();
    final session = context.watch<AppSession>();
    final amount = transferData['amount']?.toString() ?? '0.00';
    final recipient = transferData['recipient'] ?? 'N/A';
    final recipientName = transferData['recipientName'] ?? 'Unknown';
    final type = transferData['type'] ?? 'Unknown';

    final fromBank = session.selectedBank.isNotEmpty ? session.selectedBank : 'National Bank of Egypt';
    final fromHandle = session.phoneNumber.isNotEmpty ? '${session.phoneNumber}@instapay' : 'my_account@instapay';

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC), // very faint blue-ish white
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => context.go('/home'),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: const Icon(Icons.keyboard_arrow_left, color: Colors.black, size: 24),
                      ),
                    ),
                  ),
                  const Text(
                    "Approved Transaction",
                    style: TextStyle(color: Color(0xFF1B2C41), fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    // Success Graphic
                    SizedBox(
                      height: 160,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: 20, right: 80,
                            child: CircleAvatar(radius: 8, backgroundColor: Colors.greenAccent.withOpacity(0.5)),
                          ),
                          Positioned(
                            bottom: 20, left: 90,
                            child: CircleAvatar(radius: 12, backgroundColor: Colors.green.shade400.withOpacity(0.6)),
                          ),
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.greenAccent.withOpacity(0.3),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                )
                              ],
                            ),
                            child: const Center(
                              child: Icon(Icons.check_rounded, color: Colors.greenAccent, size: 80),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                    const Text("Your transaction was successful", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF1B2C41))),
                    
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(amount, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black, height: 1)),
                        const SizedBox(width: 8),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 6),
                          child: Text("EGP", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFFFF8C42))),
                        ),
                      ],
                    ),
                    const Text("Transfer Amount", style: TextStyle(fontSize: 14, color: Colors.grey)),

                    const SizedBox(height: 24),

                    // Combined Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5)),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              children: [
                                _buildFromSection(fromBank, fromHandle),
                                Container(height: 1, color: Colors.grey.shade100),
                                _buildToSection(recipient, type, recipientName, vm),
                              ],
                            ),
                            // Green check badge divider
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.green.shade200),
                                ),
                                child: Icon(Icons.check, color: Colors.green.shade600, size: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // More Details Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("More Details", style: TextStyle(color: Color(0xFFFF8C42), fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down, color: Color(0xFFFF8C42), size: 18),
                      ],
                    ),

                    const SizedBox(height: 40),

                    const Text(
                      "POWERED BY",
                      style: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.w600, letterSpacing: 1),
                    ),
                    const Text(
                      "IPN",
                      style: TextStyle(fontSize: 24, color: Color(0xFF6F00FF), fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, height: 1),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            
            // Bottom Actions
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
              child: Row(
                children: [
                  // Share Button
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6F00FF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.ios_share_outlined, color: Color(0xFF6F00FF)),
                  ),
                  const SizedBox(width: 16),
                  
                  // Home Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Resets entirely to home tab
                        context.go('/home');
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5A00CC), // Darker purple
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            "Home",
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFromSection(String bankName, String handle) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.green.shade100),
            ),
            child: Icon(Icons.account_balance, color: Colors.green.shade700, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("From", style: TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(handle, style: const TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(bankName, style: const TextStyle(fontSize: 11, color: Colors.grey, letterSpacing: 0.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToSection(String recipient, String type, String recipientName, TransferSuccessViewModel vm) {
    IconData iconData = Icons.phone_iphone;
    Color iconColor = const Color(0xFFFF8C42);
    Color bgColor = const Color(0xFFFF8C42).withOpacity(0.15);

    if (type == 'Bank' || type == 'Card') {
      iconData = Icons.account_balance;
    } else if (type == 'Wallet') {
      iconData = Icons.account_balance_wallet;
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(iconData, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type == 'Wallet' ? 'To Wallet' : 'To Instapay', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(recipientName, style: const TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(recipient, style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          GestureDetector(
            onTap: vm.toggleFavorite,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                vm.isFavorite ? Icons.star_rounded : Icons.star_border_rounded, 
                color: const Color(0xFFFF8C42), 
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
