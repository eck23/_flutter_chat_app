import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:me_chat/auth/authmethods.dart';
import 'package:me_chat/pages/settings.dart';
import 'package:me_chat/widgets/alertbox.dart';

Widget drawer(BuildContext ctx){
   return Drawer(
     
      child: ListView(
        children: [
            Padding(
              padding:  EdgeInsets.only(bottom: 10.h),
              child: DrawerHeader(
                
                child: Center(
                child: Column(
                  children: [
                    
                      StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.email).snapshots(),
                        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          return SizedBox(
                            child: Column(
                              children: [
                                CircleAvatar(
                                 minRadius:30.r,
                                backgroundColor: Colors.black,
                                child: Text(
                                snapshot.data!['name'].toString().substring(0,1).toUpperCase(),
                                style: TextStyle(color: Colors.white,fontSize: 25.sp),
                              ),
                            ),
                      
                                Padding(
                                  padding:  EdgeInsets.only(top: 10.h,bottom: 10.h),
                                  child: Text( snapshot.data!['name'].toUpperCase(),style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.bold),),
                                ),
                              ],
                            ),
                          );
                        }
                      ),
                      
                      Text( FirebaseAuth.instance.currentUser!.email.toString(),style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.bold))
                  ],
                ),
              )),
            ),
            
            ListTile(
            onTap: (){
              Navigator.of(ctx).push(MaterialPageRoute(builder: (_)=>SettingsPage()));
            },
            title:  Text("Settings",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.bold),),
            trailing: const Icon(Icons.settings,color: Colors.blue),),

            ListTile(
            onTap: ()=>alert("Do you want to log out", ()=>AuthMethods.signOut(),ctx),
            title:  Text("Log out",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.bold),),
            trailing: const Icon(Icons.logout,color: Colors.red,),),
        ],
      ),
   );
}