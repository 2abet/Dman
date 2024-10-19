import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixvalley_delivery_boy/features/profile/controllers/profile_controller.dart';
import 'package:sixvalley_delivery_boy/helper/price_converter.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';
import 'package:sixvalley_delivery_boy/utill/styles.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/calculation_widget.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_delivery_boy/features/wallet/screens/wallet_screen.dart';

class EarnStatementWidget extends StatelessWidget {
  const EarnStatementWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children:[

        GetBuilder<ProfileController>(
          builder: (profileController) {
            return Container(height: 250,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor,
                  borderRadius:  BorderRadius.only(bottomLeft:Radius.circular(Dimensions.paddingSizeDefault),
                      bottomRight:Radius.circular(Dimensions.paddingSizeDefault))),

              child: Stack(children: [Positioned.fill(
                  child: Align(alignment: Alignment.topLeft,
                    child: Container(width: 250, height : 200, decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(.05),
                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(500))))),),


                Padding(padding:  EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Padding(padding:  EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                        child: Padding(padding:  EdgeInsets.only(top: Dimensions.paddingSizeExtraLarge),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
                          Container(decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight.withOpacity(.25),
                            border: Border.all(color: Theme.of(context).primaryColorLight),
                            borderRadius: BorderRadius.circular(50)),

                            child: ClipRRect(borderRadius: BorderRadius.circular(50),
                              child: CustomImageWidget(image: '${Get.find<ProfileController>().profileImage}',
                                height: 40, width: 40, fit: BoxFit.cover))),


                          Expanded(child: Padding(padding:  EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall,0,0,0),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  const Text(''),
                                  Get.find<ProfileController>().profileModel !=null?
                                  Text('${'hi'.tr}, ${Get.find<ProfileController>().profileModel!.fName??''} ${Get.find<ProfileController>().profileModel!.lName}',
                                    overflow: TextOverflow.ellipsis, maxLines: 1,
                                    style: rubikRegular.copyWith(color: Get.isDarkMode ? Theme.of(context).primaryColorLight :Colors.white,fontSize: Dimensions.fontSizeDefault),):const SizedBox(),
                                ],
                              )),
                          ),

                          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                              const Text(''),
                              if(Get.find<ProfileController>().profileModel!= null)
                              Padding(padding:  EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall,0,0,Dimensions.paddingSizeSmall),
                                  child: Text(' ${PriceConverter.convertPrice(Get.find<ProfileController>().profileModel!.currentBalance)}',
                                    style: rubikMedium.copyWith(color: Get.isDarkMode ? Theme.of(context).primaryColorLight :Colors.white, fontSize: Dimensions.fontSizeExtraLarge),)),
                              Padding(padding:  EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall,0,0,Dimensions.paddingSizeDefault),
                                  child: Text('current_balance'.tr,
                                    style: rubikRegular.copyWith(color: Get.isDarkMode ? Theme.of(context).primaryColorLight :Colors.white, fontSize: Dimensions.fontSizeLarge),)),
                            ]),
                    ]))),
                    SizedBox(height: Dimensions.paddingSizeDefault),


                      SizedBox(height : 100,
                        child: ListView(scrollDirection: Axis.horizontal, children: [
                          CalculationWidget(title: 'cash_in_hand'.tr,
                              amount: profileController.profileModel?.cashInHand??0, isTotalAmount: true),

                          CalculationWidget(title: 'pending_withdraw'.tr,
                            amount: profileController.profileModel?.pendingWithdraw??0),

                          CalculationWidget(title: 'withdrawn'.tr,
                              amount: profileController.profileModel?.totalWithdraw ?? 0),

                          CalculationWidget(title: 'withdrawable_balance'.tr,
                            amount: profileController.profileModel?.withdrawableBalance??0, isWithdrawable: true,
                            onTap: () => Get.to(const WalletScreen(fromNotification: true)))])),
                    ],
                  ),
                ),
              ],
            ),);
          }
        ),
      ]
    );
  }
}

