


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:me_chat/auth/authmethods.dart';


class SignInPage extends StatefulWidget{
  

  @override 
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailcontrol=TextEditingController();

  TextEditingController passwordcontrol=TextEditingController();

  TextEditingController confirmcontrol=TextEditingController();

  TextEditingController namecontrol=TextEditingController();

  final formKey = GlobalKey<FormState>();  

  bool authswitch=false;
  bool loading=false;

 SnackBar snackBar(String content){
    return   SnackBar(
        content: Text(content),
        
        );
  }
 
  clearControllers(){
       passwordcontrol.clear();
       confirmcontrol.clear();
       emailcontrol.clear();
       namecontrol.clear();
       
  }

  String validatename="";
  
   check() async{
    
    
    
    if(authswitch==true){
        
        if(formKey.currentState!.validate()){
          setState(() {
            loading=true;
          });
         var result=await AuthMethods.emailSignUp(emailcontrol.text, passwordcontrol.text,namecontrol.text);
            
    
          if(result=="An error occured"){
                return false;
          }else{
            return true;
          }
          
   
        }
    }
    else{
        confirmcontrol.text=passwordcontrol.text;
        namecontrol.text="dummy";
        if(formKey.currentState!.validate()){
          
          setState(() {
            loading=true;
          });
           var result =await AuthMethods.emailSignIn(emailcontrol.text, passwordcontrol.text);
              
          if (result=="An error occured"){
           
            return false;
          }else{
           return true;
         }
         
        }
          
    }
     
   
}


  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          body: 
          loading?const Center(child:CircularProgressIndicator() ):
          SingleChildScrollView(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
             
              Container(
                
                decoration: BoxDecoration(
                  boxShadow:[BoxShadow(color:Colors.black26,blurRadius: 2.r,spreadRadius: 5.r)],
                  //color: Colors.blueAccent,
                  gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.indigo, Colors.deepPurple]
                  ),
                  
                borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(100,50),bottomRight:Radius.elliptical(200, 0) )),
                
                height: height*0.4 ,),
      
                 Padding(
                      padding:  EdgeInsets.only(top:200.h),
                      child: Text(authswitch?"Sign Up":"Sign In",style: TextStyle(fontSize: 30.sp,fontWeight:FontWeight.bold ,color: Colors.white,)),
                ),
          
              Padding(
                padding: EdgeInsets.only(top:authswitch? 120.h:50.h),
                child: Center(child:
                Container(
                 decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(20.h),topLeft: Radius.circular(20.h))),
                 constraints: BoxConstraints(minHeight: 300.h,maxHeight: 500.h,maxWidth: 250.h),
                    
                  
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                          
                          Form(
                            key: formKey,
                            child: Column(
                            children: [
                              TextFormField(
                                 
                                  controller: emailcontrol,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration:  const InputDecoration(label: Text("Email"),
                                  
                                  ),
                                  validator: (val){
                                      if(val!.trim().isNotEmpty){
                                        return null;
                                      }
                                      return "Enter a valid email address";
                                  },
                                  
                              ),
                              TextFormField(
                                
                                controller: passwordcontrol,
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: const InputDecoration(
                                  label: Text("Password")),
                        
                                  validator: (val){
                                      if(val!.isNotEmpty){
                                        if(val.length<6){
                                          return "password must be atleast 6 characters";
                                        }
                                        return null;
                                      }
                                      return "Enter a password";
                                  },
                              ),
                              if(authswitch) TextFormField(
                                
                                controller: confirmcontrol,
                                obscureText: true,
                                
                                decoration: const InputDecoration(
                                
                                  label: Text("Confirm Password")),
                                validator: (val){
                                      if(val!.isNotEmpty && val==passwordcontrol.text){
                                        return null;
                                      }
                                      return "Should match with password field";
                                  },
                              ),
                              if(authswitch) TextFormField(
                                
                                controller: namecontrol,
                                obscureText: true,
                                decoration: const InputDecoration(label: Text("Display Name")),
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
                                    },
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 30.h,bottom: 10.h),
                                child: 
                                  
                                 ElevatedButton(
                                    
                                    style: ElevatedButton.styleFrom(
                                    primary: Colors.indigoAccent,
                                    //side: BorderSide(width: 2.0, color: Colors.black),
                                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                     shape: RoundedRectangleBorder(
                                      
                                      borderRadius: BorderRadius.circular(20))),
                                      onPressed: ()async{
                                      var result=true;
                                      result =await check();
                                      if(result==false){
                                        setState(() {
                                            loading=false;
                                            clearControllers();
                                          });
                                        if(authswitch==true){
                                          
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar("Couldn't SignUp! make sure your email is unique and network is stable"));
                                        }else{
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar("Couldn't Login! try correcting email,password or network connection"));
                                        }
                                      }
                        
                                  },
                                   
                                   child: Text(authswitch?"Sign Up":"Sign In",style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.bold),),
                                   
                                    )
                                   ),
                                
                              
                              
                              TextButton(onPressed: (){
                                setState(() {
                                  authswitch=!authswitch;
                                  formKey.currentState!.reset();
                                  clearControllers();
                                  FocusScope.of(context).unfocus();
                                });
                              }, child: Text(!authswitch?"Don't have an account? Sign Up":"Already have an account? Sign In",style: TextStyle(color: Colors.indigoAccent),))
                            ],
                          ))
                    ],
                  ),
                ),
                         ),
              ),
              Padding(
                padding:  EdgeInsets.only(top: 230.h,left: 230.w),
                child: Material(

                  borderRadius: BorderRadius.circular(50.r),
                  color: Colors.white,
                  elevation:10 ,
                  
                  child: CircleAvatar(
                    backgroundColor: Colors.orange,
                    radius: 50.r,
                    child: Text("me.chat",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18.sp),),
                  ),
                ),
              )
              ],
            ),
          ),
          ),
      )
    );
  }
}




