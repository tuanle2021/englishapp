import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastController {
  static FToast fToast = FToast();
  static void showSuccess(String description, context, {String title = "",ToastGravity gravity = ToastGravity.TOP,Duration duration = const Duration(seconds: 3)}) {
    Widget toast = Container(
        width: MediaQuery.of(context).size.width * 0.65,
        padding: EdgeInsets.symmetric(vertical: 12,horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.greenAccent,
        ),
        child: Center(
          child: Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(Icons.check,size: 24,color: Theme.of(context).colorScheme.onPrimary,)),
                TextSpan(text: description,style:TextStyle(color: Theme.of(context).colorScheme.onPrimary,fontSize: 18,fontWeight: FontWeight.bold)),
              ],
            ),
          textAlign: TextAlign.center,),
        ));
    FToast fToast;
    fToast = FToast();
    fToast.init(context);
    fToast.removeCustomToast();
    fToast.showToast(
      gravity: gravity,
      child: toast,
      toastDuration: duration,
    );
  }

  static void showInfo(String description, context, {String title = ""}) {
    Widget toast = Container(
      width: MediaQuery.of(context).size.width * 0.65,
      padding: EdgeInsets.symmetric(vertical: 12,horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.yellowAccent.shade700,
      ),
      child: Center(
        child: Text.rich(

            TextSpan(
              
              children: [
                WidgetSpan(child: Icon(Icons.info,size: 24,color: Theme.of(context).colorScheme.onPrimary,),alignment: PlaceholderAlignment.middle,),
                 TextSpan(text: description,style:TextStyle(color: Theme.of(context).colorScheme.onPrimary,fontSize: 18,fontWeight: FontWeight.bold)),
              ],
            ),textAlign: TextAlign.center,
          ),
      )
    );

    fToast.init(context);
    fToast.removeCustomToast();
    fToast.showToast(
      gravity: ToastGravity.TOP,
      child: toast,
      toastDuration: Duration(seconds: 3),
    );
  }

  static void showError(String description, context, {String title = "",Duration duration = const Duration(seconds: 3),ToastGravity gravity = ToastGravity.TOP}) {
    Widget toast = Container(
      width: MediaQuery.of(context).size.width * 0.65,
      padding: EdgeInsets.symmetric(vertical: 12,horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Theme.of(context).colorScheme.error,
      ),
      child: Center(
        child: Text.rich(
            TextSpan(
              children: [
                WidgetSpan(child: Icon(Icons.warning,size:24,color: Theme.of(context).colorScheme.onPrimary),alignment: PlaceholderAlignment.middle),
                TextSpan(text: description,style:TextStyle(color: Theme.of(context).colorScheme.onPrimary,fontSize: 18,fontWeight: FontWeight.bold)),
              ],
            ),textAlign: TextAlign.center,
          ),
      )
         
    );

    fToast.init(context);
    fToast.removeCustomToast();
    fToast.showToast(
      gravity: gravity,
      child: toast,
      toastDuration: duration,
    );
  }
}
