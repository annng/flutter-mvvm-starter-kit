import 'package:latlong2/latlong.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String venue;
  final LatLng location;
  final double price;
  final String imageUrl;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.venue,
    required this.location,
    required this.price,
    required this.imageUrl,
  });

  static List<Event> Events = [
    Event(
      id: '1',
      title: 'Music Festival Jakarta',
      description:
          'Festival musik terbesar di Jakarta dengan artis internasional',
      date: DateTime.now().add(Duration(days: 7)),
      venue: 'Gelora Bung Karno Stadium',
      location: LatLng(-6.2185, 106.8014),
      price: 150000,
      imageUrl: 'https://springboard.id/wp-content/uploads/2023/02/HITC.jpg',
    ),
    Event(
      id: '2',
      title: 'Tech Conference 2025',
      description: 'Konferensi teknologi dengan pembicara terbaik',
      date: DateTime.now().add(Duration(days: 14)),
      venue: 'Jakarta Convention Center',
      location: LatLng(-6.2297, 106.8070),
      price: 300000,
      imageUrl: 'https://a.storyblok.com/f/188325/1024x681/b70ae71a00/screen-shot-2018-11-28-at-18-44-51-1024x681.jpg/m/filters:quality(75):format(webp)',
    ),
    Event(
      id: '3',
      title: 'Food Festival',
      description: 'Festival kuliner nusantara',
      date: DateTime.now().add(Duration(days: 21)),
      venue: 'Kemang Village',
      location: LatLng(-6.2615, 106.8106),
      price: 75000,
      imageUrl: 'https://i.ytimg.com/vi/BLsQyx604Yc/hq720.jpg',
    ),
  ];
}
