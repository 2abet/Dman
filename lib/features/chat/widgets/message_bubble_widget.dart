import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/image_diaglog_widget.dart';
import 'package:sixvalley_delivery_boy/features/chat/controllers/chat_controller.dart';
import 'package:sixvalley_delivery_boy/common/controllers/localization_controller.dart';
import 'package:sixvalley_delivery_boy/features/chat/widgets/chatting_multi_image_slider.dart';
import 'package:sixvalley_delivery_boy/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_delivery_boy/features/chat/domain/models/message_model.dart';
import 'package:sixvalley_delivery_boy/utill/app_constants.dart';
import 'package:sixvalley_delivery_boy/utill/color_resources.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';
import 'package:sixvalley_delivery_boy/utill/images.dart';
import 'package:sixvalley_delivery_boy/utill/styles.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/custom_image_widget.dart';


class MessageBubbleWidget extends StatelessWidget {
  final Message message;
  final Message? previous;
  final Message? next;
  const MessageBubbleWidget({Key? key, required this.message, this.previous, this.next}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMe = message.sentByDeliveryMan!;
    String basUrl =  Get.find<ChatController>().userTypeIndex == 0 ?
    Get.find<SplashController>().baseUrls?.shopImageUrl ?? '':
    Get.find<SplashController>().baseUrls?.customerImageUrl ?? '';

    String image = Get.find<ChatController>().userTypeIndex == 0 ? message.sellerInfo != null ?
    message.sellerInfo?.shops![0].imageFullUrl?.path ?? '' : '' : Get.find<ChatController>().userTypeIndex == 1 ?
    message.customer?.imageFullUrl?.path ?? '' : Get.find<SplashController>().configModel?.companyFavIcon?.path ?? '';

    String? name = Get.find<ChatController>().userTypeIndex == 0 ? message.sellerInfo != null ?
    message.sellerInfo!.shops![0].name : 'Shop not found' : Get.find<ChatController>().userTypeIndex == 1 ?
    '${message.customer?.fName} ${message.customer?.lName}' : AppConstants.companyName;


    bool _isReply = message.sentByCustomer! || message.sentBySeller! || message.sentByAdmin!;




    return
      //(_isReply) ?
    GetBuilder<ChatController>(
        builder: (chatController) {
          List<Attachment> images = [];
          List<Attachment> files = [];

          String chatTime  = chatController.getChatTime(message.createdAt!, message.createdAt);
          bool isSameUserWithPreviousMessage = chatController.isSameUserWithPreviousMessage(previous, message);
          bool isSameUserWithNextMessage = chatController.isSameUserWithNextMessage(message, next);
          bool isLTR = Get.find<LocalizationController>().isLtr;
          String previousMessageHasChatTime = previous != null ? chatController.getChatTime(previous!.createdAt!, message.createdAt) : "";

          // String previousMessageHasChatTime = "";

          if(message.attachment != null) {
            for(Attachment attachment in message.attachment!){
              if(attachment.type == 'image'){
                images.add(attachment);
              }else if (attachment.type == 'file') {
                files.add(attachment);
              }
            }
          }

        return Column(crossAxisAlignment: isMe ? CrossAxisAlignment.end:CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start, children: [

              ((!isMe && !isSameUserWithPreviousMessage) ||  (!isMe && isSameUserWithPreviousMessage)) &&
                chatController.getChatTimeWithPrevious(message, previous).isNotEmpty ?
                Padding(
                  padding: EdgeInsets.only(bottom: 3, left: isLTR ? 5 : 0,  right: isLTR ? 0 : 10),
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0),
                      color: Theme.of(context).highlightColor,
                      border: Border.all(color: Theme.of(context).primaryColor)),
                    child: ClipRRect(child: CustomImageWidget(fit: BoxFit.cover, width: Dimensions.paddingSizeExtraLarge + 5, height: Dimensions.paddingSizeExtraLarge + 5,
                      image: Get.find<ChatController>().userTypeIndex == 3 ? image : image),
                      borderRadius: BorderRadius.circular(20.0)),
                  ),
                ) : !isMe ? SizedBox(width: Dimensions.paddingSizeExtraLarge + 10) : const SizedBox(),


                Flexible(child: Column(crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
                  if(message.message != null && message.message!.isNotEmpty)
                    InkWell(
                      onTap: (){
                        chatController.toggleOnClickMessage(onMessageTimeShowID :
                        message.id.toString());
                      },
                      child: Container(
                        margin: isMe ?  const EdgeInsets.fromLTRB(70, 2, 10, 2) : const EdgeInsets.fromLTRB(10, 2, 10, 2),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: isMe && (isSameUserWithNextMessage || isSameUserWithPreviousMessage) ? BorderRadius.only(
                              topRight: Radius.circular(isSameUserWithNextMessage && isLTR && chatTime =="" ? Dimensions.radiusSmall : Dimensions.radiusExtraLarge + 5),
                              bottomRight: Radius.circular(isSameUserWithPreviousMessage && isLTR && previousMessageHasChatTime =="" ? Dimensions.radiusSmall : Dimensions.radiusExtraLarge + 5),
                              topLeft: Radius.circular(isSameUserWithNextMessage && !isLTR && chatTime ==""? Dimensions.radiusSmall : Dimensions.radiusExtraLarge + 5),
                              bottomLeft: Radius.circular(isSameUserWithPreviousMessage && !isLTR && previousMessageHasChatTime ==""? Dimensions.radiusSmall :Dimensions.radiusExtraLarge + 5),

                            ) : !isMe && (isSameUserWithNextMessage || isSameUserWithPreviousMessage) ? BorderRadius.only(
                              topLeft: Radius.circular(isSameUserWithNextMessage && isLTR && chatTime ==""? Dimensions.radiusSmall : Dimensions.radiusExtraLarge + 5),
                              bottomLeft: Radius.circular( isSameUserWithPreviousMessage && isLTR && previousMessageHasChatTime =="" ? Dimensions.radiusSmall : Dimensions.radiusExtraLarge + 5),
                              topRight: Radius.circular(isSameUserWithNextMessage && !isLTR && chatTime ==""? Dimensions.radiusSmall : Dimensions.radiusExtraLarge + 5),
                              bottomRight: Radius.circular(isSameUserWithPreviousMessage && !isLTR && previousMessageHasChatTime ==""? Dimensions.radiusSmall :Dimensions.radiusExtraLarge + 5),
                            ) : BorderRadius.circular(Dimensions.radiusExtraLarge + 5),

                            color: isMe ? Theme.of(context).hintColor.withOpacity(.125) : ColorResources.getPrimary(context).withOpacity(.10)),

                        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          (message.message != null && message.message!.isNotEmpty) ? Text(message.message!,
                              style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
                                  color: isMe ? ColorResources.getTextColor(context): ColorResources.getTextColor(context))
                          ) : const SizedBox.shrink(),
                        ]),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      child: AnimatedContainer(
                        curve: Curves.fastOutSlowIn,
                        duration: const Duration(milliseconds: 500),
                        height: chatController.onMessageTimeShowID == message.id.toString() ? 25.0 : 0.0,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: chatController.onMessageTimeShowID == message.id.toString() ?
                            Dimensions.paddingSizeExtraSmall : 0.0,
                          ),
                          child: Text(chatController.getOnPressChatTime(message) ?? "", style: rubikRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall
                          ),),
                        ),
                      ),
                    ),
                ]))
              ]),


          if(images.isNotEmpty)  SizedBox(height: Dimensions.paddingSizeSmall),
          images.isNotEmpty?
          Directionality(textDirection : Get.find<LocalizationController>().isLtr ? isMe ?
          TextDirection.rtl : TextDirection.ltr : isMe ? TextDirection.ltr : TextDirection.rtl,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: Dimensions.paddingSizeSmall,
                  left: isLTR ? 40 : 0,
                  right: isLTR ? Dimensions.paddingSizeDefault : 0,
                ),
                child: SizedBox(width: MediaQuery.of(context).size.width/2,
                  child: Stack(children: [
                    GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1, crossAxisCount: 2,
                            mainAxisSpacing: Dimensions.paddingSizeSmall, crossAxisSpacing: Dimensions.paddingSizeSmall),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: images.length> 4? 4: images.length,
                        itemBuilder: (BuildContext context, index) {
                          return  InkWell(onTap: () {
                            if(images.length == 1){
                              showDialog(context: context, builder: (ctx)  =>  ImageDialog(
                                  imageUrl: images[index].path ?? ''));
                            }else{
                              showDialog(context: context, builder: (ctx)  =>  ChattingMultiImageSlider(
                                  images: images));
                            }
                          },
                            child: ClipRRect(borderRadius: BorderRadius.circular(5),
                                child:CustomImageWidget(height: 200, width: 200, fit: BoxFit.cover,
                                    image: images[index].path ?? '')),);

                        }),

                    if(images.length> 4)
                      Positioned(bottom: 0, right: 0,
                        child: InkWell(onTap: () => showDialog(context: context, builder: (ctx)  =>  ChattingMultiImageSlider(
                            images: images)),
                          child: ClipRRect(borderRadius: BorderRadius.circular(5),
                              child:Container(width: MediaQuery.of(context).size.width/4.2, height: MediaQuery.of(context).size.width/4.2,
                                decoration: BoxDecoration(
                                    color: Colors.black54.withOpacity(.75), borderRadius: BorderRadius.circular(10)
                                ),child: Center(child: Text("+${images.length-3}", style: rubikRegular.copyWith(color: Colors.white),)),)),),
                      ),

                  ],
                  ),


                ),
              )) : const SizedBox.shrink(),









          files.isNotEmpty ?
          Column(crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
            files.isNotEmpty ?
            Padding(
              padding: EdgeInsets.only(
                bottom: Dimensions.paddingSizeSmall,
                left: isLTR ? 0 : Dimensions.paddingSizeDefault,
                right: isLTR ? Dimensions.paddingSizeDefault : 0,
              ),
              child: Directionality(
                textDirection: isMe  && isLTR?
                TextDirection.rtl : !isLTR && !isMe?
                TextDirection.rtl : TextDirection.ltr,

                child: Padding(
                  padding: EdgeInsets.only(left: !isMe ? 20 : 0, right: !isMe ? 30 : 0),
                  child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: files.length,
                      padding: files.isNotEmpty ? EdgeInsets.only(top: Dimensions.paddingSizeSmall) : EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: 60,
                          crossAxisCount: 2,
                          mainAxisSpacing: Dimensions.paddingSizeExtraSmall,
                          crossAxisSpacing: Dimensions.paddingSizeExtraSmall
                      ),
                      itemBuilder: (context, index){

                        return InkWell(
                          onTap: ()async{
                            final status = await Permission.notification.request();
                            if (kDebugMode) {
                              print("Status is $status");
                            }
                            if(status.isGranted){
                              Directory? directory = Directory('/storage/emulated/0/Download');
                              if (!await directory.exists()){
                                directory = Platform.isAndroid
                                    ? await getExternalStorageDirectory() //FOR ANDROID
                                    : await getApplicationSupportDirectory();
                              }
                              chatController.downloadFile(
                                  files[index].path!, directory!.path,
                                  "${directory.path}/${files[index].key}", ""
                                  "${files[index].key}"
                              );
                            }else if(status.isDenied){
                              await openAppSettings();
                            }
                          },
                          onLongPress: () {
                            // conversationController.toggleOnClickImageAndFile(
                            //     onImageOrFileTimeShowID : widget.conversationData.id!);
                          },
                          child: Container(width: 180, height: 60,
                              decoration: BoxDecoration(color: Theme.of(context).hintColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),),
                              child: Padding(padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Row(children: [
                                      const Image(image: AssetImage(Images.fileIcon),
                                        height: 30,
                                        width: 30,
                                      ),
                                      SizedBox(width: Dimensions.paddingSizeExtraSmall),


                                      Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start, children: [


                                            Text(files[index].key.toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: rubikBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                                            ),


                                            Text("${files[index].size}", style: rubikRegular.copyWith(
                                                fontSize: Dimensions.fontSizeDefault,
                                                color: Theme.of(context).hintColor)
                                            ),
                                          ]),
                                      )],

                                    ),
                                  )
                              )
                          ),
                        );
                      }
                  ),
                ),
              ),
            )
                : const SizedBox(),

            // AnimatedContainer(
            //   curve: Curves.fastOutSlowIn,
            //   duration: const Duration(milliseconds: 500),
            //   height: conversationController.onImageOrFileTimeShowID == widget.conversationData.id ? 25.0 : 0.0,
            //   child: Padding(
            //     padding: EdgeInsets.only(
            //       top: conversationController.onImageOrFileTimeShowID == widget.conversationData.id ?
            //       Dimensions.paddingSizeExtraSmall : 0.0,
            //     ),
            //     child: Text(conversationController.getOnPressChatTime(widget.conversationData) ?? "", style: ubuntuRegular.copyWith(
            //         fontSize: Dimensions.fontSizeSmall
            //     ),),
            //   ),
            // ),

          ]) :const SizedBox.shrink(),




        ]);
      }
    );



    // : Container(padding:  EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeLarge),
    //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
    //   child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
    //     Text("${Get.find<ProfileController>().profileModel?.fName ?? ''} ${Get.find<ProfileController>().profileModel?.lName ?? ""}",
    //         style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
    //      SizedBox(height: Dimensions.paddingSizeSmall),
    //     Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
    //       Flexible(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
    //           (message.message != null && message.message!.isNotEmpty) ? Flexible(
    //             child: Container(decoration: BoxDecoration(
    //                 color: Theme.of(context).primaryColor.withOpacity(0.5),
    //                 borderRadius:  BorderRadius.only(topLeft: Radius.circular(Dimensions.paddingSizeSmall),
    //                   bottomRight: Radius.circular(Dimensions.paddingSizeSmall),
    //                   bottomLeft: Radius.circular(Dimensions.paddingSizeSmall))),
    //               child: Container(padding: EdgeInsets.all(message.message != null ? Dimensions.paddingSizeDefault : 0),
    //                 child: Text(message.message ?? '')))) : const SizedBox()])),
    //        SizedBox(width: Dimensions.paddingSizeSmall),
    //
    //
    //       ClipRRect(borderRadius: BorderRadius.circular(20.0),
    //         child: CustomImageWidget(fit: BoxFit.cover, width: 40, height: 40,
    //           image: '${Get.find<SplashController>().baseUrls!.deliverymanImageUrl}/${Get.find<ProfileController>().profileModel!.image}'))]),
    //      SizedBox(height: Dimensions.paddingSizeSmall),
    //
    //     Text(DateConverter.localDateToIsoStringAMPM(DateTime.parse(message.createdAt!)),
    //       style: rubikRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)),
    //      SizedBox(height: Dimensions.paddingSizeDefault),
    //     if(message.attachment!.isNotEmpty)  SizedBox(height: Dimensions.paddingSizeSmall),
    //
    //
    //     message.attachment!.isNotEmpty ?
    //     Directionality(textDirection:Get.find<LocalizationController>().isLtr ?  TextDirection.rtl :  TextDirection.ltr,
    //       child: GridView.builder(gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
    //           childAspectRatio: 1, crossAxisCount: 3,
    //           mainAxisSpacing: Dimensions.paddingSizeSmall, crossAxisSpacing: Dimensions.paddingSizeSmall),
    //         shrinkWrap: true,
    //         physics: const NeverScrollableScrollPhysics(),
    //         itemCount: message.attachment!.length,
    //         itemBuilder: (BuildContext context, index) {
    //
    //
    //           return  InkWell(onTap: () => showDialog(context: context, builder: (ctx)  =>  ImageDialogWidget(
    //               imageUrl: '${AppConstants.baseUri}/storage/app/public/chatting/${message.attachment![index]}')),
    //             child: ClipRRect(borderRadius: BorderRadius.circular(5),
    //                 child:CustomImageWidget(height: 100, width: 100, fit: BoxFit.cover,
    //                     image: '${AppConstants.baseUri}/storage/app/public/chatting/${message.attachment![index]}')),);
    //         },),
    //     ):
    //     const SizedBox.shrink(),
    //
    //   ]),
    // );
  }
}
