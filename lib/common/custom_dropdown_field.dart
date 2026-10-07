import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gcci/common/gcci_label.dart';
import '../network/model/option_list.dart';
import '../theme/app_color.dart';
import '../utils/app_text_styles.dart';
import 'dimension.dart';
import 'no_data_text.dart';

class CustomDropdownField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final List<OptionList> options;
  final Function(OptionList)? onChanged;
  final Function(String)? onSearchChanged;
  final String? Function(String?)? validator;
  final bool callApi;
  final bool readOnly;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.options,
    this.onChanged,
    this.onSearchChanged,
    this.validator,
    required this.callApi,
    this.readOnly = true,
  });

  @override
  State<CustomDropdownField> createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
  bool _isOpen = false;
  Timer? _debounce;
  List<OptionList> _filteredOptions = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _filteredOptions = widget.options;
  }

  @override
  void didUpdateWidget(CustomDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.options != oldWidget.options) {
      _filteredOptions = widget.options;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (value.isNotEmpty && !_isOpen) {
        setState(() {
          _isOpen = true;
        });
      } else if (value.isEmpty) {
        setState(() {
          _isOpen = false;
        });
      }

      if (!widget.callApi) {
        // Filter from existing options
        setState(() {
          _filteredOptions = widget.options.where((option) {
            return option.name.toLowerCase().contains(value.toLowerCase());
          }).toList();
        });
      } else {
        // Call API for new data
        if (widget.onSearchChanged != null) {
          widget.onSearchChanged!(value);
        }
      }
    });
  }

  void _onOptionSelected(OptionList item) {
    widget.controller.text = item.name;
    if (widget.onChanged != null) widget.onChanged!(item);
    setState(() {
      _isOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VerticalSpacer.normal,

        GCCILabel(
          widget.label,
          style: AppTextStyles.label,
          //style: AppTextStyles.style: AppTextStyles.label.copyWith(color: AppColor.charcoalGray),
        ),
        VerticalSpacer.tiny,
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.charcoalGray),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                cursorColor: AppColor.black,
                controller: widget.controller,
                maxLength: 100,
                readOnly: widget.readOnly,
                style: AppTextStyles.regular,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  // Remove default border
                  isDense: true,
                  hintText: widget.hint,
                  counterText: '',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  suffixIconConstraints: const BoxConstraints(
                    minHeight: 0,
                    minWidth: 50,
                  ),
                  suffixIcon: GestureDetector(
                   // onTap: () => setState(() => _isOpen = !_isOpen),
                    child: Icon(
                      _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      size: 30,
                    ),
                  ),
                ),
                onTap: () => setState(() => _isOpen = !_isOpen),
                onChanged: _onTextChanged,
                validator: widget.validator,
              ),
              if (_isOpen) ...[
                const Divider(height: 1, color: AppColor.charcoalGray),
                _filteredOptions.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CrmNoDataText(),
                      )
                    : ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 250),
                        child: Scrollbar(
                          thumbVisibility: true,
                          controller: _scrollController,
                          child: ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: _filteredOptions.length,
                            itemBuilder: (context, index) {
                              final item = _filteredOptions[index];
                              if (item.isHeader) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 0,
                                    vertical: 0,
                                  ),
                                  color: Colors.grey[200],
                                  child: GCCILabel(
                                    item.name,
                                    style: AppTextStyles.regular,
                                    // style: const TextStyle(
                                    //   fontSize: 16,
                                    //   fontWeight: FontWeight.w600,
                                    //   color: AppColor.charcoalGray,
                                    // ),
                                  ),
                                );
                              } else {
                                return InkWell(
                                  onTap: () => _onOptionSelected(item),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0,
                                      vertical: 12,
                                    ),
                                    child: GCCILabel(
                                      item.name,
                                      style: AppTextStyles.regular,
                                      // style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
