import 'package:flutter/material.dart';

class CustomizedDivider extends StatelessWidget {
  final double width;

  const CustomizedDivider({Key key, this.width}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: width),
        ),
      ),
    );
  }
}
