import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hospital_finder/notifiers/config_notifier.dart';
import 'package:hospital_finder/utils/tools.dart';
import 'package:provider/provider.dart';

class DoctorsList extends StatefulWidget {
  @override
  _DoctorsListState createState() => _DoctorsListState();
}

class _DoctorsListState extends State<DoctorsList> {
  @override
  Widget build(BuildContext context) {
    ConfigBloc configBloc = Provider.of<ConfigBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Doctors"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {})
        ],
      ),
      body: ListView(
        children: <Widget>[
          DoctorCard(
            configBloc: configBloc,
            name: "Dr. Ritesh",
            address: "Vasant Kunj, Ritesh Dental Clinic",
            isFemale: false,
            rating: "99%",
            feedback: "88",
            fee: "500",
          ),
          DoctorCard(
            configBloc: configBloc,
            name: "Dr. Viraj Chopra",
            address: "New Friends Colony, VC Smile By Design",
            isFemale: true,
            rating: "98%",
            feedback: "21",
            fee: "500",
          ),
          DoctorCard(
            configBloc: configBloc,
            name: "Dr. Prashant Nanda",
            address: "Defence Colony, Nanda Dental Clinic",
            isFemale: false,
            rating: "98%",
            feedback: "115",
            fee: "500",
          ),
          DoctorCard(
            configBloc: configBloc,
            name: "Dr. Archana Bhardwaj",
            address: "South Extension 1, Abhirachna Dental",
            isFemale: true,
            rating: "99%",
            feedback: "71",
            fee: "500",
          ),
          DoctorCard(
            configBloc: configBloc,
            name: "Dr. Manav Kalra",
            address: "Defense Colony, Kalra Dental Clinic",
            isFemale: false,
            rating: "95%",
            feedback: "94",
            fee: "500",
          )
        ],
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    Key key,
    @required this.configBloc,
    @required this.isFemale,
    @required this.name,
    @required this.address,
    @required this.rating,
    @required this.feedback,
    @required this.fee,
  }) : super(key: key);

  final ConfigBloc configBloc;
  final bool isFemale;
  final String name;
  final String address;
  final String rating;
  final String feedback;
  final String fee;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20, left: 60, right: 20),
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: configBloc.darkOn
                  ? Tools.hexToColor("#1f2124")
                  : Colors.white,
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
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.only(left: 80, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AutoSizeText(
                        name,
                        maxLines: 2,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            fontSize: 18),
                      ),
                      SizedBox(height: 5),
                      AutoSizeText(
                        address,
                        maxLines: 2,
                        style: TextStyle(fontSize: 13),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.thumb_up,
                            color: Colors.green,
                            size: 15,
                          ),
                          SizedBox(width: 5),
                          Text(
                            rating,
                            style: TextStyle(color: Colors.green, fontSize: 12),
                          ),
                          SizedBox(width: 5),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Container(
                              height: 5,
                              width: 5,
                              decoration: BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle),
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "$feedback Feedback",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Consulation fee: \$$fee",
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 8),
            width: 100,
            margin: EdgeInsets.only(top: 40, left: 20, bottom: 40),
            decoration: BoxDecoration(
              color: configBloc.darkOn ? Colors.black : Colors.blue[200],
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
            child: SvgPicture.asset(!isFemale
                ? "assets/images/male_doctor.svg"
                : "assets/images/female_doctor.svg"),
          )
        ],
      ),
    );
  }
}
