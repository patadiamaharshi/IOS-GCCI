import 'dart:convert';

import '../../helper/json_helper.dart';

class StateResponse {
  final List<StateList> state;

  StateResponse({required this.state});

  factory StateResponse.fromJson(Map<String, dynamic> json) {
    return StateResponse(
      state: JsonHelper.getList(
        json['stateList'],
            (e) => StateList.fromJson(e),
      ),
      // state: (json['stateList'] as List<dynamic>? ?? [])
      //     .map((e) => StateList.fromJson(e))
      //     .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stateList': state.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class StateList {
  final String? stateId;
  final String? stateName;
  final String? stateDefault;

  StateList({
    this.stateId,
    this.stateName,
    this.stateDefault,
  });

  factory StateList.fromJson(Map<String, dynamic> json) {
    return StateList(
      stateId: JsonHelper.getString(json['state_id']),
      stateName: JsonHelper.getString(json['state_name']),
      stateDefault: JsonHelper.getString(json['state_default']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state_id': stateId,
      'state_name': stateName,
      'state_default': stateDefault,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}