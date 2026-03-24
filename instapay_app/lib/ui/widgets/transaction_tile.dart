import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  final Map<String, dynamic> tx;
  final bool showBackground;

  const TransactionTile({super.key, required this.tx, this.showBackground = false});

  @override
  Widget build(BuildContext context) {
    bool isReceived = tx['type'] == 'Received Money';

    return Container(
      margin: showBackground ? const EdgeInsets.only(bottom: 12) : EdgeInsets.zero,
      padding: EdgeInsets.all(showBackground ? 16 : 12),
      decoration: BoxDecoration(
        color: showBackground ? Colors.white : Colors.transparent,
        borderRadius: showBackground ? BorderRadius.circular(16) : null,
        border: showBackground ? null : const Border(bottom: BorderSide(color: Color(0xFFF3F3F3))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Amount & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tx['amount'],
                style: const TextStyle(fontSize: 16, color: Color(0xFF1B2C41), fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                   Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE4F9F0),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tx['status'],
                      style: const TextStyle(color: Color(0xFF27CD92), fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Bottom Row: Icon, Labels
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Area
              Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFE5D6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isReceived ? Icons.alternate_email : Icons.phone_iphone,
                          color: isReceived ? const Color(0xFFE34D25) : const Color(0xFFFF8C42),
                          size: 24,
                        ),
                      ),
                      Positioned(
                        bottom: -2,
                        right: -2,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isReceived ? const Color(0xFF00CFA1) : const Color(0xFF006CFF),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isReceived ? Icons.call_received : Icons.call_made,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tx['type'],
                    style: const TextStyle(fontSize: 8, color: Colors.black87, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              // Details Area
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx['maskedName'],
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tx['name'],
                      style: const TextStyle(fontSize: 14, color: Color(0xFF1B2C41), fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tx['date'],
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
