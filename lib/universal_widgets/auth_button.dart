import 'package:flutter/material.dart';
import 'package:hospital_finder/config/size_config.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final Icon icon;
  final Function onPressed;
  final Color color;

  const AuthButton({Key key, this.text, this.icon, this.onPressed, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      width: SizeConfig.safeBlockVertical * 30,
      child: OutlineButton(
        shape: StadiumBorder(),
        highlightedBorderColor: color,
        highlightColor: color,
        borderSide: BorderSide(color: color),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            icon,
            SizedBox(
              width: 10,
            ),
            Text(text)
          ],
        ),
        onPressed: onPressed,
      ),
    );
  }
}
