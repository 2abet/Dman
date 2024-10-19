import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sixvalley_delivery_boy/features/chat/controllers/chat_controller.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';
import 'package:sixvalley_delivery_boy/utill/images.dart';
import 'package:sixvalley_delivery_boy/utill/styles.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/custom_snackbar_widget.dart';
import 'package:flutter/foundation.dart' as foundation;


class MessageSendingSectionWidget extends StatefulWidget {
  final int? userId;
  const MessageSendingSectionWidget({Key? key, required this.userId}) : super(key: key);

  @override
  State<MessageSendingSectionWidget> createState() => _MessageSendingSectionWidgetState();
}

class _MessageSendingSectionWidgetState extends State<MessageSendingSectionWidget> {
  final TextEditingController _inputMessageController = TextEditingController();
  bool emojiPicker = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      builder: (chatController) {
        return ColoredBox(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Column(
            children: [
              Padding(padding:  EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Row(children: [
                Expanded(child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor,width: 1),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: TextField(
                    inputFormatters: [LengthLimitingTextInputFormatter(Dimensions.messageInputLength)],
                    controller: _inputMessageController,
                    onTap: (){
                      setState(() {
                        emojiPicker = false;
                      });
                    },
                    textCapitalization: TextCapitalization.sentences,
                    style: rubikRegular,
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    minLines: 1,
                    decoration: InputDecoration(
                    prefixIcon: GestureDetector(onTap: (){
                      setState(() {
                        emojiPicker = !emojiPicker;
                        FocusManager.instance.primaryFocus?.unfocus();
                      });
                    },
                      child: Padding(padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Image.asset(Images.emoji, height: 30, width: 30 )),
                    ),

                    suffixIcon : Row(mainAxisSize: MainAxisSize.min, children: [
                        InkWell(onTap: ()=>  chatController.pickOtherFile(false),
                          child: Padding(padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                            child: SizedBox(width: 30, child: Image.asset(Images.file)))),

                        InkWell(onTap: ()=>  chatController.pickMultipleImage(false),
                          child: Padding(padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                            child: SizedBox(width: 30, child: Image.asset(Images.attachment, color: Theme.of(context).primaryColor)))),
                      ],
                    ),



                    border: InputBorder.none,
                    hintText: 'type_here'.tr,
                    hintStyle: rubikRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeLarge)),
                    onSubmitted: (String newText) {
                      if(newText.trim().isNotEmpty && !Get.find<ChatController>().isSendButtonActive) {
                      Get.find<ChatController>().toggleSendButtonActivity();
                      }else if(newText.isEmpty && Get.find<ChatController>().isSendButtonActive) {
                      Get.find<ChatController>().toggleSendButtonActivity();
                  }
                },
                onChanged: (String newText) {
                  if(newText.trim().isNotEmpty && !Get.find<ChatController>().isSendButtonActive) {
                    Get.find<ChatController>().toggleSendButtonActivity();
                  }else if(newText.isEmpty && Get.find<ChatController>().isSendButtonActive) {
                    Get.find<ChatController>().toggleSendButtonActivity();
                  }
                }),
              )),

                SizedBox(width: Dimensions.paddingSizeSmall),


              GetBuilder<ChatController>(builder: (chatController) {
                return InkWell(onTap: () async {
                  if(chatController.isSendButtonActive || chatController.pickedImageFileStored!.isNotEmpty || _inputMessageController.text.isNotEmpty) {
                     await chatController.sendMessage(
                      _inputMessageController.text, widget.userId!).then((value) {
                      if(value.isSuccess){
                        Future.delayed(const Duration(seconds: 2),() {
                          chatController.getChats(1, widget.userId);
                        });
                      }
                  });
                  _inputMessageController.clear();
                  }else{
                    showCustomSnackBarWidget('write_somethings'.tr);
                  }
                },
                  child: Container(
                    padding:  EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                      border: Border.all(color: Theme.of(context).hintColor, width: 2)
                    ),
                    child: chatController.isSending ? const SizedBox(width: 25, height: 25,
                    child: CircularProgressIndicator()) :
                    Image.asset(Images.send, width: 25, height: 25,
                    color: chatController.isSendButtonActive ?Get.isDarkMode? Theme.of(context).hintColor.withOpacity(.5) :
                    Theme.of(context).primaryColor : Theme.of(context).hintColor)));
              })]),
              ),


              if(emojiPicker)
                SizedBox(height: 250,
                  child: EmojiPicker(
                    onBackspacePressed: () {
                    },
                    textEditingController: _inputMessageController,
                    config: Config(
                      height: 256,
                      checkPlatformCompatibility: true,
                      emojiViewConfig: EmojiViewConfig(
                        // Issue: https://github.com/flutter/flutter/issues/28894
                        emojiSizeMax: 28 *
                            (foundation.defaultTargetPlatform ==
                                TargetPlatform.iOS
                                ? 1.2
                                : 1.0),
                      ),
                      swapCategoryAndBottomBar: false,
                      skinToneConfig: const SkinToneConfig(),
                      categoryViewConfig: const CategoryViewConfig(),
                      bottomActionBarConfig: const BottomActionBarConfig(),
                      searchViewConfig: const SearchViewConfig(),

                      // columns: 7,
                      // emojiSizeMax: 32 * (foundation.defaultTargetPlatform == TargetPlatform.iOS ? 1.30 : 1.0),
                      // verticalSpacing: 0,
                      // horizontalSpacing: 0,
                      // gridPadding: EdgeInsets.zero,
                      // initCategory: Category.RECENT,
                      // bgColor: const Color(0xFFF2F2F2),
                      // indicatorColor: Colors.blue,
                      // iconColor: Colors.grey,
                      // iconColorSelected: Colors.blue,
                      // backspaceColor: Colors.blue,
                      // skinToneDialogBgColor: Colors.white,
                      // skinToneIndicatorColor: Colors.grey,
                      // enableSkinTones: true,
                      // recentTabBehavior: RecentTabBehavior.RECENT,
                      // recentsLimit: 28,
                      // noRecents: const Text('No Recents', style: TextStyle(fontSize: 20, color: Colors.black26),
                      //   textAlign: TextAlign.center,),
                      // loadingIndicator: const SizedBox.shrink(),
                      // tabIndicatorAnimDuration: kTabScrollDuration,
                      // categoryIcons: const CategoryIcons(),
                      // buttonMode: ButtonMode.MATERIAL,
                    ),
                  ),
                ),


            ],
          ),
        );



      }
    );
  }
}
