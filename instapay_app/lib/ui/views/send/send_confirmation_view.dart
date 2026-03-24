import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/session/app_session.dart';

class SendConfirmationView extends StatefulWidget {
  final Map<String, dynamic> transferData;

  const SendConfirmationView({super.key, required this.transferData});

  @override
  State<SendConfirmationView> createState() => _SendConfirmationViewState();
}

class _SendConfirmationViewState extends State<SendConfirmationView> {
  bool _showMoreDetails = false;

  @override
  Widget build(BuildContext context) {
    final amountStr = widget.transferData['amount']?.toString() ?? '0.00';
    final amount = double.tryParse(amountStr) ?? 0.0;
    final fees = 0.5;
    final total = amount + fees;

    final recipient = widget.transferData['recipient'] ?? 'N/A';
    final type = widget.transferData['type'] ?? 'Unknown';
    final reason = widget.transferData['reason'] ?? 'Living Expenses';
    final notes = widget.transferData['notes'] ?? '';
    final recipientName = widget.transferData['recipientName'] ?? 'Unknown';

    final session = context.watch<AppSession>();
    final fromBank = session.selectedBank.isNotEmpty ? session.selectedBank : 'National Bank of Egypt';
    final fromHandle = session.phoneNumber.isNotEmpty ? '${session.phoneNumber}@instapay' : 'my_account@instapay';

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6F00FF), // Deep purple
              Color(0xFF8B22FF),
              Color(0xFF380088), // Darker purple towards bottom
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background abstract shapes (Orange flair from image)
            Positioned(
              bottom: -50,
              left: -50,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8C42).withOpacity(0.9), // Orange shape
                  shape: BoxShape.circle,
                ),
              ),
            ),
            
            SafeArea(
              child: Column(
                children: [
                  _buildAppBar(context),
                  
                  const SizedBox(height: 20),
                  
                  // Amount Display
                  Text(
                    "$amountStr EGP",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text(
                    "Transfer Amount",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Fees Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: const [
                                  Text("Fees", style: TextStyle(color: Colors.white, fontSize: 13)),
                                  SizedBox(width: 6),
                                  Icon(Icons.info_outline, color: Colors.white, size: 14),
                                ],
                              ),
                              Text("$fees EGP", style: const TextStyle(color: Colors.white, fontSize: 13)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(height: 1, color: Colors.white.withOpacity(0.2)),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total Amount", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                              Text("$total EGP", style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // From and To Cards with overlapping arrow
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          children: [
                            _buildFromCard(fromBank, fromHandle),
                            const SizedBox(height: 16),
                            _buildToCard(recipient, type, recipientName),
                          ],
                        ),
                        // The circular downward chevron
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.keyboard_double_arrow_down_rounded, color: Color(0xFFFF8C42), size: 20),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // More Details Badge
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showMoreDetails = !_showMoreDetails;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF8C42).withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("More Details", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 4),
                          Icon(_showMoreDetails ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                  ),

                  // Expanded Details
                  if (_showMoreDetails)
                    Padding(
                      padding: const EdgeInsets.only(top: 12, left: 24, right: 24),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text("Reason for Transfer:", style: TextStyle(color: Colors.white70, fontSize: 11)),
                            Text(reason, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            const Text("Notes:", style: TextStyle(color: Colors.white70, fontSize: 11)),
                            Text(notes.isEmpty ? "No notes added" : notes, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),

                  const Spacer(),
                  


                  const SizedBox(height: 20),
                  
                  // Bottom Actions
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                    child: Row(
                      children: [
                        // Back Square Button
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
                            ),
                            child: const Icon(Icons.arrow_back, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Confirm Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              final data = Map<String, dynamic>.from(widget.transferData);
                              data['total'] = total;
                              context.push('/pin_entry', extra: data);
                            },
                            child: Container(
                              height: 54,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  "Confirm",
                                  style: TextStyle(
                                    color: Color(0xFF6F00FF),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: const Icon(Icons.keyboard_arrow_left, color: Colors.black, size: 24),
              ),
            ),
          ),
          const Text(
            "Send Money",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildFromCard(String bankName, String handle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44, // Match exact layout width
            height: 44, // Match accurate UI scaling
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
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
                Text(handle, style: const TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(bankName, style: const TextStyle(fontSize: 11, color: Colors.grey, letterSpacing: 0.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToCard(String recipient, String type, String recipientName) {
    IconData iconData = Icons.phone_iphone;
    Color iconColor = const Color(0xFFFF8C42);
    Color bgColor = const Color(0xFFFF8C42).withOpacity(0.15);

    if (type == 'Bank' || type == 'Card') {
      iconData = Icons.account_balance;
    } else if (type == 'Wallet') {
      iconData = Icons.account_balance_wallet;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
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
                Text(recipientName, style: const TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(recipient, style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
