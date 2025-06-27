import 'package:flutter/material.dart';
import '../../layout/master_layout.dart';
import '../pages/home.dart';
import '../pages/history.dart';
import '../pages/transaction.dart';
import '../widget/bottom_bar.dart';
import '../widget/app_bar.dart';

class BottomNavigation extends StatefulWidget {
  final int initialIndex;
  const BottomNavigation({super.key, this.initialIndex = 1});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late int _selectedIndex;

  final List<Widget> _pages = const [
    HistoryPage(),
    HomePage(),
    TransactionPage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterLayout(
      appBar: const AppbarCustom(),
      bottomNavigationBar: BottomBarCustom(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      child: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }
}
