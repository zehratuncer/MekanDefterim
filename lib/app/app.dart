import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'router/app_router.dart';

class MekanDefterimApp extends StatelessWidget {
  const MekanDefterimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Mekan Defteri'm",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
