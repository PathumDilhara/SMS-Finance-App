import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sms_finance_app/providers/transaction_notifier.dart';

import '../models/transaction_model.dart';

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, List<TransactionModel>>(
      (ref) => TransactionNotifier(),
    );
