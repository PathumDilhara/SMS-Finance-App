import 'package:sms_finance_app/enums/transcation_type_enum.dart';
import 'package:sms_finance_app/logger/logger.dart';
import 'package:sms_finance_app/models/transaction_model.dart';
import 'package:uuid/uuid.dart';

import '../enums/category_enum.dart';

class SMSParser {
  // convert row sms into transactional model
  static TransactionModel parse(String sms) {
    double amount = 0.0;
    TransactionTypeEnum txEnum = TransactionTypeEnum.notDefined;
    String merchantMatchStr = "";
    CategoryEnum category = CategoryEnum.other;
    DateTime dateTime = DateTime.now();

    // ============ generating unique id ===========
    final uuid = Uuid();

    // ============ Extracting price/amount ============
    final doubleRegEx = RegExp(r'(?<=LKR\s+)([\d,]+\.\d{1,2})');
    final RegExpMatch? doubleMatch = doubleRegEx.firstMatch(sms);
    if (doubleMatch != null) {
      amount = double.parse(doubleMatch.group(0)!.replaceAll(",", ""));
    }

    // ============ Decide expense or income also merchant data ============
    if (sms.toLowerCase().contains("credited")) {
      txEnum = TransactionTypeEnum.income;
      appLogger.e("credited : $txEnum\n $sms");

      // Extracting merchant/place prevent to credited regex
      final merchantRegEx = RegExp(
        r'credited\s+to\s+AC\s+\*\*\d+\s+from\s+(.+?)\s+\d{2}/',
      );
      print("###@@@ $merchantRegEx");
      final RegExpMatch? merchantMatch = merchantRegEx.firstMatch(sms);

      print("### merchantMatch is nul $merchantMatch");

      if (merchantMatch != null) {
        print("###merchantMatch : ${merchantMatch.group(1).toString().trim()}");
        merchantMatchStr = merchantMatch.group(1).toString().trim();
      }
    }

    if (sms.toLowerCase().contains("debited")) {
      txEnum = TransactionTypeEnum.expense;

      // Extracting merchant/place with regex relent to debit
      final merchantRegEx = RegExp(r'via\s+POS\s+at\s+(.+?)\s+\d+');
      final RegExpMatch? merchantMatch = merchantRegEx.firstMatch(sms);
      if (merchantMatch != null) {
        merchantMatchStr = merchantMatch.group(1).toString().trim();
      }
    }

    // ============ category detector ============
    if (merchantMatchStr.isNotEmpty) {
      category = detectCategory(merchantMatchStr);
      appLogger.d(category);
    }

    // ============ Extract date time ============
    final dateRegEx = RegExp(r'\d{2}/\d{2}/\d{4}\s+\d{2}:\d{2}:\d{2}');
    final dateMatch = dateRegEx.firstMatch(sms);

    // since sms date format != dart date time format conv
    if (dateMatch != null) {
      final rawDate = dateMatch.group(0)!;
      appLogger.d(rawDate);

      final parts = rawDate.split(RegExp(r'\s+'));

      final datePart = parts[0].split('/');
      final timePart = parts[1].split(':');

      if (parts.isNotEmpty) {
        dateTime = DateTime(
          int.parse(datePart[2]), // y
          int.parse(datePart[1]), //
          int.parse(datePart[0]), // d
          int.parse(timePart[0]), // h
          int.parse(timePart[1]), // m
          int.parse(timePart[2]), // s
        );

        appLogger.d(dateTime);
      }
    }
    // ONly consider about amount, type, merchant data
    // category can have other for more merchant not only empty merchant
    if (amount != 0.0 &&
        txEnum != TransactionTypeEnum.notDefined &&
        merchantMatchStr.isNotEmpty) {
      // model obj
      TransactionModel model = TransactionModel(
        id: uuid.v4(),
        amount: amount,
        type: txEnum,
        merchant: merchantMatchStr,
        category: category,
        dateTime: dateTime,
        rawMessage: sms,
      );
      return model;
    }

    return TransactionModel.empty();
  }

  // ============ Helper methods ======================

  static CategoryEnum detectCategory(String merchant) {
    final upperMerchant = merchant.toUpperCase();

    if (upperMerchant.contains("FUEL")) {
      return CategoryEnum.fuel;
    }
    if (upperMerchant.contains("INTERCHANGE")) {
      return CategoryEnum.transport;
    }
    if (upperMerchant.contains("KEELLS") || upperMerchant.contains("SUPER")) {
      return CategoryEnum.groceries;
    }

    return CategoryEnum.other;
  }
}
