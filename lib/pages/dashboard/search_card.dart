import 'package:flutter/material.dart';
import 'package:hospital_finder/notifiers/index.dart';
import 'package:provider/provider.dart';
import 'package:hospital_finder/config/size_config.dart';
import 'package:hospital_finder/utils/tools.dart';

class SearchCard extends StatelessWidget {
  final Function onTap;
  final String text;
  // final Icon icon;
  final Color color;

  const SearchCard({Key key, this.onTap, this.text, this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    ConfigBloc configBloc = Provider.of<ConfigBloc>(context);
    SizeConfig().init(context);
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Ink(
        height: SizeConfig.blockSizeVertical * 15,
        width: SizeConfig.blockSizeHorizontal * 42,
        decoration: BoxDecoration(
          color: configBloc.darkOn ? Tools.hexToColor("#1f2124") : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: !configBloc.darkOn
              ? [
                  BoxShadow(
                    color: Colors.grey[200],
                    blurRadius: 10,
                    spreadRadius: 5,
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.search,
              color: color,
            ),
            SizedBox(
              height: 10,
            ),
            Text(text)
          ],
        ),
      ),
    );
  }
}
