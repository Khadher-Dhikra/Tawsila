import 'package:flutter/material.dart';
import 'package:tawsila/core/router/app_router.dart';
import 'package:tawsila/core/theme/app_theme.dart';

class TawsilaApp extends StatelessWidget {
  const TawsilaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tawsila',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
