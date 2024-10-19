
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixvalley_delivery_boy/features/auth/controllers/auth_controller.dart';
import 'package:sixvalley_delivery_boy/features/profile/controllers/profile_controller.dart';
import 'package:sixvalley_delivery_boy/features/profile/domain/models/userinfo_model.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';
import 'package:sixvalley_delivery_boy/utill/images.dart';
import 'package:sixvalley_delivery_boy/utill/styles.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/animated_custom_dialog_widget.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/confirmation_dialog_widget.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/online_offline_button_widget.dart';
import 'package:sixvalley_delivery_boy/features/auth/screens/login_screen.dart';
import 'package:sixvalley_delivery_boy/features/earning_statement/screens/earning_statement_screen.dart';
import 'package:sixvalley_delivery_boy/features/emergency_contact/screens/emergency_contact_screen.dart';
import 'package:sixvalley_delivery_boy/features/help_and_support/screens/help_and_support_screen.dart';
import 'package:sixvalley_delivery_boy/features/profile/screens/policy_screen.dart';
import 'package:sixvalley_delivery_boy/features/profile/widgets/profile_button_widget.dart';
import 'package:sixvalley_delivery_boy/features/profile/widgets/profile_delivery_info_widget.dart';
import 'package:sixvalley_delivery_boy/features/profile/widgets/profile_header_widget.dart';
import 'package:sixvalley_delivery_boy/features/review/screens/review_screen.dart';
import 'package:sixvalley_delivery_boy/features/setting/screens/setting_screen.dart';


class ProfileScreen extends StatelessWidget {
   const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    UserInfoModel? profile = Get.find<ProfileController>().profileModel;
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'my_profile'.tr),

        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: GetBuilder<ProfileController>(builder: (profileController){

            return Column(children: [

                ProfileHeaderWidget(profileModel: profileController.profileModel),

                Padding(padding:  EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children:  [

                    Expanded(child: ProfileDeliveryInfoItemWidget(icon: Images.totalDelivery, title: 'total_delivery',
                        countNumber: double.parse(profile!.totalDelivery.toString()))),

                    Expanded(child: ProfileDeliveryInfoItemWidget(icon: Images.completedDelivery, title: 'completed_delivery',
                        countNumber: double.parse(profile.completedDelivery.toString()))),

                    Expanded(child: ProfileDeliveryInfoItemWidget(icon: Images.totalEarned, title: 'total_earned',
                      countNumber: profile.totalEarn, isAmount: true))])),
                  SizedBox(height: Dimensions.paddingSizeExtraSmall,),

                Container(padding:  EdgeInsets.all(Dimensions.paddingSizeSmall),
                 // color: Get.isDarkMode ? Theme.of(context).cardColor : null,
                  child: Column(children: [

                    Padding(padding:  EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall,horizontal: Dimensions.paddingSizeDefault),
                      child: Row(children: [
                        SizedBox(width: 20, child: Image.asset(Images.statusIcon, color:Get.isDarkMode ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary,)),
                         SizedBox(width: Dimensions.paddingSizeDefault),
                        Expanded(child: Text('status'.tr,style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault))),
                        const OnlineOfflineButtonWidget(showProfileImage: false)])),

                    ProfileButtonWidget(icon: Images.earnStatement, title: 'earning_statement'.tr,
                        onTap: () => Get.to(const EarningStatementScreen())),

                    ProfileButtonWidget(icon: Images.myReview, title: 'my_reviews'.tr,
                        onTap: () => Get.to(const ReviewScreen())),

                    ProfileButtonWidget(icon: Images.emergencyContact, title: 'emergency_contact'.tr,
                        onTap: () => Get.to(const EmergencyContactScreen())),

                    ProfileButtonWidget(icon: Images.helpSupport, title: 'help_and_support'.tr,
                        onTap: () => Get.to(const HelpAndSupportScreen())),

                    ProfileButtonWidget(icon: Images.settingIcon, title: 'setting'.tr,
                        onTap: () => Get.to(const SettingScreen())),


                    ProfileButtonWidget(icon: Images.myReview, title: 'privacy_policy'.tr,
                        onTap: () => Get.to(const PolicyScreen(isPrivacyPolicy: true))),


                    ProfileButtonWidget(icon: Images.myReview, title: 'terms_and_condition'.tr,
                        onTap: () => Get.to(const PolicyScreen(isPrivacyPolicy: false))),

                    ProfileButtonWidget(icon: Images.logOut, title: 'log_out'.tr,
                        onTap: () => showAnimatedDialogWidget(context,  ConfirmationDialogWidget(icon: Images.logOut,
                          title: 'log_out'.tr,
                          description: 'do_you_want_to_log_out_this_account'.tr, onYesPressed: (){
                            Get.find<AuthController>().clearSharedData().then((condition) {
                              Get.back();
                              Get.offAll(const LoginScreen());
                            });
                          },),isFlip: true)),
                    ],
                  ),
                )
              ],
            );
          },)
        ));
  }
}
