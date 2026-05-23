import 'package:dhakalocalbus/datas/bus_change_data.dart';
import 'package:dhakalocalbus/datas/bus_data.dart';
import 'package:dhakalocalbus/datas/station_data.dart';
import 'package:dhakalocalbus/mainScreen/bus_segment_card.dart';
import 'package:dhakalocalbus/utils/app_constant.dart';
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
  Map<String, List<Bus>>? segmentToBuses;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-warm heavy static caches after first frame so startup is instant.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() {
        StationData.stationBusSets;   // builds Set<String> per station once
        BusChangeData.busRoutes;      // initializes the 334K-entry map once
      });
    });
  }

  Future<void> _handleCitySource(String city) async {
    final trimmed = city.trim();
    if (trimmed == source) return;
    source = trimmed;
    await _refreshRoutes();
  }

  Future<void> _handleCityDestination(String city) async {
    final trimmed = city.trim();
    if (trimmed == destination) return;
    destination = trimmed;
    await _refreshRoutes();
  }

  Future<void> _refreshRoutes() async {
    final bothValid = StationData.stationSet.contains(source) &&
        StationData.stationSet.contains(destination);

    if (!bothValid) {
      final hadResults = directBuses.isNotEmpty ||
          advancedRoute != null ||
          segmentToBuses != null;
      if (hadResults) {
        setState(() {
          directBuses = [];
          advancedRoute = null;
          segmentToBuses = null;
        });
      }
      return;
    }

    setState(() => _isLoading = true);

    // Yield to the UI so the spinner renders before we do heavy work.
    await Future.microtask(_computeRoutes);

    if (mounted) setState(() => _isLoading = false);
  }

  void _computeRoutes() {
    final sourceBusSet = StationData.stationBusSets[source];
    final destBusSet = StationData.stationBusSets[destination];

    if (sourceBusSet != null && destBusSet != null) {
      final commonBusNames = sourceBusSet.intersection(destBusSet);
      directBuses = commonBusNames
          .where((name) => BusData.buses.containsKey(name))
          .map((name) => BusData.buses[name]!)
          .toList();
    } else {
      directBuses = [];
    }

    if (directBuses.isNotEmpty) {
      advancedRoute = null;
      segmentToBuses = null;
      return;
    }

    // No direct buses — check transfer routes.
    final key = '${source!.toLowerCase()}_${destination!.toLowerCase()}';
    final route = BusChangeData.busRoutes[key];

    if (route != null) {
      final segmentBuses = <String, List<Bus>>{};
      for (int i = 0; i < route.length - 1; i++) {
        final segmentKey = '${route[i]} to ${route[i + 1]}';
        segmentBuses[segmentKey] =
            StationData.getBusesForSegment(route[i], route[i + 1]);
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
      backgroundColor: const Color(0xFFF8F0F0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppConstant.appMainColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CityAutocomplete(
                      cityNames: StationData.stationList,
                      onCitySelected: _handleCitySource,
                      title: "Your location",
                    ),
                    const SizedBox(height: 10),
                    CityAutocomplete(
                      cityNames: StationData.stationList,
                      onCitySelected: _handleCityDestination,
                      title: "Your Destination",
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  color: AppConstant.appMainColor,
                  strokeWidth: 3,
                ),
              ),
            )
          else if (source != null && destination != null) ...[
            if (directBuses.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: directBuses.length,
                  itemBuilder: (context, index) {
                    final bus = directBuses[index];
                    return GestureDetector(
                      onTap: () => Get.to(() => BusDetails(
                          bus: bus, source: source, destination: destination)),
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 14),
                        elevation: 2,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 14),
                          leading: CircleAvatar(
                            backgroundColor: AppConstant.appSecondaryColor
                                .withValues(alpha: 0.15),
                            radius: 22,
                            child: const Icon(
                              Icons.directions_bus,
                              color: AppConstant.appSecondaryColor,
                              size: 24,
                            ),
                          ),
                          title: Text(
                            bus.busName,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                Text(bus.routes[0],
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600)),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4),
                                  child: Icon(Icons.compare_arrows,
                                      size: 16,
                                      color: AppConstant.appSecondaryColor),
                                ),
                                Text(bus.routes[bus.routes.length - 1],
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600)),
                              ],
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: AppConstant.appSecondaryColor,
                            size: 18,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            else if (advancedRoute != null && segmentToBuses != null)
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: segmentToBuses!.keys.length,
                  itemBuilder: (context, index) {
                    final segment = segmentToBuses!.keys.elementAt(index);
                    return BusSegmentCard(
                      segment: segment,
                      buses: segmentToBuses![segment]!,
                    );
                  },
                ),
              )
            else
              const Expanded(
                child: Center(
                  child: Text(
                    'No routes available for this selection.',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
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
