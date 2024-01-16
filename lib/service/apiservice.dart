import 'package:dio/dio.dart';
import 'package:mashintest/model/apimodel.dart';

import '../apiurls/apiurl.dart';


class UserService{
  Dio dio = Dio();

  Future<UserModel> userService()async{

    final respo = await dio.get("${Apiurls.userlist}");
    print("userData: ${respo.data}");
    if(respo.statusCode==200){

      return UserModel.fromJson(respo.data);
    }
    else{
      throw "Something went wrong";
    }
  }



}
