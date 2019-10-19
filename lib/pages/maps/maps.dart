import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hospital_finder/notifiers/index.dart';
import 'package:hospital_finder/utils/HFscaffold.dart';
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

  @override
  void initState() {
    super.initState();
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
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
                target: LatLng(37.42796133580664, -122.085749655962),
                zoom: 14.0),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              isMapCreated = true;
              changeMapMode();
              setState(() {});
            },
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
}
