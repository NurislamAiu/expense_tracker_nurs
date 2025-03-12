import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'package:intl/intl.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Invalid input'),
          content: Text('Please enter a valid title, amount, and date.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text('Okay'))
          ],
        ),
      );
      return;
    }
    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.shade600, // Глубокий синий
            Colors.purple.shade600, // Фиолетовый
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1), // Стеклянный эффект
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок
                Text(
                  "New Expense",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),

                // Поле Title
                _buildTextField("Title", _titleController, Icons.title),
                SizedBox(height: 12),

                // Поле Amount & Дата
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                          "Amount", _amountController, Icons.attach_money),
                    ),
                    SizedBox(width: 12),
                    _buildDatePicker(),
                  ],
                ),
                SizedBox(height: 16),

                // Выбор категории
                _buildCategoryDropdown(),
                SizedBox(height: 16),

                // Кнопки
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCancelButton(),
                    _buildSaveButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Минималистичное текстовое поле
  Widget _buildTextField(String hint, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      keyboardType: hint == "Amount" ? TextInputType.number : TextInputType.text,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Дата-пикер
  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: _presentDatePicker,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.white70),
            SizedBox(width: 8),
            Text(
              _selectedDate == null
                  ? "Select Date"
                  : DateFormat.yMd().format(_selectedDate!),
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  // Выбор категории
  Widget _buildCategoryDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<Category>(
        value: _selectedCategory,
        isExpanded: true,
        underline: SizedBox(),
        dropdownColor: Colors.indigo.shade600,
        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
        items: Category.values
            .map(
              (category) => DropdownMenuItem(
            value: category,
            child: Text(
              category.name.toUpperCase(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ),
        )
            .toList(),
        onChanged: (value) {
          if (value == null) return;
          setState(() {
            _selectedCategory = value;
          });
        },
      ),
    );
  }

  // Кнопка Cancel
  Widget _buildCancelButton() {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text(
        "Cancel",
        style: TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Кнопка Save
  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _submitExpenseData,
      child: Text("Save Expense"),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        backgroundColor: Colors.white.withOpacity(0.2),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}