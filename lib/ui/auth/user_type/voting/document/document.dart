import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../common/dimension.dart';
import '../../../../../../common/circular_progress.dart';
import '../../../../../../theme/app_color.dart';
import 'package:gcci/common/gcci_button.dart';
import '../../../../../common/gcci_label.dart';
import '../../../../../common/image_picker_utils.dart';
import '../../../../../utils/app_text_styles.dart';
import 'document_vm.dart';

class DocumentScreen extends StatelessWidget {
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final int currentStep;

  const DocumentScreen({
    super.key,
    this.onNext,
    this.onBack,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DocumentViewModel(onNext: onNext),
      child: _Screen(onNext: onNext, onBack: onBack, currentStep: currentStep),
    );
  }
}

class _Screen extends StatefulWidget {
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final int currentStep;

  const _Screen({this.onNext, this.onBack, required this.currentStep});

  @override
  State<_Screen> createState() => _ScreenState();
}

class _ScreenState extends State<_Screen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DocumentViewModel>().loadInitialData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DocumentViewModel>();

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: vm.documentList.length,
                          itemBuilder: (context, index) {
                            final item = vm.documentList[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                VerticalSpacer.large,

                                GCCILabel(
                                  item['document_name'],
                                  style: AppTextStyles.primary22_600,
                                ),

                                VerticalSpacer.medium,

                                Center(
                                  child: GestureDetector(
                                    onTap: () => showImagePickerOptions(
                                      context: context,
                                      onFilePicked: (File imageFile) async {
                                        // await vm.printImageDetails(imageFile, label: "SELECTED IMAGE");
                                        vm.setDocumentFile(index, imageFile);
                                        // setState(() {
                                        //   vm.documentFiles[index] = imageFile;
                                        //   vm.documentErrors[index] = null;
                                        // });
                                      },
                                      onRemove: () {
                                        vm.removeDocumentFile(index);
                                        // setState(() {
                                        //   vm.documentFiles.remove(index);
                                        //   vm.documentErrors[index] = "Document is required";
                                        // });
                                      },
                                      showDeleteOption: false,
                                      // hasImage: vm.documentFiles.containsKey(
                                      //   index,
                                      // ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 220,
                                          // increased for button space
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: AppColor.primary,
                                              width: 2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child:
                                                    vm.documentFiles
                                                        .containsKey(index)
                                                    // 🔹 LOCAL IMAGE (with fade effect)
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                        child: Image.file(
                                                          vm.documentFiles[index]!,
                                                          fit: BoxFit.cover,
                                                          width:
                                                              double.infinity,
                                                        ),
                                                      )
                                                    // 🔹 NETWORK IMAGE (with loader)
                                                    : (item['document_link'] !=
                                                              null &&
                                                          item['document_link']
                                                              .toString()
                                                              .isNotEmpty)
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                        child: Image.network(
                                                          item['document_link'],
                                                          fit: BoxFit.cover,
                                                          width:
                                                              double.infinity,

                                                          // 👇 SMALL LOADER HERE
                                                          loadingBuilder:
                                                              (
                                                                context,
                                                                child,
                                                                loadingProgress,
                                                              ) {
                                                                if (loadingProgress ==
                                                                    null) {
                                                                  return child;
                                                                }

                                                                return const Center(
                                                                  child: SizedBox(
                                                                    height: 15,
                                                                    width: 15,
                                                                    child: CircularProgressIndicator(
                                                                      strokeWidth:
                                                                          2,
                                                                    ),
                                                                  ),
                                                                );
                                                              },

                                                          errorBuilder:
                                                              (
                                                                _,
                                                                __,
                                                                ___,
                                                              ) => const Center(
                                                                child: Icon(
                                                                  Icons
                                                                      .broken_image,
                                                                ),
                                                              ),
                                                        ),
                                                      )
                                                    // 🔹 CAMERA ICON
                                                    : const Center(
                                                        child: Icon(
                                                          Icons.camera_alt,
                                                          size: 50,
                                                          color:
                                                              AppColor.primary,
                                                        ),
                                                      ),
                                              ),
                                              if (vm.documentFiles.containsKey(
                                                    index,
                                                  ) &&
                                                  vm.uploadedStatus[index] ==
                                                      false)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 8,
                                                      ),
                                                  child: GCCIButton(
                                                    isEnabled: true,
                                                    text: "UPLOAD",
                                                    onPressed: () async {
                                                      File imageFile = vm
                                                          .documentFiles[index]!;

                                                      // await vm.printImageDetails(imageFile, label: "ORIGINAL IMAGE");

                                                      //File compressed = await vm.compressImage(imageFile);
                                                      // File compressed = await vm.compressImageTo2MB(imageFile);
                                                      //  await vm.printImageDetails(compressed, label: "ORIGINAL IMAGE with Compressed---");

                                                      await vm.uploadDocumentApi(
                                                        context,
                                                        imageFile,
                                                        item['document_mid'],
                                                        index,
                                                      );
                                                    },
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),

                                        /// Delete Button (Same as your existing)
                                        //if (vm.documentFiles.containsKey(index))
                                        if (vm.documentFiles.containsKey(
                                              index,
                                            ) &&
                                            vm.uploadedStatus[index] == false)
                                          Positioned(
                                            top: 12,
                                            right: 12,
                                            child: GestureDetector(
                                              onTap: () {
                                                vm.removeDocumentFile(index);
                                                // setState(() {
                                                //   vm.documentFiles.remove(
                                                //     index,
                                                //   );
                                                //   vm.documentErrors[index] = "Document is required";
                                                // });
                                              },
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                padding: const EdgeInsets.all(
                                                  6,
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),

                                VerticalSpacer.medium,

                                if (vm.documentErrors[index] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                      top: 4,
                                    ),
                                    child: GCCILabel(
                                      vm.documentErrors[index]!,
                                      style: AppTextStyles.error,
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Row(
                children: [
                  if (widget.currentStep > 0)
                    Expanded(
                      child: GCCIButton(
                        isEnabled: true,
                        backgroundColor: AppColor.disableButtonColor,
                        text: "Back",
                        onPressed: () {
                          widget.onBack?.call();
                        },
                      ),
                    ),

                  if (widget.currentStep > 0) HorizontalSpacer.large,

                  Expanded(
                    child: GCCIButton(
                      isEnabled: true,
                      icon: Icons.arrow_forward,
                      text: "Next",
                      onPressed: () {
                        if (vm.validateDocuments()) {
                          widget.onNext?.call();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (vm.isLoading)
          Center(child: CircularProgress(isLoading: vm.isLoading)),
      ],
    );
  }
}
