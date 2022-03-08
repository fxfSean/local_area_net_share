
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../chat_model.dart';

class BottomInputCell extends StatefulWidget {

  const BottomInputCell({Key? key}) : super(key: key);

  @override
  _BottomInputCellState createState() => _BottomInputCellState();
}

class _BottomInputCellState extends State<BottomInputCell> {
  final controller = TextEditingController();
  bool focus = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffefefef),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              context.read<ChatModel>().pickFile();
            },
            child: Icon(
              Icons.add_circle_outline,
              color: Colors.black,
              size: 22,
            ),
          ),
          const SizedBox(width: 8,),
          Expanded(child: Container(
            height: 35,
            child: TextField(
              controller: controller,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                  bottom: 17,
                  left: 8
                ),
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
          GestureDetector(
            onTap: () {
              context.read<ChatModel>().sendMessage(controller.text);
              controller.text = '';
            },
            child: Icon(
              Icons.send,
              color: Colors.black,
              size: 22,
            ),
          )
        ],
      ),
    );
  }
}
