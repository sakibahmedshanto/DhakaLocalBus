// import 'package:dhakalocalbus/datas/bus_data.dart';
// import 'package:dhakalocalbus/datas/station_data.dart';
// import 'package:dhakalocalbus/mainScreen/bus_tiles.dart';
// import 'package:flutter/material.dart';
// import 'package:dhakalocalbus/datas/bus_model.dart';
// import 'package:dhakalocalbus/search_field.dart';
// import 'package:get/get.dart';

// import 'bus_details.dart';  // Add the import for the details screen

// class MainScreen extends StatefulWidget {
//   MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   String? source, destination;
//   List<Bus> displayedBuses = [];

//   void handleCitySource(String city) {
//     setState(() {
//       source = city;
//       destination = null; // Reset destination when source is selected
//       updateBusesForSource(city);
//     });
//   }

//   void handleCityDestination(String city) {
//     setState(() {
//       destination = city;
//       updateCommonBuses();
//     });
//   }

//   void updateBusesForSource(String city) {
//     if (StationData.stationMap.containsKey(city)) {
//       final busNames = StationData.stationMap[city] ?? [];
//       displayedBuses = busNames.map((name) => BusData.buses[name]!).toList();
//     } else {
//       displayedBuses = [];
//     }
//   }

//   void updateCommonBuses() {
//     if (source != null && destination != null) {
//       final sourceBusNames = StationData.stationMap[source] ?? [];
//       final destinationBusNames = StationData.stationMap[destination] ?? [];
//       final commonBusNames = sourceBusNames.toSet().intersection(destinationBusNames.toSet());
//       displayedBuses = commonBusNames.map((name) => BusData.buses[name]!).toList();
//     } else {
//       displayedBuses = [];
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Local Bus Route'),
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
//             SizedBox(height: 20),
//             if (destination == source && destination != null) ...[
//               const Text(
//                 'Source and Destination cannot be the same',
//                 style: TextStyle(fontSize: 16, color: Colors.red),
//               ),
//               SizedBox(height: 10),
//             ] else if (source != null && destination == null) ...[
//               Text(
//                 'Buses departing from $source:',
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//             ] else if (source != null && destination != null) ...[
//               Text(
//                 'Common Buses between $source and $destination:',
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//             ],
//             if (source != destination)
//               Expanded(
//                 child: displayedBuses.isNotEmpty
//                     ? ListView.builder(
//                         itemCount: displayedBuses.length,
//                         itemBuilder: (context, index) {
//                           final bus = displayedBuses[index];
//                           return GestureDetector(
//                             onTap: () {
//                               Get.to(()=>BusDetails(bus: bus, source: source, destination: destination)); // Navigate to the details screen
//                             },
//                             child: BusTiles(bus: bus),
//                           );
//                         },
//                       )
//                     : Text(
//                         source == null
//                             ? 'Select a source to see available buses.'
//                             : (destination == null
//                                 ? 'No buses available'
//                                 : 'No bus available in this route'),
//                         style: const TextStyle(fontSize: 16, color: Colors.red),
//                       ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
