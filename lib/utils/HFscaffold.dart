import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hospital_finder/config/size_config.dart';
import 'package:hospital_finder/notifiers/config_notifier.dart';
import 'package:hospital_finder/pages/maps/maps.dart';
import 'package:provider/provider.dart';

class HFscaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final FloatingActionButton fab;
  final bool drawerIcon;

  const HFscaffold(
      {Key key, this.title, this.body, this.fab, this.drawerIcon = false})
      : super(key: key);
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
            automaticallyImplyLeading: drawerIcon ?? false,
            title: Text(title),
            leading: !drawerIcon
                ? IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  )
                : null,
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Maps",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, HospitalListMap.routeName),
              ),
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
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text(
                    "Hospital Finder",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.safeBlockHorizontal * 5,
                        letterSpacing: SizeConfig.safeBlockHorizontal * 0.8),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.purple[600], Colors.purple[200]],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.reply),
                  title: Text("Exit"),
                  onTap: () => SystemChannels.platform
                      .invokeMethod('SystemNavigator.pop'),
                ),
              ],
            ),
          ),
          body: body,
          floatingActionButton: fab ?? null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }
}
