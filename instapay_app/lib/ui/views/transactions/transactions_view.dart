import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/transaction_tile.dart';
import '../../../core/session/app_session.dart';

class TransactionsView extends StatelessWidget {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _TransactionsBody();
  }
}

class _TransactionsBody extends StatelessWidget {
  const _TransactionsBody();

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AppSession>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Transactions History',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 40),
        itemCount: session.transactions.length,
        itemBuilder: (context, index) {
          final tx = session.transactions[index];
          return TransactionTile(tx: tx, showBackground: false);
        },
      ),
    );
  }
}
