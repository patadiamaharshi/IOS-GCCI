import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gcci/splash_screen.dart';
import 'package:gcci/theme/app_color.dart';
import 'package:in_app_update/in_app_update.dart';

import 'helper/app_navigator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  //await FileDownloader.instance.initNotification();
  //await FirebaseService.initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    checkForUpdate();
    //setupFirebaseMessaging();
    // final fcmToken = await FirebaseMessaging.instance.getToken();
  }

  @override
  Widget build(BuildContext context)   {
    return MaterialApp(
      navigatorKey: AppNavigator.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        brightness: Brightness.light,
        fontFamily: 'Poppins', //Set default font
        /*textTheme: ThemeData.light().textTheme.apply(
            bodyColor: AppColor.black,
            displayColor: AppColor.black,
          ),*/
        scaffoldBackgroundColor: AppColor.appBgColor,
      ),
      themeMode: ThemeMode.light, // Disable dark mode
      home: const SplashScreen(),
    );
  }

  Future<void> checkForUpdate() async {
    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable &&
          updateInfo.flexibleUpdateAllowed) {
        // Start Flexible Update
        InAppUpdate.startFlexibleUpdate()
            .then((_) {
              InAppUpdate.completeFlexibleUpdate();
            })
            .catchError((e) {
              debugPrint("Flexible update failed: $e");
            });
      }
    } catch (e) {
      debugPrint("Error checking for updates: $e");
    }
  }
}
