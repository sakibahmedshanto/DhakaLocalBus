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
    int? sourceIndex = bus.routes.indexOf(source ?? '');
    int? destinationIndex = bus.routes.indexOf(destination ?? '');

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
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            'Source or Destination not found',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    List<String> filteredRoutes = [];
    if (sourceIndex < destinationIndex) {
      filteredRoutes = bus.routes.sublist(sourceIndex, destinationIndex + 1);
    } else {
      filteredRoutes =
          bus.routes.sublist(destinationIndex, sourceIndex + 1).reversed.toList();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F0F0),
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
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Center(
                child: Icon(
                  Icons.directions_bus,
                  size: 64,
                  color: AppConstant.appMainColor,
                ),
              ),
              const SizedBox(height: 16),
              ...filteredRoutes.asMap().entries.map((entry) {
                int index = entry.key;
                String route = entry.value;

                Color tileColor = Colors.grey.shade100;
                Color textColor = Colors.grey.shade800;

                if (route == source) {
                  tileColor = AppConstant.appAccentColor;
                  textColor = Colors.white;
                } else if (route == destination) {
                  tileColor = AppConstant.appMainColor;
                  textColor = Colors.white;
                }

                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppConstant.appSecondaryColor
                          .withValues(alpha: 0.2),
                      radius: 16,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppConstant.appSecondaryColor,
                        ),
                      ),
                    ),
                    title: Text(
                      '$route${source == route ? " (You)" : ""}${destination == route ? " (Destination)" : ""}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    trailing: null,
                    tileColor: tileColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 12,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
