import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

//sort length
void openToast(context, message){
  Toast.show(
    message, 
    duration: Toast.lengthShort,
    gravity: Toast.bottom,
  );
}


//long length
void openToast1(context, message){
  Toast.show(
    message, 
    duration: Toast.lengthLong,
    gravity: Toast.bottom,
  );
}