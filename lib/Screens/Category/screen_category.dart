import 'package:flutter/material.dart';
import 'package:money_management/Screens/Category/Income_list.dart';
import 'package:money_management/Screens/Category/expense_category.dart';
import 'package:money_management/db/Category_db/category_db.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({Key? key}) : super(key: key);

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

class _ScreenCategoryState extends State<ScreenCategory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    CategoryDB().refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(
                text: 'Income',
              ),
              Tab(
                text: 'Expense',
              )
            ]),
        Expanded(
          child: TabBarView(
            children: const [IncomeList(), ExpenseList()],
            controller: _tabController,
          ),
        )
      ],
    );
  }
}
