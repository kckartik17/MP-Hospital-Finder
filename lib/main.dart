import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hospital_finder/config/config_page.dart';
import 'package:hospital_finder/notifiers/config_notifier.dart';
import 'package:hospital_finder/notifiers/location_notifier.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (_) => LocationBloc(),
        ),
        ChangeNotifierProvider(
          builder: (_) => ConfigBloc(),
        )
      ],
      child: ConfigPage(),
    ),
  );
}
