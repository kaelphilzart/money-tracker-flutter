import 'package:flutter/material.dart';
import 'package:money_tracker_new/core/theme/text_styles.dart';
import 'package:intl/intl.dart';

class FilterForm extends StatefulWidget {
  final void Function(int) onSentimentChanged;
  final void Function(String?) onCategoryChanged;
  final void Function(DateTime?) onStartDateChanged;
  final void Function(DateTime?) onEndDateChanged;
  final VoidCallback onReset;
  final VoidCallback onApply;
  final int sentiment;
  final String? selectedCategory;
  final DateTime? startDate;
  final DateTime? endDate;

  const FilterForm({
    super.key,
    required this.sentiment,
    required this.selectedCategory,
    required this.startDate,
    required this.endDate,
    required this.onSentimentChanged,
    required this.onCategoryChanged,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onReset,
    required this.onApply,
  });

  @override
  State<FilterForm> createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  List<String> get currentCategories => widget.sentiment == 0
      ? ['Gaji', 'Bisnis', 'Freelance', 'Lainnya']
      : ['Kebutuhan Pokok', 'Transportasi', 'Lainnya'];

  String formatDate(DateTime? date) {
    return date != null
        ? DateFormat('dd/MM/yyyy').format(date)
        : 'Pilih Tanggal';
  }

  Future<void> selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? (widget.startDate ?? DateTime.now())
          : (widget.endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      if (isStart) {
        widget.onStartDateChanged(picked);
      } else {
        widget.onEndDateChanged(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const Text("Filter History", style: AppTextStyles.headline1),
        const SizedBox(height: 10),
        const Divider(thickness: 1, color: Colors.black),
        const SizedBox(height: 20),

        // Segmented Button
        SegmentedButton<int>(
          segments: const <ButtonSegment<int>>[
            ButtonSegment<int>(
                value: 0,
                label: Text('Masuk'),
                icon: Icon(Icons.arrow_downward, color: Colors.green)),
            ButtonSegment<int>(
                value: 1,
                label: Text('Keluar'),
                icon: Icon(Icons.arrow_upward, color: Colors.red)),
          ],
          selected: <int>{widget.sentiment},
          onSelectionChanged: (Set<int> newSelection) =>
              widget.onSentimentChanged(newSelection.first),
        ),

        const SizedBox(height: 20),

        // Dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.shade600,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: widget.selectedCategory,
              hint: const Text("Pilih Kategori",
                  style: TextStyle(color: Colors.white)),
              dropdownColor: Colors.green.shade800,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              style: const TextStyle(color: Colors.white),
              items: currentCategories.map((value) {
                return DropdownMenuItem<String>(
                    value: value, child: Text(value));
              }).toList(),
              onChanged: widget.onCategoryChanged,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Tanggal
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => selectDate(context, true),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.black),
                    foregroundColor: Colors.black),
                child: Text(formatDate(widget.startDate)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextButton(
                onPressed: () => selectDate(context, false),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.black),
                    foregroundColor: Colors.black),
                child: Text(formatDate(widget.endDate)),
              ),
            ),
          ],
        ),

        const SizedBox(height: 30),

        // Tombol Reset dan Filter
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: widget.onReset,
              style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.black, foregroundColor: Colors.white),
              child: const Text("Reset"),
            ),
            ElevatedButton(
              onPressed: widget.onApply,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white),
              child: const Text("Terapkan Filter"),
            ),
          ],
        ),
      ],
    );
  }
}
