

import 'package:flutter/foundation.dart';

class DeleteState extends ChangeNotifier{
    bool selectState=false;
    
    List selectedPeople=[];
   

    void changeSelectState(bool state){
      selectState=state;
      notifyListeners();               
    }
    
   
}

class DeleteMessageTiles extends ChangeNotifier{
      bool selectMessageTile=false;
      List selectedMessageTiles=[];
       
       void changeSelectMessageTile(bool state){
          selectMessageTile=state;
          notifyListeners();
        }
}

