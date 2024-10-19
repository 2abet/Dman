import 'package:flutter/material.dart';
import 'package:sixvalley_delivery_boy/features/chat/controllers/chat_controller.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/paginated_list_view_widget.dart';
import 'package:sixvalley_delivery_boy/features/chat/widgets/message_bubble_widget.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';
import 'package:sixvalley_delivery_boy/utill/styles.dart';

class MessageListViewWidget extends StatelessWidget {
  final ChatController chatController;
  final ScrollController scrollController;
  final int? userId;
  const MessageListViewWidget({Key? key, required this.chatController, required this.scrollController, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      reverse: true,
      child: PaginatedListViewWidget(
        reverse: true,
        scrollController: scrollController,
        totalSize: chatController.messageModel?.totalSize,
        offset: chatController.messageModel != null ? int.parse(chatController.messageModel!.offset!) : 1,
        onPaginate: (int? offset) async => await chatController.getChats(offset!, userId),

        itemView: ListView.builder(
          itemCount: chatController.dateList?.length,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          reverse: true,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeSmall),
                  child: Text(chatController.dateList![index].toString(),
                    style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.5)),
                      textDirection: TextDirection.ltr)),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: chatController.messageList![index].length,
                  itemBuilder: (context, subIndex) {
                    return MessageBubbleWidget(
                      message: chatController.messageList![index][subIndex],
                      previous: (subIndex !=0) ? chatController.messageList![index][subIndex-1] : null,
                      next: subIndex == (chatController.messageList![index].length -1) ?  null : chatController.messageList![index][subIndex+1],
                    );
                }),
              ],
            );
          }

        ),
      ),
    );
  }
}
