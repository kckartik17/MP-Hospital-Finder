import 'package:flutter/material.dart';
import 'package:hospital_finder/config/size_config.dart';
import 'package:hospital_finder/notifiers/index.dart';
import 'package:hospital_finder/pages/hospital_list/hospital_list_card.dart';
import 'package:hospital_finder/utils/HFscaffold.dart';
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
          color: configBloc.darkOn ? Colors.black : Colors.purple[200],
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: CustomScrollView(
                scrollDirection: Axis.vertical,
                slivers: <Widget>[
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 5,
                        vertical: SizeConfig.blockSizeVertical * 2),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (context, index) => HospitalListCard(),
                          childCount: 5),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
