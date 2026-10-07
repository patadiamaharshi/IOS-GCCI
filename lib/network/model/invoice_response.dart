import 'dart:convert';

class InvoiceResponse {
  final List<Invoice>? newMembership;
  final List<Invoice>? membershipRenewal;
  final List<Invoice>? membershipUpgradation;
  final List<Invoice>? nonVotingPayment;
  final List<Invoice>? offlineMembershipCorrection;
  final List<Invoice>? nonVotingToVoting;

  InvoiceResponse({this.newMembership,this.membershipRenewal,this.membershipUpgradation,this.nonVotingPayment,this.offlineMembershipCorrection,this.nonVotingToVoting});

  factory InvoiceResponse.fromJson(Map<String, dynamic> json) {
    return InvoiceResponse(
      newMembership: json['New Membership'] != null
          ? List<Invoice>.from(
        json['New Membership'].map((x) => Invoice.fromJson(x)),
      )
          : null,

      membershipRenewal: json['Membership Renewal'] != null
          ? List<Invoice>.from(
        json['Membership Renewal'].map((x) => Invoice.fromJson(x)),
      )
          : null,

      membershipUpgradation: json['Membership Renewal'] != null
          ? List<Invoice>.from(
        json['Membership Upgradation'].map((x) => Invoice.fromJson(x)),
      )
          : null,

      nonVotingPayment: json['Non-Voting Payment'] != null
          ? List<Invoice>.from(
        json['Non-Voting Payment'].map((x) => Invoice.fromJson(x)),
      )
          : null,

      offlineMembershipCorrection: json['Offline Membership Correction'] != null
          ? List<Invoice>.from(
        json['Offline Membership Correction'].map((x) => Invoice.fromJson(x)),
      )
          : null,

      nonVotingToVoting: json['Non Voting to Voting'] != null
          ? List<Invoice>.from(
        json['Non Voting to Voting'].map((x) => Invoice.fromJson(x)),
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'New Membership': newMembership?.map((x) => x.toJson()).toList(),
      'Membership Renewal': membershipRenewal?.map((x) => x.toJson()).toList(),
      'Membership Upgradation': membershipUpgradation?.map((x) => x.toJson()).toList(),
      'Non-Voting Payment': nonVotingPayment?.map((x) => x.toJson()).toList(),
      'Offline Membership Correction': offlineMembershipCorrection?.map((x) => x.toJson()).toList(),
      'Non Voting to Voting': nonVotingToVoting?.map((x) => x.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}



class Invoice {
  final String? invoiceNo;
  final String? invoiceDate;
  final String? financialYear;
  final String? invoiceAmount;
  final String? paymentId;
  final String? fromDate;
  final String? toDate;

  Invoice({
    this.invoiceNo,
    this.invoiceDate,
    this.financialYear,
    this.invoiceAmount,
    this.paymentId,
    this.fromDate,
    this.toDate,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      invoiceNo: json['invoice_no']?.toString(),
      invoiceDate: json['invoice_date']?.toString(),
      financialYear: json['financial_year']?.toString(),
      invoiceAmount: json['invoice_amount']?.toString(),
      paymentId: json['payment_id']?.toString(),
      fromDate: json['from_date']?.toString(),
      toDate: json['to_date']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoice_no': invoiceNo,
      'invoice_date': invoiceDate,
      'financial_year': financialYear,
      'invoice_amount': invoiceAmount,
      'payment_id': paymentId,
      'from_date': fromDate,
      'to_date': toDate,
    };
  }
}
