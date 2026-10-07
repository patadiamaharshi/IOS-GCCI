import 'package:flutter/material.dart';
import 'package:gcci/helper/extension.dart';

import '../../../../helper/shared_keys.dart';
import '../../../../network/api_service/api_service.dart';
import '../../../../network/model/hall_response.dart';
import '../../../../network/model/hall_setting_response.dart';
import '../../../../network/model/refreshment_response.dart';
import '../../../../network/model/service_response.dart';
import '../../../../utils/pref_helper.dart';

class AddBookingViewModel extends ChangeNotifier {
  final bookingDate = TextEditingController();
  String? duration;
  DateTime? selectedDateIs;

  final fromTime = TextEditingController();
  final toTime = TextEditingController();
  String? isMember = "No";
  final memNo = TextEditingController();
  final orgName = TextEditingController();
  bool orgNameReadOnly = false;
  final address = TextEditingController();
  bool addressReadOnly = false;
  final mobile = TextEditingController();
  bool mobileReadOnly = false;
  final landline = TextEditingController();
  bool landlineReadOnly = false;
  final gstNo = TextEditingController();
  bool gstReadOnly = false;
  List<String> repList = [];
  String authPersonName = "";
  List<dynamic> repFullList = [];
  bool isLoading = false;

  final purpose = TextEditingController();
  final refundChequeName = TextEditingController();
  String? labelGST = "GST";
  String? labelDiscount = "Discount";

  List<HallModel> hallList = [];
  HallModel? selectedHall;
  final hallAmount = TextEditingController();
  final extraHour = TextEditingController();
  final extraHourCharge = TextEditingController();
  final finalAmount = TextEditingController();
  final totalAmount = TextEditingController();

  //final advanceAmount = TextEditingController();
  final roundOff = TextEditingController();
  final subTotal = TextEditingController();
  final memberDiscount = TextEditingController();
  final memberGst = TextEditingController();

  List<ServiceModal> serviceForms = [];
  List<RefreshmentModal> refreshForms = [];
  List<ServiceModel> serviceList = [];
  List<RefreshmentModel> refreshmentList = [];
  List<dynamic> holidayList = [];
  List<HallSettingModel> hallSetting = [];
  List<ValetModal> valetForms = [];
  List<HallSettingModel> valetList = [];

  AddBookingViewModel() {
    bookingDate.addListener(_onFieldChanged);
    fromTime.addListener(_onFieldChanged);
    toTime.addListener(_onFieldChanged);
    memNo.addListener(_onFieldChanged);
    orgName.addListener(_onFieldChanged);
    address.addListener(_onFieldChanged);
    mobile.addListener(_onFieldChanged);
    landline.addListener(_onFieldChanged);
    gstNo.addListener(_onFieldChanged);
    purpose.addListener(_onFieldChanged);
    refundChequeName.addListener(_onFieldChanged);
    hallAmount.addListener(_onFieldChanged);
    extraHour.addListener(_onFieldChanged);
    extraHourCharge.addListener(_onFieldChanged);
  }

  void _onFieldChanged() => notifyListeners();

  bool get isVerify =>
      bookingDate.text.isNotEmpty &&
      orgName.text.isNotEmpty &&
      address.text.isNotEmpty &&
      mobile.text.isNotEmpty &&
      landline.text.isNotEmpty &&
      gstNo.text.isNotEmpty &&
      purpose.text.isNotEmpty &&
      refundChequeName.text.isNotEmpty &&
      extraHour.text.isNotEmpty &&
      (isMember != "Yes" || authPersonName.isNotEmpty);

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> loadInitialData(BuildContext context) async {
    await getHallList();
    await getServiceList();
    await getRefreshmentList();
    await getHallSetting();
  }

  void onDurationSelected(String? value) {
    duration = value.toString();

    if (duration != "Hourly") {
      fromTime.text = "";
      toTime.text = "";
      extraHour.text = "";
      //  extraHourCharge.text = "";
    }

    notifyListeners();
  }

  void updateRelatedFields() {
    bool isHallHoliday = false;

    if (selectedDateIs != null) {
      isHallHoliday = isHoliday(
        date: selectedDateIs!,
        holidayEnabled: selectedHall?.holiday,
        holidayList: holidayList,
      );

      final bool isHallSunday = isSunday(
        date: selectedDateIs!,
        sundayEnabled: selectedHall?.sunday,
      );

      final bool isHallSaturday = isSpecialSaturday(
        date: selectedDateIs!,
        saturdayEnabled: selectedHall?.saturday,
      );
/*
      debugPrint("isSelectedHall -- : ${selectedHall.toString()}");
      debugPrint("isHallHoliday -- : $isHallHoliday");
      debugPrint("isHallSunday -- : $isHallSunday");
      debugPrint("isHallSaturday : $isHallSaturday");*/

      String hallRate;
      String extraRate;

      if (isMember == "Yes") {
        // Default rates
        hallRate = selectedHall?.memberHallRate ?? "0";
        extraRate = selectedHall?.memberAdditionalHoursRate ?? "0";

        if (isHallHoliday) {
          hallRate = selectedHall?.memberHolidayHallRate ?? "0";
          extraRate = selectedHall?.memberAdditionalHolidayHoursRate ?? "0";
        } else if (isHallSunday) {
          hallRate = selectedHall?.memberFulldayHolidayRate ?? "0";
          extraRate = selectedHall?.memberAdditionalHolidayHoursRate ?? "0";
        } else if (isHallSaturday) {
          hallRate = selectedHall?.memberFulldayWeekdayRate ?? "0";
          extraRate = selectedHall?.memberAdditionalHolidayHoursRate ?? "0";
        }
      } else {
        // Default rates
        hallRate = selectedHall?.nonMemberHourRate ?? "0";
        extraRate = selectedHall?.additionalNonMemberHoursRate ?? "0";

        if (isHallHoliday) {
          hallRate = selectedHall?.nonMemberHolidayHourRate ?? "0";
          extraRate = selectedHall?.additionalNonMemberHolidayHoursRate ?? "0";
        } else if (isHallSunday) {
          hallRate = selectedHall?.nonMemberFulldayHoliday ?? "0";
          extraRate = selectedHall?.additionalNonMemberHolidayHoursRate ?? "0";
        } else if (isHallSaturday) {
          hallRate = selectedHall?.nonMemberFulldayWeekday ?? "0";
          extraRate = selectedHall?.additionalNonMemberHolidayHoursRate ?? "0";
        }
      }

      hallAmount.text = hallRate;
      extraHourCharge.text = extraRate;

      // Update all selected services
      for (int i = 0; i < serviceForms.length; i++) {
        final service = serviceForms[i].selectedService;
        if (service == null) continue;

        String serviceRate;
        final bool isServiceHoliday = isHoliday(
          date: selectedDateIs!,
          holidayEnabled: service.serviceHoliday,
          holidayList: holidayList,
        );

        final bool isServiceSunday = isSunday(
          date: selectedDateIs!,
          sundayEnabled: service.serviceSunday,
        );

        final bool isServiceSaturday = isSpecialSaturday(
          date: selectedDateIs!,
          saturdayEnabled: service.serviceSaturday,
        );

        if (isMember == "Yes") {
          serviceRate = service.memberServiceAmount ?? "0";

          if (extraHour.text.isNotEmpty && isServiceHoliday) {
            serviceRate =
                service.memberAdditionalHolidayServicesHoursRate ?? "0";
          } else if (extraHour.text.isNotEmpty) {
            serviceRate = service.memberAdditionalHoursServicesRate ?? "0";
          } else if (isServiceHoliday) {
            serviceRate = service.memberHolidayServicesRate ?? "0";
          } else if (isServiceSunday) {
            serviceRate = service.memberFulldayHolidayServicesRate ?? "0";
          } else if (isServiceSaturday) {
            serviceRate = service.memberFulldayWeekdayServicesRate ?? "0";
          }
        } else {
          serviceRate = service.nonMemberServicesRate ?? "0";
          if (extraHour.text.isNotEmpty && isServiceHoliday) {
            serviceRate =
                service.additionalHoursNonMemberHolidayServicesRate ?? "0";
          } else if (isServiceHoliday) {
            serviceRate = service.nonMemberHolidayServicesRate ?? "0";
          } else if (extraHour.text.isNotEmpty) {
            serviceRate = service.additionalHoursNonMemberServicesRate ?? "0";
          } else if (isServiceSunday) {
            serviceRate = service.nonMemberFulldayHolidayServicesRate ?? "0";
          } else if (isServiceSaturday) {
            serviceRate = service.nonMemberFulldayWeekdayServicesRate ?? "0";
          }
        }

        serviceForms[i].serviceAmount.text = serviceRate;
      }
    } else {
      if (isMember == "Yes") {
        hallAmount.text = selectedHall?.memberHallRate ?? "";
        extraHourCharge.text = selectedHall?.memberAdditionalHoursRate ?? "";
      } else {
        hallAmount.text = selectedHall?.nonMemberHourRate ?? "";
        extraHourCharge.text = selectedHall?.additionalNonMemberHoursRate ?? "";
      }
    }

    //debugPrint("isHallHoliday: $isHallHoliday");
    updateFinalAmount();
    notifyListeners();
  }

  void isMemberSelect(String? value) {
    isMember = value.toString();
    bool isYes = value == "Yes";

    if (!isYes) memNo.clear();

    _clearControllers();

    orgNameReadOnly = addressReadOnly = mobileReadOnly = landlineReadOnly =
        gstReadOnly = isYes;

    authPersonName = "";
    repList.clear();
    updateRelatedFields();
    notifyListeners();
  }

  void _clearControllers() {
    orgName.clear();
    address.clear();
    mobile.clear();
    landline.clear();
    gstNo.clear();
  }

  void onMemNoChanged(String memNo) {
    Future.delayed(const Duration(seconds: 2), () {
      getMemberDetailFromCode(memNo);
    });
  }

  void onRepSelect(String value) {
    debugPrint("onRepSelect $value");
    authPersonName = value;

    final selectedRep = repFullList.cast<Map<String, dynamic>?>().firstWhere(
      (e) => e?['rep_name'] == value,
      orElse: () => null,
    );
    mobile.text = selectedRep?['mobile_no']?.toString() ?? '';
    notifyListeners();
  }

  void onHAllSelected(HallModel? hall) {
    selectedHall = hall;
    updateRelatedFields();
  }

  void onServiceSelect(int index, ServiceModel? service) {
    serviceForms[index].selectedService = service;
    updateRelatedFields();
  }

  void onRefreshmentSelect(int index, RefreshmentModel? refreshment) {
    refreshForms[index].selectedRefreshment = refreshment;
    refreshForms[index].rate.text =
        refreshment?.refreshmentAmount?.toString() ?? '';

    debugPrint(
      "Selected Refreshment at $index : ${refreshment?.refreshmentName}",
    );
    notifyListeners();
  }

  void refreshNumberChanged(int index, String value) {
    debugPrint(value);
    final rate = double.tryParse(refreshForms[index].rate.text) ?? 0.0;

    final qty = double.tryParse(refreshForms[index].number.text) ?? 0.0;

    final total = rate * qty;

    refreshForms[index].refAmount.text = total.toStringAsFixed(2);
    updateFinalAmount();
  }

  void valetNumberChanged(int index, String value) {
    debugPrint(value);
    final rate = double.tryParse(valetForms[index].valetRate.text) ?? 0.0;

    final qty = double.tryParse(valetForms[index].valetNumber.text) ?? 0.0;

    final total = rate * qty;

    valetForms[index].valetAmount.text = total.toStringAsFixed(2);
    updateFinalAmount();
  }

  void updateFinalAmount() {
    double totalServiceAmount = 0.0;
    double totalRefreshmentAmount = 0.0;
    double totalValetAmount = 0.0;

    final hallAmt = double.tryParse(hallAmount.text) ?? 0.0;
    final extraHallCharge = double.tryParse(extraHourCharge.text) ?? 0.0;
    final extraHours = double.tryParse(extraHour.text) ?? 0.0;

    for (var service in serviceForms) {
      totalServiceAmount += double.tryParse(service.serviceAmount.text) ?? 0.0;
    }

    for (var refresh in refreshForms) {
      totalRefreshmentAmount += double.tryParse(refresh.refAmount.text) ?? 0.0;
    }

    for (var valet in valetForms) {
      totalValetAmount += double.tryParse(valet.valetAmount.text) ?? 0.0;
    }

    final total =
        hallAmt +
        (extraHallCharge * extraHours) +
        totalServiceAmount +
        totalRefreshmentAmount +
        totalValetAmount;

    subTotal.text = total.toStringAsFixed(2);

    // Discount
    final discountPercent = getSettingPercent("6");
    labelDiscount = "Discount ${discountPercent.toInt()}%";

    final discount = total * (discountPercent / 100);
    memberDiscount.text = discount.toStringAsFixed(2);

    //Total Amount
    final totalAfterDiscount = total - discount;
    totalAmount.text = totalAfterDiscount.toStringAsFixed(2);

    final gstPercent = getSettingPercent("5");
    labelGST = "GST ${gstPercent.toInt()}%";

    final gst = totalAfterDiscount * (gstPercent / 100);
    memberGst.text = gst.toStringAsFixed(2);

    // Amount before round off
    final finalAmountValue = totalAfterDiscount + gst;

    // Rounded amount
    final roundedAmount = finalAmountValue.roundToDouble();

    // Round off difference
    final roundOffValue = roundedAmount - finalAmountValue;

    roundOff.text = roundOffValue.toStringAsFixed(2);

    // Final payable amount
    finalAmount.text = roundedAmount.toStringAsFixed(2);

    notifyListeners();
  }

  Future<void> getMemberDetailFromCode(String memNo) async {
    _setLoading(true);

    final requestBody = ({"member_code": memNo});
    authPersonName = "";

    try {
      final response = await ApiService.instance.post<dynamic>(
        "getMemberDetailsFromCode",
        body: requestBody,
      );

      final data = response.data?['representatives'] ?? [];
      repFullList = data;
      repList = data.map<String>((e) => e['rep_name'].toString()).toList();

      orgName.text = response.data?['member_name'] ?? '';
      orgNameReadOnly = true;
      addressReadOnly = true;
      mobileReadOnly = true;
      landlineReadOnly = true;
      gstReadOnly = true;
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getHallList() async {
    _setLoading(true);
    try {
      final response = await ApiService.instance.post<HallResponse>(
        "hallList",
        fromJson: (data) => HallResponse.fromJson(data),
      );
      hallList = response.data.halls;
    } catch (e) {
      debugPrint('Error getHallList add hall screen 👉 $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getServiceList() async {
    _setLoading(true);
    try {
      final response = await ApiService.instance.post<ServiceResponse>(
        "servicesList",
        fromJson: (data) => ServiceResponse.fromJson(data),
      );

      serviceList = response.data.services;
    } catch (e) {
      debugPrint('Error getServiceList add hall screen 👉 $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getHoliday(String date) async {
    _setLoading(true);
    try {
      final response = await ApiService.instance.post<dynamic>(
        "holidayList",
        // body: {date},
        fromJson: (data) => data,
      );
      holidayList = response.data['refreshment'];
      //  debugPrint("Holiday List: $holidayList");
    } catch (e) {
      debugPrint('Error getServiceList add hall screen 👉 $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getRefreshmentList() async {
    _setLoading(true);
    try {
      final response = await ApiService.instance.post<RefreshmentResponse>(
        "refreshmentList",
        fromJson: (data) => RefreshmentResponse.fromJson(data),
      );

      refreshmentList = response.data.refreshment;
    } catch (e) {
      debugPrint('Error getServiceList add hall screen 👉 $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getHallSetting() async {
    _setLoading(true);
    try {
      final response = await ApiService.instance.post<HallSettingResponse>(
        "hallSetting",
        fromJson: (data) => HallSettingResponse.fromJson(data),
      );

      hallSetting = response.data.hallSetting;
      valetList = hallSetting
          .where((item) => item.settingId == "3" || item.settingId == "4")
          .toList();

      valetForms.clear();

      for (var item in valetList) {
        final form = ValetModal();
        form.valetParking.text = item.settingsName ?? "";
        form.valetRate.text = item.settingAmount?.toString() ?? "";
        // form.valetNumber.text = "";
        // form.valetAmount.text = "";
        valetForms.add(form);
      }

      notifyListeners();
      debugPrint('valetList screen 👉 $valetList');
    } catch (e) {
      debugPrint('Error getHallSetting add hall screen 👉 $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> onlinePayment(BuildContext context) async {
    //  _setLoading(true);

    final memberID = await Prefs.getData(SharedKeys.memberId);

    List<Map<String, String?>> serviceData = serviceForms.map((form) {
      return {
        "serviceName": form.selectedService?.serviceName.toString(),
        "serviceAmount": form.serviceAmount.text,
      };
    }).toList();

    List<Map<String, String?>> refreshData = refreshForms.map((form) {
      return {
        "refreshName": form.selectedRefreshment?.refreshmentName.toString(),
        "refreshRate": form.rate.text.trim(),
        "refreshNumber": form.number.text.trim(),
        "refreshAmount": form.refAmount.text.trim(),
      };
    }).toList();

    List<Map<String, String?>> valetData = valetForms.map((form) {
      return {
        "valetName": form.valetParking.text.trim(),
        "valetRate": form.valetRate.text.trim(),
        "valetNumber": form.valetNumber.text.trim(),
        "valetAmount": form.valetAmount.text.trim(),
      };
    }).toList();

    final requestBody = {
      "member_id": memberID.toString().trim(),
      'bookingDate': bookingDate.text.toString().trim(),
      'duration': duration.toString().trim(),
      'from': fromTime.text.toString().trim(),
      'to': toTime.text.toString().trim(),
      'isMember': isMember,
      'memNo': memNo.text.toString().trim(),
      'orgName': orgName.text.toString().trim(),
      'authPersonName': authPersonName.toString().trim(),
      'address': address.text.toString().trim(),
      "mobile": mobile.text.trim(),
      "landline": landline.text.trim(),
      "gstNo": gstNo.text.trim(),
      'purpose': purpose.text.toString().trim(),
      'refundChequeName': refundChequeName.text.toString().trim(),
      'hallName': selectedHall?.hallId.toString(),
      'hallAmount': hallAmount.text.toString(),
      'extraHour': extraHour.text.toString(),
      'extraHourCharge': extraHourCharge.text.toString(),
      'service': serviceData,
      'refreshment': refreshData,
      'valet': valetData,
      'finalAmount': finalAmount.text.toString(),
    };

    debugPrint("Add hall Form -- $requestBody");
    //getPaymentLink(requestBody, context);

    // final response = await ApiService.instance.post<dynamic>(
    //   //   context,
    //   "hallBooking",
    //   body: requestBody,
    //   //fromJson: (data) => InvoiceResponse.fromJson(data),
    // );

    //     // _setLoading(false);
    //     // final result = await Navigator.push(
    //     //   context,
    //     //  // MaterialPageRoute(builder: (_) => WebViewScreen("https://google.com",requestBody)),
    //     //   MaterialPageRoute(builder: (_) => WebViewScreen("https://www.gujaratchamber.org/ccavRequestHandlerEvent.php",requestBody)),
    //     // );
  }

  void addServiceForm() {
    serviceForms.add(ServiceModal());
    notifyListeners();
  }

  void addRefreshmentModal() {
    refreshForms.add(RefreshmentModal());
    notifyListeners();
  }

  void addValetModal() {
    valetForms.add(ValetModal());
    notifyListeners();
  }

  removeServiceAt(index) {
    serviceForms.removeAt(index);
    updateFinalAmount();
    notifyListeners();
  }

  removeRefreshmentAt(index) {
    refreshForms.removeAt(index);
    updateFinalAmount();
    notifyListeners();
  }

  removeValetAt(index) {
    valetForms.removeAt(index);
    updateFinalAmount();
    notifyListeners();
  }

  double getSettingPercent(String id) {
    final setting = hallSetting
        .where((item) => item.settingId.toString() == id)
        .firstOrNull;

    return double.tryParse(
          (setting?.settingAmount ?? '0').replaceAll('%', ''),
        ) ??
        0;
  }

  //   Future<void> getPaymentLink(requestBody, context) async {
  //     _setLoading(true);
  //
  //     try {
  //       final response = await ApiService.instance.post<dynamic>(
  //         //   context,
  //         "paymentAPILink",
  //         body: requestBody,
  //         //fromJson: (data) => InvoiceResponse.fromJson(data),
  //       );
  //       // final response = await ApiService.instance.getPaymentLink(
  //       //   requestBody,
  //       //   context,
  //       // );
  //
  //       debugPrint(
  //         "payment API LINK --------------------- ${response.data['APILINK']}",
  //       );
  //
  //       if (response != null && response.data != null) {
  //         String fixedUrl =
  //             response.data['APILINK']?.toString().replaceAll(' ', '') ?? '';
  //
  //         if (fixedUrl.startsWith("http://") || fixedUrl.startsWith("https://")) {
  //           final result = await Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (_) => WebViewScreen(fixedUrl, requestBody),
  //             ),
  //           );
  //
  //           if (result == true) {
  //             DialogHelper.alertDialog(
  //               iconPath: "assets/check.png",
  //               btnString: AppStrings.done,
  //               errorMessageHeading: "Payment Successful",
  //               errorMessageTitle:
  //                   "Your event has been registered successfully and Thank you for your payment.",
  //               onClick: () {
  //                 Navigator.of(context, rootNavigator: true).pop();
  //                 Navigator.pop(context);
  //               },
  //             );
  //             debugPrint("------------------------- payment done");
  //           }
  //         } else {
  //           DialogHelper.alertDialog(
  //             iconPath: "assets/check.png",
  //             btnString: AppStrings.done,
  //             errorMessageHeading: "Request Sent",
  //             errorMessageTitle:
  //                 "Your request has been sent successfully and Thank you for the interest.",
  //             onClick: () {
  //               Navigator.of(context, rootNavigator: true).pop(); // close dialog
  //               Navigator.pop(context); // go back screen
  //             },
  //           );
  //
  //           debugPrint("------------------------- hall done");
  //         }
  //
  //         /* final result = await Navigator.push(
  //           context,
  //           // MaterialPageRoute(builder: (_) => WebViewScreen("https://google.com",requestBody)),
  //           MaterialPageRoute(
  //             builder: (_) => WebViewScreen(
  //               response.data['APILINK'],
  //               requestBody,
  //             ),
  //           ),
  //         );*/
  //         // if (result == true) {
  //         //   DialogHelper.alertDialog(
  //         //     context,
  //         //     iconPath: "assets/check.png",
  //         //     btnString: AppStrings.done,
  //         //     errorMessageHeading: "Request Sent",
  //         //     errorMessageTitle:
  //         //         "Your request has been sent successfully and Thank you for the interest.",
  //         //     onClick: () {
  //         //       Navigator.of(context, rootNavigator: true).pop(); // close dialog
  //         //       Navigator.pop(context); // go back screen
  //         //     },
  //         //   );
  //         //
  //         //   debugPrint("------------------------- hall done");
  //         // }
  //       }
  //     } catch (e) {
  //       debugPrint('Error getPaymentLink  👉 $e');
  //     }
  //
  //     _setLoading(false);
  //     notifyListeners();
  //   }
  //
}

class ServiceModal {
  ServiceModel? selectedService;
  TextEditingController serviceAmount = TextEditingController();
}

class RefreshmentModal {
  RefreshmentModel? selectedRefreshment;
  TextEditingController rate = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController refAmount = TextEditingController();
}

class ValetModal {
  TextEditingController valetParking = TextEditingController();
  TextEditingController valetRate = TextEditingController();
  TextEditingController valetNumber = TextEditingController();
  TextEditingController valetAmount = TextEditingController();
}
