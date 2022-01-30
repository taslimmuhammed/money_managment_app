// ignore: file_names
import 'package:flutter/material.dart';
import 'package:money_management/Models/Category/category_model.dart';
import 'package:money_management/db/Category_db/category_db.dart';

class IncomeList extends StatelessWidget {
  const IncomeList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: CategoryDB().incomeCategoryListListener,
        builder: (BuildContext ctx, List<CategoryModel> newList, Widget? _) {
          return ListView.separated(
              itemBuilder: (ctx, index) {
                final _category = newList[index];
                return ListTile(
                  title: Text(_category.name),
                  trailing: IconButton(
                    onPressed: () {
                       CategoryDB.instance.daleteCategory(_category.id);
                    },
                    icon: Icon(Icons.delete),
                  ),
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
}
