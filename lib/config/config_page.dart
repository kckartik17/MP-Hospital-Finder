import 'package:flutter/material.dart';
import 'package:hospital_finder/notifiers/config_notifier.dart';
import 'package:hospital_finder/pages/authentication/signin.dart';
import 'package:hospital_finder/utils/hf.dart';
import 'package:provider/provider.dart';

class ConfigPage extends StatefulWidget {
  static const String routeName = "/";
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    ConfigBloc configBloc = Provider.of<ConfigBloc>(context);
    return MaterialApp(
      title: "Hospital Finder",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: HF.google_sans,
        primarySwatch: Colors.red,
        primaryColor: configBloc.darkOn ? Colors.black : Colors.white,
        disabledColor: Colors.grey,
        cardColor: configBloc.darkOn ? Colors.black : Colors.white,
        canvasColor: configBloc.darkOn ? Colors.black : Colors.grey[50],
        brightness: configBloc.darkOn ? Brightness.dark : Brightness.light,
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
            colorScheme:
                configBloc.darkOn ? ColorScheme.dark() : ColorScheme.light()),
        appBarTheme: AppBarTheme(
          elevation: 0.0,
        ),
      ),
      home: SignIn(),
    );
  }
}
