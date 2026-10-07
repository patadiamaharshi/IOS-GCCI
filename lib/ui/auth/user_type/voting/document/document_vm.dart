import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../../helper/shared_keys.dart';
import '../../../../../network/api_service/api_service.dart';
import '../../../../../network/app_config.dart';
import '../../../../../utils/pref_helper.dart';

class DocumentViewModel extends ChangeNotifier {
  final Function()? onNext;

  bool isLoading = false;
  List<dynamic> documentList = [];
  Map<int, File> documentFiles = {};
  Map<int, bool> uploadedStatus = {};
  Map<int, String?> documentErrors = {};

  DocumentViewModel({this.onNext});

  Future<void> loadInitialData(BuildContext context) async {
    await docList(context);
    await getDocumentList();
  }

  Future<void> docList(BuildContext context) async {
    final memberID = await Prefs.getData(SharedKeys.memberId);
    final requestBody = ({"mid": memberID});

    _setLoading(true);
    try {
      final response = await ApiService.instance.post<dynamic>(
        //context,
        "uploadDocumentList",
        body: requestBody,
      );

      documentList = response.data['uploadDocumentList'] ?? [];
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> uploadDocumentApi(
    BuildContext context,
    File imageFile,
    String docMid,
    int index,
  ) async {
    debugPrint(docMid);

    try {
      _setLoading(true);
      // debugPrint(imageFile.toString);

      String fileName = imageFile.path.split('/').last;
      final memberID = await Prefs.getData(SharedKeys.memberId);

      debugPrint("------------- upload document image request");

      debugPrint("memberID $memberID");
      debugPrint("doc_mid $docMid");
      debugPrint("fileName $fileName");
      debugPrint("path ${imageFile.path}");

      debugPrint("------------- upload document image request");

      FormData formData = FormData.fromMap({
        "mid": memberID.toString(),
        "doc_mid": docMid.toString(),
        "doc_file": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final response = await Dio().post(
        "${AppConfig.baseUrl}uploadDocument",
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );

      debugPrint("Upload Response: ${response.data}");
      final data = response.data;
      final bool status = data['status'] == true;
      final String message =
          data['message']?.toString() ?? "Something went wrong";

      if (!context.mounted) return;

      if (status) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        debugPrint("SUCCESS");

        uploadedStatus[index] = true;
        documentErrors[index] = null; // remove error
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        debugPrint("FAIL");
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Upload Error: $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Upload Failed")));
    } finally {
      _setLoading(false);
    }
  }

  void setDocumentFile(int index, File file) {
    // documentFiles[index] = file;
    // documentErrors[index] = null;
    // notifyListeners();
    // ----------- ORIGINAL IMAGE -----------
    //     I/flutter (32063): Path: /data/user/0/com.gcci.gcci/cache/189923e0-449b-405b-9e95-e9e0fed17fe86558706150181125134.jpg
    // I/flutter (32063): Resolution: 2992 x 4000
    // I/flutter (32063): Size: 3.87 MB


    // ORIGINAL IMAGE with Compressed--- -----------
    // I/flutter (32063): Path: /data/user/0/com.gcci.gcci/cache/189923e0-449b-405b-9e95-e9e0fed17fe86558706150181125134.jpg_compressed.jpg
    // I/flutter (32063): Resolution: 1920 x 2566
    // I/flutter (32063): Size: 0.78 MB
    documentFiles[index] = file;
    uploadedStatus[index] = false;
    documentErrors[index] = null;
    notifyListeners();
  }

  void removeDocumentFile(int index) {
    documentFiles.remove(index);
    uploadedStatus[index] =
        documentList[index]['document_link'] != null &&
            documentList[index]['document_link'].toString().isNotEmpty;

    documentErrors[index] = null; // Let validateDocuments handle error
    notifyListeners();
  }
  // void removeDocumentFile(int index) {
  //   documentFiles.remove(index);
  //   documentErrors[index] = "Document is required";
  //   notifyListeners();
  // }

  bool validateDocuments() {
    bool isValid = true;

    for (int i = 0; i < documentList.length; i++) {
      final item = documentList[i];
      final hasLocalFile = documentFiles.containsKey(i);
      final hasUploadedLink =
          item['document_link'] != null &&
              item['document_link'].toString().isNotEmpty;

      if (!hasLocalFile && !hasUploadedLink) {
        documentErrors[i] = "Document is required";
        isValid = false;
      } else {
        documentErrors[i] = null;
      }
    }

    notifyListeners();
    return isValid;
  }

 /* bool validateDocuments() {
    bool isValid = true;

    for (int i = 0; i < documentList.length; i++) {
      if (!documentFiles.containsKey(i)) {
        documentErrors[i] = "Document is required";
        isValid = false;
      } else {
        documentErrors[i] = null;
      }
    }

    notifyListeners();
    return isValid;
  }
*/
  Future<void> getDocumentList() async {
    final memberID = await Prefs.getData(SharedKeys.memberId);

    final response = await ApiService.instance.post<dynamic>(
      "getDocumentList",
      body: {"mid": memberID},
    );

    final res = response.data['uploadDocumentList'];

    documentList = res;
    for (int i = 0; i < documentList.length; i++) {
      final link = documentList[i]['document_link'];

      if (link != null && link.toString().isNotEmpty) {
        uploadedStatus[i] = true; // already uploaded
      } else {
        uploadedStatus[i] = false;
      }
    }
    notifyListeners();
  }




  /*Future<File> compressImage(File file) async {
    final data = await file.readAsBytes();

    final codec = await ui.instantiateImageCodec(
      data,
      targetWidth: 1600, // reduce resolution
    );

    final frame = await codec.getNextFrame();
    final image = frame.image;

    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    final dir = await getTemporaryDirectory();
    final compressedFile = File('${dir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.png');

    await compressedFile.writeAsBytes(byteData!.buffer.asUint8List());

    return compressedFile;
  }*/


}
