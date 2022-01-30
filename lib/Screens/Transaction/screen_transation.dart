import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_management/Models/Category/category_model.dart';
import 'package:money_management/Models/Transaction/transaction.dart';
import 'package:money_management/db/Category_db/category_db.dart';
import 'package:money_management/db/transaction_db/transaction_db.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refresh();
    CategoryDB.instance.refreshUI();
    return ValueListenableBuilder(
        valueListenable: TransactionDB.instance.transactionListNotifier,
        builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
          return ListView.separated(
              padding: const EdgeInsets.all(10),
              itemBuilder: (ctx, index) {
                final _value = newList[index];
                return Stack(
                  children: [
                    Slidable(
                      key: Key(_value.id!),
                      startActionPane:
                          ActionPane(motion: const ScrollMotion(), children: [
                        SlidableAction(
                          onPressed: (ctx) async {
                            await TransactionDB.instance
                                .deleteTransaction(_value.id.toString());
                            TransactionDB.instance.refresh();
                          },
                          icon: Icons.delete,
                        )
                      ]),
                      child: Card(
                        elevation: 1,
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              parseDate(_value.date),
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: _value.type == CategoryType.income
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            radius: 50,
                          ),
                          title: Text('Rs ${_value.amount}'),
                          subtitle: Text(_value.category.name),
                        ),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (ctx, index) {
                return const SizedBox(
                  height: 10,
                );
              },
              itemCount: newList.length);
        });
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splitDate = _date.split(" ");
    return "${_splitDate.last}\n${_splitDate.first}";
  }
}
