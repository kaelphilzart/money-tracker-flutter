import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money_tracker_new/provider/transaction_provider.dart';
import '../widget/history_item_template.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().loadTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Consumer<TransactionProvider>(
            builder: (context, txProvider, _) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "History",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                          TextButton(
                            onPressed: () {
                              txProvider.resetFilterHistory();
                            },
                            child: const Text(
                              "Hapus Filter",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        IconButton(
                          icon: const Icon(
                            Icons.filter_list,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            Navigator.pushNamed(context, '/filter');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 2),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Consumer<TransactionProvider>(
                builder: (context, txProvider, _) {
                  final transactions = txProvider.transactions;

                  if (transactions.isEmpty) {
                    return const Center(child: Text("Tidak ada transaksi."));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return HistoryItem(transaction: transaction);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
