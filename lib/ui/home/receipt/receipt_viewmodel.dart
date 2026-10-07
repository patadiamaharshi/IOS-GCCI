import 'package:flutter/material.dart';
import '../../../helper/file_downloader.dart';
import '../../../network/api_service/api_service.dart';
import '../../../network/model/receipt_response.dart';

class ReceiptViewModel extends ChangeNotifier {
  final otpController = TextEditingController();
  List<Receipt> receipts = [];

  bool isLoading = false;

  Future<void> loadInitialData(BuildContext context) async {
    //await getReceiptList(context);
  }

  Future<void> getReceiptList(BuildContext context) async {
    _setLoading(true);
    try {
      final response = await ApiService.instance.post<ReceiptResponse>(
       // context,
        "eventList",
        fromJson: (data) => ReceiptResponse.fromJson(data),
      );


      //final response = await HomeService.instance.getReceiptList(context);
      receipts = response.data.receipts ?? [];
    } catch (e) {
      debugPrint('Error getReceiptList 👉 $e');
    }

    _setLoading(false);
    notifyListeners();
  }


  final List<Map<String, dynamic>> receipt = [
    {
      "title": "Receipts",
      "children": [
        {
          "No": "GCC00000811",
          "Name": "Service Charge Receipt",
          "Amount": "1500",
          "created_at": "20-12-2025 11:30 AM",
        },
      ],
    },
  ];

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  onDownloadClick() async {
    //debugPrint(" download file url ----------------- $linkUrl");

    FileDownloader.instance.downloadFile(
      url:
          "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
      // fileName: "myGCCI.pdf",
    );
  }
}