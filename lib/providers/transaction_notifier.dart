import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sms_finance_app/enums/category_enum.dart';
import 'package:sms_finance_app/models/transaction_model.dart';
import 'package:sms_finance_app/services/sms_parser.dart';

class TransactionNotifier extends StateNotifier<List<TransactionModel>>{
  TransactionNotifier() : super([]);

  void loadFromSms(List<String> smsList){
    final parsedSMSs=  smsList.map((e){
      return SMSParser.parse(e);
    }).toList();

    state = parsedSMSs;
  }

  void updateCategory(String id, CategoryEnum newCategory){
    state = state.map((tx){
      if(tx.id == id) {
        return tx.copyWith(category:newCategory);
      }
      return tx;
    }).toList();
  }
}

