import 'package:file_picker/file_picker.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sixvalley_delivery_boy/data/api/api_client.dart';
import 'package:sixvalley_delivery_boy/interface/repository_interface.dart';

abstract class ChatRepositoryInterface implements RepositoryInterface{
  Future<Response> getConversationList(int offset,String _userTypeIndex);
  Future<Response> searchChatList(String  _userTypeIndex , String searchChat);
  Future<Response> getChatList(int offset,String userType, int? userId);
  Future<Response> sendMessage(String message, int userId,String  userType,List<MultipartBody> files, List<PlatformFile>? platformFile);
  Future<Response> searchConversationList(String name);
}