import 'package:flutter/material.dart';
import 'package:money_tracker_new/presentation/pages/register.dart';
import 'package:money_tracker_new/provider/user_provider.dart';
import 'package:money_tracker_new/presentation/navigation/navigation.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUser();
    });
  }

  Future<void> _checkUser() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchUser();

    final user = userProvider.user;

    if (!mounted) return;

    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RegisterPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNavigation()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(color: Colors.green),
      ),
    );
  }
}
