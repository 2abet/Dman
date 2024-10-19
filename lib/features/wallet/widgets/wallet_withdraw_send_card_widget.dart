import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixvalley_delivery_boy/features/profile/controllers/profile_controller.dart';
import 'package:sixvalley_delivery_boy/helper/price_converter.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';
import 'package:sixvalley_delivery_boy/utill/images.dart';
import 'package:sixvalley_delivery_boy/utill/styles.dart';
import 'package:sixvalley_delivery_boy/features/withdraw/screens/withdraw_request_screen.dart';

class WalletSendWithdrawCardWidget extends StatelessWidget {
  const WalletSendWithdrawCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(padding:  EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      color: Get.isDarkMode ? Theme.of(context).canvasColor : Theme.of(context).cardColor, alignment:   Alignment.center,
      child:GetBuilder<ProfileController>(
        builder: (profileController) {
          return Stack(children: [
              Container(height: MediaQuery.of(context).size.width/2,
                width: MediaQuery.of(context).size.width,
                padding:  EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                margin:  EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                  boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 900 : 200]!,
                      spreadRadius: 0.5, blurRadius: 0.3)])),

              Padding(
                padding: EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                child: Container(width: MediaQuery.of(context).size.width-70,height: 200,
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withOpacity(.10),
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(MediaQuery.of(context).size.width/2.5), topLeft: const Radius.circular(10), bottomLeft: const Radius.circular(10)))),
              ),

              Container(height: MediaQuery.of(context).size.width/2.5,
                width: MediaQuery.of(context).size.width,
                padding:  EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                margin:  EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center, children: [
                      SizedBox (width: Dimensions.logoHeight, height: Dimensions.logoHeight,
                          child: Image.asset(Images.cardWhite)),

                      Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Text('balance_withdraw'.tr, style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Colors.white)),
                        SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                        Text(PriceConverter.convertPrice(profileController.profileModel?.withdrawableBalance ?? 0),
                            style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge,
                                color:Get.isDarkMode? Theme.of(context).hintColor : Theme.of(context).cardColor))]),
                        const SizedBox(width: Dimensions.logoHeight)]),


                     SizedBox(height: Dimensions.paddingSizeLarge,),
                    InkWell(onTap: ()=> Get.to(const BalanceWithdrawScreen()),
                      child: Container(height: 40,width: 250,
                        decoration: BoxDecoration(color:Get.isDarkMode?
                        Theme.of(context).hintColor.withOpacity(.5) : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraLarge)),

                        child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                          Text('send_withdraw_request'.tr, style:rubikRegular.copyWith(color: Theme.of(context).primaryColor,
                              fontSize: Dimensions.fontSizeLarge))])))
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
