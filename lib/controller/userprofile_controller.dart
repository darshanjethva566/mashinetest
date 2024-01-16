import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/apimodel.dart';
import '../service/apiservice.dart';

class UserProfile_Controller extends GetxController{
  Rx<TextEditingController> email  = TextEditingController().obs;
  Rx<TextEditingController> fname  = TextEditingController().obs;
  Rx<TextEditingController> lname  = TextEditingController().obs;
  RxBool edit  = false.obs;
  RxList<Data> ulist = <Data>[].obs;
  RxInt selected_user = 0.obs;

  void getuserdata() async{
    final shar =  await SharedPreferences.getInstance();

    final get = await UserService().userService();
    if(get.data!.isNotEmpty){

      selected_user.value = 0 ;
      email.value.text =  get.data![0].email.toString();
      lname.value.text =  get.data![0].lastName.toString();
      fname.value.text =  get.data![0].firstName.toString();
     ulist.value = get.data!;
      List<Map<String, dynamic>> serializedList = ulist.map((data) => data.toJson()).toList();


      String jsonString = json.encode(serializedList);

      shar.setString('employee', jsonString);
    }
  }
  @override
  void onInit() {
    getuserdata();
    // TODO: implement onInit
    super.onInit();
  }
}