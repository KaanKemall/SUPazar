import 'package:flutter/material.dart';

import 'routes/app_routes.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const SUPazarApp());
}

class SUPazarApp extends StatelessWidget {
  const SUPazarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SUPazar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
