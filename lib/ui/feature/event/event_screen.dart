import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mvvm/domain/models/event/event.dart';

import 'component/event_card.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final events = Event.Events;

    return Scaffold(
      appBar: AppBar(
        title: Text('Event Tickets'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return EventCard(
            event: event,
            onClick: () {
              _showTicketDialog(context, event);
            },
          );
        },
      ),
    );
  }

  void _showTicketDialog(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Beli Tiket'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Event: ${event.title}'),
              SizedBox(height: 8),
              Text('Harga: Rp ${event.price.toStringAsFixed(0)}'),
              SizedBox(height: 8),
              Text(
                  'Tanggal: ${event.date.day}/${event.date.month}/${event.date.year}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Tiket berhasil dibeli!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text('Beli'),
            ),
          ],
        );
      },
    );
  }
}
