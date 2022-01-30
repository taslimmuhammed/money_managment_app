import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_management/Models/Category/category_model.dart';
import 'package:money_management/Models/Transaction/transaction.dart';
import 'package:money_management/Screens/Add_Transaction/screeen_add_transaction.dart';
import 'package:money_management/Screens/Home/screen_home.dart';
import 'package:money_management/db/Category_db/category_db.dart';

void main() async {
  const TRANSACTION_DB_NAME = 'transaction_db';
  final CategoryDB obj1 = CategoryDB();
  final CategoryDB obj2 = CategoryDB();
  if (obj1 == obj2) print("Objects are same");
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }
  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)) {
    Hive.registerAdapter(TransactionModelAdapter());
  }
  await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ScreenHome(),
        routes: {
          ScreenAddTransation.routeName: (ctx) => const ScreenAddTransation(),
        });
  }
}
