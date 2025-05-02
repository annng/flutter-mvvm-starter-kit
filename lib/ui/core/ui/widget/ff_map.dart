
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as ltlng;

import 'custom_map.dart';

class MapRealtimeTracking extends StatefulWidget {
  final double width;
  final double height;
  final List<MapDestination> destinations;
  final double circleRadius; // in meters
  final Widget Function()? homeMarker;
  final Widget Function() driverMarker;
  final Widget Function() restaurantMarker;
  final Color polylineColor;
  final double polylineWidth;
  final Color circleColor;
  final String mapBoxApiKey;
  final ltlng.LatLng driverLocation;
  final List<RoutesStruct>? routes;

  const MapRealtimeTracking(
      {super.key,
        required this.width,
        required this.height,
        required this.destinations,
        this.circleRadius = 500, // Default radius 500m
        this.homeMarker,
        required this.driverMarker,
        required this.restaurantMarker,
        this.polylineColor = Colors.blue,
        this.polylineWidth = 3.0,
        this.circleColor = Colors.blue,
        required this.driverLocation,
        required this.mapBoxApiKey,
        this.routes});

  @override
  State<MapRealtimeTracking> createState() => _MapRealtimeTrackingState();
}

class _MapRealtimeTrackingState extends State<MapRealtimeTracking> {
  final MapController _mapController = MapController();
  late ltlng.LatLng _currentPosition;
  List<List<ltlng.LatLng>> _routePolylines = [];
  bool _isControllerReady = false;

  @override
  void initState() {
    super.initState();
    _currentPosition = ltlng.LatLng(
        widget.driverLocation.latitude, widget.driverLocation.longitude);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Set controller ready after the first frame
      setState(() {
        _isControllerReady = true;
      });
    });
  }

  void _processRoutes() {
    if (widget.routes != null && widget.routes!.isNotEmpty) {
      List<List<ltlng.LatLng>> generatedRoutes = [];

      for (var routes in widget.routes!) {
        // Skip empty routes
        if (routes.route.isEmpty) continue;

        var newRoute = routes.route
            .map((route) => ltlng.LatLng(route.latitude, route.longitude))
            .toList();
        generatedRoutes.add(newRoute);
      }

      // Only update state if there are actually routes to show
      if (generatedRoutes.isNotEmpty) {
        setState(() {
          _routePolylines = generatedRoutes;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(MapRealtimeTracking oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if routes have changed
    if (widget.routes != oldWidget.routes) {
      _processRoutes();
    }

    // Update current position if driver location changed
    if (widget.driverLocation != oldWidget.driverLocation) {
      setState(() {
        _currentPosition = ltlng.LatLng(
            widget.driverLocation.latitude,
            widget.driverLocation.longitude
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
          initialCenter: _currentPosition,
          initialZoom: 15.0,
          onMapReady: () {
            if (!_isControllerReady) {
              setState(() {
                _isControllerReady = true;
              });
            }
          }),
      children: [
        // Map tile layer (choose between Mapbox or Google Maps)
        TileLayer(
          urlTemplate:
          'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=${widget.mapBoxApiKey}',
          additionalOptions: {
            'accessToken':
            '${widget.mapBoxApiKey}', // Replace with your token in FlutterFlow
            'id': 'mapbox/streets-v11',
          },
        ),

        // Circle around user's current position
        CircleLayer(
          circles: [
            CircleMarker(
              point: _currentPosition,
              radius: widget.circleRadius /
                  (_isControllerReady && _mapController.camera.zoom > 0
                      ? _mapController.camera.zoom
                      : 15.0),
              color: widget.circleColor.withAlpha(40),
              borderColor: widget.circleColor,
              borderStrokeWidth: 2.0,
            )
          ],
        ),

        // Polyline connecting points
        ..._routePolylines.map(
              (routePoints) => PolylineLayer(
            polylines: [
              Polyline(
                points: routePoints
                    .map((routePoint) =>
                    ltlng.LatLng(routePoint.latitude, routePoint.longitude))
                    .toList(),
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
              point: ltlng.LatLng(widget.destinations[index].location!.latitude,
                  widget.destinations[index].location!.longitude),
              child:
              index == 0 ? widget.restaurantMarker() : widget.homeMarker?.call() ?? _buildDefaultMarker(color: Colors.red),
            ),
          ),
        ),

        // Marker for driver's current position
        MarkerLayer(
          markers: [
            Marker(
              width: 40.0,
              height: 40.0,
              point: _currentPosition,
              child: widget.driverMarker() ??
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
}
