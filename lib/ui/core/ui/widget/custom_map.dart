import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_mvvm/utils/cons/util_con.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class CustomMapWidget extends StatefulWidget {
  final List<MapDestination> destinations;
  final double circleRadius; // in meters
  final Widget? customUserMarker;
  final List<Widget>? customDestinationMarkers;
  final Color polylineColor;
  final double polylineWidth;
  final Color circleColor;
  final String mapBoxApiKey;

  const CustomMapWidget({
    Key? key,
    required this.destinations,
    this.circleRadius = 500, // Default radius 500m
    this.customUserMarker,
    this.customDestinationMarkers,
    this.polylineColor = Colors.blue,
    this.polylineWidth = 3.0,
    this.circleColor = Colors.blue,
    required this.mapBoxApiKey,
  }) : super(key: key);

  @override
  _CustomMapWidgetState createState() => _CustomMapWidgetState();
}

class _CustomMapWidgetState extends State<CustomMapWidget> {
  final MapController _mapController = MapController();
  late LatLng _currentPosition;
  StreamSubscription<Position>? _positionStreamSubscription;
  List<List<LatLng>> _routePolylines = [];
  bool _isLoadingRoutes = false;

  @override
  void initState() {
    super.initState();
    _currentPosition = LatLng(-7.129806599999999,110.388832);
    _initLocationTracking();
  }

  Future<void> _initLocationTracking() async {
    // Request location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Handle denied permissions
      return;
    }

    // Get current position once
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    // Once we have the position, calculate routes
    if (widget.destinations.isNotEmpty) {
      print("calculate route : destination not empty");
      await _calculateRoutes();
    }

    // Setup location stream for real-time updates
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update if moved 10 meters
      ),
    ).listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      // Recalculate routes when user position changes significantly
      _debounceCalculateRoutes();
    });
  }

  Timer? _debounceTimer;

  void _debounceCalculateRoutes() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(seconds: 5), () {
      if (widget.destinations.isNotEmpty) {
        _calculateRoutes();
      }
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Create a list of points for polyline
    final List<LatLng> polylinePoints = [];

    // Add current position as the starting point if we have destinations
    if (widget.destinations.isNotEmpty) {
      polylinePoints.add(_currentPosition!);
    }

    // Add all destination points
    for (var destination in widget.destinations) {
      polylinePoints.add(LatLng(destination.latitude, destination.longitude));
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _currentPosition,
        initialZoom: 15.0,
      ),
      children: [
        // Map tile layer (choose between Mapbox or Google Maps)
        TileLayer(
          urlTemplate:
              'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=${widget.mapBoxApiKey}',
          additionalOptions: {
            'accessToken': widget.mapBoxApiKey,
            // Replace with your token in FlutterFlow
            'id': 'mapbox/streets-v11',
          },
        ),

        // Circle around user's current position
        CircleLayer(
          circles: [
            CircleMarker(
              point: _currentPosition!,
              radius: widget.circleRadius /15.0,
              // Adjust radius based on zoom level
              color: widget.circleColor.withAlpha(50),
              borderColor: widget.circleColor,
              borderStrokeWidth: 2.0,
            )
          ],
        ),

        // Polyline connecting points
        // Polylines for street-based routes
        ..._routePolylines.map(
          (routePoints) => PolylineLayer(
            polylines: [
              Polyline(
                points: routePoints,
                strokeWidth: widget.polylineWidth,
                color: widget.polylineColor,
              ),
            ],
          ),
        ),

        // Markers for destinations
        MarkerLayer(
          markers: List.generate(
            widget.destinations.length,
            (index) => Marker(
              width: 40.0,
              height: 40.0,
              point: LatLng(widget.destinations[index].latitude,
                  widget.destinations[index].longitude),
              child: widget.customDestinationMarkers != null &&
                      index < widget.customDestinationMarkers!.length
                  ? widget.customDestinationMarkers![index]
                  : _buildDefaultMarker(color: Colors.red),
            ),
          ),
        ),

        // Marker for user's current position
        MarkerLayer(
          markers: [
            Marker(
              width: 40.0,
              height: 40.0,
              point: _currentPosition,
              child: widget.customUserMarker ??
                  _buildDefaultMarker(color: Colors.blue),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDefaultMarker({required Color color}) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: const Icon(
        Icons.location_on,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Future<List<LatLng>> _getRoute(LatLng start, LatLng end) async {
    // Using Mapbox Directions API
    final String url = 'https://api.mapbox.com/directions/v5/mapbox/driving/'
        '${start.longitude},${start.latitude};${end.longitude},${end.latitude}'
        '?geometries=geojson&access_token=${widget.mapBoxApiKey}';

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

  Future<void> _calculateRoutes() async {
    print("calculate start : $_currentPosition");
    if (_currentPosition == null || widget.destinations.isEmpty) {
      return;
    }

    setState(() {
      _isLoadingRoutes = true;
    });

    try {
      List<List<LatLng>> allRoutes = [];

      // Starting point is the user's current location
      LatLng startPoint = _currentPosition!;

      // For each destination, calculate the route from the previous point
      final destination =
          widget.destinations[1]; // 1 is destination location for driver
      final endPoint = LatLng(destination.latitude, destination.longitude);

      // Get the route between these two points
      final route = await _getRoute(startPoint, endPoint);
      if (route.isNotEmpty) {
        allRoutes.add(route);
      }

      print(allRoutes);

      // The next route will start from this destination
      startPoint = endPoint;

      setState(() {
        _routePolylines = allRoutes;
        _isLoadingRoutes = false;
      });
    } catch (e) {
      print('Error calculating routes: $e');
      setState(() {
        _isLoadingRoutes = false;
      });
    }
  }
}

// Class to define destinations
class MapDestination {
  final double latitude;
  final double longitude;
  final LatLng? location;
  final String? title;
  final String? snippet;

  MapDestination({
    required this.latitude,
    required this.longitude,
    this.location,
    this.title,
    this.snippet,
  });
}

class RoutesStruct {
  final List<LatLng> route;

  RoutesStruct(this.route);
}
