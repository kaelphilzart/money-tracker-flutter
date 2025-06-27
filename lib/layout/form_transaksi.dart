import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker_new/data/models/transaction_model.dart';
import 'package:provider/provider.dart';
import 'package:money_tracker_new/provider/transaction_provider.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  bool _isFormatting = false;
  bool _isSaving = false;

  int sentiment = 0;
  String? selectedCategory;

  final List<String> incomeCategories = ['Gaji', 'Bisnis', 'Freelance', 'Lainnya'];
  final List<String> expenseCategories = ['Kebutuhan Pokok', 'Transportasi', 'Lainnya'];

  List<String> get currentCategories => sentiment == 0 ? incomeCategories : expenseCategories;

  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'IDR ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_formatAmount);
  }

  void _formatAmount() {
    if (_isFormatting) return;
    _isFormatting = true;

    final rawText = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (rawText.isEmpty) {
      _amountController.text = '';
      _isFormatting = false;
      return;
    }

    final number = int.tryParse(rawText) ?? 0;
    final formatted = currencyFormatter.format(number);
    final newSelection = TextSelection.collapsed(offset: formatted.length);

    _amountController.value = TextEditingValue(
      text: formatted,
      selection: newSelection,
    );

    _isFormatting = false;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    final rawAmount = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final amount = (int.tryParse(rawAmount) ?? 0).toDouble();
    final desc = _descController.text.trim();
    final category = selectedCategory;
    final type = sentiment == 0 ? 'income' : 'expense';

    if (amount <= 0 || category == null || desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mohon lengkapi semua data dengan benar")),
      );
      return;
    }

    final newTx = TransactionModel()
      ..amount = amount
      ..description = desc
      ..category = category
      ..type = type
      ..date = DateTime.now();

    setState(() => _isSaving = true);
    await context.read<TransactionProvider>().addTransaction(newTx);
    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transaksi berhasil disimpan!")),
      );
      _resetForm();
    }
  }

  void _resetForm() {
    setState(() {
      _amountController.clear();
      _descController.clear();
      selectedCategory = null;
      sentiment = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SegmentedButton<int>(
            segments: const <ButtonSegment<int>>[
              ButtonSegment<int>(
                value: 0,
                label: Text('Masuk'),
                icon: Icon(Icons.arrow_downward, color: Colors.green),
              ),
              ButtonSegment<int>(
                value: 1,
                label: Text('Keluar'),
                icon: Icon(Icons.arrow_upward, color: Colors.red),
              ),
            ],
            selected: <int>{sentiment},
            onSelectionChanged: (Set<int> newSelection) {
              setState(() {
                sentiment = newSelection.first;
                selectedCategory = null;
              });
            },
          ),
          const SizedBox(height: 20),

          const Text("Jumlah", style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(border: InputBorder.none),
          ),
          const Divider(thickness: 1),

          const Text("Keterangan", style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(
            controller: _descController,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(border: InputBorder.none),
          ),
          const Divider(thickness: 1),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Custom Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    hint: const Text("Pilih Kategori", style: TextStyle(color: Colors.white)),
                    dropdownColor: Colors.green.shade700,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                    style: const TextStyle(color: Colors.white),
                    items: currentCategories.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    },
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: _isSaving ? null : _resetForm,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: const Text("Reset", style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: _isSaving ? null : _handleSave,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: _isSaving
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text("Save", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
