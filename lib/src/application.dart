import 'package:flutter/material.dart';
import 'package:foxbit_hiring_test_template/src/app_routes.dart';
import 'package:foxbit_hiring_test_template/src/core/constants/constants.dart';

class FoxbitApp extends StatelessWidget {
  const FoxbitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.white,
      ),
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}
