import 'package:flutter/material.dart';
import 'package:hospital_finder/notifiers/index.dart';
import 'package:hospital_finder/widgets/divider.dart';
import 'package:provider/provider.dart';
import 'package:hospital_finder/config/size_config.dart';
import 'package:hospital_finder/utils/tools.dart';

class HospitalCard extends StatelessWidget {
  final Function onTap;
  final String text;
  final double distance;

  const HospitalCard({Key key, this.onTap, this.text, this.distance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConfigBloc configBloc = Provider.of<ConfigBloc>(context);
    SizeConfig().init(context);
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            left: SizeConfig.blockSizeHorizontal * 2,
            right: SizeConfig.blockSizeHorizontal * 2,
            bottom: SizeConfig.blockSizeHorizontal * 3.5,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onTap,
            child: Ink(
              height: SizeConfig.blockSizeVertical * 40,
              width: SizeConfig.blockSizeHorizontal * 40,
              decoration: BoxDecoration(
                color: configBloc.darkOn
                    ? Tools.hexToColor("#1f2124")
                    : Colors.white,
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.zero,
                    height: SizeConfig.blockSizeVertical * 13,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/background.jpg"),
                          fit: BoxFit.cover),
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
                        Text(text),
                        Text(
                          "Gurugram, Haryana",
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 2.5),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -SizeConfig.blockSizeHorizontal * 1,
          left: SizeConfig.blockSizeHorizontal * 40 / 2.7,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Chip(
              label: Text(
                "$distance km",
                style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3),
              ),
              backgroundColor:
                  configBloc.darkOn ? Colors.red : Colors.blue[100],
              elevation: 8,
            ),
          ),
        ),
      ],
    );
  }
}
