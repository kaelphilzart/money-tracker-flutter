import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; 
import 'package:provider/provider.dart';
import 'package:money_tracker_new/provider/transaction_provider.dart';
import 'package:money_tracker_new/provider/user_provider.dart';

import 'core/theme/app_theme.dart';
import 'package:money_tracker_new/presentation/pages/splash_page.dart';
import 'presentation/pages/filter.dart';
import 'presentation/pages/summary.dart';
import 'helper/isar_service.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await IsarService.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
         ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Philzart Finance',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashPage(),
      routes: {
        '/filter': (context) => const FilterPage(),
        '/summary': (context) => const SummaryPage(),
      },
    );
  }
}
