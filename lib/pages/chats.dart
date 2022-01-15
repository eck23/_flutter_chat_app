

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:me_chat/data/datamanage.dart';
import 'package:me_chat/pages/chat_area.dart';
import 'package:me_chat/pages/search.dart';
import 'package:me_chat/providers/delete_state.dart';
import 'package:me_chat/widgets/alertbox.dart';
import 'package:me_chat/widgets/app_drawer.dart';
import 'package:provider/provider.dart';



class Chats extends StatefulWidget{
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  String? user=FirebaseAuth.instance.currentUser!.email;
  CollectionReference collectionRef=FirebaseFirestore.instance.collection("users");
  List peopleList=[];
  SnackBar snackBar(String content){
    return   SnackBar(
        content: Text(content),
        
        );
  }
  
  @override
  Widget build(BuildContext context) {
    DeleteState provider=Provider.of<DeleteState>(context,listen: false);
    return SafeArea(
      child: Scaffold(
        drawer: drawer(context),
        appBar: AppBar(
           title: const Text("Me Chat"),
           backgroundColor: Colors.black,
         
          actions:Provider.of<DeleteState>(context,listen: true).selectState==false? [
          // IconButton(onPressed: (){
          //   }, icon: const Icon(Icons.search)),
            
            
            PopupMenuButton(
                        onSelected: (String confrim){alert("Are you sure to delete all", ()=>DataManage.deleteChats(peopleList, true), context);},
                        icon: const Icon(Icons.more_vert_rounded),
                        itemBuilder: (context)=>
                        [const PopupMenuItem<String>(child: Text("Delete All"),value: 'deleteAll')]),
          ]:[
            IconButton(onPressed: ()async{
                //print(Provider.of<DeleteState>(context,listen: false).selectedPeople);
                var result=  await DataManage.deleteChats(provider.selectedPeople,true);
               
               
                setState((){
                    provider.changeSelectState(false);
                    provider.selectedPeople.clear();
                });
                if(result=='Couldn\'t delete'){
                  ScaffoldMessenger.of(context).showSnackBar(snackBar('Couldn\'t delete'));
                }
    
            }, icon: const Icon(Icons.delete)),
            IconButton(onPressed: (){
              setState((){
                    provider.changeSelectState(false);
                    provider.selectedPeople.clear();
                });
            }, icon: const Icon(Icons.cancel),)
          ]
        ),
        body: SizedBox(
                     height: MediaQuery.of(context).size.height*0.9,
                     width: MediaQuery.of(context).size.width,
                     child: StreamBuilder(
                         stream:collectionRef.doc(user).snapshots() ,
                         builder:(context,AsyncSnapshot<DocumentSnapshot> snapshot){
                           if(snapshot.hasData && !snapshot.hasError){
                               peopleList=snapshot.data!['peopleList'];
                               return peopleList.isNotEmpty?  ListView.builder(
                                 itemCount: peopleList.length,
                                 itemBuilder: (ctx,index){
                                   
                                  var recipentEmail=peopleList[index];
                                  
                                return chatTile(collectionRef: collectionRef, recipentEmail: recipentEmail);
                               }):const Center(child: Text("No Chats"),);
                             
                           }else{
                             return const Center(child: CircularProgressIndicator(),);
                           }
                         }
                     
                     ),
                   ),
        floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.chat),
        onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (_)=>Search()));},),
      ),
    );
  }
}

class chatTile extends StatefulWidget {
   chatTile({
    
    required this.collectionRef,
    required this.recipentEmail,
    
    
  });

  final CollectionReference<Object?> collectionRef;
  final  String recipentEmail;
 

  @override
  State<chatTile> createState() => ChatTileState();
}

class ChatTileState extends State<chatTile> {
  
 bool isSelected=false;

  @override
  Widget build(BuildContext context) {
    DeleteState provider=Provider.of<DeleteState>(context,listen: false);
    if(provider.selectState==false){
      isSelected=false;
    }
    return StreamBuilder(
      stream: widget.collectionRef.doc(widget.recipentEmail).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        var recipentName=snapshot.data!['name'];                              
        return Container(
          height: 70.h,
          child: Card(
            child: Center(
              child: ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text(recipentName,style: TextStyle(fontWeight: FontWeight.bold),),
                trailing: isSelected?Icon(Icons.check):null,
                onLongPress: (){
                   if(provider.selectState==false){
                        setState(() {
                      isSelected=true;
                      provider.changeSelectState(true);
                      provider.selectedPeople.add(widget.recipentEmail);
                     });
                   }
                  },
                onTap: (){ 
                  if(provider.selectState==true){
                        setState(() {
                          isSelected=!isSelected;
                          if(isSelected==true){
                            provider.selectedPeople.add(widget.recipentEmail);
                          }
                          else{
                            provider.selectedPeople.removeWhere((element) => element==widget.recipentEmail);
                          }

                          if(provider.selectedPeople.isEmpty){
                            provider.changeSelectState(false);
                          }
                        });
                  }
                  
                  else{
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ChatArea(widget.recipentEmail,recipentName),));
                  }
                  }),
            ),
          ),
        );
      }
    );
  }
}