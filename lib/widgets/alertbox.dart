import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void alert (String text,Function function,BuildContext ctx){
      showDialog(context: ctx, builder:(ctx){
      return AlertDialog(
        title: Text (text),
        actions: [
          ElevatedButton(onPressed: (){
            Navigator.of(ctx).pop();
          }, child: const Text("No")),
          ElevatedButton(onPressed: (){
            function();
            Navigator.of(ctx).pop();
           
          }, child: const Text("Yes")),
        ],
      );
    });
  }