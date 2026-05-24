import 'package:flutter/material.dart';
import 'package:sms_finance_app/enums/category_enum.dart';

class CategoryDropdown extends StatelessWidget {
  final CategoryEnum selectedCategory;
  final Function(CategoryEnum) onChanged;

  const CategoryDropdown({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<CategoryEnum>(
      value: selectedCategory,
      items:
          CategoryEnum.values.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(category.name),
            );
          }).toList(),
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}
