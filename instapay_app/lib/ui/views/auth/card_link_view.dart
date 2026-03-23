import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/session/app_session.dart';
import 'package:go_router/go_router.dart';
import 'card_link_viewmodel.dart';

class CardLinkView extends StatelessWidget {
  const CardLinkView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CardLinkViewModel(),
      child: const _CardLinkBody(),
    );
  }
}

class _CardLinkBody extends StatelessWidget {
  const _CardLinkBody();

  Widget buildBox(String value) {
    return Container(
      width: 60,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(value, style: const TextStyle(fontSize: 18)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CardLinkViewModel>();
    final session = context.watch<AppSession>();

    final bank = session.selectedBank;
    final phone = session.phoneNumber;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// HEADER
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => context.go('/bank'),
                    ),
                    Expanded(
                      child: Text(
                        bank,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// TEXT
                Text(
                  "Please use Debit or Meeza Cards number.\nYour Mobile number +20$phone must be registered at your bank.",
                ),

                const SizedBox(height: 30),

                /// CARD NUMBER
                const Text("Enter Card Number"),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(4, (i) {
                    String part = "";

                    if (vm.cardNumber.length > i * 4) {
                      int end = (i + 1) * 4;
                      if (end > vm.cardNumber.length) end = vm.cardNumber.length;
                      part = vm.cardNumber.substring(i * 4, end);
                    }

                    return buildBox(part);
                  }),
                ),

                const SizedBox(height: 30),

                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Enter Card ATM PIN"),
                    IconButton(
                      icon: Icon(
                        vm.isPinVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: vm.togglePinVisibility,
                    )
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(4, (i) {
                    String value = "";

                    if (i < vm.pin.length) {
                      value = vm.isPinVisible ? vm.pin[i] : "*";
                    }

                    return buildBox(value);
                  }),
                ),

                TextField(
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  showCursor: false,
                  decoration: const InputDecoration(border: InputBorder.none),
                  onChanged: (value) {
                    String digits =
                        value.replaceAll(RegExp(r'[^0-9]'), '');

                    for (var digit in digits.split('')) {
                      if (vm.cardNumber.length < 16) {
                        vm.addCardDigit(digit);
                      } else {
                        vm.addPinDigit(digit);
                      }
                    }
                  },
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      for (var row in [
                        ["1","2","3"],
                        ["4","5","6"],
                        ["7","8","9"],
                        ["<","0","ENTER"]
                      ])
                        Expanded(
                          child: Row(
                            children: row.map((e) {
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () async {

                                    if (e == "<") {
                                      if (vm.pin.isNotEmpty) {
                                        vm.removePinDigit();
                                      } else {
                                        vm.removeCardDigit();
                                      }
                                    } else if (e == "ENTER") {

                                      bool success = await vm.submit();

                                      if (success) {
                                        context.go('/home');
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Invalid card or PIN"),
                                          ),
                                        );
                                      }

                                    } else {
                                      if (vm.cardNumber.length < 16) {
                                        vm.addCardDigit(e);
                                      } else {
                                        vm.addPinDigit(e);
                                      }
                                    }

                                  },
                                  child: Center(
                                    child: Text(
                                      e,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}