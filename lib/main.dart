import 'package:dhakalocalbus/datas/station_data.dart';
import 'package:dhakalocalbus/mainScreen/master_bus_route.screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() => runApp(CitySearchApp());

class CitySearchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: CitySearchScreen(),
    );
  }
}
class CitySearchScreen extends StatelessWidget {
  final List<String> cityNames = StationData.stationList;
      // Add your logic here, e.g., update state, call API, etc.


  @override
  Widget build(BuildContext context) {
    return const MasterBusRouteScreen();
  }
}
