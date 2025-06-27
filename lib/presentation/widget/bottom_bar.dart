import 'package:flutter/material.dart';
import '../../core/theme/color_schemes.dart';

class BottomBarCustom extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomBarCustom({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  BottomNavigationBarItem _buildNavItem({
    required IconData iconData,
    required String label,
    required int index,
  }) {
    final bool isSelected = currentIndex == index;

    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: isSelected ? Matrix4.rotationZ(-0.1) : Matrix4.identity(),
        padding: isSelected ? const EdgeInsets.all(8) : EdgeInsets.zero,
        decoration: isSelected
            ? BoxDecoration(
               gradient: AppColorsLight.darkGreen,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              )
            : null,
        child: Icon(
          iconData,
          color: isSelected
              ? AppColorsLight.onPrimary
              : const Color.fromARGB(255, 255, 255, 255),
          size: 24,
        ),
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
         gradient: AppColorsLight.darkGreen,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: onTap,
        selectedItemColor: AppColorsLight.onPrimary,
        unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        showUnselectedLabels: true,
        items: [
          _buildNavItem(iconData: Icons.history, label: 'History', index: 0),
          _buildNavItem(iconData: Icons.home, label: 'Home', index: 1),
          _buildNavItem(iconData: Icons.swap_horiz, label: 'Transaction', index: 2),
        ],
      ),
    );
  }
}
