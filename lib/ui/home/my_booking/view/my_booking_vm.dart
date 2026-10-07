import 'package:flutter/material.dart';
import '../../../../network/api_service/api_service.dart';
import '../../../../network/model/hall_response.dart';

class MyBookingViewModel extends ChangeNotifier {
  List<HallModel> bookings = [];

  bool isLoading = false;

  Future<void> loadInitialData(BuildContext context) async {
    await getHallList(context);
  }

  Future<void> getHallList(BuildContext context) async {
    _setLoading(true);
    try {
      final response = await ApiService.instance.post<HallResponse>(
        //context,
        "hallList",
        fromJson: (data) => HallResponse.fromJson(data),
      );
      bookings = response.data.halls;
    } catch (e) {
      debugPrint('Error getHallList 👉 $e');
    } finally {
      _setLoading(false);
    }
  }

  /*
  Color getStatusBgColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange.shade200;
      case 'APPROVED':
        return Colors.green.shade200;

      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey.shade300;
    }
  }*/

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> newBooking(BuildContext context) async {
  /*  Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddBookingScreen()),
    );*/
  }
}
