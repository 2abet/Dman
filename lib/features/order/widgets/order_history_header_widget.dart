import 'package:flutter/material.dart';
import 'package:sixvalley_delivery_boy/features/order/controllers/order_controller.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/custom_search_widget.dart';
import 'package:sixvalley_delivery_boy/features/order/widgets/order_type_button_widget.dart';
import 'package:sixvalley_delivery_boy/features/wallet/widgets/transaction_search_filter_widget.dart';
import 'package:get/get.dart';


class OrderHistoryHeaderWidget extends StatefulWidget {
  const OrderHistoryHeaderWidget({Key? key}) : super(key: key);

  @override
  State<OrderHistoryHeaderWidget> createState() => _OrderHistoryHeaderWidgetState();
}

class _OrderHistoryHeaderWidgetState extends State<OrderHistoryHeaderWidget> {
  @override
  Widget build(BuildContext context) {

    return GetBuilder<OrderController>(
      builder: (orderController) {
        return Container(height: 165,decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius:  BorderRadius.only(bottomLeft: Radius.circular(Dimensions.paddingSizeOverLarge),
              bottomRight: Radius.circular(Dimensions.paddingSizeOverLarge))),
          padding:  EdgeInsets.only(top : Dimensions.paddingSizeSmall),
          child: Column(children: [
            GetBuilder<OrderController>(
            builder: (order) {
              return Padding(padding:  EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,
                    Dimensions.fontSizeExtraSmall, Dimensions.paddingSizeDefault,5),
                child: Container(height: 48, decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary.withOpacity(.25),
                  borderRadius: BorderRadius.circular(Dimensions.flagSize)),
                    child: Stack(children: [
                        Padding(padding: const EdgeInsets.only(left: 48, right: 10),
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              OrderTypeButtonWidget(text: 'all'.tr, index: 0),

                              OrderTypeButtonWidget(text: 'out_for_delivery'.tr, index: 1),

                              OrderTypeButtonWidget(text: 'paused'.tr, index: 2),

                              OrderTypeButtonWidget(text: 'delivered'.tr, index: 3),

                              OrderTypeButtonWidget(text: 'return'.tr, index: 4),

                              OrderTypeButtonWidget(text: 'canceled'.tr, index: 5),
                            ],
                          ),
                        ),
                        CustomSearchWidget(
                          width: MediaQuery.of(context).size.width,
                          textController: orderController.searchOrderController,
                          onSuffixTap: () => orderController.searchOrderController.clear(),
                          onChanged: (value){
                            if(value != null){
                              orderController.setOrderTypeIndex(orderController.orderTypeIndex,
                                  search: orderController.searchOrderController.text);
                            }
                          },
                          color: Get.isDarkMode ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                          helpText: "search_by_order_id".tr,
                          autoFocus: true,
                          closeSearchOnSuffixTap: true,
                          animationDurationInMilli: 200,
                          rtl: false)])));}),
            const DeliverySearchFilterWidget(fromHistory : true),

        ],),);
      }
    );
  }
}
