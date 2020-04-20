import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hospital_finder/config/size_config.dart';
import 'package:hospital_finder/models/hospital.dart';
import 'package:hospital_finder/notifiers/index.dart';
import 'package:hospital_finder/utils/call.dart';
import 'package:hospital_finder/utils/loadData.dart';
import 'package:hospital_finder/utils/navigation.dart';
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
            height: Curves.easeInOut.transform(value) * 145.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
        onTap: () {
          // moveCamera();
        },
        child: Container(
          decoration: BoxDecoration(
            color: _configBloc.darkOn ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: new Offset(0.0, 10.0),
                  spreadRadius: 5),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 3,
                ),
                AutoSizeText(
                  hospitals[index].name,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
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
                  height: SizeConfig.blockSizeVertical * 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.call,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        call(hospitals[index].mobile);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.directions,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        navigate(hospitals[index].latitude,
                            hospitals[index].longitude);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
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
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        GoogleMap(
          mapType: MapType.normal,
          compassEnabled: false,
          zoomGesturesEnabled: true,
          markers: Set.from(allMarkers),
          initialCameraPosition: CameraPosition(
              target: LatLng(28.5068374, 77.0485119), zoom: 14.0),
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
            print("created");

            changeMapMode();
            setState(() {
              isMapCreated = true;
            });
          },
        ),
        Positioned(
          bottom: 30.0,
          child: Container(
              height: 200.0,
              width: MediaQuery.of(context).size.width,
              child: PageView.builder(
                controller: _pageController,
                itemCount: hospitals.length,
                itemBuilder: (BuildContext context, int index) {
                  return _hospitalList(index);
                },
              )),
        ),
        Positioned(
          top: 30.0,
          left: 10.0,
          right: 10.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              IconButton(
                icon: Icon(
                  configBloc.darkOn
                      ? FontAwesomeIcons.moon
                      : FontAwesomeIcons.solidMoon,
                  size: 18,
                ),
                onPressed: () {
                  configBloc.reverseDarkMode();
                },
              )
            ],
          ),
        )
      ],
    ));
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
      allMarkers.add(
        Marker(
          markerId: MarkerId(element.name),
          draggable: false,
          infoWindow: InfoWindow(title: element.name, snippet: element.address),
          position: LatLng(
            double.parse(element.latitude),
            double.parse(element.longitude),
          ),
        ),
      );
    });
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
  }
}
