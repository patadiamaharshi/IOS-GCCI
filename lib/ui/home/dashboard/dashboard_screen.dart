import 'package:flutter/material.dart';
import 'package:gcci/common/gcci_label.dart';
import 'package:gcci/common/no_data_text.dart';
import 'package:gcci/dialog/confirmation_dialog.dart';
import 'package:gcci/theme/app_color.dart';
import 'package:gcci/ui/auth/login/login.dart';
import 'package:gcci/ui/home/event/view/events.dart';
import 'package:gcci/ui/home/home/home_screen.dart';
import 'package:gcci/ui/home/invoice/invoice.dart';
import 'package:gcci/ui/home/my_booking/view/my_booking.dart';
import 'package:gcci/ui/home/profile/profile.dart';
import 'package:gcci/ui/home/receipt/receipt.dart';
import 'package:gcci/utils/app_text_styles.dart';
import 'package:gcci/utils/pref_helper.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../helper/permission_handler.dart';
import '../../../utils/app_strings.dart';
import '../hall/view/booking.dart';
import '../system_profiles/system_profiles.dart';
import '../youtube/youtube.dart';
import 'home_app_bar.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  late String _selectedPath = "home";
  late String _title = "GCCI";
  late IconData icon = Icons.home;

  String type = "";

  Key dashboardKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    requestPermission(Permission.notification);
  }

  final List<Map<String, dynamic>> dynamicMenu = [
    {"Name": "Home", "icon": Icons.home, "route": "home"},
    {"Name": "Profile", "icon": Icons.person, "route": "profile"},
    {"Name": "Profile List", "icon": Icons.person, "route": "profileList"},
    {"Name": "Invoice", "icon": Icons.receipt_long, "route": "invoice"},
    {"Name": "Receipt", "icon": Icons.receipt, "route": "receipt"},
    {"Name": "Event", "icon": Icons.event, "route": "event"},
    {"Name": "Hall Booking", "icon": Icons.meeting_room, "route": "hall"},
    {"Name": "My Booking", "icon": Icons.event_available, "route": "myBooking"},
    {"Name": "YouTube", /*"icon": FontAwesomeIcons.youtube,*/ "route": "youtube"},
    {"Name": "Logout", "icon": Icons.logout, "route": "logout"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(title: _title /*AppStrings.appName*/),
      drawer: Drawer(
        backgroundColor: AppColor.appBgColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 12,
              top: 30,
              right: 12,
              bottom: 25,
            ),
            child: Column(
              children: [
                Center(child: Image.asset('assets/gcci_icon.png', height: 120)),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(top: 40),
                    children: [
                      ...dynamicMenu.map((item) => menuItem(context, item)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _getSelectedPage(),
    );
  }

  Widget _getSelectedPage() {
    switch (_selectedPath) {
      case "home":
        return Home();
      case "invoice":
        return InvoiceScreen();
      case "event":
        return EventScreen();
      case "hall":
        return BookingScreen();
      case "myBooking":
        return MyBooking();
      case "receipt":
        return ReceiptScreen();
      default:
        return Center(child: CrmNoDataText());
    }
  }

  Widget menuItem(BuildContext context, Map<String, dynamic> item) {
    final bool isSelected = _selectedPath == item['route'];
    return ListTile(
      leading: Icon(
        item['icon'],
        color: isSelected ? AppColor.buttonColor : AppColor.primary,
      ),
      title: GCCILabel(
        item['Name']!,
        style: AppTextStyles.primary22_600.copyWith(
          color: isSelected ? AppColor.buttonColor : AppColor.primary,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        if (item['route'] == 'logout') {
          confirmationDialog(
            context,
            message: AppStrings.logoutWarning,
            btnRight: AppStrings.logout,
            onClick: () async {
              debugPrint("-- ---------------------- Logout  Click-------------------");
              await Prefs.clearAll();
              if(!context.mounted) return;

              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          );
          return;
        }

        if (item['route'] == 'profile') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProfileScreen()),
          );
          return;
        }

        if (item['route'] == 'profileList') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SystemProfileScreen()),
          );
          return;
        }
        if (item['route'] == 'youtube') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => Youtube()),
          );
          return;
        }

        setState(() {
          _selectedPath = item['route'];
          _title = AppStrings.appName;
          icon = item['icon'];
        });

        //Navigator.pop(context);
        //Navigator.pushNamed(context, item['route']);
      },
    );
  }
}
