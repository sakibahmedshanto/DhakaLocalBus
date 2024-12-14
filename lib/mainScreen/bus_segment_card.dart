import 'package:dhakalocalbus/utils/app_constant.dart';
import 'package:flutter/material.dart';
import '../datas/bus_model.dart';
import 'bus_details.dart'; // Assuming this is the file where bus details screen is defined

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
    // Split the segment by ' to '
    List<String> splitSegment = segment.split(' to ');

    // Capitalize the first letter of each part
    String src = capitalizeWords(splitSegment[0]);
    String dest = capitalizeWords(splitSegment[1]);

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the capitalized segment with improved styling
            Center(
              child: Text(
                '$src to $dest',
                style:const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 8, 118, 132),
                  
                ),
                softWrap: true,
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
              height: 20,
            ),
            const SizedBox(height: 12),

            // Display buses in the segment
            if (buses.isNotEmpty)
              ...buses.map((bus) => GestureDetector(
                    onTap: () {
                      // Navigate to the BusDetails page when a bus tile is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BusDetails(
                            bus: bus,
                            source: src,  // Pass source if needed
                            destination: dest,  // Pass destination if needed
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child:const Icon(
                            Icons.directions_bus,
                            color:Color.fromARGB(255, 6, 121, 134),
                          ),
                        ),
                        title: Text(
                          bus.busName,
                          style:const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing:const Icon(
                          Icons.arrow_forward_ios,
                          color:AppConstant.appSecondaryColor,
                          size: 18,
                        ),
                        tileColor: Colors.blue.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ))
            else
              Text(
                'No buses available for this segment.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
          ],
        ),
      ),
    );
  }

String capitalizeWords(String text) {
  if (text.isEmpty) return text;
  
  // Split the string into words, capitalize each word, and join them back
  return text
      .split(' ')
      .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
      .join(' ');
}
  // Helper function to capitalize the first letter of a string
 
}
