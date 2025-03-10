import 'package:expense_tracker_nurs/widgets/expenses.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(
    MaterialApp(
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: Expenses()
    )
  );
}