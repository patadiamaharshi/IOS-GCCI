import 'package:flutter/material.dart';
import 'package:gcci/common/gcci_label.dart';
import 'package:gcci/ui/home/profile/profile.dart';
import '../../../theme/app_color.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  const HomeAppBar({super.key, required this.title,});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 10,
      backgroundColor: AppColor.appBarColor,

      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Builder(
          builder: (BuildContext context) {
            return IconButton(
              iconSize: 30,
              icon: Icon(Icons.menu, color: AppColor.primary),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),

      actionsPadding: const EdgeInsets.only(right: 10),
      actions: [
      /*  IconButton(
          icon: Icon(Icons.notifications, color: AppColor.primary,size: 30),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationScreen()),
            );
          },
        ),*/
        IconButton(
          icon: Icon(Icons.person, color: AppColor.primary,size: 30),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          },
        ),
      ],

      title: Row(
       children: [
         GCCILabel(
           widget.title,
           style: TextStyle(
             color: AppColor.primary,
             fontSize: 22.0,
             fontWeight: FontWeight.bold,
           ),
         ),
       ],
      )
    );
  }
}