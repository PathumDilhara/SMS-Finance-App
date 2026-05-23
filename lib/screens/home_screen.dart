import 'package:flutter/material.dart';
import 'package:sms_finance_app/logger/logger.dart';
import 'package:sms_finance_app/mock_data/mock_data.dart';
import 'package:sms_finance_app/models/transaction_model.dart';
import 'package:sms_finance_app/services/sms_parser.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SMS Finance")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              TransactionModel model = SMSParser.parse(kMockData[0]);

              appLogger.i(
                "${model.id}, "
                "${model.amount}, "
                "${model.type}, "
                "${model.merchant}, "
                "${model.category}, "
                "${model.dateTime}",
              );
              },
            child: Text("Tap"),
          ),
        ],
      ),
    );
  }
}
