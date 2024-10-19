
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixvalley_delivery_boy/features/chat/controllers/chat_controller.dart';
import 'package:sixvalley_delivery_boy/features/order/domain/models/order_model.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';
import 'package:sixvalley_delivery_boy/utill/images.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_delivery_boy/features/chat/screens/chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class CallAndChatWidget extends StatelessWidget {
  final OrderModel? orderModel;
  final bool isSeller;
  final bool isAdmin;
  const CallAndChatWidget({Key? key, this.orderModel, this.isSeller = false, this.isAdmin = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? phone = isSeller? orderModel!.sellerInfo!.phone :orderModel!.isGuest! ? orderModel?.shippingAddress?.phone: orderModel!.customer?.phone??'';
    int? id = 0;
    String? name = '';
    if(isAdmin){
      id = 0;
      name = 'admin';
    }else{
      id =   isSeller ? orderModel!.sellerInfo!.id! : orderModel!.customer?.id?? -1;
      name = isSeller ? orderModel!.sellerInfo!.shop!.name! : '${orderModel!.customer?.fName??''} ${orderModel!.customer?.lName??''}';
    }

    return Row(children: [
      InkWell(onTap: ()=> _launchUrl("tel:$phone"),
        child: Padding(padding:  EdgeInsets.only(right: Dimensions.paddingSizeSmall),
          child: Container(width: 30,height: 30,decoration: BoxDecoration(
            color: Theme.of(context).hintColor.withOpacity(.0525),
            border: Border.all(color: Theme.of(context).hintColor),
            borderRadius: BorderRadius.circular(50)),
            padding:  EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Image.asset(Images.callIcon,color: Theme.of(context).colorScheme.onTertiaryContainer)))),


      if(isAdmin || isSeller || !orderModel!.isGuest!)
      InkWell(onTap: (){
        if(!isSeller && !isAdmin && orderModel!.isGuest!){
          showCustomSnackBarWidget('you_cant_chat_with_guest_user'.tr);
        }
          else if(!isSeller && !isAdmin && !orderModel!.isGuest!){
            Get.find<ChatController>().setUserTypeIndex(1);
          }else if(isAdmin){
            Get.find<ChatController>().setUserTypeIndex(3);
          }else if(isSeller){
          Get.find<ChatController>().setUserTypeIndex(0);
        }
          if(id != -1){
            Get.to(()=> ChatScreen(userId: id, name: name));
          }else if(id  == -1){
            showCustomSnackBarWidget('user_account_was_deleted'.tr);
          }
        },
        child: Padding(padding:  EdgeInsets.only(right: Dimensions.paddingSizeSmall),
          child: Container(width: 30,decoration: BoxDecoration(
            color: Theme.of(context).hintColor.withOpacity(.0525),
            border: Border.all(color: Theme.of(context).hintColor),
            borderRadius: BorderRadius.circular(50)),
            padding:  EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Image.asset(Images.smsIcon,color:Get.isDarkMode? Theme.of(context).hintColor: Theme.of(context).primaryColor,),),
        ),
      )
    ],);
  }
}

Future<void> _launchUrl(String _url) async {
  if (!await launchUrl(Uri.parse(_url))) {
    throw 'Could not launch $_url';
  }
}