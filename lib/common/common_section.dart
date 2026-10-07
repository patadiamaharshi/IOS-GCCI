import 'package:flutter/material.dart';

import '../theme/app_color.dart';
import 'no_data_text.dart';

class CommonSection extends StatelessWidget {
  final bool isLoading;
  final bool? isEmpty;
  // final bool isEmpty;
  final Future<void> Function() onRefresh;
  final Widget child;
  final ScrollController? controller;

  const CommonSection({
    super.key,
    required this.isLoading,
    this.isEmpty,
    required this.onRefresh,
    required this.child,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
     if (isLoading && isEmpty!) {
       return const Center(child: CircularProgressIndicator());
     }
    // if (isLoading) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColor.primary,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            controller: controller,
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: (isEmpty ?? false)
                    ? const Center(
                  child: CrmNoDataText()
                )
                    : child,
              ),
            ),
          );
        },
      ),
    );
  }
}
