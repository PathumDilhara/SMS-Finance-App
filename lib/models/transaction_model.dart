import 'package:sms_finance_app/enums/category_enum.dart';
import 'package:sms_finance_app/enums/transcation_type_enum.dart';

class TransactionModel {
  final String id;
  final double amount;
  final TransactionTypeEnum type;

  // Type defined as enum
  final String merchant;

  // place where the payment was made
  final CategoryEnum category;

  // Transport / Groceries / Fuel
  final DateTime dateTime;

  // just pass raw sms
  final String rawMessage;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.merchant,
    required this.category,
    required this.dateTime,
    required this.rawMessage,
  });

  factory TransactionModel.empty() {
    return TransactionModel(
      id: '',
      amount: 0.0,
      type: TransactionTypeEnum.expense,
      merchant: "",
      category: CategoryEnum.other,
      dateTime: DateTime.now(),
      rawMessage: "",
    );
  }

  TransactionModel copyWith({
    String? id,
    double? amount,
    TransactionTypeEnum? type,
    String? merchant,
    CategoryEnum? category,
    DateTime? dateTime,
    String? rawMessage,
}){
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      merchant: merchant ?? this.merchant,
      category: category ?? this.category,
      dateTime: dateTime ?? this.dateTime,
      rawMessage: rawMessage ?? this.rawMessage,
    );
  }
}
