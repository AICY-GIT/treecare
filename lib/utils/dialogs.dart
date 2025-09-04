import 'package:flutter/material.dart';


class Popup{
  static void showLoading(BuildContext context)
  {
    showDialog(context: context,
        barrierDismissible: false,
        builder: (_)=> const Center(
          child: CircularProgressIndicator(color: Colors.green),
        ));
  }

  static void hideLoading(BuildContext context){
    Navigator.of(context, rootNavigator: true).pop();
  }

  static void showErrorPopup(BuildContext context,String error){
       showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 80),
            const SizedBox(height: 10),
            Text('Error: $error'),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Retry'),
            ),
          )
        ],
      ),
    );
  }

}