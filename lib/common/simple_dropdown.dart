import 'package:flutter/material.dart';
import 'package:gcci/common/gcci_label.dart';
import 'package:gcci/theme/app_color.dart';
import '../utils/app_text_styles.dart';
import 'dimension.dart';
import 'common_form.dart';

class SimpleDropDown<T> extends StatelessWidget {
  final String? label;
  final String? hint;
  final List<T> items;
  final T? value;
  final String Function(T item) labelBuilder;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;

  const SimpleDropDown({
    super.key,
    this.label,
    this.hint,
    required this.items,
    required this.labelBuilder,
    this.value,
    this.onChanged,
    this.validator,
  });

  void _openBottomSheet(BuildContext context, FormFieldState<T> state) {
    final searchKey = TextEditingController();
    List<T> filteredItems = List.from(items);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: buildFormField({
                      'hint': 'Search',
                      'controller': searchKey,
                      'icon': Icons.search,
                      'type': 'text',
                      'onChanged': (value) {

                        setModalState(() {
                          filteredItems = items.where((item) {
                            final name =
                            labelBuilder(item).toLowerCase();
                            return name.contains(
                              value.toLowerCase(),
                            );
                          }).toList();
                        });

                      },
                    }, context),
                  ),

                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 0,
                      ),
                      itemCount: filteredItems.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        thickness: 0.8,
                      ),
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final isSelected = item == state.value;

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 6,
                          ),
                          dense: true, // reduces extra height
                          title: GCCILabel(labelBuilder(item)),
                          trailing: isSelected
                              ? const Icon(Icons.check, color: AppColor.primary)
                              : null,
                          onTap: () {
                            state.didChange(item);      // update value
                            state.validate();           // 👈 revalidate to remove error
                            onChanged?.call(item);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
  //
  // void _openBottomSheet(BuildContext context, FormFieldState<T> state) {
  //   debugPrint("--------------$items");
  //   final searchKey = TextEditingController();
  //   List<T> filteredItems = List.from(items);
  //
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (_) {
  //       return Column(
  //         children: [
  //
  //           buildFormField({
  //             'hint': 'Search',
  //             'controller':searchKey,
  //             'icon': Icons.search,
  //             'type': 'text',
  //             'onChanged': (value) {
  //               debugPrint("Drop down search --------------$value");
  //
  //               //setModalState(() {
  //                 filteredItems = items.where((item) {
  //                   final name =
  //                   labelBuilder(item).toLowerCase();
  //                   return name.contains(
  //                     value.toLowerCase(),
  //                   );
  //                 }).toList();
  //               // });
  //             },
  //           }, context),
  //
  //           ListView.separated(
  //             padding: const EdgeInsets.all(16),
  //             itemCount: items.length,
  //             separatorBuilder: (_, __) => const Divider(),
  //             itemBuilder: (context, index) {
  //               final item = items[index];
  //               final isSelected = item == value;
  //
  //               return ListTile(
  //                 title: GCCILabel(labelBuilder(item)),
  //                 trailing: isSelected
  //                     ? const Icon(Icons.check, color: AppColor.primary)
  //                     : null,
  //                 onTap: () {
  //                   state.didChange(item);
  //                   onChanged?.call(item);
  //                   Navigator.pop(context);
  //                 },
  //               );
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      key: ValueKey(value),
      validator: validator,
      initialValue: value,
      //initialValue: value ?? (items.isNotEmpty ? items.first : null),
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VerticalSpacer.normal,

            if (label != null) GCCILabel(label!, style: AppTextStyles.label),

            VerticalSpacer.tiny,

            InkWell(
              onTap: () => _openBottomSheet(context, state),
              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),

                  hintStyle: AppTextStyles.hint,

                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.error, width: 1.2),
                  ),

                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.error, width: 1.2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.primary, width: 2.0),
                  ),
                  errorStyle: AppTextStyles.error,
                  errorText: state.errorText,
                  suffixIcon: const Icon(Icons.keyboard_arrow_down),
                ),
                child: Text(
                  /*"test",*/
                  value != null ? labelBuilder(state.value as T) : (hint ?? ''),
                  //  labelBuilder(value as T),
                  /* state.value != null
                      ? labelBuilder(state.value as T)
                     ,*/
                  //state.value == null
                  style: value == null
                      ? AppTextStyles.regular.copyWith(color: Colors.grey)
                      : AppTextStyles.regular,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/*
Flutter default drop down

class SimpleDropDown<T> extends StatelessWidget {
  final String? label;
  final String? hint;
  final List<T> items;
  final T? value;
  final String Function(T item) labelBuilder;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool isExpanded;

  const SimpleDropDown({
    super.key,
    this.label,
    this.hint,
    required this.items,
    required this.labelBuilder,
    this.value,
    this.onChanged,
    this.validator,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VerticalSpacer.normal,

        if (label != null) GCCILabel(label!, style: AppTextStyles.label),

        VerticalSpacer.tiny,

        DropdownButtonFormField<T>(
          value: value,
          isExpanded: isExpanded,
          style: AppTextStyles.regular,
          hint: GCCILabel(hint ?? ''),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 12,
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: GCCILabel(labelBuilder(item)),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,

          selectedItemBuilder: (context) {
            return items.map((item) {
              return Text(
                labelBuilder(item),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.regular,
              );
            }).toList();
          },

        ),
      ],
    );
  }
}*/
