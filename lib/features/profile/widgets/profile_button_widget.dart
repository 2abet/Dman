import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';
import 'package:sixvalley_delivery_boy/utill/styles.dart';

class ProfileButtonWidget extends StatelessWidget {
  final String icon;
  final String title;
  final Function onTap;
  const ProfileButtonWidget({Key? key, required this.icon, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      child: GestureDetector(
        onTap: onTap as void Function()?,
        child: Container(width: MediaQuery.of(context).size.width,
          color: Get.isDarkMode ? null : Theme.of(context).cardColor,
          child: Column(
            children: [
              Divider(color: Get.isDarkMode ? Theme.of(context).hintColor.withOpacity(.25) : Theme.of(context).primaryColor.withOpacity(.25)),
              Padding(
                padding:  EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall,
                    horizontal: Dimensions.paddingSizeDefault),
                child: Row(
                  children: [
                    SizedBox(width: 20,child: Image.asset(icon, color:Get.isDarkMode ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary)),
                     SizedBox(width: Dimensions.paddingSizeDefault),
                    Text(title, style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Get.isDarkMode ? Theme.of(context).primaryColorLight : Colors.black ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}