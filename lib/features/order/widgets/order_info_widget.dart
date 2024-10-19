import 'package:flutter/material.dart';
import 'package:sixvalley_delivery_boy/features/order_details/controllers/order_details_controller.dart';
import 'package:sixvalley_delivery_boy/features/order_details/widgets/ordered_product_list_view_widget.dart';
import 'package:sixvalley_delivery_boy/theme/controllers/theme_controller.dart';
import 'package:sixvalley_delivery_boy/features/order/domain/models/order_model.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';
import 'package:sixvalley_delivery_boy/utill/images.dart';
import 'package:sixvalley_delivery_boy/utill/styles.dart';
import 'package:sixvalley_delivery_boy/features/order/widgets/order_item_info_widget.dart';
import 'package:get/get.dart';

class OrderInfoWidget extends StatelessWidget {
  final OrderModel? orderModel;
  final OrderDetailsController? orderController;
  final bool fromDetails;
  const OrderInfoWidget({Key? key, this.orderModel, this.orderController, this.fromDetails = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(padding:  EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(color: Theme.of(context).cardColor,
            boxShadow: [BoxShadow(color: Get.find<ThemeController>().darkTheme ? Colors.black.withOpacity(0.10) : Colors.grey[100]!,
              blurRadius: 5, spreadRadius: 1,)],
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
        child: Column(children: [
          Row(children: [
            SizedBox(width: 20, child: Image.asset(Images.orderInfo)),
            Padding(padding:  EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
              child: Text('order_info'.tr,style: rubikMedium.copyWith(color: Get.isDarkMode?
              Theme.of(context).hintColor.withOpacity(.5) : Theme.of(context).primaryColor,
                  fontSize: Dimensions.fontSizeLarge)))]),

          Padding(padding:  EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault, 0),
            child: Column(children: [
              OrderItemInfoWidget(title: 'order_id',info: orderModel!.id.toString()),
              OrderItemInfoWidget(title: 'order_placed',info: orderModel!.updatedAt.toString(),isDate: true,),
              OrderItemInfoWidget(title: 'payment',info: orderModel!.paymentMethod),
              InkWell(onTap: ()=> Get.bottomSheet(
                OrderedItemProductListWidget(orderController: orderController),
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                clipBehavior: Clip.none,
                enableDrag: true),
                  child: OrderItemInfoWidget(title: 'products',
                    info: orderController!.orderDetails!.length.toString(), isProduct: true,))]))

        ]));
  }
}
