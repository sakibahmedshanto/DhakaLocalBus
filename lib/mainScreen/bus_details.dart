import 'package:dhakalocalbus/utils/app_constant.dart';
import 'package:flutter/material.dart';
import '../datas/bus_model.dart';

class BusDetails extends StatelessWidget {
  const BusDetails({
    super.key,
    required this.bus,
    required this.source,
    required this.destination,
  });

  final Bus bus;
  final String? source, destination;

  @override
  Widget build(BuildContext context) {
    // Find the index of source and destination in the bus routes
    int? sourceIndex = bus.routes.indexOf(source ?? '');
    int? destinationIndex = bus.routes.indexOf(destination ?? '');

    // If source or destination isn't found, return an empty list
    if (sourceIndex == -1 || destinationIndex == -1) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            bus.busName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppConstant.appMainColor,
          elevation: 1,
        ),
        body: const Center(
          child: Text(
            'Source or Destination not found',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    // Determine the range of indices from source to destination
    List<String> filteredRoutes = [];
    if (sourceIndex < destinationIndex) {
      filteredRoutes = bus.routes.sublist(sourceIndex, destinationIndex + 1);
    } else {
      filteredRoutes =
          bus.routes.sublist(destinationIndex, sourceIndex + 1).reversed.toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          bus.busName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppConstant.appMainColor,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
             const Center(
                child: Icon(
                  Icons.directions_bus,
                  size: 60,
                  color: AppConstant.appSecondaryColor,
                ),
              ),
              const SizedBox(height: 12),
              ...filteredRoutes.asMap().entries.map((entry) {
                int index = entry.key;
                String route = entry.value;

                // Define colors for source and destination
                Color routeColor = Colors.grey.shade700;
                Color tileColor = Colors.grey.shade100;

                if (route == source) {
                  routeColor = Colors.white;
                  tileColor = Colors.teal.shade400;
                } else if (route == destination) {
                  routeColor = Colors.white;
                  tileColor = Colors.teal.shade600;
                }

                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal.shade100,
                      radius: 14,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    title: Text(
                      '$route${source == route ? " (You)" : ""}${destination == route ? " (Destination)" : ""}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: routeColor,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.double_arrow,
                      size: 16,
                      color: Colors.teal,
                    ),
                    tileColor: tileColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 10,
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
