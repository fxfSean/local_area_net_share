
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomInputCell extends StatelessWidget {
  const BottomInputCell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffefefef),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      child: Row(
        children: [
          Expanded(child: Container(
            height: 35,
            child: TextField(
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none
                  )
                ),
                fillColor: Colors.white,
                filled: true,
              ),

            ),
          )),
          SizedBox(width: 10,),
          Icon(
            Icons.add_circle_outline,
            color: Colors.black,
            size: 22,
          )
        ],
      ),
    );
  }
}
