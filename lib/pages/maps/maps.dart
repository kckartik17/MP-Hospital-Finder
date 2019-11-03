import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hospital_finder/config/size_config.dart';
import 'package:hospital_finder/models/hospital.dart';
import 'package:hospital_finder/notifiers/index.dart';
import 'package:hospital_finder/utils/HFscaffold.dart';
import 'package:hospital_finder/utils/loadHospitals.dart';
import 'package:provider/provider.dart';

class HospitalListMap extends StatefulWidget {
  static const String routeName = "/maps";
  @override
  _HospitalListMapState createState() => _HospitalListMapState();
}

class _HospitalListMapState extends State<HospitalListMap> {
  GoogleMapController _controller;
  ConfigBloc _configBloc;
  bool isMapCreated = false;
  List<Marker> allMarkers = [];

  PageController _pageController;
  List<Hospital> hospitals;

  int prevPage;

  @override
  void initState() {
    super.initState();

    loadHospitalList();
  }

  void _onScroll() {
    if (_pageController.page.toInt() != prevPage) {
      prevPage = _pageController.page.toInt();
      moveCamera();
    }
  }

  _hospitalList(index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 125.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
        onTap: () {
          // moveCamera();
        },
        child: Stack(
          children: <Widget>[
            Container(
              margin:
                  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 10),
              height: SizeConfig.blockSizeVertical * 18,
              width: SizeConfig.blockSizeHorizontal * 80,
              decoration: BoxDecoration(
                color: _configBloc.darkOn ? Colors.black : Colors.white,
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
              child: Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal * 15,
                    right: SizeConfig.blockSizeHorizontal * 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 3,
                    ),
                    Text(
                      hospitals[index].name,
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
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
                              "2.1 km",
                              style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              size: SizeConfig.blockSizeHorizontal * 3,
                            ),
                            SizedBox(
                              width: 3.0,
                            ),
                            Text(
                              "${hospitals[index].district}",
                              style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Fluttertoast.showToast(
                                msg: "Call",
                                gravity: ToastGravity.BOTTOM,
                                toastLength: Toast.LENGTH_SHORT);
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.call,
                                size: SizeConfig.blockSizeHorizontal * 3,
                                color: Colors.green,
                              ),
                              SizedBox(
                                width: 3.0,
                              ),
                              Text(
                                "Call",
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.safeBlockHorizontal * 3,
                                    color: Colors.green),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Fluttertoast.showToast(
                                msg: "Get Directions",
                                gravity: ToastGravity.BOTTOM,
                                toastLength: Toast.LENGTH_SHORT);
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.directions,
                                size: SizeConfig.blockSizeHorizontal * 3,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 3.0,
                              ),
                              Text(
                                "Get Directions",
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.safeBlockHorizontal * 3,
                                    color: Colors.red),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: SizeConfig.blockSizeVertical * 4,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ConfigBloc configBloc = Provider.of<ConfigBloc>(context);
    setState(() {
      _configBloc = configBloc;
    });
    if (isMapCreated) {
      changeMapMode();
    }
    return HFscaffold(
      title: "Hospitals",
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            markers: Set.from(allMarkers),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
                target: LatLng(28.5068374, 77.0485119), zoom: 14.0),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              isMapCreated = true;
              changeMapMode();
              setState(() {});
            },
          ),
          Positioned(
            bottom: 20.0,
            child: Container(
              height: 200.0,
              width: MediaQuery.of(context).size.width,
              child: PageView.builder(
                controller: _pageController,
                itemCount: hospitals.length,
                itemBuilder: (BuildContext context, int index) {
                  return _hospitalList(index);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  changeMapMode() {
    if (_configBloc.darkOn) {
      getJsonFile("assets/nightmode.json").then(setMapStyle);
    } else {
      getJsonFile("assets/daymode.json").then(setMapStyle);
    }
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    _controller.setMapStyle(mapStyle);
  }

  moveCamera() {
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
              double.parse(hospitals[_pageController.page.toInt()].latitude),
              double.parse(hospitals[_pageController.page.toInt()].longitude),
            ),
            zoom: 14.0,
            bearing: 45.0,
            tilt: 45.0),
      ),
    );
  }

  Future loadHospitalList() async {
    List<Hospital> _hospitals = await loadHospitals();

    setState(() {
      hospitals = _hospitals;
    });
    hospitals.forEach((element) {
      allMarkers.add(Marker(
          markerId: MarkerId(element.name),
          draggable: false,
          infoWindow: InfoWindow(title: element.name, snippet: element.address),
          position: LatLng(double.parse(element.latitude),
              double.parse(element.longitude))));
    });
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
  }
}
