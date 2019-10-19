import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hospital_finder/config/size_config.dart';
import 'package:hospital_finder/notifiers/config_notifier.dart';
import 'package:provider/provider.dart';

class HFscaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final FloatingActionButton fab;

  const HFscaffold({Key key, this.title, this.body, this.fab})
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
            automaticallyImplyLeading: true,
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
                  title: Text("Item 1"),
                  onTap: () {},
                ),
                ListTile(
                  title: Text("Item 2"),
                  onTap: () {},
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
