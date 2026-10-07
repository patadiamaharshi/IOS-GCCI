import 'dart:convert';

class OptionList {
  final String id;
  final String name;
  final String amount;
  final bool isHeader;

  OptionList(
      this.id,
      this.name,
      this.amount, {
        this.isHeader = false,
      });

  factory OptionList.fromJson(Map<String, dynamic> json) {
    return OptionList(
      json['ID']?.toString() ?? '',
      json['Name']?.toString() ?? '',
      json['Amount']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Name': name,
      'Amount': amount,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
