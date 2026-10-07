import 'dart:io';

import 'package:dio/dio.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class FileDownloader {
  FileDownloader._();
  static final FileDownloader instance = FileDownloader._();

  final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  /// ---------------- INIT NOTIFICATION ----------------
  Future<void> initNotification() async {
    //const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const android = AndroidInitializationSettings('gcci_icon_bg');
    const settings = InitializationSettings(android: android);

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) async {
        if (Platform.isAndroid) {
          if (response.payload != null) {
            OpenFilex.open(response.payload!);
          }
         /* final intent = AndroidIntent(
            action: 'android.intent.action.VIEW_DOWNLOADS',
            flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
          );
          await intent.launch();*/
        }
      },
    );
  }

  /// ---------------- DOWNLOAD FILE ----------------
  Future<void> downloadFile({
    required String url,
    // required String fileName,
  }) async {
    try {
      Directory directory;

      // Permission only for Android <= 28
      if (Platform.isAndroid) {
        final sdk = (await DeviceInfoPlugin().androidInfo).version.sdkInt;
        if (sdk <= 28) {
          await Permission.storage.request();
        }
        directory = Directory('/storage/emulated/0/Download');
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final fileName = getFileNameFromUrl(url);

      final savePath = await _getUniqueFilePath(directory.path, fileName);
      final realFileName = savePath.split('/').last;

      await Dio().download(url, savePath);

      await _showDownloadNotification(savePath, realFileName);

      debugPrint('Downloaded: $savePath');
    } catch (e) {
      debugPrint('Download error: $e');
    }
  }

  /// ---------------- NOTIFICATION ----------------
  Future<void> _showDownloadNotification(String filePath, String fileName) async {
    final androidDetails = AndroidNotificationDetails(
      'download_channel',
      'Downloads',
      channelDescription: 'File download notifications',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _notifications.show(
      0,
      'Download complete',
      '$fileName downloaded',
      notificationDetails,
      payload: filePath,
    );
  }


  /// ---------------- UNIQUE FILE NAME ----------------
  Future<String> _getUniqueFilePath(String dirPath, String fileName) async {
    final dotIndex = fileName.lastIndexOf('.');
    final baseName =
    dotIndex == -1 ? fileName : fileName.substring(0, dotIndex);
    final extension =
    dotIndex == -1 ? '' : fileName.substring(dotIndex);

    String path = '$dirPath/$fileName';
    int count = 1;

    while (await File(path).exists()) {
      path = '$dirPath/$baseName($count)$extension';
      count++;
    }

    return path;
  }

  String getFileNameFromUrl(String url) {
    return url.split('/').last;
  }

}
