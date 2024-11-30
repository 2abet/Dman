import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_delivery_boy/features/dashboard/screens/dashboard_screen.dart';
import 'package:sixvalley_delivery_boy/features/order/controllers/order_controller.dart';
import 'package:sixvalley_delivery_boy/features/order/widgets/order_info_widget.dart';
import 'package:sixvalley_delivery_boy/features/order_details/controllers/order_details_controller.dart';
import 'package:sixvalley_delivery_boy/features/order_details/domain/models/order_details_model.dart';
import 'package:sixvalley_delivery_boy/features/order_details/screens/order_delivered_screen.dart';
import 'package:sixvalley_delivery_boy/features/order_details/widgets/camera_or_gallery_widget.dart';
import 'package:sixvalley_delivery_boy/features/order_details/widgets/customer_widget.dart';
import 'package:sixvalley_delivery_boy/features/order_details/widgets/order_info_with_customer_widget.dart';
import 'package:sixvalley_delivery_boy/features/order_details/widgets/order_status_change_custom_button_widget.dart';
import 'package:sixvalley_delivery_boy/features/order_details/widgets/order_status_widget.dart';
import 'package:sixvalley_delivery_boy/features/order_details/widgets/payment_info_widget.dart';
import 'package:sixvalley_delivery_boy/features/order_details/widgets/seller_info_widget.dart';
import 'package:sixvalley_delivery_boy/features/order_details/widgets/verify_otp_sheet_widget.dart';
import 'package:sixvalley_delivery_boy/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_delivery_boy/theme/controllers/theme_controller.dart';
import 'package:sixvalley_delivery_boy/features/order/domain/models/order_model.dart';
import 'package:sixvalley_delivery_boy/helper/price_converter.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';
import 'package:sixvalley_delivery_boy/utill/images.dart';
import 'package:sixvalley_delivery_boy/utill/styles.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/custom_loader_widget.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/custom_title_widget.dart';
import 'package:get/get.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel? orderModel;
  final bool fromNotification;
  const OrderDetailsScreen({Key? key, this.orderModel, required this.fromNotification}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  double totalPrice = 0;
  double? deliveryCharge = 0;
  OrderModel? orderModel;


  @override
  void initState() {
    print("===OrderDetailsInitState====>>}");
    Get.find<OrderDetailsController>().getOrderDetails(widget.orderModel!.id.toString(), context);
    if(widget.orderModel?.orderStatus == null){
      Get.find<OrderController>().getSingleOrderHistory(widget.orderModel!.id.toString());
    }
    Get.find<OrderDetailsController>().gotoEndOfPageInitialize();
    Get.find<OrderDetailsController>().emptyIdentityImage();
    orderModel = widget.orderModel;
    super.initState();
  }


  final ScrollController _controller = ScrollController();
  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvokedWithResult: (didPop, result) async{
        if(widget.fromNotification) {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const DashboardScreen(pageIndex: 0)), (route) => false);
        } else {
          return;
        }
      },

      child: Scaffold(
        appBar: CustomAppBarWidget(title: 'order_information'.tr, isBack: true,
          onTap: () {
            if(widget.fromNotification) {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const DashboardScreen(pageIndex: 0)), (route) => false);
            } else {
              Future.microtask(() {
                Get.back();
              });
            }
          },
        ),

        body: GetBuilder<OrderController>(
          builder: (orderController) {
            return GetBuilder<OrderDetailsController>(
              builder: (orderDetailsController) {
                if(orderDetailsController.endOfPage){
                  _scrollDown();
                }
                double _itemsPrice = 0;
                double _discount = 0;
                double _tax = 0;
                double _subTotal = 0;

                if(widget.orderModel?.orderStatus == null){
                  orderModel = orderController.orderModel;
                }


                if(widget.orderModel?.orderStatus == null ? orderController.orderModel != null : true){
                  deliveryCharge = orderModel!.shippingCost;

                  if (orderDetailsController.orderDetails != null) {
                    for (var orderDetails in orderDetailsController.orderDetails!) {
                      _itemsPrice = _itemsPrice + (orderDetails.price! * orderDetails.qty!);
                      _discount = _discount + orderDetails.discount!;
                      _tax = _tax + orderDetails.tax!;
                    }
                  }

                  if(widget.orderModel?.isShippingFree ?? false){
                    deliveryCharge = 0;
                  }

                  _subTotal = _itemsPrice + _tax - _discount;
                  totalPrice = _subTotal  + deliveryCharge! - orderModel!.discountAmount!;
                }
            
                return (orderDetailsController.orderDetails != null && (widget.orderModel?.orderStatus == null ? orderController.orderModel != null : true)) ?
                Column(children: [
                  Expanded(child: ListView(
                    controller: _controller,
                    physics: const BouncingScrollPhysics(),
                    padding:  EdgeInsets.all(Dimensions.paddingSizeSmall), children: [
            
                      Padding(padding:  EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                        child: OrderStatusWidget(orderModel : orderModel)),
            
                      orderModel!.orderStatus == 'processing' || orderModel!.orderStatus == 'out_for_delivery'?
                      OrderInfoWithCustomerWidget(orderModel: orderModel): const SizedBox(),
            
                      orderModel!.sellerInfo != null?
                      SellerInfoWidget(orderModel: orderModel): const SizedBox(),
                       SizedBox(height: Dimensions.paddingSizeSmall),
            
                      OrderInfoWidget(orderModel: orderModel, orderController: orderDetailsController,fromDetails: true),
            
            
                      Padding(padding:  EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                        child: CustomerWidget(orderModel: orderModel)),
            
            
                      PaymentInfoWidget(itemsPrice: _itemsPrice, tax: _tax, subTotal: _subTotal,
                        discount: _discount, deliveryCharge: widget.orderModel!.isShippingFree == true ? 0 : deliveryCharge, totalPrice: totalPrice),
            
                      Padding(padding:  EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                        child: Container(decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                          boxShadow: [BoxShadow(color: Get.find<ThemeController>().darkTheme ? Colors.black.withOpacity(0.10) : Colors.grey[100]!,
                            blurRadius: 5, spreadRadius: 1,)],
                          color: Theme.of(context).cardColor),
                          padding:  EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Expanded(child: Text('additional_delivery_charge_by_admin'.tr, style: rubikMedium.copyWith(color: Get.isDarkMode ? Theme.of(context).hintColor : Colors.black),)),
                            SizedBox(width: Dimensions.paddingSizeSmall,),
                            DottedBorder(color: Theme.of(context).primaryColor,
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(45),
                              child: Container(color: Theme.of(context).primaryColor.withOpacity(.05),
                                padding:  EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                child: Row( children: [
                                  Text(PriceConverter.convertPrice(orderModel!.deliveryManCharge),style: rubikMedium.copyWith(color: Get.isDarkMode ? Theme.of(context).hintColor : Colors.black))])))]))),
            
            
                      SizedBox(height: Dimensions.paddingSizeSmall),
            
                      if(orderModel!.orderStatus == 'out_for_delivery' && Get.find<SplashController>().configModel?.imageUpload == 1)
                      Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                          boxShadow: [BoxShadow(color: Get.find<ThemeController>().darkTheme ? Colors.black.withOpacity(0.10) : Colors.grey[100]!,
                            blurRadius: 5, spreadRadius: 1,)],
                          color: Theme.of(context).cardColor),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomTitleWidget(title: 'completed_service_picture',),
                          Padding(padding:  EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,
                              Dimensions.paddingSizeExtraSmall, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault),
                            child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,crossAxisSpacing: 10, mainAxisSpacing: 10),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount : orderDetailsController.identityImages.length + 1 ,
                                itemBuilder: (BuildContext context, index){
                                  return index ==  orderDetailsController.identityImages.length ?
                                  InkWell(onTap: (){
                                    showModalBottomSheet<void>(
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                          child: CameraOrGalleryWidget(orderModel: orderModel, totalPrice: totalPrice),
                                        );
                                      },
                                    );
                                  }, child: Container(decoration: BoxDecoration(
                                      color: Get.isDarkMode ? Theme.of(context).cardColor : Theme.of(context).primaryColor.withOpacity(.125),
                                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                                      child: Stack(children: [
                                        Center(child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                            child: SizedBox(width: 40, height: 40, child: Image.asset(Images.camera))))]))) :
            
            
                                  Stack(children: [
                                    Padding(padding: EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                                      child: Container(decoration:  BoxDecoration(color: Theme.of(context).cardColor,
                                        borderRadius: const BorderRadius.all(Radius.circular(20)),),
                                        child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),
                                          child:  Image.file(File(orderDetailsController.identityImages[index].path),
                                            height: 400,width: 400, fit: BoxFit.cover)))),
            
            
                                    Positioned(top:0,right:0,
                                      child: InkWell(onTap :() => orderDetailsController.removeImage(index),
                                        child: Container(decoration: BoxDecoration(color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault))),
                                            child: const Padding(padding: EdgeInsets.all(4.0),
                                              child: Center(child: Icon(Icons.delete_forever_rounded,color: Colors.red,size: 15))))))]);
                            })),
                        ],),),
                    ],
                  ),
                  ),
                ],) : CustomLoaderWidget(height: Get.height);});
          }
        ),


        bottomNavigationBar: GetBuilder<OrderController>(
          builder: (orderController) {
            return GetBuilder<OrderDetailsController>(
              builder: (orderDetailsController) {
                if(widget.orderModel?.orderStatus == null){
                  orderModel = orderController.orderModel;
                }
                //  && (widget.orderModel?.orderStatus == null ? orderController.orderModel != null : true)
                return (orderDetailsController.orderDetails != null && orderModel != null && (orderModel?.orderStatus == null ? orderController.orderModel != null : true)) ?

                SizedBox(height: (orderModel?.orderStatus == 'processing' || orderModel?.orderStatus == 'out_for_delivery') && !orderModel!.isPause! ? 80 : 0,
                  child : (orderDetailsController.endOfPage || Get.find<SplashController>().configModel?.imageUpload == 0 && orderModel!.orderStatus != 'processing' &&
                  !(Get.find<SplashController>().configModel?.orderVerification == 0 && Get.find<SplashController>().configModel?.imageUpload == 0)) ?

                    Padding(padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: orderDetailsController.uploading ? const Center(child: CircularProgressIndicator()):
                      CustomButtonWidget(btnTxt: 'proceed_next'.tr,
                      onTap: (){
                        if(Get.find<SplashController>().configModel?.imageUpload == 1 && orderDetailsController.identityImages.isEmpty) {
                          showCustomSnackBarWidget('please_select_an_image'.tr, isError: false);
                        } else if(orderDetailsController.identityImages.isNotEmpty && Get.find<SplashController>().configModel?.imageUpload == 1){
                          orderDetailsController.uploadOrderVerificationImage(orderModel!.id.toString()).then((value){
                            if(Get.find<SplashController>().configModel?.orderVerification == 1){
                              showModalBottomSheet<void>(
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                    child: VerifyDeliverySheetWidget(orderModel: orderModel, totalPrice: totalPrice),
                                  );
                                },
                              );
                            }else{
                              if(orderModel?.paymentStatus != 'paid') {
                                orderDetailsController.toggleProceedToNext();
                                showModalBottomSheet<void>(
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                      child: VerifyDeliverySheetWidget(orderModel: orderModel, totalPrice: totalPrice),
                                    );});
                              } else{orderDetailsController.updateOrderStatus(orderId: orderModel!.id,
                                  context: context, status: 'delivered').then((value) {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (_) => OrderDeliveredScreen(orderID: orderModel!.id.toString(),
                                        orderModel: orderModel,)));
                                });
                              }
                            }
                          });
                        }else{
                          if(Get.find<SplashController>().configModel?.orderVerification == 1){
                            showModalBottomSheet<void>(
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child: VerifyDeliverySheetWidget(orderModel: orderModel, totalPrice: totalPrice),
                                );
                              },
                            );
                          }else{
                            if(orderModel?.paymentStatus != 'paid'){
                              orderDetailsController.toggleProceedToNext();
                              showModalBottomSheet<void>(
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                    child: VerifyDeliverySheetWidget(orderModel: orderModel, totalPrice: totalPrice),
                                  );
                                },
                              );
                            }else{
                              orderDetailsController.updateOrderStatus(orderId: orderModel!.id,context: context,
                                  status: 'delivered').then((value) {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (_) => OrderDeliveredScreen(orderID: orderModel!.id.toString(),
                                      orderModel: orderModel)));
                              });
                            }
                          }
                        }
                      })) :
                      Container(
                        color: Get.isDarkMode ? Theme.of(context).cardColor : null,
                        child: OrderStatusChangeCustomButtonWidget(orderModel: orderModel, totalPrice: totalPrice))
                ) : const Center(child: CircularProgressIndicator());
              }
            );
          }
        ),



      ),
    );
  }
}

