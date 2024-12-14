// import 'package:dhakalocalbus/datas/bus_change_data.dart';
// import 'package:dhakalocalbus/datas/bus_model.dart';
// import 'package:flutter/material.dart';

// import '../datas/station_data.dart';
// import '../search_field.dart';

// class AdvancedBusRoute extends StatefulWidget {
//   const AdvancedBusRoute({super.key});

//   @override
//   State<AdvancedBusRoute> createState() => _AdvancedBusRouteState();
// }

// class _AdvancedBusRouteState extends State<AdvancedBusRoute> {
//   String? source, destination;
//   List<String>? displayedRoute;
//   Map<String, List<Bus>>? segmentToBuses = {}; // Map for buses in each segment

//   /// Updates the displayed route and fetch buses for each segment
//   void updateDisplayedRoute() {
//     if (source != null && destination != null) {
//       final key = '${source!.toLowerCase()}_${destination!.toLowerCase()}';
//       final route = BusChangeData.busRoutes[key];

//       if (route != null) {
//         final segmentBuses = <String, List<Bus>>{};

//         for (int i = 0; i < route.length - 1; i++) {
//           final segmentKey = '${route[i]} to ${route[i + 1]}';

//           final buses = StationData.getBusesForSegment(route[i], route[i + 1]);
//           segmentBuses[segmentKey] = buses;
//         }

//         setState(() {
//           displayedRoute = route;
//           segmentToBuses = segmentBuses;
//         });
//       } else {
//         setState(() {
//           displayedRoute = null;
//           segmentToBuses = null;
//         });
//       }
//     } else {
//       setState(() {
//         displayedRoute = null;
//         segmentToBuses = null;
//       });
//     }
//   }

//   /// Handle source selection
//   void handleCitySource(String city) {
//     setState(() {
//       source = city;
//       updateDisplayedRoute();
//     });
//   }

//   /// Handle destination selection
//   void handleCityDestination(String city) {
//     setState(() {
//       destination = city;
//       updateDisplayedRoute();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Advanced Bus Route'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CityAutocomplete(
//               cityNames: StationData.stationList,
//               onCitySelected: handleCitySource,
//               title: "Your location",
//             ),
//             const SizedBox(height: 20),

//             CityAutocomplete(
//               cityNames: StationData.stationList,
//               onCitySelected: handleCityDestination,
//               title: "Your Destination",
//             ),
//             const SizedBox(height: 20),

//             // Display the bus route with buses in each segment
//             if (source != null && destination != null) ...[
//               if (displayedRoute != null && segmentToBuses != null)
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: segmentToBuses!.keys.length,
//                     itemBuilder: (context, index) {
//                       final segment = segmentToBuses!.keys.elementAt(index);
//                       final buses = segmentToBuses![segment]!;

//                       return Card(
//                         elevation: 3,
//                         margin: const EdgeInsets.symmetric(vertical: 8),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 segment,
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               if (buses.isNotEmpty)
//                                 ...buses.map((bus) => ListTile(
//                                       leading: const Icon(Icons.directions_bus),
//                                       title: Text(
//                                         bus.busName,
//                                         style: const TextStyle(fontSize: 16),
//                                       ),
//                                     ))
//                               else
//                                 const Text(
//                                   'No buses available for this segment.',
//                                   style: TextStyle(fontSize: 14, color: Colors.grey),
//                                 )
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 )
//               else
//                 const Center(
//                   child: Text(
//                     'No routes available for this selection.',
//                     style: TextStyle(fontSize: 16, color: Colors.red),
//                   ),
//                 ),
//             ] else
//               const Expanded(
//                 child: Center(
//                   child: Text(
//                     'Select source and destination to find routes.',
//                     style: TextStyle(fontSize: 16, color: Colors.grey),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

