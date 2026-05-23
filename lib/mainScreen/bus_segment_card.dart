import 'package:dhakalocalbus/utils/app_constant.dart';
import 'package:flutter/material.dart';
import '../datas/bus_model.dart';
import 'bus_details.dart';

class BusSegmentCard extends StatelessWidget {
  final String segment;
  final List<Bus> buses;

  const BusSegmentCard({
    super.key,
    required this.segment,
    required this.buses,
  });

  @override
  Widget build(BuildContext context) {
    List<String> splitSegment = segment.split(' to ');
    String src = capitalizeWords(splitSegment[0]);
    String dest = capitalizeWords(splitSegment[1]);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                '$src to $dest',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.appSecondaryColor,
                ),
                softWrap: true,
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 0.5,
              height: 18,
            ),
            if (buses.isNotEmpty)
              ...buses.map((bus) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BusDetails(
                            bus: bus,
                            source: src,
                            destination: dest,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      color: AppConstant.appSecondaryColor.withValues(alpha: 0.08),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              AppConstant.appSecondaryColor.withValues(alpha: 0.2),
                          child: const Icon(
                            Icons.directions_bus,
                            color: AppConstant.appSecondaryColor,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          bus.busName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: AppConstant.appSecondaryColor,
                          size: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ))
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No buses available for this segment.',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}
