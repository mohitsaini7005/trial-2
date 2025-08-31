import 'package:flutter/material.dart';
import '/pages/intro.dart';
import '/core/utils/next_screen.dart';

class DonePage extends StatefulWidget {
  const DonePage({super.key});

  @override
  State<DonePage> createState() => _DonePageState();
}

class _DonePageState extends State<DonePage> {


  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000)).then((_) {
      if (!mounted) return;
      nextScreenCloseOthers(context, const IntroPage());
    });
  }


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.8, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: const Icon(
                Icons.check_circle,
                size: 120,
                color: Colors.green,
              ),
            );
          },
        ),
      ),
    );
  }
}