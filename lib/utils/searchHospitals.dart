import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hospital_finder/config/size_config.dart';
import 'package:hospital_finder/models/index.dart';
import 'package:hospital_finder/utils/call.dart';
import 'package:hospital_finder/utils/loadHospitals.dart';
import 'package:hospital_finder/utils/navigation.dart';

class SearchHospitalsDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.close,
        ),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        // color: Colors.black,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> mylist = ["dsfgsdg", "dgdagda", "dgsdgsd", "dagadg"];
    return FutureBuilder(
      future: loadHospitals(),
      builder: (context, snapshot) {
        List<Hospital> hospitals = snapshot.data;
        List<Hospital> filteredList;
        if (query != "") {
          filteredList = hospitals
              .where((hospital) =>
                  hospital.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
        } else {
          filteredList = hospitals;
        }

        if (!snapshot.hasData || snapshot.data.isEmpty)
          return Center(child: CircularProgressIndicator());
        else
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, i) {
              return Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: 'Call',
                    color: Colors.green,
                    icon: Icons.call,
                    onTap: () => call(filteredList[i].mobile),
                  ),
                  IconSlideAction(
                    caption: 'Get Directions',
                    color: Colors.red,
                    icon: Icons.directions,
                    onTap: () => navigate(
                        filteredList[i].latitude, filteredList[i].longitude),
                  ),
                ],
                child: Container(
                  // color:
                  //     configBloc.darkOn ? Colors.black : Colors.white,
                  child: ListTile(
                    onTap: () {},
                    contentPadding: EdgeInsets.symmetric(horizontal: 2.0),
                    title: RichText(
                      text: TextSpan(
                          text: filteredList[i].name.substring(0, query.length),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          children: [
                            TextSpan(
                                text: filteredList[i]
                                    .name
                                    .substring(query.length),
                                style: TextStyle(color: Colors.grey))
                          ]),
                    ),
                    leading: CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/images/background.jpg"),
                    ),
                    subtitle: AutoSizeText(
                      "${filteredList[i].district}, ${filteredList[i].state}",
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 3),
                    ),
                    trailing: AutoSizeText("${filteredList[i].index} km"),
                  ),
                ),
              );
            },
            itemCount: filteredList.length,
          );
      },
    );
  }
}
