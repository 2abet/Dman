import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixvalley_delivery_boy/features/chat/controllers/chat_controller.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';

class ImageSectionForSendingMessageWidget extends StatelessWidget {
  const ImageSectionForSendingMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      builder: (chatController) {
        return SizedBox(height: 100,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: chatController.chatImage!.length,
              itemBuilder: (BuildContext context, index){
                return  chatController.chatImage!.isNotEmpty ?
                Padding(padding: const EdgeInsets.all(8.0),
                  child: Stack(children: [

                    Container(width: 100, height: 100,
                      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: ClipRRect(
                        borderRadius:  BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault)),
                        child:  Image.file(File(chatController.chatImage![index].path), width: 100, height: 100, fit: BoxFit.cover))),

                    Positioned(top:0, right:0,
                      child: InkWell(onTap : () => chatController.removeImage(index),
                        child: Container(decoration:  BoxDecoration(color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault))),
                          child: const Padding(padding: EdgeInsets.all(4.0),
                            child: Icon(Icons.clear, color: Colors.red, size: 15)))),
                    )]),
                ) : const SizedBox();
              }),
        );
      }
    );
  }
}
