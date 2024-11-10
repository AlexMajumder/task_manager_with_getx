import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:task_manager/controller_binder.dart';
import 'package:task_manager/ui/screen/splash_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  _TaskManagerAppState createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: TaskManagerApp.navigatorKey,
      theme: ThemeData(
        colorSchemeSeed: AppColors.themeColor,
        textTheme: const TextTheme(),
        inputDecorationTheme: _inputDecorationTheme(),
        elevatedButtonTheme: _elevatedButtonThemeData()
      ),
      initialBinding: ControllerBinder(),
      initialRoute: '/',
      routes: {
        '/' :(context)   => const SplashScreen(),
      },
    );
  }

  InputDecorationTheme _inputDecorationTheme(){
    return InputDecorationTheme(
      fillColor: Colors.white,
      filled: true,
      hintStyle: const TextStyle(
        fontWeight: FontWeight.w300
      ),
      border: _inputBorder(),
      enabledBorder: _inputBorder(),
      focusedBorder: _inputBorder(),
      errorBorder: _inputBorder(),
    );
  }

  OutlineInputBorder _inputBorder(){
    return OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(8),
    );
  }

  ElevatedButtonThemeData _elevatedButtonThemeData(){
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.themeColor,
          foregroundColor: Colors.white,
          padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          fixedSize: const Size.fromWidth(double.maxFinite),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8))),
    );
  }


}