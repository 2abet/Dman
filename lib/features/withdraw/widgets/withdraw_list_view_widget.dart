import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/custom_loader_widget.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/no_data_screen_widget.dart';
import 'package:sixvalley_delivery_boy/features/withdraw/controllers/withdraw_controller.dart';
import 'package:sixvalley_delivery_boy/features/withdraw/widgets/withdraw_card_widget.dart';

class WithdrawListViewWidget extends StatelessWidget {
  const WithdrawListViewWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithdrawController>(
        builder: (withdrawController) {
          return !withdrawController.isLoading? withdrawController.withdrawList.isNotEmpty?
          ListView.builder(
              itemCount: withdrawController.withdrawList.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (withdrawContext, withdrawIndex){
                return WithdrawCardWidget(withdraws: withdrawController.withdrawList[withdrawIndex]);
              }):const NoDataScreenWidget() :CustomLoaderWidget(height: Get.height-600,);
        }
    );
  }
}
