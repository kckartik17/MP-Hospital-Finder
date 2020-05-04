import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hospital_finder/notifiers/index.dart';
import 'package:hospital_finder/pages/description_page/Description.dart';
import 'package:hospital_finder/universal_widgets/divider.dart';
import 'package:hospital_finder/utils/call.dart';
import 'package:hospital_finder/utils/navigation.dart';
import 'package:provider/provider.dart';
import 'package:hospital_finder/config/size_config.dart';
import 'package:hospital_finder/utils/tools.dart';
import 'package:hospital_finder/models/hospitalfirestore.dart';

class HospitalCard extends StatelessWidget {
  final HospitalFirestore hospital;

  const HospitalCard({Key key, this.hospital}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConfigBloc configBloc = Provider.of<ConfigBloc>(context);
    SizeConfig().init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Description(
                hospital: hospital,
              ),
            ),
          );
        },
        child: Ink(
          height: SizeConfig.blockSizeHorizontal * 60,
          width: SizeConfig.blockSizeHorizontal * 40,
          decoration: BoxDecoration(
            color:
                configBloc.darkOn ? Tools.hexToColor("#1f2124") : Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: !configBloc.darkOn
                ? [
                    BoxShadow(
                      color: Color(0xFFE6E6E6),
                      blurRadius: 17,
                      offset: Offset(0, 17),
                      spreadRadius: 0,
                    )
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Hero(
                tag: "${hospital.name}",
                child: Container(
                  margin: EdgeInsets.zero,
                  height: SizeConfig.blockSizeVertical * 13,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    image: DecorationImage(
                        image: AssetImage("assets/images/hospital.jpg"),
                        fit: BoxFit.fill),
                  ),
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
                      hospital.name.length < 42
                          ? hospital.name
                          : "${hospital.name.substring(0, 42)}...",
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    AutoSizeText(
                      "${hospital.district}, ${hospital.state}",
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 2),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.directions_car,
                          size: SizeConfig.blockSizeHorizontal * 3,
                        ),
                        SizedBox(
                          width: 3.0,
                        ),
                        Text(
                          "${hospital.distance} km",
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 3),
                        )
                      ],
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
                        onPressed: () {
                          call(hospital.mobile);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.directions,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          navigate(hospital.latitude, hospital.longitude);
                        },
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
