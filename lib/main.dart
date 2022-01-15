import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:me_chat/auth/authmethods.dart';
import 'package:me_chat/pages/signinpage.dart';
import 'package:me_chat/providers/delete_state.dart';
import 'package:provider/provider.dart';
import 'pages/chats.dart';


void main() async {
  
  
  runApp(Main());
}

class Main extends StatefulWidget{
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
   


  
  
  @override
  Widget build(BuildContext context) {
    return  
      ScreenUtilInit(
        designSize: Size(360, 690),
      minTextAdapt: true,
      builder: () => MultiProvider(
        providers: [
      ChangeNotifierProvider(
        create: (context)=> DeleteState(),
      ),
      ChangeNotifierProvider(
        
        create: (context) => DeleteMessageTiles(),
      ),
        ],
        builder: (context, child){ return
         MaterialApp(
          debugShowCheckedModeBanner: false,
          home: 
            FutureBuilder(future: Firebase.initializeApp(),
            builder: (context,snapshot){
                if(snapshot.connectionState==ConnectionState.done){
                  return StreamBuilder(
                    stream: AuthMethods.authStateChanges,
                    builder: (context,snapshot){
                      print("snap data : ${snapshot.data}");
                      return snapshot.connectionState==ConnectionState.active && snapshot.hasData? Chats():SignInPage();
                  });
              }else{  
                return Scaffold(body: const Center(child: CircularProgressIndicator(),));
              }
            },)
          
          
        );},
      ),
      );
  }
}




