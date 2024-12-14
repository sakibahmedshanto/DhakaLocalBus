// import 'package:dhakalocalbus/datas/bus_model.dart';

// class Stations {
//   // Centralized buses map
//   static Map<String, Bus> buses = {
//     'Achim Paribahan': Bus(
//       busName: 'Achim Paribahan',
//       routes: [
//         'Gabtoli',
//         'Technical',
//         'Ansar Camp',
//         'Mirpur 1',
//         'Sony Cinema Hall',
//         'Mirpur 2',
//         'Mirpur 10',
//         'Mirpur 11',
//         'Purobi',
//         'Kalshi',
//         'ECB Square',
//         'MES',
//         'Shewra',
//         'Kuril',
//         'Bishwa Road',
//         'Jamuna Future Park',
//         'Bashundhara',
//         'Nadda',
//         'Notun Bazar',
//         'Shahjadpur',
//         'Uttar Badda',
//         'Badda',
//         'Madhya Badda',
//         'Merul',
//         'Rampura Bridge',
//         'Banarse',
//         'Demra Staff Quarter'
//       ],
//       times: null,
//     ),
//     'Agradut': Bus(
//       busName: 'Agradut',
//       routes: [
//         'Hemayetpur',
//         'Amin Bazar',
//         'Gabtoli',
//         'Technical',
//         'Kallyanpur',
//         'Shyamoli',
//         'Shishu Mela',
//         'Agargaon',
//         'Zia Uddyan',
//         'Bipy Sarani',
//         'Jahangir Gate',
//         'Mohakhali',
//         'Wireless',
//         'Gulshan 1',
//         'Badda Link Road',
//         'Bashltola',
//         'Shahjadpur',
//         'Uttar Badda',
//         'Notun Bazar'
//       ],
//       times: null,
//     ),
//     'Active Paribahan': Bus(
//       busName: 'Active Paribahan',
//       routes: [
//         'Shia Masjid',
//         'Adabor',
//         'Shyamoli',
//         'Technical',
//         'Ansar Camp',
//         'Mirpur 1',
//         'Sony Cinema Hall',
//         'Mirpur 2',
//         'Mirpur 10',
//         'Mirpur 11',
//         'Purobi',
//         'Kalshi',
//         'ECB Square',
//         'MES',
//         'Shewra',
//         'Kuril Bishwa Road',
//         'Khilkhet',
//         'Airport',
//         'Jashimuddin',
//         'Rajlakshmi',
//         'Azampur',
//         'House Building',
//         'Abdullahpur'
//       ],
//       times: null,
//     ),
//   };

  
//   static Map<String, List<String>> stationMap = {
//     'Gabtoli': ['Achim Paribahan', 'Agradut'],
//     'Technical': ['Achim Paribahan', 'Active Paribahan'],
//     // Add other stations and their bus names
//   };

//   // Station list
//   static const List<String> stationList = [
//     'Gabtoli',
//     'Technical',
//     'Ansar Camp',
//     'Mirpur 1',
//     'Mirpur 2',
//     'Sony Cinema Hall',
//     'Mirpur 10',
//     'Mirpur 11',
//     'Purobi',
//     'Kalshi',
//     'ECB Square',
//     'MES',
//     'Shewra',
//     'Kuril',
//     'Bishwa Road',
//     'Jamuna Future Park',
//     'Bashundhara',
//     'Nadda',
//     'Notun Bazar',
//     'Shahjadpur',
//     'Uttar Badda',
//     'Badda',
//     'Madhya Badda',
//     'Merul',
//     'Rampura Bridge',
//     'Banarse',
//     'Demra Staff Quarter',
//     'Shia Masjid',
//     'Adabor',
//     'Shyamoli',
//     'House Building',
//     'Abdullahpur'
//   ];

//   // Helper method to get buses for a station
//   static List<Bus> getBusesForStation(String station) {
//     return stationMap[station]?.map((busName) => buses[busName]!).toList() ?? [];
//   }
// }
