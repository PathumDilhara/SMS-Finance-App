import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_finance_app/enums/transcation_type_enum.dart';
import 'package:sms_finance_app/logger/logger.dart';
import 'package:sms_finance_app/providers/transaction_provider.dart';
import 'package:sms_finance_app/router/router_paths.dart';

import '../sample_data/sample_sms.dart';

class TransactionListScreen extends ConsumerStatefulWidget {
  const TransactionListScreen({super.key});

  @override
  ConsumerState<TransactionListScreen> createState() =>
      _TransactionListScreenState();
}

class _TransactionListScreenState extends ConsumerState<TransactionListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(transactionProvider.notifier).loadFromSms(kSampleSMS);
    });
  }

  @override
  Widget build(BuildContext context) {
    // watch state
    final transactions = ref.watch(transactionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SMS Finance",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body:
          transactions.isEmpty
              ? Center(child: Text("No transactions"))
              : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final tx = transactions[index];
                  bool isExpense = tx.type == TransactionTypeEnum.expense;

                  return ListTile(
                    title: Text(
                      "LKR ${tx.amount.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: isExpense ? Colors.redAccent : Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "${tx.merchant} - ${tx.category.name}",
                      style: TextStyle(
                        color: isExpense ? Colors.redAccent : Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                    trailing: Text(
                      tx.type.name,
                      style: TextStyle(
                        color: isExpense ? Colors.redAccent : Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      appLogger.i("Pressed");
                      GoRouter.of(
                        context,
                      ).push("/${RouterPaths.transactionDetails}", extra: tx);
                    },
                  );
                },
              ),
    );
  }
}
