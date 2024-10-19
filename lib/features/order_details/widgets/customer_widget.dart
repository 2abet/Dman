import 'package:flutter/material.dart';
import 'package:sixvalley_delivery_boy/theme/controllers/theme_controller.dart';
import 'package:sixvalley_delivery_boy/features/order/domain/models/order_model.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';
import 'package:sixvalley_delivery_boy/utill/images.dart';
import 'package:sixvalley_delivery_boy/utill/styles.dart';
import 'package:get/get.dart';
import 'package:sixvalley_delivery_boy/features/order/widgets/order_item_info_widget.dart';


class CustomerWidget extends StatelessWidget {
  final OrderModel? orderModel;
  final int? index;
  const CustomerWidget({Key? key, this.orderModel, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(padding:  EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Get.find<ThemeController>().darkTheme ? Colors.black.withOpacity(0.10) : Colors.grey[100]!,
          blurRadius: 5, spreadRadius: 1)]),


      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Row(children: [
          SizedBox(width: 20, child: Image.asset(Images.customerIcon)),
          Padding(padding:  EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
            child: Text('delivery_info'.tr,style: rubikMedium.copyWith(color: Theme.of(context).colorScheme.tertiary,
                fontSize: Dimensions.fontSizeLarge)))]),


        Padding(padding:  EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault, 0),
          child: Column(children: [
            OrderItemInfoWidget(title: 'name',info: orderModel!.shippingAddress?.contactPersonName?? ''),
            OrderItemInfoWidget(title: 'contact',info: orderModel!.shippingAddress?.phone??''),
            OrderItemInfoWidget(title: 'location', info: orderModel!.shippingAddress != null ?
            '${orderModel!.shippingAddress?.address}, ''${orderModel!.shippingAddress?.city}, ''${orderModel!.shippingAddress?.zip}' :  '')])),
         SizedBox(height: Dimensions.paddingSizeDefault),
      ]),
    );
  }
}
