import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money_tracker_new/provider/transaction_provider.dart';

import '../widget/app_bar.dart';
import '../../layout/form_filter.dart';
import '../../layout/master_layout.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  int sentiment = 0;
  String? selectedCategory;
  DateTime? startDate;
  DateTime? endDate;

  void resetFilter() {
    setState(() {
      sentiment = 0;
      selectedCategory = null;
      startDate = null;
      endDate = null;
    });

    final provider = context.read<TransactionProvider>();
    provider.setSentiment(sentiment);
    provider.setCategory(selectedCategory);
    provider.setStartDate(startDate);
    provider.setEndDate(endDate);
    provider.applyFilter();
  }

  void applyFilter() {
    if (startDate != null && endDate != null && endDate!.isBefore(startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tanggal akhir harus setelah tanggal mulai")),
      );
      return;
    }

    final provider = context.read<TransactionProvider>();
    provider.setSentiment(sentiment);
    provider.setCategory(selectedCategory);
    provider.setStartDate(startDate);
    provider.setEndDate(endDate);
    provider.applyFilter();

    Navigator.pop(context); // kembali ke halaman sebelumnya
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterLayout(
      appBar: const AppbarCustom(),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: FilterForm(
                    sentiment: sentiment,
                    selectedCategory: selectedCategory,
                    startDate: startDate,
                    endDate: endDate,
                    onSentimentChanged: (val) =>
                        setState(() => sentiment = val),
                    onCategoryChanged: (val) =>
                        setState(() => selectedCategory = val),
                    onStartDateChanged: (val) =>
                        setState(() => startDate = val),
                    onEndDateChanged: (val) =>
                        setState(() => endDate = val),
                    onReset: resetFilter,
                    onApply: applyFilter,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
