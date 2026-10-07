import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gcci/common/gcci_label.dart';
import 'package:gcci/common/simple_dropdown.dart';
import '../theme/app_color.dart';
import '../utils/app_text_styles.dart';
import 'dimension.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'custom_dropdown_field.dart';

Widget buildFormField<T>(Map<String, dynamic> field, BuildContext context) {
  TextEditingController? controller =
      field['controller'] as TextEditingController?;
  final int maxLen = (field['maxLength'] is int && field['maxLength'] > 0)
      ? field['maxLength']
      : 150;

  final bool readMode = field['readOnly'] ?? false;
  final bool callApi = field['callApi'] ?? false;
  final String hint = field['hint'] ?? "Select";
  final bool isCapital = field['capital'] ?? false;
  //Function(String?)? onChanged = field['onChanged'];

  switch (field['type']) {
    case 'text':
    case 'name':
    case 'email':
    case 'number':
    case 'alphanumeric':
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //VerticalSpacer.large,
          VerticalSpacer.normal,

          if ((field['label'] ?? '').toString().isNotEmpty) ...[
            GCCILabel(field['label'], style: AppTextStyles.label),
            VerticalSpacer.tiny,
          ],

          StatefulBuilder(
            builder: (context, setState) {
              field['_obscureText'] ??= true;

              return TextFormField(
                cursorColor: AppColor.black,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: field['obscureText'] == true
                    ? field['_obscureText']
                    : false,
                controller: controller,
                maxLength: maxLen,
                readOnly: readMode,
                style: AppTextStyles.regular,

                textCapitalization: isCapital
                    ? TextCapitalization.characters
                    : TextCapitalization.none,
                onChanged: field['onChanged'],
                keyboardType: () {
                  switch (field['type']) {
                    case 'number':
                      return TextInputType.number;

                    case 'email':
                      return TextInputType.emailAddress;

                    case 'name':
                      return TextInputType.name;

                    case 'alphanumeric':
                      return TextInputType.text;

                    default:
                      return TextInputType.text;
                  }
                }(),
                /* keyboardType: field['type'] == 'number'
                    ? TextInputType.number
                    : TextInputType.text,*/
                /*inputFormatters: () {
                  switch (field['type']) {
                    case 'number':
                      return [FilteringTextInputFormatter.digitsOnly];

                    case 'name':
                      return [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                      ];

                    case 'email':
                      return [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9@._\-+]'),
                        ),
                      ];

                    case 'alphanumeric':
                      return [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9]'),
                        ),
                      ];


                    default:
                      return <TextInputFormatter>[];
                  }
                  if (isCapital) {
                    formatters.add(UpperCaseTextFormatter());
                  }
                }(),*/
                inputFormatters: () {
                  List<TextInputFormatter> formatters = [];

                  switch (field['type']) {
                    case 'number':
                      formatters.add(FilteringTextInputFormatter.digitsOnly);
                      break;

                    case 'name':
                      formatters.add(
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                      );
                      break;

                    case 'email':
                      formatters.add(
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9@._\-+]'),
                        ),
                      );
                      break;

                    case 'alphanumeric':
                      formatters.add(
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9]'),
                        ),
                      );
                      break;
                  }

                  if (isCapital) {
                    formatters.add(UpperCaseTextFormatter());
                  }

                  return formatters;
                }(),
                minLines: field['minLines'],
                maxLines: field['maxLines'] ?? 1,
                decoration: InputDecoration(
                  hintStyle: AppTextStyles.hint,
                  errorStyle: AppTextStyles.error,

                  prefixIcon: field['icon'] != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 18, right: 10),
                          child: Icon(
                            field['icon'],
                            size: 24,
                            color: AppColor.charcoalGray,
                          ),
                        )
                      : null,

                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.error, width: 1.2),
                  ),

                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.error, width: 1.2),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.primary, width: 2.0),
                  ),

                  isDense: true,
                  hintText: field['hint'],
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 12,
                  ),
                  counterText: '',
                  suffixIconConstraints: const BoxConstraints(
                    minHeight: 0,
                    minWidth: 50,
                  ),

                  suffixIcon: field['obscureText'] == true
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              field['_obscureText'] = !field['_obscureText'];
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(
                              field['_obscureText']
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 20,
                            ),
                          ),
                        )
                      : null,
                ),
                validator: field['validator'],
              );
            },
          ),
          VerticalSpacer.tiny,

          if ((field['note'] ?? '').toString().trim().isNotEmpty)
            GCCILabel(field['note'], style: AppTextStyles.hint),
        ],
      );

    case 'radio':
      String? groupValue = field['groupValue'] as String?;
      List<String> options = field['options'] as List<String>;
      Function(String?) onChanged = field['onChanged'];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VerticalSpacer.normal,

          GCCILabel(field['label'], style: AppTextStyles.label),

          VerticalSpacer.tiny,

        Wrap(
          spacing: 24,
          runSpacing: 8,
          children: options.map((option) {
            return InkWell(
              onTap: () => onChanged(option),
              child: Row(
                mainAxisSize: MainAxisSize.min, // 👈 Important
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.scale(
                    scale: 1.2,
                    child: Radio<String>(
                      value: option,
                      groupValue: groupValue,
                      onChanged: onChanged,
                      activeColor: AppColor.primary,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact, // reduce internal padding
                    ),
                  ),

                  const SizedBox(width: 8),

                  // 👇 This is the key for wrapping inside Row
                  Flexible(
                    child: GCCILabel(
                      option,
                      style: AppTextStyles.regular,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        ],
      );

    case 'customDropDown':
      return CustomDropdownField(
        label: field['label'],
        hint: hint,
        controller: field['controller'],
        options: field['options'],
        onChanged: field['onChanged'],
        onSearchChanged: field['onSearchChanged'],
        validator: field['validator'],
        callApi: callApi,
        readOnly: field['readOnly'] ?? true,
        //callApi:false,
      );

    case 'dropDown':
      return SimpleDropDown<T>(
        label: field['label'] as String?,
        hint: field['hint'] as String?,
        items: field['items'] as List<T>,
        value: field['value'] as T?,
        //labelBuilder: field['labelBuilder'],
        labelBuilder: field['labelBuilder'] as String Function(T),
        onChanged: field['onChanged'] as void Function(T?)?,
        validator: field['validator'] as String? Function(T?)?,
      );

    // case 'checkbox':
    //   return CheckboxListTile(
    //     value: field['value'] ?? false,
    //     onChanged: field['onChanged'] ?? (value) {},
    //     title: Transform.translate(
    //       offset: const Offset(-8, 0), // move label 8px to the left
    //       child: GCCILabel(field['label'] ?? ''),
    //     ),
    //     contentPadding: EdgeInsets.zero,
    //     controlAffinity: ListTileControlAffinity.leading,
    //     dense: true,
    //   );
    case 'checkbox':
      return InkWell(
        onTap: () {
          final currentValue = field['value'] as bool? ?? false;
          final onChanged = field['onChanged'] as Function(bool?)?;
          if (onChanged != null) {
            onChanged(!currentValue);
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: field['value'] as bool? ?? false,
                  onChanged: field['onChanged'] as Function(bool?)?,
                  activeColor: AppColor.primary,
                  checkColor: Colors.white,
                  side: const BorderSide(color: AppColor.primary, width: 2),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: GCCILabel(field['label'] ?? ''),
              ),
            ),
          ],
        ),
      );

    case 'date':
      Function(String)? onDateSelected =
          field['onDateSelected'] as Function(String)?;

      bool futureDate = field['futureDate'] ?? true;
      bool previousDate = field['previousDate'] ?? false;
      bool showMonth = field['showMonth'] ?? false;
      bool showTime = field['showTime'] ?? false;
      bool showYearOnly = field['showYearOnly'] ?? false;

      DateTime today = DateTime.now();
      DateTime firstDate = previousDate ? DateTime(1900) : today;
      DateTime lastDate = futureDate ? DateTime(2100) : today;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VerticalSpacer.normal,
          GCCILabel(field['label'], style: AppTextStyles.label),

          VerticalSpacer.tiny,

          TextFormField(
            readOnly: true,
            controller: controller,
            style: AppTextStyles.regular,
            decoration: InputDecoration(
              hintStyle: AppTextStyles.hint,
              errorStyle: AppTextStyles.error,

              prefixIcon: field['icon'] != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 18, right: 10),
                      child: Icon(
                        field['icon'],
                        size: 24,
                        color: AppColor.charcoalGray,
                      ),
                    )
                  : null,

              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.primary, width: 2.0),
              ),

              // focusedErrorBorder: OutlineInputBorder(
              //   borderSide: BorderSide(color: AppColor.error, width: 1.2),
              // ),
              isDense: true,
              hintText: (field['hint']?.toString().trim().isNotEmpty ?? false)
                  ? field['hint']
                  : 'DD-MM-YYYY',

              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 12,
              ),
              /* suffixIcon: Icon(
                Icons.calendar_today,
                color: AppColor.black,
                size: 20,
              ),*/
              suffixIconConstraints: const BoxConstraints(
                minHeight: 0,
                minWidth: 50,
              ),
            ),
            validator: field['validator'],
            onTap: () async {
              if (showYearOnly) {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: today,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  initialDatePickerMode:
                      DatePickerMode.year, // 🔥 opens year mode
                );

                if (picked != null) {
                  String year = DateFormat('yyyy').format(picked);
                  controller?.text = year;
                  onDateSelected?.call(year);
                }
              } else if (showMonth) {
                DateTime? picked = await showMonthPicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  initialDate: DateTime.now(),
                );
                if (picked != null) {
                  String formattedDate = DateFormat('MMM yyyy').format(picked);
                  controller?.text = formattedDate;
                  onDateSelected?.call(formattedDate);
                }
              } else {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: today,
                  firstDate: firstDate,
                  lastDate: lastDate,
                );

                if(!context.mounted) return;

                if (selectedDate != null) {
                  if (showTime) {
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (selectedTime != null) {
                      final DateTime fullDateTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );

                      String formattedDateTime = DateFormat(
                        'MM/dd/yyyy hh:mm a',
                      ).format(fullDateTime);
                      controller?.text = formattedDateTime;
                      onDateSelected?.call(formattedDateTime);
                    } else {
                      // Fallback: User didn't select time, use just the date
                      String formattedDate = DateFormat(
                        'dd/MM/yyyy',
                      ).format(selectedDate);
                      controller?.text = formattedDate;
                      onDateSelected?.call(formattedDate);
                    }
                  } else {
                    String formattedDate = DateFormat(
                      'dd/MM/yyyy',
                    ).format(selectedDate);
                    controller?.text = formattedDate;
                    onDateSelected?.call(formattedDate);
                  }
                }
              }
            },
          ),
        ],
      );

    case 'time':
      Function(String)? onDateSelected =
          field['onDateSelected'] as Function(String)?;

      final bool is24Hour = field['24Hour'] ?? false;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VerticalSpacer.normal,
          GCCILabel(field['label'], style: AppTextStyles.label),

          VerticalSpacer.tiny,

          TextFormField(
            readOnly: true,
            controller: controller,
            style: AppTextStyles.regular,
            decoration: InputDecoration(
              hintStyle: AppTextStyles.hint,
              errorStyle: AppTextStyles.error,

              prefixIcon: field['icon'] != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 18, right: 10),
                      child: Icon(
                        field['icon'],
                        size: 24,
                        color: AppColor.charcoalGray,
                      ),
                    )
                  : null,

              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.primary, width: 2.0),
              ),

              isDense: true,
              hintText: (field['hint']?.toString().trim().isNotEmpty ?? false)
                  ? field['hint']
                  : (is24Hour ? 'HH:mm' : 'hh:mm a'),

              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 12,
              ),
              suffixIconConstraints: const BoxConstraints(
                minHeight: 0,
                minWidth: 50,
              ),
            ),
            validator: field['validator'],
            onTap: () async {
              TimeOfDay? selectedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(
                      context,
                    ).copyWith(alwaysUse24HourFormat: is24Hour),
                    child: child!,
                  );
                },
              );

              if (selectedTime != null) {
                final DateTime now = DateTime.now();
                final DateTime fullDateTime = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );

                String formattedTime = is24Hour
                    ? DateFormat('HH:mm').format(fullDateTime)
                    : DateFormat('hh:mm a').format(fullDateTime);

                controller?.text = formattedTime;
                onDateSelected?.call(formattedTime);
              }
            },
          ),
        ],
      );

    case 'otp':
      return PinCodeTextField(
        appContext: context,
        length: field['length'],
        controller: controller,
        keyboardType: TextInputType.number,
        obscureText: false,
        animationType: AnimationType.fade,
        cursorColor: AppColor.black,
        showCursor: true,
        validator: field['validator'],
        onChanged: field['onChanged'] ?? (value) {},
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(8),
          fieldHeight: 50,
          fieldWidth: 50,
          inactiveColor: AppColor.grey,
          inactiveFillColor: AppColor.white,
          activeFillColor: AppColor.white,
          activeColor: AppColor.black,
          selectedColor: AppColor.black,
          selectedFillColor: AppColor.white,
        ),
      );

    default:
      return const SizedBox.shrink();
  }
}

/// 🔹 Uppercase Formatter
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
