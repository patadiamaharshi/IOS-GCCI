import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gcci/common/gcci_label.dart';
import 'package:gcci/theme/app_color.dart';
import 'package:gcci/utils/app_text_styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

Future<void> showImagePickerOptions({
  required BuildContext context,
  //required Function(File pickedImage) onImagePicked,
  required Function(File pickedFile) onFilePicked,
  required VoidCallback onRemove,
  //required bool hasImage,
  bool showDeleteOption = true,
  bool showDocumentOption = false
}) async {
  final ImagePicker picker = ImagePicker();

  void pickImage(ImageSource source) async {
    Navigator.pop(context);

    try {
      final XFile? pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        File originalFile = File(pickedFile.path);

        await printImageDetails(originalFile, label: "Image Picker ORIGINAL IMAGE");

        File compressedFile = await compressImageTo2MB(originalFile);

        await printImageDetails(compressedFile, label: "Image Picker COMPRESSED IMAGE");

        onFilePicked(compressedFile);
      }
    } catch (e) {
      debugPrint('Image picker error: $e');
    }
  }

  void pickDocument() async {
    Navigator.pop(context);

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx'],
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);

        debugPrint("----------- DOCUMENT PICKED -----------");
        debugPrint("Path: ${file.path}");
        debugPrint("Size: ${(await file.length()) / (1024 * 1024)} MB");
        debugPrint("--------------------------------------");

        onFilePicked(file);
      }
    } catch (e) {
      debugPrint('Document picker error: $e');
    }
  }


  /*void pick(ImageSource source) async {
    Navigator.pop(context); // Close the sheet
    try {
      final XFile? pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        onImagePicked(File(pickedFile.path));
      }
    } catch (e) {
      debugPrint('Image picker error: $e');
    }
  }*/

  List<Map<String, dynamic>> getOptions() {
    final options = [
      {
        'icon': Icons.camera_alt,
        'title': 'Camera',
        'type': 'camera',
      },
      {
        'icon': Icons.photo,
        'title': 'Gallery',
        'type': 'gallery',
      },
    ];

    if (showDocumentOption) {
      options.add({
        'icon': Icons.insert_drive_file,
        'title': 'Document',
        // 'title': 'Upload Document',
        'type': 'document',
      });
    }

    if (showDeleteOption) {
      options.add({
        'icon': Icons.delete,
        'title': 'Remove',
        'type': 'remove',
      });
    }

    return options;
  }

  showModalBottomSheet(
    context: context,
    builder: (ctx) => Padding(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: getOptions().map((option) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(option['icon'], size: 30, color: AppColor.primary),
            title: GCCILabel(
              option['title'],
              style: AppTextStyles.primary22_600,
            ),
            onTap: () {
              switch (option['type']) {
                case 'camera':
                  pickImage(ImageSource.camera);
                  break;

                case 'gallery':
                  pickImage(ImageSource.gallery);
                  break;

                case 'document':
                  pickDocument();
                  break;

                case 'remove':
                  Navigator.pop(context);
                  onRemove();
                  break;
              }
            },
           /* onTap: () {
              if (option['source'] == 'remove') {
                Navigator.pop(context);
                onRemove();
              } else {
                pick(option['source'] as ImageSource);
              }
            },*/
          );
        }).toList(),
      ),
    ),
  );
}

Future<void> printImageDetails(File file, {String label = ""}) async {
  try {
    // File size
    final bytes = await file.length();
    final sizeInMb = bytes / (1024 * 1024);

    // Image resolution
    final data = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(data);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    final width = image.width;
    final height = image.height;

    debugPrint("----------- $label -----------");
    debugPrint("Path: ${file.path}");
    debugPrint("Resolution: $width x $height");
    debugPrint("Size: ${sizeInMb.toStringAsFixed(2)} MB");
    debugPrint("--------------------------------");
  } catch (e) {
    debugPrint("Error reading image info: $e");
  }
}

Future<File> compressImageTo2MB(File file) async {
  final result = await FlutterImageCompress.compressAndGetFile(
    file.path,
    "${file.path}_compressed.jpg",
    quality: 50,
    keepExif: true,
    minWidth: 800,
    minHeight: 800,
  );

  return File(result!.path);
}
