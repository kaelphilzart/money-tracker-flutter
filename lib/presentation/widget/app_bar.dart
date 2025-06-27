import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ← Tambahkan untuk SystemUiOverlayStyle

import 'package:money_tracker_new/core/theme/text_styles.dart';
import 'package:money_tracker_new/core/theme/color_schemes.dart';

class AppbarCustom extends StatelessWidget implements PreferredSizeWidget {
  const AppbarCustom({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // transparan
      elevation: 0, // hilangkan shadow
      title: Text(
        "Philzart Finance",
        style: AppTextStyles.headline1.copyWith(
          color: AppColorsLight.onPrimary,
        ),
      ),
      iconTheme: const IconThemeData(color: AppColorsLight.onPrimary),
      automaticallyImplyLeading: true,
      systemOverlayStyle: SystemUiOverlayStyle.light, // ← status bar putih
    );
  }
}
