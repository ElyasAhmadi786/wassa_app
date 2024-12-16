// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class AddressPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("WASSA Office Location"),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: LatLng(34.3529, 62.2041), // مختصات هرات
//           zoom: 15,
//         ),
//         markers: {
//           Marker(
//             markerId: MarkerId("wassa_office"),
//             position: LatLng(34.3529, 62.2041),
//             infoWindow: InfoWindow(
//               title: "WASSA Office",
//               snippet: "Herat, Afghanistan",
//             ),
//           ),
//         },
//       ),
//     );
//   }
// }
// File: address.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressPage extends StatelessWidget {
  final Map<String, dynamic> data;
  AddressPage({required this.data, required String language, required bool isDarkMode});

  @override
  Widget build(BuildContext context) {
    final location = data['location'] ?? {'latitude': 0.0, 'longitude': 0.0};
    final LatLng position = LatLng(location['latitude'], location['longitude']);

    return Scaffold(
      appBar: AppBar(title: Text(data['title_en'] ?? "Address")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: position,
          zoom: 14,
        ),
        markers: {
          Marker(
            markerId: MarkerId("office"),
            position: position,
          )
        },
      ),
    );
  }
}
