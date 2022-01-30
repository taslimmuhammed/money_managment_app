import 'package:flutter/material.dart';
import 'package:money_management/Models/Category/category_model.dart';
import 'package:money_management/Screens/Add_Transaction/screeen_add_transaction.dart';
import 'package:money_management/Screens/Category/category_add_popup.dart';
import 'package:money_management/Screens/Category/screen_category.dart';
import 'package:money_management/Screens/Home/widgets/bottom_navigation.dart';
import 'package:money_management/Screens/Transaction/screen_transation.dart';
import 'package:money_management/db/Category_db/category_db.dart';

class ScreenHome extends StatelessWidget {
  ScreenHome({Key? key}) : super(key: key);
  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);
  final _pages = const [ScreenTransaction(), ScreenCategory()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Money Manager'),
        centerTitle: true,
      ),
      bottomNavigationBar: const BottomBar(),
      body: SafeArea(
        child: ValueListenableBuilder(
            valueListenable: selectedIndexNotifier,
            builder: (BuildContext context, int updatedIndex, _) {
              return _pages[updatedIndex];
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedIndexNotifier.value == 0) {
            Navigator.of(context).pushNamed(ScreenAddTransation.routeName);
          } else if (selectedIndexNotifier.value == 1) {
            showCategoryAddPopup(context);
            // final _sample = CategoryModel(
            //     id: DateTime.now().millisecondsSinceEpoch.toString(),
            //     name: "travel",
            //     type: CategoryType.income);
            // CategoryDB().insertCategory(_sample);

          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
