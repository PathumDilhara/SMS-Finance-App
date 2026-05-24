import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sms_finance_app/enums/category_enum.dart';
import 'package:sms_finance_app/enums/transcation_type_enum.dart';
import 'package:sms_finance_app/providers/transaction_provider.dart';
import 'package:sms_finance_app/widgets/custom_drop_down_button.dart';

import '../models/transaction_model.dart';

class TransactionDetailScreen extends ConsumerStatefulWidget {
  final TransactionModel transaction;
  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  ConsumerState<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState
    extends ConsumerState<TransactionDetailScreen> {
  late TransactionModel transaction;
  final ValueNotifier<CategoryEnum> _category = ValueNotifier(
    CategoryEnum.other,
  );

  @override
  void initState() {
    super.initState();
    transaction = widget.transaction;
    _category.value = transaction.category;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle customTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Transaction Details",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w400),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transaction.type.name.toUpperCase(),
              style: TextStyle(
                fontSize: 26,
                color:
                    transaction.type == TransactionTypeEnum.expense
                        ? Colors.redAccent
                        : Colors.blue,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Amount : ${transaction.amount.toStringAsFixed(2)}",
              style: customTextStyle,
            ),
            Text("Merchant: ${transaction.merchant}", style: customTextStyle),
            Row(
              children: [
                Text("Category: ", style: customTextStyle),
                ValueListenableBuilder(
                  valueListenable: _category,
                  builder: (context, category, child) {
                    print("### category changed : $category");
                    return CategoryDropdown(
                      selectedCategory: category,
                      onChanged: (value) {
                        ref
                            .read(transactionProvider.notifier)
                            .updateCategory(transaction.id, value);

                        _category.value = value;
                        // Navigator.pop(context);
                      },
                    );
                  },
                ),
              ],
            ),
            Text("Date: ${transaction.dateTime}", style: customTextStyle),

            const SizedBox(height: 20),
            Text("Raw SMS:", style: customTextStyle),
            Text(transaction.rawMessage),
          ],
        ),
      ),
    );
  }
}

//
// class TransactionDetailScreen extends ConsumerWidget {
//   final TransactionModel transaction;
//   TransactionDetailScreen({super.key, required this.transaction});
//
//   final ValueNotifier<CategoryEnum> _category = ValueNotifier(
//     CategoryEnum.other,
//   );
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     TextStyle customTextStyle = TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 18,
//     );
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Transaction Details",
//           style: TextStyle(fontSize: 26, fontWeight: FontWeight.w400),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               transaction.type.name.toUpperCase(),
//               style: TextStyle(
//                 fontSize: 26,
//                 color:
//                     transaction.type == TransactionTypeEnum.expense
//                         ? Colors.redAccent
//                         : Colors.blue,
//               ),
//             ),
//             SizedBox(height: 10),
//             Text("Amount : ${transaction.amount}", style: customTextStyle),
//             Text("Merchant: ${transaction.merchant}", style: customTextStyle),
//             Row(
//               children: [
//                 Text("Category: ", style: customTextStyle),
//                 ValueListenableBuilder(
//                   valueListenable: _category,
//                   builder: (context, child, category) {
//                     return CategoryDropdown(
//                       selectedCategory: transaction.category,
//                       onChanged: (value) {
//                         ref
//                             .read(transactionProvider.notifier)
//                             .updateCategory(transaction.id, value);
//
//                         _category.value = value;
//                         // Navigator.pop(context);
//                       },
//                     );
//                   },
//                 ),
//               ],
//             ),
//             Text("Date: ${transaction.dateTime}", style: customTextStyle),
//
//             const SizedBox(height: 20),
//             Text("Raw SMS:", style: customTextStyle),
//             Text(transaction.rawMessage),
//           ],
//         ),
//       ),
//     );
//   }
// }
