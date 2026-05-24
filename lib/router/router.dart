import 'package:go_router/go_router.dart';
import 'package:sms_finance_app/models/transaction_model.dart';
import 'package:sms_finance_app/router/router_paths.dart';
import 'package:sms_finance_app/screens/transaction_detail_screen.dart';

import '../screens/transaction_list_screen.dart';

class RouterClass {
  final router = GoRouter(
    initialLocation: "/${RouterPaths.home}",
    routes: [
      GoRoute(
        name: RouterPaths.home,
        path: "/${RouterPaths.home}",
        builder: (context, state) => TransactionListScreen(),
      ),
      GoRoute(
        name: RouterPaths.transactionDetails,
        path: "/${RouterPaths.transactionDetails}",
        builder: (context, state) {
          final tx = state.extra as TransactionModel;
          return TransactionDetailScreen(transaction: tx);
        },
      ),
    ],
  );
}
