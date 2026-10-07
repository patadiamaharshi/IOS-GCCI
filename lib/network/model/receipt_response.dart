import 'dart:convert';

class ReceiptResponse {
  final List<Receipt>? receipts;

  ReceiptResponse({this.receipts});

  factory ReceiptResponse.fromJson(Map<String, dynamic> json) {
    return ReceiptResponse(
      receipts: json['events'] != null
          ? List<Receipt>.from(
        json['events'].map((x) => Receipt.fromJson(x)),
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'events': receipts?.map((x) => x.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class Receipt {
  final String? eventId;
  final String? eventName;
  final String? fromDate;
  final String? toDate;
  final String? eventTime;
  final String? eventVenue;
  final String? eventPayment;
  final String? memberDiscount;
  final String? eventRegistration;
  final String? eventLink;
  final List<PaymentInfo>? paymentInfo;

  Receipt({
    this.eventId,
    this.eventName,
    this.fromDate,
    this.toDate,
    this.eventTime,
    this.eventVenue,
    this.eventPayment,
    this.memberDiscount,
    this.eventRegistration,
    this.eventLink,
    this.paymentInfo,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      eventId: json['event_id'],
      eventName: json['event_name'],
      fromDate: json['from_date'],
      toDate: json['to_date'],
      eventTime: json['event_time'],
      eventVenue: json['event_venue'],
      eventPayment: json['event_payment'],
      memberDiscount: json['member_discount'],
      eventRegistration: json['event_registration'],
      eventLink: json['event_link'],
      paymentInfo: json['payment_info'] != null
          ? List<PaymentInfo>.from(
        json['payment_info'].map((x) => PaymentInfo.fromJson(x)),
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'event_name': eventName,
      'from_date': fromDate,
      'to_date': toDate,
      'event_time': eventTime,
      'event_venue': eventVenue,
      'event_payment': eventPayment,
      'member_discount': memberDiscount,
      'event_registration': eventRegistration,
      'event_link': eventLink,
      'payment_info': paymentInfo?.map((x) => x.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class PaymentInfo {
  final String? eventPaymentID;
  final String? paymentDetails;
  final String? nonmemberAmount;
  final String? memberAmount;
  final String? displayOrderNo;

  PaymentInfo({
    this.eventPaymentID,
    this.paymentDetails,
    this.nonmemberAmount,
    this.memberAmount,
    this.displayOrderNo,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      eventPaymentID: json['event_payment_id'],
      paymentDetails: json['payment_details'],
      nonmemberAmount: json['nonmember_amount'],
      memberAmount: json['member_amount'],
      displayOrderNo: json['display_order_no'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_payment_id': eventPaymentID,
      'payment_details': paymentDetails,
      'nonmember_amount': nonmemberAmount,
      'member_amount': memberAmount,
      'display_order_no': displayOrderNo,
    };
  }
}