import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

class MyCustomWidget extends StatefulWidget {
  MyCustomWidget(
      {required this.text,
      required this.ontap,
      required this.stateTextWithIcon,
      required this.icon,
      this.color = Colors.black});
  @override
  _MyCustomWidgetState createState() => _MyCustomWidgetState();
  String text;
  VoidCallback ontap;
  IconData icon;
  Color color;
  ButtonState stateTextWithIcon = ButtonState.idle;
}

class _MyCustomWidgetState extends State<MyCustomWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ProgressButton.icon(iconedButtons: {
        ButtonState.idle: IconedButton(
            text: widget.text,
            icon: Icon(widget.icon, color: Colors.white),
            color: widget.color),
        ButtonState.loading: IconedButton(text: 'Loading', color: Colors.black),
        ButtonState.fail: IconedButton(
            text: 'Failed',
            icon: Icon(Icons.cancel, color: Colors.white),
            color: Colors.red.shade300),
        ButtonState.success: IconedButton(
            text: 'Success',
            icon: Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            color: Colors.green.shade400)
      }, onPressed: widget.ontap, state: widget.stateTextWithIcon),
    );
  }
}
