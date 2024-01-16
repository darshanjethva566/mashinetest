import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mashintest/model/apimodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/userprofile_controller.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final key =  GlobalKey<FormState>();
  final userdata = Get.put(UserProfile_Controller());
  changeDetails(index){
    userdata.email.value.text =  userdata.ulist.value[index].email.toString();
    userdata.fname.value.text =  userdata.ulist.value[index].firstName.toString();
    userdata.lname.value.text =  userdata.ulist.value[index].lastName.toString();
    userdata.edit.value = false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('User Profile',style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(onPressed: () async{
            userdata.ulist.value.clear();
            final get =  await SharedPreferences.getInstance();
            var lst =  await get.getString('employee');
            if (lst != null) {
              // Convert the JSON string to a List<Map<String, dynamic>>
              List<Map<String, dynamic>> serializedList = List<Map<String, dynamic>>.from(json.decode(lst));

              // Convert the List<Map<String, dynamic>> to a List<Data>
              List<Data> yourList = serializedList.map((map) => Data.fromJson(map)).toList();
              userdata.ulist.value = yourList;
              userdata.selected_user.value = 0;
              changeDetails(0);

            }
            else{
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("no data in table !")));

            }
          //  userdata.getuserdata();
          }, icon: Icon(Icons.refresh_outlined,color: Colors.white,))
        ],
      ),
      body:Obx(() =>userdata.ulist.value.isEmpty?Center(child:Text("No user available",style: TextStyle(color: Colors.white)),):  ListView(
        children: [
          Container(
            height: 52.h,
            width: 1.sw,
            child: ListView.builder(itemCount: userdata.ulist.length,scrollDirection: Axis.horizontal,itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(index ==  userdata.selected_user.value ?Colors.purple:Colors.white),shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                    onPressed: () {
                      changeDetails(index);

                      userdata.selected_user.value =  index;
                    }, child: Text("Employee ${ userdata.ulist[index].id}",style: TextStyle(color: index ==  userdata.selected_user.value ?Colors.white:Colors.purple),)),
              );
            },),
          ),
          Form(
            key: key,
            child: Card(
              color: Colors.grey[900],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(radius: 50.r,backgroundImage: NetworkImage(userdata.ulist.value[userdata.selected_user.value].avatar!),),
                    Row(
                      children: [
                        IconButton(onPressed: () {
                          userdata.edit.value = true;
                        }, icon: Icon(Icons.edit,size: 25,color: Colors.white,)),
                        IconButton(onPressed: () {
                          if(userdata.ulist.value.length==userdata.selected_user.value+1){

                            userdata.ulist.removeAt(userdata.selected_user.value);
                            userdata.selected_user = userdata.selected_user -1;
                            changeDetails(userdata.selected_user.value);

                          }
                          else {
                            userdata.ulist.removeAt(userdata.selected_user.value);
                            changeDetails(userdata.selected_user.value);

                          }
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User Delete Successfully !")));

                        }, icon: Icon(Icons.delete,size: 25,color: Colors.red,))
                      ],
                    ),
                    Row(
                      children: [
                        Text("First name  :  ",style: TextStyle(color: Colors.white,fontSize: 16)),
                        SizedBox(
                          width: 200.w,
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),

                            keyboardType: TextInputType.name,
                            enabled: userdata.edit.value,
                            controller: userdata.fname.value,
                            validator: (value) {
                              if(value!.isEmpty){
                                return 'Please enter your first name';
                              }

                            },
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text("Last name  :  ",style: TextStyle(color: Colors.white,fontSize: 16)),
                        SizedBox(
                          width: 200.w,
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),

                            keyboardType: TextInputType.name,
                            enabled: userdata.edit.value,
                            controller: userdata.lname.value,
                            validator: (value) {
                              if(value!.isEmpty){
                                return 'Please enter your last name';
                              }

                            },
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text("Email          :  ",style: TextStyle(color: Colors.white,fontSize: 16)),
                        SizedBox(
                          width: 200.w,
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            keyboardType: TextInputType.name,
                            enabled: userdata.edit.value,
                            controller: userdata.email.value,
                            validator: (value) {
                              if(value!.isEmpty){
                                return 'Please enter your email';
                              }

                            },
                          ),
                        )
                      ],
                    ),


                  ],
                ),
              ),
            ),
          ),
          if(userdata.edit.value)  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              ElevatedButton(onPressed: () {
                userdata.edit.value = false;
                userdata.email.value.text = userdata.ulist.value[userdata.selected_user.value].email.toString();
                userdata.fname.value.text = userdata.ulist.value[userdata.selected_user.value].firstName.toString();
                userdata.lname.value.text = userdata.ulist.value[userdata.selected_user.value].lastName.toString();

              }, child: Text("Cancel")),
              SizedBox(width: 10.w,),
              ElevatedButton(onPressed: () {
                if(key.currentState!.validate()){
                  userdata.ulist.value[userdata.selected_user.value].email = userdata.email.value.text;
                  userdata.ulist.value[userdata.selected_user.value].firstName = userdata.fname.value.text;
                  userdata.ulist.value[userdata.selected_user.value].lastName = userdata.lname.value.text;
                  userdata.edit.value = false;

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Saved successfully !")));
                }

              }, child: Text("Save")),
            ],),
          )
        ],
      ),)
    );
  }


}
