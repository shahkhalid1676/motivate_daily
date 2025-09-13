import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'core/theme/app_theme.dart';
import 'modules/auth/auth_controller/auth_controller.dart';
import 'routes/app_pages.dart';
import 'routes/app_rotes.dart';
import 'firebase_options.dart';

import 'core/theme/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize AuthController globally
  Get.put(AuthController());

  // Initialize ThemeController globally
  Get.put(ThemeController());

  runApp(const InspireMeApp());
}

class InspireMeApp extends StatelessWidget {
  const InspireMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Motivate Daily",
      debugShowCheckedModeBanner: false,

      // Themes
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // can toggle dynamically with ThemeController

      // Initial route based on login status
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? AppRoutes.login
          : AppRoutes.home,

      // Centralized GetX routes
      getPages: AppPages.pages,
    );
  }
}
