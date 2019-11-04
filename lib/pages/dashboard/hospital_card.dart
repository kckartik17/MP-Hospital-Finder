import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hospital_finder/notifiers/index.dart';
import 'package:hospital_finder/universal_widgets/divider.dart';
import 'package:provider/provider.dart';
import 'package:hospital_finder/config/size_config.dart';
import 'package:hospital_finder/utils/tools.dart';

class HospitalCard extends StatelessWidget {
  final Function onTap;
  final String name;
  final int distance;
  final String district;
  final String state;

  const HospitalCard(
      {Key key,
      this.onTap,
      this.name,
      this.distance,
      this.district,
      this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConfigBloc configBloc = Provider.of<ConfigBloc>(context);
    SizeConfig().init(context);
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal * 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Ink(
          height: SizeConfig.blockSizeHorizontal * 60,
          width: SizeConfig.blockSizeHorizontal * 40,
          decoration: BoxDecoration(
            color:
                configBloc.darkOn ? Tools.hexToColor("#1f2124") : Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: !configBloc.darkOn
                ? [
                    BoxShadow(
                      color: Colors.grey[400],
                      blurRadius: 10,
                      offset: Offset(0, 10),
                      spreadRadius: 5,
                    )
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.zero,
                height: SizeConfig.blockSizeVertical * 13,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  image: DecorationImage(
                      image: AssetImage("assets/images/background.jpg"),
                      fit: BoxFit.fill),
                ),
              ),
              CustomizedDivider(
                width: 1.0,
              ),
              Padding(
                padding: EdgeInsets.all(
                  SizeConfig.blockSizeHorizontal * 2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AutoSizeText(
                      name,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    AutoSizeText(
                      "$district, $state",
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 2),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.call,
                          color: Colors.green,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.directions,
                          color: Colors.red,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
