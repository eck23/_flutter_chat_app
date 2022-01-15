import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:me_chat/data/datamanage.dart';
import 'package:me_chat/providers/delete_state.dart';
import 'package:me_chat/widgets/alertbox.dart';
import 'package:provider/provider.dart';

class ChatArea extends StatefulWidget{
  String recipentEmail;
  String recipentName;
  ChatArea(this.recipentEmail,this.recipentName);
  @override
  State<ChatArea> createState() => _ChatAreaState();
}

class _ChatAreaState extends State<ChatArea> {
  //late DocumentReference docReference;
  TextEditingController controller=TextEditingController();
  bool exist=false;
  
  String? userEmail=FirebaseAuth.instance.currentUser!.email;


  


   @override
  Widget build(BuildContext context) {
    DeleteMessageTiles provider=Provider.of<DeleteMessageTiles>(context,listen: false);
     return WillPopScope(
       onWillPop: ()async{provider.changeSelectMessageTile(false);return true;},
       child: GestureDetector(
         
         onTap: () => FocusScope.of(context).unfocus(),
         child: Scaffold(
           backgroundColor: Colors.white,
           appBar: AppBar(
             actions: 
            Provider.of<DeleteMessageTiles>(context,listen: true).selectMessageTile?[
                  IconButton(onPressed: ()=>alert("Are you sure to delete the chats?",(){
                    //print(provider.selectedMessageTiles.toString());
                    setState(() {
                      DataManage.deleteMessages(widget.recipentEmail, provider.selectedMessageTiles);
                      provider.selectedMessageTiles.clear();
                      provider.changeSelectMessageTile(false);
                    });
                  },context), icon: const Icon(Icons.delete)),
                  IconButton(onPressed: (){
                    setState(() {
                       provider.selectedMessageTiles.clear();
                       provider.changeSelectMessageTile(false);
                    });
                    
                  }, icon:const  Icon(Icons.cancel),)]:[
             
                  PopupMenuButton(
                      onSelected: (String confrim){alert("Are you sure to delete all", ()=>DataManage.deleteChats([widget.recipentEmail], false), context);},
                      icon: const Icon(Icons.more_vert_rounded),
                      itemBuilder: (context)=>
                      [const PopupMenuItem<String>(child: Text("Delete All"),value: 'deleteAll')])          
               
             ],
             backgroundColor: Colors.black45,
             title: Text(widget.recipentName),),
           body:SingleChildScrollView(
             child: Column(
               
                 children: [
                   
                     Padding(
                       padding:  EdgeInsets.only(top: 6.h),
                       child: SizedBox(
                         height: MediaQuery.of(context).size.height*0.78,
                         child: StreamBuilder(
                             stream:FirebaseFirestore.instance.collection("users").doc(userEmail).collection(widget.recipentEmail).orderBy('time').snapshots() ,
                             builder:(context,AsyncSnapshot<QuerySnapshot> snapshot){
                               if(snapshot.connectionState==ConnectionState.active && snapshot.hasData){
                                  List list=snapshot.data!.docs;
                                  List listID=[];
                                  snapshot.data!.docs.forEach((element) { 
                                    listID.add(element.id);
                                  });
                                   return ListView.builder(
                                     itemCount: list.length,
                                     itemBuilder: (ctx,index){
                                       bool isSendbyMe=list[index]['sender']==userEmail;
                                       return MessageTile(isSendbyMe: isSendbyMe, list: list,message: list[index]['message'],id: listID[index],);
                                    
                                   });
                                 
                               }else{
                                 return const Center(child: CircularProgressIndicator(),);
                               }
                             }
                         
                         ),
                       ),
                     ),
                         
                     
                    Padding(
                      padding:  EdgeInsets.only(left: 5.w,right: 5.w,bottom: 5.h),
                      child: Container(
                        constraints: BoxConstraints(minHeight: 5.h,maxHeight: 500.h),
                        decoration: BoxDecoration(
                          
                          borderRadius: BorderRadius.all(Radius.circular(25.r)),
                          color: Colors.black54),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          
                          children: [
                            SizedBox(
                              
                              
                              width: MediaQuery.of(context).size.width*0.85,
                              child: Padding(
                                padding:  EdgeInsets.only(left: 5.w,right: 5.w),
                                child: TextField(
                                    controller: controller,
                                    maxLines: null,
                                    minLines: null,
                                    style:const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      focusColor: Colors.white,
                                      hintText: 'Message',border: InputBorder.none),
                           ),
                              ),
                            ),
           
                           IconButton(onPressed: (){
                             var msg=controller.text;
                            if(msg.isNotEmpty){
                              DataManage.storeMessage(userEmail!,widget.recipentEmail,msg);
                             controller.clear();
                             FocusScope.of(context).unfocus();
                             DataManage.addPeopleToList(userEmail!, widget.recipentEmail);
                            }
                             
                            }, icon: Icon(Icons.send))
                          ],
                        ),
                      ),
                    )
                 ],
               ),
           ) 
         ),
       ),
     );
  }
}

class MessageTile extends StatefulWidget {
   MessageTile({
    
    required this.isSendbyMe,
    required this.list,
    required this.message,
    required this.id
  }) ;

  final bool isSendbyMe;
  final List list;
  final String message;
  final  String id;

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {

  bool isSelected=false;
  @override
  Widget build(BuildContext context) {
    DeleteMessageTiles provider=Provider.of<DeleteMessageTiles>(context,listen:false);
    if(provider.selectMessageTile==false){
      isSelected=false;
    }
    return Padding(
      padding:  EdgeInsets.only(bottom: 10.h),
      child: 
         Container(
          color: isSelected?Colors.black38:null,
         padding :widget.isSendbyMe?EdgeInsets.only(left: 50.w,right: 10.w):EdgeInsets.only(right: 50.w,left: 10.w),
         alignment:widget.isSendbyMe?Alignment.centerRight :Alignment.centerLeft,
          child: GestureDetector(
            onLongPress: (){
              
              if(provider.selectMessageTile==false){
                        setState(() {
                      isSelected=true;
                      provider.changeSelectMessageTile(true);
                      //provider.selectedMessageTiles.add(widget.id);
                     });
                   }
               
              
            },
            onTap: (){
               if(provider.selectMessageTile==true){
                        setState(() {
                          isSelected=!isSelected;
                          if(isSelected==true){
                            provider.selectedMessageTiles.add(widget.id);
                          }
                          else{
                            provider.selectedMessageTiles.removeWhere((element) => element==widget.id);
                          }

                          if(provider.selectedMessageTiles.isEmpty){
                            provider.changeSelectMessageTile(false);
                          }
                        });
               }
               
            },
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10),),color: widget.isSendbyMe? Colors.blue.shade800:Colors.black),
              
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(widget.message,
                softWrap: true,
                style: TextStyle(fontSize: 15.sp,color: Colors.white,fontWeight: FontWeight.bold),),
              ),
            ),
          ),
        ),
      
    );
  }
}