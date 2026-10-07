class Validators {
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email.trim());
  }

  static bool isValidMobile(String mobile) {
    final mobileRegex = RegExp(r'^\d{10}$');
    return mobileRegex.hasMatch(mobile.trim());
  }

  static bool isValidGST(String gst) {
    final gstRegex = RegExp(
      r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
    );
    return gstRegex.hasMatch(gst.trim());
  }

  static bool isValidPAN(String pan) {
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    return panRegex.hasMatch(pan);
  }

  static bool isValidPinCode(String pinCode) {
    final pinRegex = RegExp(r'^\d{6}$');
    return pinRegex.hasMatch(pinCode.trim());
  }
}
