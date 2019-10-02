import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hospital_finder/notifiers/config_notifier.dart';
import 'package:provider/provider.dart';

class HFscaffold extends StatelessWidget {
  final String title;
  final Widget body;

  const HFscaffold({Key key, this.title, this.body}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ConfigBloc configBloc = Provider.of<ConfigBloc>(context);
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      color: configBloc.darkOn ? Colors.grey[800] : Colors.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  configBloc.darkOn
                      ? FontAwesomeIcons.moon
                      : FontAwesomeIcons.solidMoon,
                  size: 18,
                ),
                onPressed: () {
                  configBloc.reverseDarkMode();
                },
              )
            ],
          ),
          body: body,
        ),
      ),
    );
  }
}
