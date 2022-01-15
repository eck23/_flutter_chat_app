
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:me_chat/pages/chat_area.dart';

TextEditingController controller=TextEditingController();


class Search extends StatefulWidget{
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
   var searchResult;
   
   late Stream<dynamic>searchStream;

   List<String> get searchArray{
      List<String> caseSearchList = [];
      String temp = "";
    for (int i = 0; i < controller.text.length; i++) {
    temp = temp + controller.text[i];
    caseSearchList.add(temp);
    }
    return caseSearchList;
  }
  CollectionReference collection=FirebaseFirestore.instance.collection("users");
   String? userEmail=FirebaseAuth.instance.currentUser!.email;
   String? username=FirebaseAuth.instance.currentUser!.displayName;
    @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: ()async{controller.clear();return true;},
        child: Scaffold(
          body: 
            
             SingleChildScrollView(
               child: Column(children: [
                Divider(height: 30,),
                Container(
                  height:35.h,
                  decoration: BoxDecoration(color: Colors.black54,borderRadius: BorderRadius.all(Radius.circular(20.r))),
                  width: MediaQuery.of(context).size.width*0.9,
                  child: Padding(
                    padding:  EdgeInsets.only(left: 8,right: 4),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration:  InputDecoration(
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: "Search People",border: InputBorder.none),
                      controller: controller,
                    onChanged:(val)async {
                        // await DataManage.searchPeople(val).then((value){searchStream=value as Stream;});
                    },),
                  ),
                ),
                  Divider(height: 30,),
                  StreamBuilder(
                    stream: collection.where('name',isEqualTo: controller.text).where('name',isNotEqualTo: username).snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                    
                    if(snapshot.hasData){
                      return Container(
                      height: MediaQuery.of(context).size.height*0.7,
                      width: MediaQuery.of(context).size.width*0.9,
                      child: ListView.builder(
                        itemCount:snapshot.data!.docs.length,
                        itemBuilder: (context,index){
                        return Card(
                          child: ListTile(
                            title: Text(snapshot.data!.docs[index]['name'],style: TextStyle(fontWeight: FontWeight.bold),),
                            trailing: Icon(Icons.message),
                            onTap: () {
                              
                                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ChatArea("${snapshot.data!.docs[index]['email']}",snapshot.data!.docs[index]['name'])));
                                    
                        
                              }),
                        );
                             
                          }
                           
                        
                      ),
                    );
                  }else{
                    return Center(child: Text("Search Something"),);
                  }
                  })
                       ],),
             ),
          ),
      ),
      
    );
  }
}