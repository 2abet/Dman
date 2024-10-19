
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/custom_loader_widget.dart';
import 'package:sixvalley_delivery_boy/features/chat/controllers/chat_controller.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_delivery_boy/features/chat/widgets/message_list_view_widget.dart';
import 'package:sixvalley_delivery_boy/features/chat/widgets/message_sendig_section_widget.dart';
import 'package:sixvalley_delivery_boy/helper/image_size_checker.dart';
import 'package:sixvalley_delivery_boy/utill/app_constants.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';
import 'package:sixvalley_delivery_boy/utill/images.dart';
import 'package:sixvalley_delivery_boy/utill/styles.dart';


class ChatScreen extends StatefulWidget {
  final int? userId;
  final String? name;
  const ChatScreen({Key? key, required this.userId, this.name = 'chat'}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();



  @override
  void initState() {
    super.initState();
    Get.find<ChatController>().getChats(1, widget.userId,firstLoad: true);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (chatController) {
      return PopScope(
        canPop: true,
        onPopInvoked: (value) {
          Get.find<ChatController>().getConversationList(1);
        },
        child: Scaffold(
          appBar: CustomAppBarWidget(title: widget.name, isBack: true,),

          body: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(children: [

                chatController.messageModel != null ?
                 Expanded(child: (chatController.messageModel!.message != null && chatController.messageModel!.message!.isNotEmpty) ?
                    MessageListViewWidget(chatController: chatController, scrollController: _scrollController, userId: widget.userId) :
                    const SizedBox()): Expanded(child: CustomLoaderWidget(height: Get.height-300,)),

                chatController.pickedImageFileStored != null && chatController.pickedImageFileStored!.isNotEmpty ?
                Container(
                  color:  chatController.isLoading == false && ((chatController.pickedImageFileStored!=null && chatController.pickedImageFileStored!.isNotEmpty) || (chatController.objFile != null && chatController.objFile!.isNotEmpty)) ?
                  Theme.of(context).primaryColor.withOpacity(0.1) : null,
                  height: (chatController.pickedFIleCrossMaxLimit || chatController.pickedFIleCrossMaxLength || chatController.singleFIleCrossMaxLimit) ? 105 : 90, width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: Dimensions.paddingSizeExtraSmall),
                  child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      SizedBox(
                        height: 80,
                        child: ListView.builder(scrollDirection: Axis.horizontal,
                            itemBuilder: (context,index){
                              return  Stack(children: [
                                Padding(padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: ClipRRect(borderRadius: BorderRadius.circular(10),
                                      child: SizedBox(height: 80, width: 80,
                                        child: Image.file(File(chatController.pickedImageFileStored![index].path), fit: BoxFit.cover)))),

                                Positioned(right: 5, child: InkWell(
                                    child: const Icon(Icons.cancel_outlined, color: Colors.red),
                                    onTap: () => chatController.pickMultipleImage(true,index: index)))]);},
                            itemCount: chatController.pickedImageFileStored!.length),
                      ),

                      if(chatController.pickedFIleCrossMaxLimit || chatController.pickedFIleCrossMaxLength || chatController.singleFIleCrossMaxLimit)
                        Text( "${chatController.pickedFIleCrossMaxLength ? "• ${"can_not_select_more_than".tr} ${AppConstants.maxLimitOfTotalFileSent.floor()} ${'files'.tr}" :""} "
                            "${chatController.pickedFIleCrossMaxLimit ? "• ${'total_images_size_can_not_be_more_than'.tr} ${AppConstants.maxLimitOfFileSentINConversation.floor()} MB" : ""} "
                            "${chatController.singleFIleCrossMaxLimit ? "• ${'single_file_size_can_not_be_more_than'.tr} ${AppConstants.maxSizeOfASingleFile.floor()} MB" : ""} ",
                          style: rubikRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.error.withOpacity(0.7),
                          ),
                        ),
                    ],
                  )

                ) : const SizedBox(),


                chatController.objFile != null && chatController.objFile!.isNotEmpty && chatController.isLoading == false ?
                ColoredBox(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 70,
                          child: ListView.separated(
                            shrinkWrap: true, scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(bottom: 5),
                            separatorBuilder: (context, index) =>  SizedBox(width: Dimensions.paddingSizeDefault),
                            itemCount: chatController.objFile!.length,
                            itemBuilder: (context, index){
                              String fileSize =  ImageSize.getFileSizeFromPlatformFileToString(chatController.objFile![index]);
                              return Container(width: 180,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                ),
                                padding: const EdgeInsets.only(left: 10, right: 5),
                                child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [

                                  Image.asset(Images.fileIcon,height: 30, width: 30,),
                                  SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center, children: [

                                    Text(chatController.objFile![index].name,
                                      maxLines: 1, overflow: TextOverflow.ellipsis,
                                      style: rubikBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                                    ),

                                    Text(fileSize, style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
                                      color: Theme.of(context).hintColor,
                                    )),
                                  ])),


                                  InkWell(
                                    onTap: () {
                                      chatController.pickOtherFile(true, index: index);
                                    },
                                    child: Padding(padding: const EdgeInsets.only(top: 5),
                                      child: Align(alignment: Alignment.topRight,
                                        child: Icon(Icons.close,
                                          size: Dimensions.paddingSizeLarge,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                              );
                            },
                          ),
                        ),

                        if(chatController.pickedFIleCrossMaxLimit || chatController.pickedFIleCrossMaxLength || chatController.singleFIleCrossMaxLimit)
                          Text( "${chatController.pickedFIleCrossMaxLength ? "• ${"can_not_select_more_than".tr} ${AppConstants.maxLimitOfTotalFileSent.floor()} ${'files'.tr}" :""} "
                              "${chatController.pickedFIleCrossMaxLimit ? "• ${'total_images_size_can_not_be_more_than'.tr} ${AppConstants.maxLimitOfFileSentINConversation.floor()} MB" : ""} "
                              "${chatController.singleFIleCrossMaxLimit ? "• ${'single_file_size_can_not_be_more_than'.tr} ${AppConstants.maxSizeOfASingleFile.floor()} MB" : ""} ",
                            style: rubikRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.error.withOpacity(0.7),
                            ),
                          ),
                      ],
                    ),
                  ),
                ) : const SizedBox(),



                SizedBox(height: Dimensions.paddingSizeSmall),
                Container(color: Theme.of(context).canvasColor,
                  child: Column(children: [
                     MessageSendingSectionWidget(userId: widget.userId)])), //: const SizedBox(),
              ]),
            ),
          ),
        ),
      );
    }
    );
  }
}
