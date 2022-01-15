import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class DataManage{

  static Future createRoom(String chatId,String recipent)async {
    try{
       FirebaseFirestore.instance.collection("ChatRoom").doc(chatId).set({
      'roomId':chatId,
      
    });
    }catch(e){
      throw FirebaseException;
    }
  }

  static Future storeMessage(String userEmail,String recipentEmail,String message)async{
    String datetime=DateTime.now().toIso8601String();
    await FirebaseFirestore.instance.collection("users").doc(userEmail).collection(recipentEmail).add({
      'message':message,
      'sender' :userEmail,
      'time'   :datetime
    });

     await FirebaseFirestore.instance.collection("users").doc(recipentEmail).collection(userEmail).add({
      'message':message,
      'sender' :userEmail,
      'time'   :datetime
    });
  }
  
 static Future addPeopleToList(String user,String recipentEmail)async {

        DocumentReference ref=FirebaseFirestore.instance.collection("users").doc(user);
        DocumentReference ref2=FirebaseFirestore.instance.collection("users").doc(recipentEmail);
        
                ref.update({
                  'peopleList':FieldValue.arrayUnion([recipentEmail])
                });
                ref2.update({
                  'peopleList':FieldValue.arrayUnion([user])
                });
          
  }

  static Future<dynamic> deleteChats(List deleteList,bool removeFromFront)async {

            try{
              var user=FirebaseAuth.instance.currentUser!.email;
              deleteList.forEach((element) {
                 FirebaseFirestore.instance.collection("users").doc(user).collection(element).get().then((value){
                       value.docs.forEach((doc) {
                         FirebaseFirestore.instance.collection("users").doc(user).collection(element).doc(doc.id).delete();
                       });
                 }).whenComplete((){
                      if(removeFromFront==true){
                        FirebaseFirestore.instance.collection("users").doc(user).update(
                       {
                        'peopleList':FieldValue.arrayRemove([element]),
                       }
                      );
                      }
                });
                });
               
            }catch(e){
                return 'Couldn\'t delete';
            }
        }

  static Future deleteMessages(String reciepntEmail,List messages)async{

        var user=FirebaseAuth.instance.currentUser!.email;
        try{
           messages.forEach((element) {
              FirebaseFirestore.instance.collection("users").doc(user).collection(reciepntEmail).doc(element).delete();
           });
        }catch(e){
          return "error";
        }
          
  }
  
     
}