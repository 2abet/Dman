import 'package:flutter/material.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/custom_loader_widget.dart';
import 'package:sixvalley_delivery_boy/common/controllers/localization_controller.dart';
import 'package:sixvalley_delivery_boy/features/order_details/controllers/order_details_controller.dart';
import 'package:sixvalley_delivery_boy/features/order_details/screens/order_delivered_screen.dart';
import 'package:sixvalley_delivery_boy/features/order_details/widgets/camera_or_gallery_widget.dart';
import 'package:sixvalley_delivery_boy/features/order_details/widgets/slider_button_widget.dart';
import 'package:sixvalley_delivery_boy/features/order_details/widgets/verify_otp_sheet_widget.dart';
import 'package:sixvalley_delivery_boy/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_delivery_boy/features/order/domain/models/order_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:sixvalley_delivery_boy/features/order/controllers/order_controller.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';
import 'package:sixvalley_delivery_boy/utill/images.dart';
import 'package:sixvalley_delivery_boy/utill/styles.dart';
import 'package:get/get.dart';

class OrderStatusChangeCustomButtonWidget extends StatelessWidget {
  final OrderModel? orderModel;
  final int? index;
  final double? totalPrice;
  const OrderStatusChangeCustomButtonWidget({Key? key, this.orderModel, this.index, this.totalPrice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (orderModel!.orderStatus == 'processing' || orderModel!.orderStatus == 'out_for_delivery') && !orderModel!.isPause! ?
    Padding(
      padding:  EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeSmall),
      child: Directionality(
        textDirection: Get.find<LocalizationController>().isLtr ? TextDirection.ltr :  TextDirection.rtl,
        child: SliderButtonWidget(
          isRtl: !Get.find<LocalizationController>().isLtr,
          action:  ()  {
            if(orderModel!.orderStatus == 'processing'){
              showDialog(context: context, builder: (ctx)  => const CustomLoaderWidget());
              Get.find<OrderDetailsController>().updateOrderStatus(orderId: orderModel!.id,
                  status: 'out_for_delivery',context: context);
              Navigator.of(context).pop();
              Get.find<OrderController>().getCurrentOrders();
            }else if(orderModel!.orderStatus == 'out_for_delivery'){
        
             if(Get.find<SplashController>().configModel?.imageUpload == 1) {
                showDialog(context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Dialog(backgroundColor: Colors.transparent,
        
                        shadowColor: Colors.transparent,
                        surfaceTintColor: Colors.transparent,
                        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
        
                          InkWell(onTap: (){
                            Get.find<OrderDetailsController>().gotoEndOfPage();
                            Get.back();
                          }, child: Padding(padding: EdgeInsets.only(bottom : Dimensions.paddingSizeDefault),
                                child: Icon(Icons.cancel_rounded, color: Theme.of(context).hintColor,size: 30))),
        
                          InkWell(onTap: (){
                            Get.back();
                            showModalBottomSheet<void>(
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child: CameraOrGalleryWidget(orderModel: orderModel, totalPrice: totalPrice));});
                          }, child: Container(width: Get.width,height: 170,
                            decoration: BoxDecoration(color: Get.isDarkMode ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                              child: Column(children: [
        
                                Padding(padding: EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
                                  child: Text('take_a_picture'.tr, style: rubikMedium.copyWith(color: Get.isDarkMode ? Theme.of(context).hintColor : Colors.black)),),
                                Container(width: 150,height: 75,
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(color: Get.isDarkMode ? Theme.of(context).cardColor : Theme.of(context).primaryColor.withOpacity(.125),
                                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                                    child: Image.asset(Images.camera))])))]));
                });
              }else{
               if (Get.find<SplashController>().configModel?.imageUpload == 0 && Get.find<SplashController>().configModel?.orderVerification == 0) {
                 if(orderModel?.paymentStatus != 'paid'){
                   Get.find<OrderDetailsController>().toggleProceedToNext();
                   showModalBottomSheet<void>(
                       backgroundColor: Colors.transparent,
                       isScrollControlled: true,
                       context: context,
                       builder: (BuildContext context) {
                         return Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                           child: VerifyDeliverySheetWidget(orderModel: orderModel, totalPrice: totalPrice),
                         );});
                 }else{Get.find<OrderDetailsController>().updateOrderStatus(orderId: orderModel!.id,
                     context: context, status: 'delivered').then((value) {
                   Navigator.of(context).pushReplacement(MaterialPageRoute(
                       builder: (_) => OrderDeliveredScreen(orderID: orderModel!.id.toString(),
                         orderModel: orderModel,)));
                 });
                 }
               } else{
                 Get.find<OrderDetailsController>().gotoEndOfPage();
               }
             }
            }
        
          },
        
          label: Text(orderModel!.orderStatus == 'processing'? 'swipe_to_out_for_delivery_order'.tr : 'swip_to_deliver_order'.tr,
            style: rubikMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall),),
          dismissThresholds: 0.5,
          icon: RotationTransition(
            turns:  const AlwaysStoppedAnimation(45 / 360),
            child: Center(child: Icon(!Get.find<LocalizationController>().isLtr ? Icons.arrow_forward_sharp :  CupertinoIcons.paperplane, color: Colors.white, size: 20.0,
                textDirection: TextDirection.rtl,
                semanticLabel: 'Text to announce in accessibility modes'))),
          radius: 100,
          width: MediaQuery.of(context).size.width-55,
          boxShadow: const BoxShadow(blurRadius: 0.0),
          buttonColor: Theme.of(context).primaryColor,
          backgroundColor: Get.isDarkMode ? Theme.of(context).cardColor : Theme.of(context).primaryColor.withOpacity(.05),
          baseColor: Theme.of(context).primaryColor),
      )):const SizedBox();}
}
