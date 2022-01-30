import 'package:flutter/material.dart';
import 'package:money_management/Models/Category/category_model.dart';
import 'package:money_management/db/Category_db/category_db.dart';

ValueNotifier<CategoryType> selectedCatgoryNotifier =
    ValueNotifier(CategoryType.income);
Future<void> showCategoryAddPopup(BuildContext context) async {
  final _nameEditingController = TextEditingController();
   showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text("Add Category"),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _nameEditingController,
                decoration: const InputDecoration(
                    hintText: "Category Name", border: OutlineInputBorder()),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    RadioButton(title: "Income", type: CategoryType.income),
                    RadioButton(title: "Expense", type: CategoryType.expense)
                  ],
                )),
            ElevatedButton(
                onPressed: () {
                  final _name = _nameEditingController.text;
                  if (_name.isEmpty) {
                    return;
                  }
                  final _type = selectedCatgoryNotifier.value;
                  final _category = CategoryModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: _name,
                    type: _type,
                  );
                  CategoryDB().insertCategory(_category);
                  Navigator.of(ctx).pop();
                },
                child: const Text("Add"))
          ],
        );
      });
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;
  RadioButton({Key? key, required this.title, required this.type})
      : super(key: key);

  CategoryType? _type;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: selectedCatgoryNotifier,
          builder: (BuildContext ctx, CategoryType newCategory, Widget? _) {
            return Radio<CategoryType>(
              value: type,
              groupValue: selectedCatgoryNotifier.value,
              onChanged: (value) {
                print(value);
                if (value == null) {
                  return;
                } //To avoid type ? Error of value
                selectedCatgoryNotifier.value = value;
                selectedCatgoryNotifier.notifyListeners();
              },
            );
          },
        ),
        Text(title)
      ],
    );
  }
}
