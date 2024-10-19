import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sixvalley_delivery_boy/features/wallet/controllers/wallet_controller.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomCalenderWidget extends StatefulWidget {
  const CustomCalenderWidget({Key? key}) : super(key: key);

  @override
  State<CustomCalenderWidget> createState() => _CustomCalenderWidgetState();
}

class _CustomCalenderWidgetState extends State<CustomCalenderWidget> {
  String _range = '';

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('yyyy-MM-d').format(args.value.startDate)}/'

            '${DateFormat('yyyy-MM-d').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
      } else if (args.value is List<DateTime>) {
      } else {
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    List<String> rng = _range.split('/');
    return GetBuilder<WalletController>(
      builder: (walletController) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault, vertical: MediaQuery.of(context).size.height/5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
            child: Container(
              padding:  const EdgeInsets.fromLTRB(40,10,10,10),
              color: Get.isDarkMode ? Theme.of(context).dividerColor : Theme.of(context).canvasColor,
              child: SfDateRangePicker(

                confirmText: 'ok'.tr,
                showActionButtons: true,
                cancelText: 'cancel'.tr,
                onCancel: ()=> Get.back(),
                onSubmit: (value){
                  walletController.selectDate(rng[0], rng[1]);

                  Get.back();
                },

                todayHighlightColor: Get.isDarkMode ? Colors.white : Theme.of(context).primaryColor,
                selectionMode: DateRangePickerSelectionMode.range,
                rangeSelectionColor: Theme.of(context).primaryColor.withOpacity(.50),
                view: DateRangePickerView.month,

                startRangeSelectionColor: Theme.of(context).colorScheme.primary,
                endRangeSelectionColor: Theme.of(context).colorScheme.primary,
                initialSelectedRange: PickerDateRange(
                    DateTime.now().subtract(const Duration(days: 2)),
                    DateTime.now().add(const Duration(days: 2))),
                onSelectionChanged: _onSelectionChanged,
                          ),),
          ),
        );
      }
    );
  }
}
