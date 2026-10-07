class LoginResponse {
  final String action;
  final String message;
  final List<dynamic> profileList;

  LoginResponse({
    required this.action,
    required this.message,
    required this.profileList,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      action: json['action']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      profileList: json['profile_list'] is List
          ? json['profile_list']
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    "action": action,
    "message": message,
    "profile_list": profileList,
  };

  @override
  String toString() => toJson().toString();
}
