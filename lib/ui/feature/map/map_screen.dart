// Example usage for FlutterFlow
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mvvm/ui/core/ui/widget/ff_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../../utils/cons/util_con.dart';
import '../../core/ui/widget/custom_map.dart';

class MapWidgetForFlutterFlow extends StatefulWidget {
  const MapWidgetForFlutterFlow({Key? key}) : super(key: key);

  @override
  State<MapWidgetForFlutterFlow> createState() =>
      _MapWidgetForFlutterFlowState();
}

class _MapWidgetForFlutterFlowState extends State<MapWidgetForFlutterFlow> {
  final driverLocation = const LatLng(-7.129337, 110.387355);
  List<RoutesStruct> routes = [];

  // Example data that would come from FlutterFlow parameters
  final List<MapDestination> destinations = [
    MapDestination(
      latitude: -7.129806599999999,
      longitude: 110.388832,
      title: "Destination 1",
      location: LatLng( -7.129806599999999,
        110.388832,)
    ),
    MapDestination(
      latitude: -7.1262384,
      longitude: 110.4099864,
      title: "Destination 2",
      location: LatLng(-7.1262384,
        110.4099864,)
    ),
  ];

  @override
  void initState()  {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      calculateRoutes(driverLocation, destinations[1].location!);
    });

  }

  Future<List<LatLng>> _getRoute(LatLng start, LatLng end) async {
    // Using Mapbox Directions API
    final String url = 'https://api.mapbox.com/directions/v5/mapbox/driving/'
        '${start.longitude},${start.latitude};${end.longitude},${end.latitude}'
        '?geometries=geojson&access_token=${MAP_BOX_API_KEY}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('routes') && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final geometry = route['geometry'];

          if (geometry.containsKey('coordinates')) {
            List<LatLng> points = [];

            for (var coord in geometry['coordinates']) {
              // Mapbox returns coordinates as [longitude, latitude]
              points.add(LatLng(coord[1], coord[0]));
            }

            return points;
          }
        }
      }

      // If there's an issue with the API, fall back to a straight line
      return [start, end];
    } catch (e) {
      print('Error fetching route: $e');
      // Fall back to straight line
      return [start, end];
    }
  }

  Future<void> calculateRoutes(LatLng start, LatLng end) async {
    try {
      List<RoutesStruct> dataRoutes = [];

      // Starting point is the user's current location
      LatLng startPoint = start;

      // For each destination, calculate the route from the previous point
      final endPoint = end;

      // Get the route between these two points
      final route = await _getRoute(startPoint, endPoint);
      if (route.isNotEmpty) {
        dataRoutes.add(RoutesStruct(route));
        // allRoutes.add(route);
      }

      // The next route will start from this destination
      startPoint = endPoint;
      setState(() {
        routes = dataRoutes;
      });
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    // Example custom markers
    Widget customUserMarker() => Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.person_pin_circle,
              color: Colors.white, size: 30),
        );

    List<Widget Function()> customDestMarkers() => [
          () => Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.place, color: Colors.white, size: 30),
              ),
          () => Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.flag, color: Colors.white, size: 30),
              ),
        ];

    // return CustomMapWidget(
    //   destinations: destinations,
    //   circleRadius: 300,
    //   customUserMarker: customUserMarker,
    //   customDestinationMarkers: customDestMarkers,
    //   polylineColor: Colors.deepOrange,
    //   polylineWidth: 4,
    //   circleColor: Colors.blue,
    //   mapBoxApiKey: MAP_BOX_API_KEY,
    // );
    return MapRealtimeTracking(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      destinations: destinations,
      circleRadius: 300,
      driverMarker: customUserMarker,
      homeMarker: customDestMarkers()[0],
      restaurantMarker: customDestMarkers()[1],
      polylineColor: Colors.deepOrange,
      polylineWidth: 4,
      circleColor: Colors.blue,
      driverLocation: driverLocation,
      mapBoxApiKey: MAP_BOX_API_KEY,
      routes: routes,
    );
  }
}
