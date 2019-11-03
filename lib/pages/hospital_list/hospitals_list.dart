import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hospital_finder/config/size_config.dart';
import 'package:hospital_finder/models/index.dart';
import 'package:hospital_finder/notifiers/index.dart';
import 'package:hospital_finder/utils/HFscaffold.dart';
import 'package:hospital_finder/utils/call.dart';
import 'package:hospital_finder/utils/loadHospitals.dart';
import 'package:hospital_finder/utils/navigation.dart';
import 'package:provider/provider.dart';

class HospitalList extends StatefulWidget {
  static const String routeName = "/hospitalList";
  @override
  _HospitalListState createState() => _HospitalListState();
}

class _HospitalListState extends State<HospitalList> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ConfigBloc configBloc = Provider.of<ConfigBloc>(context);
    return HFscaffold(
      title: "Search Hospitals",
      fab: FloatingActionButton.extended(
        onPressed: () {},
        label: Text("Sort by distance"),
        elevation: 10.0,
        icon: Icon(Icons.directions),
        backgroundColor: configBloc.darkOn ? Colors.grey[700] : Colors.white,
        foregroundColor: configBloc.darkOn ? Colors.white : Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: configBloc.darkOn ? Colors.black : Colors.white,
        ),
        child: Center(
          child: FutureBuilder(
            future: loadHospitals(),
            builder: (context, snapshot) {
              List<Hospital> hospitals = snapshot.data;
              if (!snapshot.hasData || snapshot.data.isEmpty)
                return Center(child: CircularProgressIndicator());
              else
                return Scrollbar(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, i) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.blockSizeHorizontal * 5,
                            vertical: SizeConfig.blockSizeVertical * 0.7),
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: 'Call',
                              color: Colors.green,
                              icon: Icons.call,
                              onTap: () => call(hospitals[i].mobile),
                            ),
                            IconSlideAction(
                              caption: 'Get Directions',
                              color: Colors.red,
                              icon: Icons.directions,
                              onTap: () => navigate(hospitals[i].latitude,
                                  hospitals[i].longitude),
                            ),
                          ],
                          child: Container(
                            color:
                                configBloc.darkOn ? Colors.black : Colors.white,
                            child: ListTile(
                              onTap: () {},
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 2.0),
                              title: AutoSizeText(
                                hospitals[i].name,
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.safeBlockHorizontal * 4),
                              ),
                              leading: CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/images/background.jpg"),
                              ),
                              subtitle: AutoSizeText(
                                "${hospitals[i].district}, ${hospitals[i].state}",
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.safeBlockHorizontal * 3),
                              ),
                              trailing:
                                  AutoSizeText("${hospitals[i].index} km"),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: hospitals == null ? 0 : hospitals.length,
                  ),
                );
            },
          ),
        ),
      ),
    );
  }
}
