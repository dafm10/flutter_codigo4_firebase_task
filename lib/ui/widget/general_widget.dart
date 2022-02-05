
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void showSnackErrorMessage(BuildContext context, String icon, String message){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.redAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 1),
      content: Row(
        children: [
          SvgPicture.asset('assets/icons/$icon.svg', color: Colors.white,),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
                message
              // "Hubo un inconveniente. Por favor, inténtalo nuevamente.",
            ),
          ),
        ],
      ),
    ),
  );
}

void showSnackSucessMessage(BuildContext context, String icon, String message){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Color(0xff5ae095),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 3),
      content: Row(
        children: [
          SvgPicture.asset('assets/icons/$icon.svg', color: Colors.white,),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
                message
              // "Hubo un inconveniente. Por favor, inténtalo nuevamente.",
            ),
          ),
        ],
      ),
    ),
  );
}