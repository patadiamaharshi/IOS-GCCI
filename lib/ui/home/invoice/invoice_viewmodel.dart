import 'package:flutter/material.dart';

import '../../../helper/shared_keys.dart';
import '../../../helper/file_downloader.dart';
import '../../../network/api_service/api_service.dart';
import '../../../network/model/invoice_response.dart';
import '../../../utils/pref_helper.dart';

class InvoiceViewModel extends ChangeNotifier {
  bool isLoading = false;
  String memberID = "";
  InvoiceResponse? invoiceResponse;

  Future<void> loadInitialData(BuildContext context) async {
    memberID = await Prefs.getData(SharedKeys.memberId);
    await getInvoiceList();
  }

  Future<void> getInvoiceList() async {
    final requestBody = {"member_id": memberID};

    _setLoading(true);
    try {
      final response = await ApiService.instance.post<InvoiceResponse>(
        // context,
        "memberInvoice",
        body: requestBody,
        fromJson: (data) => InvoiceResponse.fromJson(data),
      );

      // final response = await HomeService.instance.getInvoiceList(
      //   requestBody,
      //   context,
      // );
      invoiceResponse = response.data;
      debugPrint('Invoice Response 👉 $invoiceResponse');
    } catch (e) {
      debugPrint('Error getInvoiceList 👉 $e');
    }

    _setLoading(false);
    notifyListeners();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  onDownloadClick(paymentID, context) async {
    final requestBody = {
      "member_id": memberID.toString(),
      "payment_id": paymentID,
    };
    invoicePDF(requestBody, context);
    debugPrint(requestBody.toString());
  }

  Future<void> invoicePDF(requestBody, context) async {
    try {
      // final response = await ApiService.instance.memberInvoicePDF(
      //   requestBody,
      //   context,
      // );
      final response = await ApiService.instance.post<dynamic>(
        //context,
        "memberInvoicePDF",
        body: requestBody,
        //fromJson: (data) => InvoiceResponse.fromJson(data),
      );

      if (response.data != null &&
          response.data['invoiceLink'] != null &&
          response.data['invoiceLink'].toString().isNotEmpty) {
        FileDownloader.instance.downloadFile(url: response.data['invoiceLink']);
      }
    } catch (e) {
      debugPrint('Error invoicePDF invoice file  👉 $e');
    }

    _setLoading(false);
    notifyListeners();
  }
}
