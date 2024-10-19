import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sixvalley_delivery_boy/common/controllers/localization_controller.dart';
import 'package:sixvalley_delivery_boy/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_delivery_boy/helper/price_converter.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';
import 'package:sixvalley_delivery_boy/utill/styles.dart';

class CalculationWidget extends StatelessWidget {
  final String? title;
  final double? amount;
  final bool isTotalAmount;
  final bool isWithdrawable;
  final Function? onTap;
  const CalculationWidget({Key? key, this.title, this.amount, this.isTotalAmount = false, this.isWithdrawable = false, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Padding(
        padding:  EdgeInsets.only(left : Dimensions.paddingSizeExtraSmall),
        child: Row(
          children: [
            Container(height: 100,width:isWithdrawable? 120 : 100,
              padding:  EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.secondary.withOpacity(.5)),
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),

              ),
              child: Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Text('${Get.find<SplashController>().myCurrency!.symbol} ${NumberFormat.compact().format(double.parse(PriceConverter.convertPriceWithoutSymbol(context, amount)))}',style:
                    rubikBold.copyWith(color: Get.isDarkMode ? Theme.of(context).primaryColorLight :Colors.white,
                        fontSize: Dimensions.fontSizeLarge)),
                     SizedBox(height: Dimensions.paddingSizeSmall),

                    Text(title!,maxLines : 2,textAlign: TextAlign.center,
                      style: rubikRegular.copyWith(color: Get.isDarkMode ? Theme.of(context).primaryColorLight :Colors.white,
                          fontSize: Dimensions.fontSizeSmall),),

                  ],),
              ),
            ),
            isWithdrawable?
            Container(transform: Get.find<LocalizationController>().isLtr? Matrix4.translationValues(-25, -25, 0) : Matrix4.translationValues(25, -25,0),
            child: Icon(CupertinoIcons.arrow_right_circle_fill,size: Dimensions.iconSizeLarge, color:Get.isDarkMode? Theme.of(context).hintColor.withOpacity(.5) : Theme.of(context).cardColor.withOpacity(.5),)):const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}