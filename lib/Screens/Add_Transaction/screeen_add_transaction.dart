import 'package:flutter/material.dart';
import 'package:money_management/Models/Category/category_model.dart';
import 'package:money_management/Models/Transaction/transaction.dart';
import 'package:money_management/Screens/Category/category_add_popup.dart';
import 'package:money_management/db/Category_db/category_db.dart';
import 'package:money_management/db/transaction_db/transaction_db.dart';

class ScreenAddTransation extends StatefulWidget {
  static const routeName = "add-transaction";
  const ScreenAddTransation({Key? key}) : super(key: key);

  @override
  State<ScreenAddTransation> createState() => _ScreenAddTransationState();
}

class _ScreenAddTransationState extends State<ScreenAddTransation> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;
  String? _categoryID;
  final _purposeController = TextEditingController();
  final _amountController = TextEditingController();
  @override
  void initState() {
    _selectedCategoryType = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            //purpose
            TextFormField(
              decoration: const InputDecoration(hintText: "purpose"),
              controller: _purposeController,
            ),
            //Amount
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: "Amount"),
              controller: _amountController,
            ),

            // Calander
            TextButton.icon(
                onPressed: () async {
                  final _selectedDatetemp = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(Duration(days: 30)),
                    lastDate: DateTime.now(),
                  );
                  if (_selectedDatetemp == null) {
                    setState(() {
                      _selectedDate = DateTime.now();
                    });
                  } else {
                    print(_selectedDatetemp.toString());
                    setState(() {
                      _selectedDate = _selectedDatetemp;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(_selectedDate == null
                    ? "Select Date"
                    : _selectedDate.toString())),

            // Category
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Radio(
                    value: CategoryType.income,
                    groupValue: _selectedCategoryType,
                    onChanged: (newValue) {
                      // if (newValue == null) {
                      //   return;
                      // }
                      setState(() {
                        _selectedCategoryType = CategoryType.income;
                        _categoryID = null;
                      });
                    }),
                const Text("Income"),
                const SizedBox(
                  width: 10,
                ),
                Radio(
                    value: CategoryType.expense,
                    groupValue: _selectedCategoryType,
                    onChanged: (newValue) {
                      //    if (newValue == null) return;
                      setState(() {
                        _selectedCategoryType = CategoryType.expense;
                        _categoryID = null;
                      });
                    }),
                const Text("Expense")
              ],
            ),

            // Category Type
            DropdownButton<String>(
              hint: const Text("Select Category"),
              value: _categoryID,
              items: (_selectedCategoryType == CategoryType.income
                      ? CategoryDB().incomeCategoryListListener
                      : CategoryDB().expenseCategoryListListener)
                  .value
                  .map((e) {
                return DropdownMenuItem(
                  child: Text(e.name),
                  value: e.id,
                  onTap: () {
                    print(e.toString());
                    _selectedCategoryModel = e;
                  },
                );
              }).toList(),
              onChanged: (selectedValue) {
                // print(selectedValue);
                setState(() {
                  _categoryID = selectedValue;
                });
              },
            ),
            //Submit Button
            ElevatedButton(
                onPressed: () {
                  addTransaction();
                },
                child: Text("Submit"))
          ],
        ),
      ),
    );
  }

  Future<void> addTransaction() async {

    final String _purposeText = _purposeController.text;
    final _amountText = _amountController.text;
    if (_purposeText.isEmpty) print("Purpose Epty");
    if (_purposeText.isEmpty ||
        _selectedCategoryModel == null ||
        _selectedDate == null) {
      return;
    }
    ;
    final _parserAmount = double.tryParse(_amountText);
    print(_parserAmount);
    if (_parserAmount == null) {
      return;
    }
    ;
    TransactionModel _model = TransactionModel(
      purpose: _purposeText,
      amount: _parserAmount,
      date: _selectedDate!,
      type: _selectedCategoryType!,
      category: _selectedCategoryModel!,
    );
    print("Added Model ${_model.toString()}");
    await TransactionDB.instance.addTransaction(_model);

    TransactionDB.instance.refresh();
    Navigator.of(context).pop();
  }
}
