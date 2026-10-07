import 'package:flutter/material.dart';
import 'package:gcci/utils/app_strings.dart';

import '../../../../dialog/confirmation_dialog.dart';
import '../../../../helper/shared_keys.dart';
import '../../../../network/api_service/api_service.dart';
import '../../../../network/model/event_response.dart';
import '../../../../network/model/profile_list_response.dart';
import '../../../../utils/pref_helper.dart';
import '../../web_view/web_view_screen.dart';

class AddEventViewModel extends ChangeNotifier {
  late final Event? event;
  final eventName = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final mobile = TextEditingController();
  final email = TextEditingController();
  final instituteOrgName = TextEditingController();
  final designation = TextEditingController();
  final gstNo = TextEditingController();
  final payment = TextEditingController();
  final eventAmount = TextEditingController();
  List<PaymentInfo> paymentInfo = [];
  PaymentInfo? selectedPayment;
  String? eventId;
  String? eventPaymentId;
  bool isLoading = false;
  String? representative;
  ProfileList? member;
  Map<String, dynamic>? data;

  AddEventViewModel(this.event) {
    _init();

    firstName.addListener(_onFieldChanged);
  //  lastName.addListener(_onFieldChanged);
    mobile.addListener(_onFieldChanged);
   // email.addListener(_onFieldChanged);
  }

  Future<void> _init() async {
    data = await Prefs.getObject(SharedKeys.member);
    debugPrint("result of member $data");

    if (data != null) {
      member = ProfileList.fromJson(data);
    }

    if (event != null) {
      eventId = event?.eventId ?? '';
      eventName.text = event?.eventName ?? '';

      if (event?.paymentInfo != null) {
        paymentInfo = event?.paymentInfo ?? [];

        // if (paymentInfo.isNotEmpty) {
        //   onOptionSelected(paymentInfo.first);
        // }
      }
    }

    onRadioSelected("Representative 1");
    notifyListeners();
  }

  void _onFieldChanged() => notifyListeners();

  bool get isVerify =>
      firstName.text.isNotEmpty &&
      lastName.text.isNotEmpty &&
      mobile.text.isNotEmpty &&
      email.text.isNotEmpty;

  bool get isReadOnlyRepresentative =>
      representative == "Representative 1" ||
      representative == "Representative 2";

  bool get isLastNameReadOnly =>
      representative == "Representative 1" ||
          representative == "Representative 2"
      ? lastName.text.trim().isNotEmpty
      : false;

  bool get isEmailReadOnly =>
      representative == "Representative 1" ||
          representative == "Representative 2"
      ? email.text.trim().isNotEmpty
      : false;

  void onRadioSelected(String value) {
    debugPrint("onRadioSelected $value");
    representative = value;

    //instituteOrgName.text = member.memberEmail;
    if (representative == "Representative 1") {
      if (member != null) {
        firstName.text = member?.memberRep1Fname ?? '';
        lastName.text = member?.memberRep1Lname ?? '';
        mobile.text = member?.memberRep1Mobile ?? '';
        email.text = member?.memberRep1Emailid ?? '';
        designation.text = member?.memberRep1Designation ?? '';
        gstNo.text = member?.memberGstno ?? '';
      }
    } else if (representative == "Representative 2") {
      if (member != null) {
        firstName.text = member?.memberRep2Fname ?? '';
        lastName.text = member?.memberRep2Lname ?? '';
        mobile.text = member?.memberRep2Mobile ?? '';
        email.text = member?.memberRep2Emailid ?? '';
        designation.text = member?.memberRep2Designation ?? '';
        gstNo.text = member?.memberGstno ?? '';
      }
    } else {
      firstName.clear();
      lastName.clear();
      mobile.clear();
      email.clear();
      designation.clear();
      gstNo.clear();
    }
    notifyListeners();
  }

  void onOptionSelected(PaymentInfo? event) {
    selectedPayment = event;
    eventPaymentId = event?.eventPaymentID ?? '';
    eventAmount.text = event?.memberAmount ?? '';
    debugPrint("onOptionSelected $event");
    notifyListeners();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> onlinePayment(BuildContext context) async {
    final memberID = await Prefs.getData(SharedKeys.memberId);

    final requestBody = {
      "member_id": memberID.toString().trim(),
      "ddl_event": eventId.toString().trim(),
      "ddl_details": eventPaymentId.toString().trim(),
      "fname": firstName.text.toString().trim(),
      "lname": lastName.text.toString().trim(),
      "mobile": mobile.text.toString().trim(),
      "email": email.text.toString().trim(),
      "institute": instituteOrgName.text.toString().trim(),
      "occupation": designation.text.toString().trim(),
      "gstno": gstNo.text.toString().trim(),
      "amount": eventAmount.text.toString().trim(),
      "dataSource": "Mobile",
    };

    debugPrint("add event onlinePayment -- $requestBody");
    if (!context.mounted) return;

    getPaymentLink(requestBody, context);
    //_setLoading(false);
  }

  Future<void> getPaymentLink(requestBody, context) async {
    _setLoading(true);

    try {
      final response = await ApiService.instance.post<dynamic>(
       "eventRegistration",// "paymentAPILink",
        body: requestBody,
      );

      debugPrint(
        "payment API LINK --------------------- ${response.data['APILINK']}",
      );
      _setLoading(false);

      if (response.data != null) {
        String fixedUrl =
            response.data['payu_url']?.toString().replaceAll(' ', '') ?? '';

        if (!context.mounted) return;

        // Check if URL starts with http or https
        if (fixedUrl.startsWith("http://") || fixedUrl.startsWith("https://")) {
          //debugPrint("Paid event ------------------------- ${response.data['data']}");

          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              //builder: (_) => WebViewScreen(fixedUrl, requestBody),
              builder: (_) => WebViewScreen(fixedUrl,   Map<String, dynamic>.from(response.data['data']),),
            ),
          );

          if (result == null) return;
          final action = result["action"].toString().toLowerCase();
          final message = result["message"].toString();

          switch (action) {
            case "success":
              DialogHelper.alertDialog(
                iconPath: "assets/check.png",
                btnString: AppStrings.done,
                errorMessageHeading: "Payment Successful",
                errorMessageTitle: message,
                onClick: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.pop(context);
                },
              );
              break;

            case "failed":
              DialogHelper.alertDialog(
                iconPath: "assets/error.png",
                btnString: AppStrings.done,
                errorMessageHeading: "Payment Failed",
                errorMessageTitle: message,
                onClick: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              );
              break;

            case "notify":
              DialogHelper.alertDialog(
                iconPath: "assets/info.png",
                btnString: AppStrings.done,
                errorMessageHeading: "Payment Pending",
                errorMessageTitle: message,
                onClick: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              );
              break;

            default:
              DialogHelper.alertDialog(
                iconPath: "assets/error.png",
                btnString: AppStrings.done,
                errorMessageHeading: "Payment Status",
                errorMessageTitle: message,
                onClick: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              );
          }

         /* if (result == true) {
            DialogHelper.alertDialog(
              iconPath: "assets/check.png",
              btnString: AppStrings.done,
              errorMessageHeading: "Payment Successful",
              errorMessageTitle:
                  "Your event has been registered successfully and Thank you for your payment.",
              onClick: () {
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.pop(context);
              },
            );
            debugPrint("Paid event ------------------------- payment done");
          }*/
        } else {
          DialogHelper.alertDialog(
            iconPath: "assets/check.png",
            btnString: AppStrings.done,
            errorMessageHeading: "Thanks for registration",
            errorMessageTitle:
                "Your event registration has been completed successfully.",
            onClick: () {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.pop(context);
            },
          );
          debugPrint("Free event ------------------------- payment done");
        }
      }

      /* if (response != null && response.data != null) {
        String fixedUrl = response.data['APILINK'].replaceAll(' ', '');

        final result = await Navigator.push(
          context,
          // MaterialPageRoute(builder: (_) => WebViewScreen("https://google.com",requestBody)),
          MaterialPageRoute(
            builder: (_) => WebViewScreen(
              fixedUrl,
             // "https://www.gujaratchamber.org/ccavRequestHandlerEvent.php",
              requestBody,
            ),
          ),
        );
        if (result == true) {
          DialogHelper.alertDialog(
            context,
            iconPath: "assets/check.png",
            btnString: AppStrings.done,
            errorMessageHeading: "Payment Successful",
            errorMessageTitle:
                "Your event has been registered successfully and Thank you for your payment.",
            onClick: () {
              Navigator.of(context, rootNavigator: true).pop(); // close dialog
              Navigator.pop(context); // go back screen
            },
          );
          debugPrint("------------------------- payment done");
        }
      }*/
    } catch (e) {
      debugPrint('Error getPaymentLink  👉 $e');
    }

    _setLoading(false);
    notifyListeners();
  }

  @override
  void dispose() {
    eventName.dispose();
    firstName.dispose();
    lastName.dispose();
    mobile.dispose();
    email.dispose();
    instituteOrgName.dispose();
    designation.dispose();
    gstNo.dispose();
    super.dispose();
  }
}
