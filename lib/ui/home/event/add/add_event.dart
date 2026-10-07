import 'package:flutter/material.dart';
import 'package:gcci/common/common_form.dart';
import 'package:gcci/common/common_toolbar.dart';
import 'package:gcci/common/gcci_button.dart';
import 'package:gcci/ui/home/event/add/add_event_viewmodel.dart';
import 'package:gcci/utils/validators.dart';
import 'package:gcci/utils/app_strings.dart';
import 'package:provider/provider.dart';
import '../../../../common/circular_progress.dart';
import '../../../../network/model/event_response.dart';

class AddEventScreen extends StatelessWidget {
  final Event? event;
  const AddEventScreen({super.key,this.event});

  @override
  Widget build(BuildContext context) {
    debugPrint('Event add event screen : $event');
    return ChangeNotifierProvider(
      create: (_) => AddEventViewModel(event),
      child: const _AddEvent(),
    );
  }
}

class _AddEvent extends StatefulWidget {
  const _AddEvent();

  @override
  State<_AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<_AddEvent> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AddEventViewModel>();

    return Scaffold(
      appBar: const CommonToolbar(title: AppStrings.newEvent),

      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        // top: 10,
                        bottom: 20,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildFormField({
                              'label': 'Event Name',
                              'hint': 'Event Name',
                              'readOnly': true,
                              'controller': vm.eventName,
                              'type': 'name',
                              // 'icon': Icons.event,
                              'minLines': 1,
                              'maxLines': 10,
                            }, context),

                            buildFormField({
                              "type": 'radio',
                              "label": 'Select Representative',
                              "options": ['Representative 1', 'Representative 2', 'Other'],
                              "groupValue": vm.representative,
                              "onChanged": (value) {
                                  vm.onRadioSelected(value);
                              },
                            }, context),

                            buildFormField({
                              'label': 'First Name *',
                              'hint': 'First Name',
                              'readOnly': vm.isReadOnlyRepresentative,
                              'controller': vm.firstName,
                              'icon': Icons.person,
                              'type': 'name',
                              'validator': (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppStrings.firstNameRequired;
                                }
                                return null;
                              },
                            }, context),

                            buildFormField({
                              'label': 'Last Name *',
                              'hint': 'Last Name',
                              'controller': vm.lastName,
                              'readOnly': vm.isLastNameReadOnly,
                              'icon': Icons.person,
                              'type': 'name',
                              'validator': (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppStrings.lastNameRequired;
                                }
                                return null;
                              },
                            }, context),

                            buildFormField({
                              'label': 'Mobile Number *',
                              'type': 'number',
                              'icon': Icons.phone,
                              'readOnly': vm.isReadOnlyRepresentative,
                              'hint': 'Enter your 10-digit mobile number',
                              'maxLength': 10,
                              'controller': vm.mobile,
                              'validator': (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppStrings.mobileRequired;
                                }
                                if (!Validators.isValidMobile(value)) {
                                  return AppStrings.mobileNotValid;
                                }
                                return null;
                              },
                            }, context),

                            buildFormField({
                              'type': 'email',
                              'label': 'Email *',
                              'hint': 'Email',
                              'icon': Icons.mail,
                              'controller': vm.email,
                              'readOnly': vm.isEmailReadOnly,
                              'required': true,
                              'validator': (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppStrings.emailRequired;
                                }
                                if (!Validators.isValidEmail(value)) {
                                  return AppStrings.emailNotValid;
                                }
                                return null;
                              },
                            }, context),

                            buildFormField({
                              'label': 'Institute/Organization Name',
                              'hint': 'Institute/Organization Name',
                              'controller': vm.instituteOrgName,
                              'icon': Icons.apartment,
                              'type': 'name',
                              'minLines': 1,
                              'maxLines': 3,
                            }, context),

                            buildFormField({
                              'label': 'Designation',
                              'hint': 'Designation',
                              'controller': vm.designation,
                              'readOnly': vm.isReadOnlyRepresentative,
                              'icon': Icons.work,
                              'type': 'name',
                              'minLines': 1,
                              'maxLines': 3,
                            }, context),

                            buildFormField({
                              'label': 'GST No',
                              'hint': 'GST No',
                              'type': 'alphanumeric',
                              'readOnly': vm.isReadOnlyRepresentative,
                              'maxLength': 15,
                              'controller': vm.gstNo,
                              'icon': Icons.receipt_long,
                              'validator': (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return null; // do not show any error
                                }

                                if (!Validators.isValidGST(value.trim())) {
                                  return AppStrings.gstNotValid;
                                }

                                return null;
                              },
                            }, context),

                            buildFormField<PaymentInfo>({
                              'label': 'Payment Info',
                              'type': 'dropDown',
                              'hint': 'Select',
                              'items': vm.paymentInfo,
                              'value': vm.selectedPayment,
                              'labelBuilder': (PaymentInfo item) => item.paymentDetails ?? '',
                              'onChanged': (PaymentInfo? selected) {
                                vm.onOptionSelected(selected);
                              },
                              'validator': (PaymentInfo? value) {
                                if (value == null) {
                                  return AppStrings.paymentInfoReq;
                                }
                                return null;
                              },
                            }, context),

                            buildFormField({
                              'label': 'Event Amount',
                              'hint': '0',
                              'icon': Icons.currency_rupee,
                              'readOnly': true,
                              'controller': vm.eventAmount,
                              'type': 'name',
                            }, context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: GCCIButton(
                    isEnabled: vm.isVerify,
                    text: AppStrings.onlinePayment,
                    icon: Icons.arrow_forward,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        vm.onlinePayment(context);
                      }
                    },
                  ),
                ),
              ],
            ),

            if (vm.isLoading)
              Center(child: CircularProgress(isLoading: vm.isLoading)),
          ],
        ),
      ),
    );
  }
}