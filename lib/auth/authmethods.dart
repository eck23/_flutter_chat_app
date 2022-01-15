import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';




class  AuthMethods  {
   static FirebaseAuth auth=FirebaseAuth.instance;

   static validateName(String displayName)async {
      try{
           final QuerySnapshot result=await FirebaseFirestore.instance.collection("users").where("name",isEqualTo: displayName).limit(1).get();
           final List<DocumentSnapshot> documents = result.docs;
            if(documents.isNotEmpty){
                  return "already exists";
            }
            
            return "ok";
      
      }on FirebaseException catch(e){
          return "An error occured";
      }
   }
  
   static Future emailSignUp(String email,String password,String displayName)async {
      
        try{
        await auth.createUserWithEmailAndPassword(email: email, password: password).then((value)async {
          try {
            
            await FirebaseAuth.instance.currentUser!.updateDisplayName(displayName);
            await  FirebaseFirestore.instance.collection("users").doc(value.user!.email).set({
            'email':AuthMethods.auth.currentUser!.email,
            'name' :AuthMethods.auth.currentUser!.displayName,
            'peopleList':[]
            });
            var letter=displayName.substring(0,1);
            FirebaseFirestore.instance.collection("startsWith_$letter").doc().set({
              'email':email,
              'displayName':displayName
            });
           
        }on FirebaseException catch(e){
          return "An error occured";
         }
      });
        
        
       }on FirebaseException catch(e){
          return "An error occured"  ;
        }
    
    }
     static Future emailSignIn(String email,String password)async {
      
      try{
        await auth.signInWithEmailAndPassword(email: email, password: password);
        
       
       return "ok";        
       }on FirebaseException catch(e){
          return "An error occured";
      }
    }
    @override
    static Stream<String> get authStateChanges => auth.authStateChanges().map((user) => user!.uid);

    static Future signOut() async{
    
      await auth.signOut();
    }

    static Future changeDisplayName(String newName)async{
         await FirebaseAuth.instance.currentUser!.updateDisplayName(newName);
         FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.email).update(
           {
             'name':FirebaseAuth.instance.currentUser!.displayName
           }
         );

    }

  
}



