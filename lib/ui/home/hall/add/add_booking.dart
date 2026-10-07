import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gcci/common/common_form.dart';
import 'package:gcci/common/common_toolbar.dart';
import 'package:gcci/common/gcci_button.dart';
import 'package:gcci/utils/app_strings.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../common/circular_progress.dart';
import '../../../../common/dimension.dart';
import '../../../../common/gcci_label.dart';
import '../../../../network/model/hall_response.dart';
import '../../../../network/model/refreshment_response.dart';
import '../../../../network/model/service_response.dart';
import '../../../../theme/app_color.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/validators.dart';
import 'add_booking_vm.dart';

class AddBookingScreen extends StatelessWidget {
  const AddBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddBookingViewModel(),
      child: const _AddBooking(),
    );
  }
}

class _AddBooking extends StatefulWidget {
  const _AddBooking();

  @override
  State<_AddBooking> createState() => _AddBookingState();
}

class _AddBookingState extends State<_AddBooking> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddBookingViewModel>().loadInitialData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AddBookingViewModel>();

    return Scaffold(
      appBar: const CommonToolbar(title: AppStrings.newBooking),
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
                        left: 20.0,
                        right: 20.0,
                        bottom: 20.0,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildFormField({
                              'label': 'Booking Date *',
                              'type': 'date',
                              'icon': Icons.calendar_today,
                              'previousDate': true,
                              'futureDate': true,
                              'controller': vm.bookingDate,
                              'onDateSelected': (String? date) async {
                                //debugPrint('date bookingDateRequired call ');
                                //debugPrint('$date');

                                await vm.getHoliday(date.toString());
                                final selectedDate = DateFormat(
                                  'dd/MM/yyyy',
                                ).parse(date.toString());
                                vm.selectedDateIs = selectedDate;
                                vm.updateRelatedFields();
                              },
                              'validator': (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppStrings.bookingDateRequired;
                                }
                              },
                            }, context),

                            buildFormField<String>({
                              'label': 'Booking Duration *',
                              'type': 'dropDown',
                              'hint': 'Select Duration',
                              'items': ['Full Day', 'Hourly'],
                              'value': vm.duration,
                              'labelBuilder': (String? item) => item ?? '',
                              'onChanged': (String? v) {
                                vm.onDurationSelected(v);
                              },
                              'validator': (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppStrings.bookingDurationRequired;
                                }
                                return null;
                              },
                            }, context),

                            if (vm.duration == "Hourly") ...[
                              buildFormField({
                                'label': 'From Time *',
                                'icon': Icons.access_time,
                                'controller': vm.fromTime,
                                'type': 'time',
                                'validator': (String? value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return AppStrings.timeRequired;
                                  }
                                },
                              }, context),

                              buildFormField({
                                'label': 'To Time *',
                                'icon': Icons.access_time,
                                'controller': vm.toTime,
                                'type': 'time',
                                'validator': (String? value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return AppStrings.timeRequired;
                                  }
                                },
                              }, context),
                            ],

                            buildFormField<String>({
                              'label': 'Are You Member? *',
                              'type': 'dropDown',
                              'hint': 'Are you member',
                              'items': ['Yes', 'No'],
                              'value': vm.isMember,
                              'labelBuilder': (String? item) => item ?? '',
                              'onChanged': (String? v) {
                                vm.isMemberSelect(v);
                              },
                              'validator': (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppStrings.required;
                                }
                                return null;
                              },
                            }, context),

                            if (vm.isMember == "Yes")
                              buildFormField({
                                'label': 'Membership No *',
                                'hint': 'Membership No',
                                'controller': vm.memNo,
                                'icon': Icons.pin,
                                'type': 'number',
                                'onChanged': (value) {
                                  vm.onMemNoChanged(value);
                                },
                                'validator': (String? value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return AppStrings.memberNoReq;
                                  }
                                  return null;
                                },
                              }, context),

                            buildFormField({
                              'label': 'Organization Name *',
                              'hint': 'Organization Name',
                              'controller': vm.orgName,
                              'icon': Icons.business,
                              'type': 'text',
                              'readOnly': vm.orgNameReadOnly,
                              'validator': (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppStrings.orgNameRequired;
                                }
                                return null;
                              },
                            }, context),
                            if (vm.repList.isNotEmpty)
                              buildFormField<String>({
                                "type": 'radio',
                                "label": 'Name of Representative',
                                "options": vm.repList,
                                "groupValue": vm.authPersonName,
                                "onChanged": (value) {
                                  vm.onRepSelect(value);
                                },
                              }, context),

                            VerticalSpacer.xSmall,

                            if (vm.authPersonName.isEmpty &&
                                vm.repList.isNotEmpty) ...[
                              VerticalSpacer.tiny,
                              GCCILabel(
                                "Select Representative",
                                style: AppTextStyles.error,
                              ),
                            ],

                            buildFormField({
                              'label': 'Address *',
                              'hint': 'Address',
                              'controller': vm.address,
                              'type': 'text',
                              'readOnly': vm.addressReadOnly,
                              'icon': Icons.location_on,
                              'validator': (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppStrings.addressRequired;
                                }
                                return null;
                              },
                            }, context),

                            buildFormField({
                              'label': 'Mobile Number *',
                              'type': 'number',
                              "icon": Icons.phone,
                              'hint': "Enter your 10-digit mobile number",
                              'readOnly': vm.mobileReadOnly,
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
                              'label': 'Telephone No *',
                              'type': 'number',
                              "icon": Icons.phone,
                              'hint': "Enter your telephone number",
                              'maxLength': 15,
                              'readOnly': vm.landlineReadOnly,
                              'controller': vm.landline,
                              'validator': (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppStrings.required;
                                }
                                return null;
                              },
                            }, context),

                            buildFormField({
                              'label': 'GST No *',
                              'hint': 'GST No',
                              'readOnly': vm.gstReadOnly,
                              'controller': vm.gstNo,
                              'icon': Icons.receipt_long,
                              'type': 'alphanumeric',
                              'maxLength': 15,
                              'validator': (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppStrings.gstNoRequired;
                                }
                                if (!Validators.isValidGST(value)) {
                                  return AppStrings.gstNotValid;
                                }
                                return null;
                              },
                            }, context),

                            buildFormField({
                              'label': 'Purpose *',
                              'hint': 'Purpose',
                              'controller': vm.purpose,
                              //'icon': FontAwesomeIcons.clipboard,
                              'type': 'text',
                              'minLines': 1,
                              'maxLines': 3,
                              'validator': (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppStrings.required;
                                }
                                return null;
                              },
                            }, context),

                            buildFormField({
                              'label':
                                  'Hall deposit refund cheque in favour of *',
                              'hint': 'Hall deposit refund cheque in favour of',
                              'controller': vm.refundChequeName,
                              // 'icon': FontAwesomeIcons.moneyCheck,
                              'type': 'name',
                              'validator': (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppStrings.required;
                                }
                                return null;
                              },
                            }, context),

                            buildFormField<HallModel>({
                              'label': 'Hall Name *',
                              'type': 'dropDown',
                              'hint': 'Select Hall Name',
                              'items': vm.hallList,
                              'value': vm.selectedHall,
                              'labelBuilder': (HallModel item) =>
                                  item.hallName ?? '',
                              'onChanged': (HallModel? selected) {
                                vm.onHAllSelected(selected);
                              },
                              'validator': (HallModel? value) {
                                if (value == null) {
                                  return AppStrings.hallNameRequired;
                                }
                                return null;
                              },
                            }, context),

                            buildFormField({
                              'label': 'Hall Amount *',
                              'hint': '0',
                              'readOnly': true,
                              'controller': vm.hallAmount,
                              'icon': Icons.currency_rupee,
                              'type': 'number',
                              'validator': (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppStrings.amountRequired;
                                }
                                return null;
                              },
                            }, context),

                            if (vm.duration == "Hourly") ...[
                              buildFormField({
                                'label': 'Additional Hours *',
                                'hint': 'Additional Hours',
                                'controller': vm.extraHour,
                                'icon': Icons.timelapse,
                                'type': 'number',
                                'maxLength': 3,
                                'onChanged': (String value) {
                                  vm.updateRelatedFields();
                                  //vm.updateFinalAmount();
                                },
                                'validator': (String? value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return AppStrings.required;
                                  }
                                  return null;
                                },
                              }, context),

                              buildFormField({
                                'label': 'Additional Hour Total Charges *',
                                'hint': '0',
                                'controller': vm.extraHourCharge,
                                'icon': Icons.currency_rupee,
                                'type': 'number',
                                'readOnly': true,
                                'validator': (String? value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return AppStrings.amountRequired;
                                  }
                                  return null;
                                },
                              }, context),
                            ],

                            VerticalSpacer.normalMedium,

                            serviceDesign(vm),

                            VerticalSpacer.normalMedium,

                            refreshmentDesign(vm),

                            VerticalSpacer.normalMedium,

                            valetParking(vm),

                            /*buildFormField({
                              'label': 'Advance Amount *',
                              'hint': '0',
                              'controller': vm.advanceAmount,
                              'icon': Icons.currency_rupee,
                              'type': 'number',
                              'readOnly': true,
                            }, context),*/
                            buildFormField({
                              'label': 'Sub Total *',
                              'hint': '0',
                              'controller': vm.subTotal,
                              'icon': Icons.currency_rupee,
                              'type': 'number',
                              'readOnly': true,
                            }, context),

                            buildFormField({
                              'label': "${vm.labelDiscount} *",
                              'hint': '0',
                              'controller': vm.memberDiscount,
                              'icon': Icons.percent,
                              'type': 'number',
                              'readOnly': true,
                              'validator': (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppStrings.required;
                                }
                                return null;
                              },
                            }, context),

                            buildFormField({
                              'label': 'Total Amount *',
                              'hint': '0',
                              'controller': vm.totalAmount,
                              'icon': Icons.currency_rupee,
                              'type': 'number',
                              'readOnly': true,
                              'validator': (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppStrings.amountRequired;
                                }
                                return null;
                              },
                            }, context),

                            buildFormField({
                              'label': "${vm.labelGST} *",
                              'hint': '0',
                              'controller': vm.memberGst,
                              'icon': Icons.percent,
                              'type': 'text',
                              'readOnly': true,
                              'validator': (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppStrings.required;
                                }
                                return null;
                              },
                            }, context),

                            buildFormField({
                              'label': 'Round Off',
                              'hint': '0',
                              'readOnly': true,
                              'icon': Icons.currency_rupee,
                              'controller': vm.roundOff,
                              'type': 'number',
                            }, context),

                            buildFormField({
                              'label': 'Final Amount *',
                              'hint': '0',
                              'readOnly': true,
                              'icon': Icons.currency_rupee,
                              'controller': vm.finalAmount,
                              'type': 'number',
                              'validator': (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppStrings.amountRequired;
                                }
                                return null;
                              },
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
                    // isEnabled: vm.isVerify,
                    isEnabled: true,
                  //  text: AppStrings.onlinePayment + vm.finalAmount.text,
                    text: AppStrings.submit,
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

  Widget serviceDesign(AddBookingViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (vm.serviceForms.isNotEmpty) ...[
          GCCILabel("Services", style: AppTextStyles.primary22_600),
          VerticalSpacer.small,
        ],

        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: vm.serviceForms.length,
          itemBuilder: (context, index) {
            final form = vm.serviceForms[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColor.buttonColor, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (vm.serviceForms.isNotEmpty)
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          vm.removeServiceAt(index);
                        },
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 24,
                        ),
                      ),
                    ),

                  buildFormField<ServiceModel>({
                    'label': 'Service *',
                    'type': 'dropDown',
                    'hint': 'Select Service',
                    'items': vm.serviceList,
                    'value': form.selectedService,
                    'labelBuilder': (ServiceModel item) =>
                        item.serviceName ?? '',
                    'onChanged': (ServiceModel? selected) {
                      vm.onServiceSelect(index, selected);
                    },
                  }, context),

                  buildFormField({
                    'label': 'Service Amount',
                    'hint': '0',
                    'controller': form.serviceAmount,
                    'icon': Icons.currency_rupee,
                    'type': 'number',
                    'readOnly': true,
                    'validator': (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.amountRequired;
                      }
                      return null;
                    },
                  }, context),
                ],
              ),
            );
          },
        ),

        Row(
          children: [
            Expanded(
              child: Visibility(
                visible: vm.serviceForms.isEmpty,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: GCCILabel(
                  "Services",
                  style: AppTextStyles.primary22_600,
                ),
              ),
            ),

            HorizontalSpacer.small,

            GCCIButton(
              isEnabled: true,
              height: 45,
              leadingIcon: Icons.add,
              fullWidth: false,
              text: "ADD",
              onPressed: () {
                vm.addServiceForm();
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget refreshmentDesign(AddBookingViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (vm.refreshForms.isNotEmpty) ...[
          GCCILabel("Refreshment", style: AppTextStyles.primary22_600),
          VerticalSpacer.small,
        ],

        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: vm.refreshForms.length,
          itemBuilder: (context, index) {
            final form = vm.refreshForms[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColor.buttonColor, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (vm.refreshForms.isNotEmpty)
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          vm.removeRefreshmentAt(index);
                        },
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 24,
                        ),
                      ),
                    ),

                  buildFormField<RefreshmentModel>({
                    'label': 'Refreshment *',
                    'type': 'dropDown',
                    'hint': 'Select Refreshment',
                    'items': vm.refreshmentList,
                    'value': form.selectedRefreshment,
                    'labelBuilder': (RefreshmentModel item) =>
                        item.refreshmentName ?? '',
                    'onChanged': (RefreshmentModel? selected) {
                      vm.onRefreshmentSelect(index, selected);
                    },
                    'validator': (RefreshmentModel? value) {
                      if (value == null) {
                        return AppStrings.required;
                      }
                      return null;
                    },
                  }, context),

                  buildFormField({
                    'label': 'Rate *',
                    'hint': 'Rate',
                    'controller': form.rate,
                    'icon': Icons.currency_rupee,
                    'type': 'number',
                    'readOnly': true,
                    'validator': (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.required;
                      }
                      return null;
                    },
                  }, context),

                  buildFormField({
                    'label': 'Number *',
                    'hint': 'Number',
                    'controller': form.number,
                    'icon': Icons.pin,
                    'type': 'number',
                    'maxLength': 5,
                    'onChanged': (value) {
                      vm.refreshNumberChanged(index, value);
                    },
                    'validator': (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.required;
                      }
                      return null;
                    },
                  }, context),

                  buildFormField({
                    'label': 'Refreshment Amount *',
                    'hint': 'Refreshment Amount',
                    'controller': form.refAmount,
                    'icon': Icons.currency_rupee,
                    'type': 'number',
                    'readOnly': true,
                    'validator': (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.amountRequired;
                      }
                      return null;
                    },
                  }, context),
                ],
              ),
            );
          },
        ),

        Row(
          children: [
            Expanded(
              child: Visibility(
                visible: vm.refreshForms.isEmpty,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: GCCILabel(
                  "Refreshment",
                  style: AppTextStyles.primary22_600,
                ),
              ),
            ),

            HorizontalSpacer.small,

            GCCIButton(
              isEnabled: true,
              height: 45,
              leadingIcon: Icons.add,
              fullWidth: false,
              text: "ADD",
              onPressed: () {
                vm.addRefreshmentModal();
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget valetParking(AddBookingViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GCCILabel("Valet Parking", style: AppTextStyles.primary22_600),
        VerticalSpacer.small,

        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: vm.valetForms.length,
          itemBuilder: (context, index) {
            final form = vm.valetForms[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColor.buttonColor, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildFormField({
                    'label': 'Valet Parking *',
                    'hint': 'Valet Parking',
                    'controller': form.valetParking,
                    'icon': Icons.currency_rupee,
                    'type': 'text',
                    'readOnly': true,
                    'validator': (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.required;
                      }
                      return null;
                    },
                  }, context),

                  buildFormField({
                    'label': 'Valet Parking Rate *',
                    'hint': 'Valet Parking Rate',
                    'controller': form.valetRate,
                    'icon': Icons.currency_rupee,
                    'type': 'number',
                    'readOnly': true,
                    'validator': (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.required;
                      }
                      return null;
                    },
                  }, context),

                  buildFormField({
                    'label': 'Number *',
                    'hint': 'Number',
                    'controller': form.valetNumber,
                    'icon': Icons.pin,
                    'type': 'number',
                    'maxLength': 5,
                    'onChanged': (value) {
                      vm.valetNumberChanged(index, value);
                    },
                    /* 'validator': (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.required;
                      }
                      return null;
                    },*/
                  }, context),

                  buildFormField({
                    'label': 'Valet Parking Total Amount *',
                    'hint': 'Valet Parking Total Amount',
                    'controller': form.valetAmount,
                    'icon': Icons.currency_rupee,
                    'type': 'number',
                    'readOnly': true,
                    /* 'validator': (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.amountRequired;
                      }
                      return null;
                    },*/
                  }, context),
                ],
              ),
            );
          },
        ),

        /*Align(
          alignment: Alignment.centerRight,
          child: GCCIButton(
            isEnabled: true,
            height: 45,
            leadingIcon: Icons.add,
            fullWidth: false,
            text: "ADD",
            onPressed: () {
              vm.addValetModal();
            },
          ),
        ),*/
      ],
    );
  }
}
