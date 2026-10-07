class RegisterResponse {
  final String action;
  final String message;
  final List<dynamic> memberRegister;

  RegisterResponse({
    required this.action,
    required this.message,
    required this.memberRegister,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      action: json['action']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      memberRegister: json['memberRegister'] is List
          ? json['memberRegister']
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    "action": action,
    "message": message,
    "memberRegister": memberRegister,
  };

  @override
  String toString() => toJson().toString();
}
