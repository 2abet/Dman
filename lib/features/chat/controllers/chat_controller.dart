import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_delivery_boy/data/api/api_checker.dart';
import 'package:sixvalley_delivery_boy/data/api/api_client.dart';
import 'package:sixvalley_delivery_boy/features/auth/domain/models/response_model.dart';
import 'package:sixvalley_delivery_boy/features/chat/domain/models/chat_model.dart';
import 'package:sixvalley_delivery_boy/features/chat/domain/models/message_model.dart';
import 'package:sixvalley_delivery_boy/features/chat/domain/services/chat_service_interface.dart';
import 'package:sixvalley_delivery_boy/helper/date_converter.dart';
import 'package:sixvalley_delivery_boy/helper/image_size_checker.dart';
import 'package:sixvalley_delivery_boy/utill/app_constants.dart';


enum SenderType {
  customer,
  seller,
  admin,
  deliveryMan,
  unknown
}

class ChatController extends GetxController implements GetxService{
  ChatServiceInterface chatServiceInterFace;
  ChatController({required this.chatServiceInterFace});

  List<bool>? _showDate;
  List<XFile>? _imageFiles;
  bool _isSendButtonActive = false;
  final bool _isSeen = false;
  final bool _isSend = true;
  final bool _isMe = false;
  bool _isLoading= false;
  bool _isSending= false;
  bool get isSending=> _isSending;
  List <XFile>?_chatImage = [];
  int? _pageSize;
  int? _offset;
  ChatModel? _conversationModel;
  MessageModel? _messageModel;
  int _userTypeIndex = 0;
  int _apiHitCount = 0;


  bool get isLoading => _isLoading;
  List<bool>? get showDate => _showDate;
  List<XFile>? get imageFiles => _imageFiles;
  bool get isSendButtonActive => _isSendButtonActive;
  bool get isSeen => _isSeen;
  bool get isSend => _isSend;
  bool get isMe => _isMe;
  int? get pageSize => _pageSize;
  int? get offset => _offset;
  List<XFile>? get chatImage => _chatImage;
  ChatModel? get conversationModel => _conversationModel;
  MessageModel? get messageModel => _messageModel;
  int get userTypeIndex =>  _userTypeIndex;


  bool _pickedFIleCrossMaxLimit = false;
  bool get pickedFIleCrossMaxLimit => _pickedFIleCrossMaxLimit;

  bool _pickedFIleCrossMaxLength = false;
  bool get pickedFIleCrossMaxLength => _pickedFIleCrossMaxLength;

  bool _singleFIleCrossMaxLimit = false;
  bool get singleFIleCrossMaxLimit => _singleFIleCrossMaxLimit;

  List<PlatformFile>? objFile;


  List<dynamic> _messageList = [];
  List<dynamic>? get messageList => _messageList;

  List<Message> _allMessageList=[];
  List<Message>? get allMessageList => _allMessageList;

  List<String> _dateList = [];
  List<String>? get dateList => _dateList;

  String _onImageOrFileTimeShowID = '';
  String get onImageOrFileTimeShowID => _onImageOrFileTimeShowID;

  bool _isClickedOnImageOrFile = false;
  bool get isClickedOnImageOrFile => _isClickedOnImageOrFile;

  bool _isClickedOnMessage = false;
  bool get isClickedOnMessage => _isClickedOnMessage;

  String _onMessageTimeShowID = '';
  String get onMessageTimeShowID => _onMessageTimeShowID;



  Future<void> getConversationList(int offset, {bool isUpdate = true}) async{
    _apiHitCount ++;
    if(offset == 1){
      _conversationModel = null;
      if(isUpdate){
        update();
      }
    }
    _isLoading = true;
    Response response = await chatServiceInterFace.getConversationList(offset, _userTypeIndex == 0? 'seller' :_userTypeIndex == 1? 'customer':'admin');
    if(response.statusCode == 200) {
      if(offset == 1) {
        _conversationModel = null;
        _conversationModel = ChatModel.fromJson(response.body);
        print('=====>>${_conversationModel?.chat?.length}<<=====');
      }else {
        _conversationModel!.totalSize = ChatModel.fromJson(response.body).totalSize;
        _conversationModel!.offset = ChatModel.fromJson(response.body).offset;
        _conversationModel!.chat!.addAll(ChatModel.fromJson(response.body).chat!);
      }
    }else {
      ApiChecker.checkApi(response);
    }
    _apiHitCount--;
    _isLoading = false;

    if(_apiHitCount == 0){
      update();
    }
  }

  Future<void> searchConversationList(String searchChat) async{
    _isLoading = true;
    _conversationModel = await chatServiceInterFace.searchChatList(  _userTypeIndex == 0 ? 'seller' : _userTypeIndex == 1 ? 'customer':'admin', searchChat);
    _isLoading = false;
    update();
  }

  Future<void> getChats(int offset, int? userId, {bool firstLoad = false}) async {
    if(firstLoad){
      _isLoading = true;
      _messageModel = null;
      _messageList = [];
      _dateList = [];
      _allMessageList = [];
    }
    Response _response = await chatServiceInterFace.getChatList(offset, userId);
    if (_response.body != {} && _response.statusCode == 200) {
      if(offset == 1 ){
        _messageModel = null;
        _messageList = [];
        _dateList = [];
        _allMessageList = [];
        _messageModel = MessageModel.fromJson(_response.body);

        for (var data in _messageModel!.message!) {
          if(!_dateList.contains(DateConverter.dateStringMonthYear(DateTime.tryParse(data.createdAt!)))) {
            dateList!.add(DateConverter.dateStringMonthYear(DateTime.tryParse(data.createdAt!)));
          }
          _allMessageList.add(data);
        }

        for(int i=0; i< dateList!.length; i++){
          messageList!.add([]);
          for (var element in _allMessageList) {
            if(_dateList[i]== DateConverter.dateStringMonthYear(DateTime.tryParse(element.createdAt!))){
              _messageList[i].add(element);
            }
          }
        }
      }else{
        _messageModel?.message = [];
        _messageModel!.totalSize =  MessageModel.fromJson(_response.body).totalSize;
        _messageModel!.offset =  MessageModel.fromJson(_response.body).offset;
        _messageModel!.message!.addAll(MessageModel.fromJson(_response.body).message!) ;

        for (var data in _messageModel!.message!) {
          if(!_dateList.contains(DateConverter.dateStringMonthYear(DateTime.tryParse(data.createdAt!)))) {
            dateList!.add(DateConverter.dateStringMonthYear(DateTime.tryParse(data.createdAt!)));
          }
          _allMessageList.add(data);
        }

        for(int i=0; i< dateList!.length; i++) {
          messageList!.add([]);
          for (var element in _allMessageList) {
            if(_dateList[i]== DateConverter.dateStringMonthYear(DateTime.tryParse(element.createdAt!))){
              _messageList[i].add(element);
          }}
        }
      }
    } else {
      ApiChecker.checkApi(_response);
    }
    _isLoading = false;
    update();
  }


  void pickImage(bool isRemove) async {
    final ImagePicker _picker = ImagePicker();
    if(isRemove) {
      _imageFiles = [];
      _chatImage = [];
    }else {
      _imageFiles = await _picker.pickMultiImage(imageQuality: 30);
      if (_imageFiles != null) {
        _chatImage = imageFiles;
        _isSendButtonActive = true;
      }
    }
    update();
  }

  void removeImage(int index){
    chatImage!.removeAt(index);
    update();
  }

  void toggleSendButtonActivity() {
    _isSendButtonActive = !_isSendButtonActive;
    update();
  }



  Future<ResponseModel> sendMessage(String message, int userId) async {
    _isSending = true;
    update();
    ResponseModel _response = await chatServiceInterFace.sendMessage(message, userId, files, objFile ?? []);
    if(_response.isSuccess){
      _isSendButtonActive = false;
      getChats(1, userId);
      _pickedImageFiles = [];
      pickedImageFileStored = [];
      files= [];
      objFile = [];
    }else{
      _isSendButtonActive = false;
    }
    _isSending = false;
    update();
    return _response;
  }


  void setUserTypeIndex(int index, {bool isUpdate = true}) {
    _userTypeIndex = index;
    getConversationList(1, isUpdate: isUpdate);
    if(isUpdate) {
      update();
    }
  }

  List <XFile> _pickedImageFiles =[];
  List <XFile>? get pickedImageFile => _pickedImageFiles;
  List <XFile>?  pickedImageFileStored = [];
  List<MultipartBody> files = [];
  void pickMultipleImage(bool isRemove,{int? index}) async {
    _pickedFIleCrossMaxLimit = false;
    _pickedFIleCrossMaxLength = false;
    files = [];
    if(isRemove) {
      if(index != null){
        pickedImageFileStored!.removeAt(index);
      }
    }else {
      _pickedImageFiles = await ImagePicker().pickMultiImage(imageQuality: 40);
      pickedImageFileStored?.addAll(_pickedImageFiles);
      for(int i=0; i< pickedImageFileStored!.length; i++){
        files.add(MultipartBody('image[$i]', pickedImageFileStored![i]));
      }
    }

    if(pickedImageFileStored!.length > AppConstants.maxLimitOfTotalFileSent){
      _pickedFIleCrossMaxLength = true;
    }
    if( _pickedImageFiles.length == AppConstants.maxLimitOfTotalFileSent && await ImageSize.getMultipleImageSizeFromXFile(pickedImageFileStored!) > AppConstants.maxLimitOfFileSentINConversation){
      _pickedFIleCrossMaxLimit = true;
    }
    update();
  }


  Future<void> pickOtherFile(bool isRemove, {int? index}) async {
    _pickedFIleCrossMaxLimit = false;
    _pickedFIleCrossMaxLength = false;
    _singleFIleCrossMaxLimit = false;
    List<String> allowedExtensions = ['doc', 'docx', 'txt', 'csv', 'xls', 'xlsx', 'rar', 'tar', 'targz', 'zip', 'pdf'];
    if(isRemove){
      if(objFile!=null){
        objFile!.removeAt(index!);
      }else if(objFile!.isEmpty){
        _isSendButtonActive = false;
      }
    }else{

      List<PlatformFile>? platformFile = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: true,
        withReadStream: true,
      ))?.files ;

      objFile = [];
      // _pickedImageFiles = [];
      // pickedImageFileStored = [];

      platformFile?.forEach((element) {
        if(ImageSize.getFileSizeFromPlatformFileToDouble(element) > AppConstants.maxSizeOfASingleFile) {
          _singleFIleCrossMaxLimit = true;
        } else{
          if(  objFile!.length < AppConstants.maxLimitOfTotalFileSent){
            if(!allowedExtensions.contains(element.extension)){
              showCustomSnackBarWidget('file_type_should_be'.tr);
            } else if((ImageSize.getMultipleFileSizeFromPlatformFiles(objFile!) + ImageSize.getFileSizeFromPlatformFileToDouble(element)) < AppConstants.maxLimitOfFileSentINConversation){
              objFile!.add(element);
            }
          }
        }
      });

      if(objFile?.length == AppConstants.maxLimitOfTotalFileSent && platformFile != null &&   platformFile.length > AppConstants.maxLimitOfTotalFileSent){
        _pickedFIleCrossMaxLength = true;
      }
      if(objFile?.length == AppConstants.maxLimitOfTotalFileSent && platformFile != null && ImageSize.getMultipleFileSizeFromPlatformFiles(platformFile) > AppConstants.maxLimitOfFileSentINConversation){
        _pickedFIleCrossMaxLimit = true;
      }
      _isSendButtonActive = true;
    }
    update();
  }


  bool isSameUserWithPreviousMessage(Message? previousConversation, Message currentConversation){
    if(getSenderType(previousConversation) == getSenderType(currentConversation) && previousConversation?.message != null && currentConversation.message !=null){
      return true;
    }
    return false;
  }
  bool isSameUserWithNextMessage( Message currentConversation, Message? nextConversation){
    if(getSenderType(currentConversation) == getSenderType(nextConversation) && nextConversation?.message != null && currentConversation.message !=null){
      return true;
    }
    return false;
  }

  SenderType getSenderType(Message? senderData) {
    if (senderData?.sentByCustomer == true) {
      return SenderType.customer;
    } else if (senderData?.sentBySeller == true) {
      return SenderType.seller;
    } else {
      return SenderType.unknown;
    }
  }


  String getChatTimeWithPrevious (Message currentChat, Message? previousChat) {
    DateTime todayConversationDateTime = DateConverter
        .isoUtcStringToLocalTimeOnly(currentChat.createdAt ?? "");

    DateTime previousConversationDateTime;

    if (previousChat?.createdAt == null) {
      return 'Not-Same';
    } else {
      previousConversationDateTime =
          DateConverter.isoUtcStringToLocalTimeOnly(previousChat!.createdAt!);
      if (kDebugMode) {
        print("The Difference is ${previousConversationDateTime.difference(todayConversationDateTime) < const Duration(minutes: 30)}");
      }
      if (previousConversationDateTime.difference(todayConversationDateTime) <
          const Duration(minutes: 30) &&
          todayConversationDateTime.weekday ==
              previousConversationDateTime.weekday && isSameUserWithPreviousMessage(currentChat, previousChat)) {
        return '';
      } else {
        return 'Not-Same';
      }
    }
  }


  String getChatTime (String todayChatTimeInUtc , String? nextChatTimeInUtc) {
    String chatTime = '';
    DateTime todayConversationDateTime = DateConverter.isoUtcStringToLocalTimeOnly(todayChatTimeInUtc);

    DateTime nextConversationDateTime;
    DateTime currentDate = DateTime.now();

    if(nextChatTimeInUtc == null){
      String chatTime = DateConverter.isoStringToLocalDateAndTime(todayChatTimeInUtc);
      return chatTime;
    }else{
      nextConversationDateTime = DateConverter.isoUtcStringToLocalTimeOnly(nextChatTimeInUtc);
      if(todayConversationDateTime.difference(nextConversationDateTime) < const Duration(minutes: 30) &&
          todayConversationDateTime.weekday == nextConversationDateTime.weekday){
        chatTime = '';
      }else if(currentDate.weekday != todayConversationDateTime.weekday
          && DateConverter.countDays(todayConversationDateTime) < 6){

        if( (currentDate.weekday -1 == 0 ? 7 : currentDate.weekday -1) == todayConversationDateTime.weekday){
          chatTime = DateConverter.convert24HourTimeTo12HourTimeWithDay(todayConversationDateTime, false);
        }else{
          chatTime = DateConverter.convertStringTimeToDate(todayConversationDateTime).toString();
        }
      }else if(currentDate.weekday == todayConversationDateTime.weekday
          && DateConverter.countDays(todayConversationDateTime) < 6){
        chatTime = DateConverter.convert24HourTimeTo12HourTimeWithDay(todayConversationDateTime, true);
      }else{
        chatTime = DateConverter.isoStringToLocalDateAndTime(todayChatTimeInUtc);
      }
    }

    return chatTime;
  }


  void downloadFile(String url, String dir, String openFileUrl, String fileName) async {

    var snackBar = const SnackBar(content: Text('Downloading....'),backgroundColor: Colors.black54, duration: Duration(seconds: 1),);
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);

    final task  = await FlutterDownloader.enqueue(
      url: url,
      savedDir: dir,
      fileName: fileName,
      showNotification: true,
      saveInPublicStorage: true,
      openFileFromNotification: true,
    );

    if(task !=null){
      await OpenFile.open(openFileUrl);
    }
  }

  void toggleOnClickMessage ({required String onMessageTimeShowID}) {
    _onImageOrFileTimeShowID = '';
    _isClickedOnImageOrFile = false;
    if(_isClickedOnMessage && _onMessageTimeShowID != onMessageTimeShowID){
      _onMessageTimeShowID = onMessageTimeShowID;
    }else if(_isClickedOnMessage && _onMessageTimeShowID == onMessageTimeShowID){
      _isClickedOnMessage = false;
      _onMessageTimeShowID = '';
    }else{
      _isClickedOnMessage = true;
      _onMessageTimeShowID = onMessageTimeShowID;
    }
    update();
  }


  String? getOnPressChatTime(Message currentConversation){
    if(currentConversation.id.toString() == _onMessageTimeShowID || currentConversation.id.toString() == _onImageOrFileTimeShowID){
      DateTime currentDate = DateTime.now();
      DateTime todayConversationDateTime = DateConverter.isoUtcStringToLocalTimeOnly(
          currentConversation.createdAt ?? ""
      );

      if(currentDate.weekday != todayConversationDateTime.weekday
          && DateConverter.countDays(todayConversationDateTime) <= 7){
        return DateConverter.convertStringTimeToDateChatting(todayConversationDateTime);
      }else if(currentDate.weekday == todayConversationDateTime.weekday
          && DateConverter.countDays(todayConversationDateTime) <= 7){
        return  DateConverter.convert24HourTimeTo12HourTime(todayConversationDateTime);
      }else{
        return DateConverter.isoStringToLocalDateAndTime(currentConversation.createdAt!);
      }
    }else{
      return null;
    }
  }


}