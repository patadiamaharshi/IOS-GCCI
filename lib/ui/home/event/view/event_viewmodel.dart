import 'package:flutter/material.dart';
import 'package:gcci/ui/home/event/add/add_event.dart';
import '../../../../network/api_service/api_service.dart';
import '../../../../network/model/event_response.dart';

class EventViewModel extends ChangeNotifier {
  bool isLoading = false;
  List<Event> events = [];

  Future<void> loadInitialData(BuildContext context) async {
    await getEventList(context);
  }

  Future<void> getEventList(BuildContext context) async {
    _setLoading(true);
    try {
      final response = await ApiService.instance.post<EventResponse>(
       // context,
        "eventList",
        fromJson: (data) => EventResponse.fromJson(data),
      );
      events = response.data.events ?? [];
    } catch (e) {
      debugPrint('Error getEventList 👉 $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> newEvent(BuildContext context, Event? event) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEventScreen(event: event)),
    );
  }
}
