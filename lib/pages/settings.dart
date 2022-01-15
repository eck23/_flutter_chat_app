import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:me_chat/auth/authmethods.dart';

class SettingsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
     return SafeArea(child: 
          Scaffold(
            
            appBar: AppBar(
              title: const Text("Settings"),
              backgroundColor: Colors.black,),
          body: ListView(children: [
            ListTile(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_)=>SettingNextPage())),
              leading: const Icon(Icons.perm_identity_sharp),
              title: Text("Change Display Name",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.bold),),
              ),
            Divider(height: 2.h,color: Colors.black,),

            ],) ,)
          );
  }
  
}

class SettingNextPage extends StatefulWidget{
  @override
  State<SettingNextPage> createState() => _SettingNextPageState();
}

class _SettingNextPageState extends State<SettingNextPage> {
  var validatename="";
  final key = GlobalKey<FormState>(); 
  TextEditingController namecontrol=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{namecontrol.clear();return true;},
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(title: Text("Change Display Name"),
          backgroundColor: Colors.black,),
          body: 
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.5.w,
                      child: Form(
                        key: key,
                        child: TextFormField(decoration: InputDecoration(hintText: "Display Name"),textAlign: TextAlign.center,
                          controller: namecontrol,
                          validator: (val){
                                   
                                   if(validatename=='already exists'){
                                     return "Already exists! try another";
                                   }
                                   else if(validatename=='An error occured'){
                                      return "Couldn't validate!";
                                   }
                                   return null;
                            }
                                     
                                  
                                ,
                                onChanged: (val)async{
                                  if(val.isNotEmpty){
                                          var result=await AuthMethods.validateName(val);
                      
                                          setState(() {
                                             validatename=result;
                                          });
                      
                                  
                                }
                                }),
                      )
                      ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(top: 12.h),
                    child: ElevatedButton(onPressed: (){
                          if(key.currentState!.validate()){
                            setState(() {
                              AuthMethods.changeDisplayName(namecontrol.text.trim());
                              namecontrol.clear();
                              Navigator.of(context).pop();
                            });
                          }
                    }, child: Text("Save")),
                  ),
                ],
              ),
            
          
        ),
      ),
    );
  }
}