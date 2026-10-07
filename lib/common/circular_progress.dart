import 'package:flutter/material.dart';
import 'package:gcci/theme/app_color.dart';

class CircularProgress extends StatelessWidget {
  final bool isLoading;

  const CircularProgress({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();

    return Stack(
      children: [
        ModalBarrier(
          dismissible: false,
          //color: Colors.black26, // optional background dim
        ),
        // Blocks all touch events
        /* const Opacity(
          opacity: 0.0,
          child: ModalBarrier(
            dismissible: false,
           // color: Colors.white,
          ),
        ),*/
        const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
          ),
        ),
      ],
    );
  }
}
