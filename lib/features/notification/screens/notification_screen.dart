import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixvalley_delivery_boy/features/dashboard/screens/dashboard_screen.dart';
import 'package:sixvalley_delivery_boy/features/notification/controllers/notification_controller.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/custom_loader_widget.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/no_data_screen_widget.dart';
import 'package:sixvalley_delivery_boy/features/notification/widgets/notification_card_item_widget.dart';

class NotificationScreen extends StatelessWidget {
  final bool fromNotification;
  const NotificationScreen({Key? key, required this.fromNotification}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.find<NotificationController>().getNotificationList(1);

    return PopScope(
      canPop: false,
      onPopInvoked: (val) async {
        if(fromNotification) {
          Get.to(()=> const DashboardScreen(pageIndex: 0));
        }
        return;
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(title: 'notification'.tr),
        body: GetBuilder<NotificationController>(builder: (notificationController) {

          return RefreshIndicator(
            onRefresh: () async {
              await notificationController.getNotificationList(1);
            },
            child: !notificationController.isLoading? notificationController.notificationList!.isNotEmpty?
            Scrollbar(child: SingleChildScrollView(child: Center(child: SizedBox(width: 1170, child:
             ListView.builder(
              itemCount: notificationController.notificationList!.length,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                bool _addTitle = false;
                return NotificationCardWidget(notificationModel: notificationController.notificationList![index],addTitle: _addTitle);
              },
            ))))):const NoDataScreenWidget(): const CustomLoaderWidget(),
          );
        }),
      ),
    );
  }
}
