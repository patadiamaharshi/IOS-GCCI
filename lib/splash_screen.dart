import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gcci/helper/shared_keys.dart';
import 'package:gcci/ui/auth/login/login.dart';
import 'package:gcci/ui/home/dashboard/dashboard_screen.dart';
import 'package:gcci/ui/home/system_profiles/system_profiles.dart';
import 'package:gcci/utils/pref_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  String appVersion = "";

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final isLoggedIn = (await Prefs.getData(SharedKeys.isLogin)) ?? false;
    final isProfileSelected =
        (await Prefs.getData(SharedKeys.isProfileSelected)) ?? false;

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (isProfileSelected) {
        Navigator.pushReplacement(
          context,
           MaterialPageRoute(builder: (context) => const Dashboard()),
          // MaterialPageRoute(builder: (context) => const AddBookingScreen()),
        );
      } else if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SystemProfileScreen()),
          //MaterialPageRoute(builder: (context) => const Dashboard()),
          //MaterialPageRoute(builder: (context) => const SystemProfileScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  "assets/gcci_icon.png",
                  width: 180,
                  height: 180,
                ),
              ),
            ),
            //const SizedBox(height: 20),
            //  const Text(
            //     AppStrings.appName,
            //   style: TextStyle(
            //     color: Colors.black,
            //     fontSize: 24.0,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
          /*  Padding(
              padding: const EdgeInsets.all(8.0),
              child: GCCILabel("App Version $appVersion",style: AppTextStyles.hint),
            )*/
          ],
        ),
      ),
    );
  }
}
