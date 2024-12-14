import 'package:dhakalocalbus/datas/bus_change_data.dart';
import 'package:dhakalocalbus/datas/bus_data.dart';
import 'package:dhakalocalbus/datas/station_data.dart';
import 'package:dhakalocalbus/mainScreen/bus_segment_card.dart';
import 'package:flutter/material.dart';
import 'package:dhakalocalbus/datas/bus_model.dart';
import 'package:dhakalocalbus/search_field.dart';
import 'package:get/get.dart';

import 'bus_details.dart';

class MasterBusRouteScreen extends StatefulWidget {
  const MasterBusRouteScreen({super.key});

  @override
  State<MasterBusRouteScreen> createState() => _MasterBusRouteScreenState();
}

class _MasterBusRouteScreenState extends State<MasterBusRouteScreen> {
  String? source, destination;
  List<Bus> directBuses = [];
  List<String>? advancedRoute;
  Map<String, List<Bus>>? segmentToBuses = {};
  Set<String> stationSet = Set.from(StationData.stationList);

  bool checkExactMatch(Set<String> stationSet, String? destination) {
    return stationSet.contains(destination);
  }

  void handleCitySource(String city) {
    setState(() {
      source = city;
      updateRoutes();
    });
  }

  void handleCityDestination(String city) {
    setState(() {
      destination = city;
      updateRoutes();
    });
  }

  void updateRoutes() {
    if (checkExactMatch(stationSet, destination) &&
        checkExactMatch(stationSet, source)) {
      updateDirectBuses();

      if (directBuses.isEmpty) {
        updateAdvancedRoute();
      } else {
        advancedRoute = null;
        segmentToBuses = null;
      }
    } else {
      directBuses = [];
      advancedRoute = null;
      segmentToBuses = null;
    }
  }

  void updateDirectBuses() {
    if (StationData.stationMap.containsKey(source)) {
      final sourceBusNames = StationData.stationMap[source] ?? [];
      final destinationBusNames = StationData.stationMap[destination] ?? [];
      final commonBusNames =
          sourceBusNames.toSet().intersection(destinationBusNames.toSet());

      directBuses = commonBusNames.map((name) => BusData.buses[name]!).toList();
    } else {
      directBuses = [];
    }
  }

  void updateAdvancedRoute() {
    final key = '${source!.toLowerCase()}_${destination!.toLowerCase()}';
    final route = BusChangeData.busRoutes[key];

    if (route != null) {
      final segmentBuses = <String, List<Bus>>{};

      for (int i = 0; i < route.length - 1; i++) {
        final segmentKey = '${route[i]} to ${route[i + 1]}';
        final buses = StationData.getBusesForSegment(route[i], route[i + 1]);
        segmentBuses[segmentKey] = buses;
      }

      advancedRoute = route;
      segmentToBuses = segmentBuses;
    } else {
      advancedRoute = null;
      segmentToBuses = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 6, 133, 147),
                    Color.fromARGB(255, 32, 172, 165),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              const  SizedBox(height: 40,),

                // Autocomplete for source city
                CityAutocomplete(
                  cityNames: StationData.stationList,
                  onCitySelected: handleCitySource,
                  title: "Your location",
                ),
                const SizedBox(height: 10),

                // Autocomplete for destination city
                CityAutocomplete(
                  cityNames: StationData.stationList,
                  onCitySelected: handleCityDestination,
                  title: "Your Destination",
                ),
              ],
            ),
          ),
     
          if (source != null && destination != null) ...[
            if (directBuses.isNotEmpty) ...[

              // List of direct buses
              Expanded(
                child: ListView.builder(
                  itemCount: directBuses.length,
                  itemBuilder: (context, index) {
                    final bus = directBuses[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => BusDetails(
                            bus: bus,
                            source: source,
                            destination: destination));
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading:const Icon(
                            Icons.directions_bus,
                            color: Color.fromARGB(255, 6, 121, 134),
                            size: 30,
                          ),
                          title: Text(
                            bus.busName,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                '${bus.routes[0]}  ',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade600),
                              ),
                             const Icon(Icons.compare_arrows, size: 20, color:  Color.fromARGB(255, 6, 121, 134)),
                              Text(
                                ' ${bus.routes[bus.routes.length - 1]}',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade600),
                              )
                            ],
                          ),
                          trailing:const Icon(
                            Icons.arrow_forward_ios,
                            color:   Color.fromARGB(255, 6, 121, 134),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ] else if (advancedRoute != null && segmentToBuses != null) ...[

              // List of bus segments for advanced route
              Expanded(
                child: ListView.builder(
                  itemCount: segmentToBuses!.keys.length,
                  itemBuilder: (context, index) {
                    final segment = segmentToBuses!.keys.elementAt(index);
                    final buses = segmentToBuses![segment]!;

                    return BusSegmentCard(
                      segment: segment,
                      buses: buses,
                    // Pass destination dynamically
                    );
                  },
                ),
              ),
            ] else ...[
              const Center(
                child: Text(
                  'No routes available for this selection.',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ] else
            const Expanded(
              child: Center(
                child: Text(
                  'Select source and destination to find routes.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
