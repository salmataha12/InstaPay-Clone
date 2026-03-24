import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/session/app_session.dart';
import 'pin_entry_viewmodel.dart';

class PinEntryView extends StatelessWidget {
  final Map<String, dynamic> transferData;

  const PinEntryView({super.key, required this.transferData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PinEntryViewModel(),
      child: _PinEntryBody(transferData: transferData),
    );
  }
}

class _PinEntryBody extends StatelessWidget {
  final Map<String, dynamic> transferData;

  const _PinEntryBody({required this.transferData});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PinEntryViewModel>();
    final session = context.watch<AppSession>();
    final totalAmount = transferData['total'] ?? 0.0;
    final fromBank = session.selectedBank.isNotEmpty ? session.selectedBank : 'National Bank of Egypt';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      fromBank,
                      style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                    ),
                  ),
                  // Fake IPN Logo
                  const Text(
                    "IPN",
                    style: TextStyle(color: Color(0xFF6F00FF), fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, fontSize: 24, letterSpacing: -1),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE0E0E0)),
            
            // Account Info Subheader
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Account Info", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                      SizedBox(height: 2),
                      Text("XXXXX0180", style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w700)),
                      Text("SAVING", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text("Total Amount", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text("$totalAmount EGP", style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w700)),
                          const SizedBox(width: 4),
                          const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 18),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE0E0E0)),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (vm.error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(vm.error!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                      
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Enter IPN PIN", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black)),
                        GestureDetector(
                          onTap: vm.toggleVisibility,
                          child: Icon(vm.obscurePin ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
                        bool hasValue = index < vm.pin.length;
                        return Container(
                          width: 45,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: hasValue ? const Color(0xFF6F00FF) : Colors.grey.shade400, width: hasValue ? 2 : 1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: hasValue
                                ? Text(
                                    vm.obscurePin ? '•' : vm.pin[index],
                                    style: TextStyle(fontSize: vm.obscurePin ? 28 : 22, fontWeight: FontWeight.bold, color: Colors.black),
                                  )
                                : null,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            
            // Numpad Area
            if (vm.isLoading)
              const Padding(
                padding: EdgeInsets.only(bottom: 60),
                child: CircularProgressIndicator(color: Color(0xFF6F00FF)),
              )
            else
              Container(
                padding: const EdgeInsets.only(bottom: 24, top: 12),
                color: Colors.white,
                child: Column(
                  children: [
                    _buildNumpadRow(['1', '2', '3'], vm),
                    _buildNumpadRow(['4', '5', '6'], vm),
                    _buildNumpadRow(['7', '8', '9'], vm),
                    _buildNumpadRow(['<', '0', 'ENTER'], vm, context),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumpadRow(List<String> keys, PinEntryViewModel vm, [BuildContext? context]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((k) {
        return Expanded(
          child: AspectRatio(
            aspectRatio: 2.0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  if (k == '<') {
                    vm.removeDigit();
                  } else if (k == 'ENTER' && context != null) {
                    final success = await vm.verify();
                    if (success) {
                      context.push('/transfer_success', extra: transferData);
                    }
                  } else if (k != 'ENTER' && k != '<') {
                    vm.addDigit(k);
                  }
                },
                child: Center(
                  child: k == 'ENTER'
                      ? const Text("ENTER", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black))
                      : k == '<'
                          ? const Icon(Icons.backspace_outlined, size: 24, color: Colors.black)
                          : Text(k, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black)),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
