import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  final List<double> listLatLong;

  MapScreen(this.listLatLong);

  @override
  Widget build(BuildContext context) {
    // Khởi tạo vị trí ban đầu của camera
    final CameraPosition _kInitialPosition = CameraPosition(
      target: LatLng(listLatLong[0], listLatLong[1]),
      zoom: 14.0, // Bạn có thể điều chỉnh mức zoom theo ý muốn
    );

    // Tạo marker
    final Marker _marker = Marker(
      markerId: MarkerId('marker_1'),
      position: LatLng(listLatLong[0], listLatLong[1]),
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.2,
      child: GoogleMap(
        initialCameraPosition: _kInitialPosition,
        markers: {_marker},
      ),
    );
  }
}
