import 'package:flutter/material.dart';
import 'package:hospital_finder/config/size_config.dart';
import 'package:hospital_finder/notifiers/config_notifier.dart';
import 'package:provider/provider.dart';

class HospitalListCard extends StatefulWidget {
  @override
  _HospitalListCardState createState() => _HospitalListCardState();
}

class _HospitalListCardState extends State<HospitalListCard> {
  @override
  Widget build(BuildContext context) {
    ConfigBloc configBloc = Provider.of<ConfigBloc>(context);
    SizeConfig().init(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 2),
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 10),
            height: SizeConfig.blockSizeVertical * 15,
            width: SizeConfig.blockSizeHorizontal * 70,
            decoration: BoxDecoration(
              color: configBloc.darkOn ? Colors.black : Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                  offset: new Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 3,
                ),
                Text("Columbia Asia Hospital")
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: SizeConfig.blockSizeVertical * 3,
            ),
            height: SizeConfig.blockSizeVertical * 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }
}
