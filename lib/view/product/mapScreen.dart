import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';

class MapScreen extends StatelessWidget {
  final List<double> listLatLong;

  const MapScreen(this.listLatLong, {super.key});

  @override
  Widget build(BuildContext context) {
    final CameraPosition kInitialPosition = CameraPosition(
      target: LatLng(listLatLong[0], listLatLong[1]),
      zoom: 14.0,
    );

    // Tạo marker
    final Marker marker = Marker(
      markerId: const MarkerId('marker_1'),
      position: LatLng(listLatLong[0], listLatLong[1]),
    );

    return SizedBox(
      width: context.mediaQueryWidth,
      height: MediaQuery.of(context).size.height * 0.2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GoogleMap(
          initialCameraPosition: kInitialPosition,
          markers: {marker},
        ),
      ),
    );
  }
}
