import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mvvm/domain/models/event/event.dart';
import 'package:flutter_mvvm/ui/feature/event/component/event_card_horizontal.dart';
import 'package:flutter_mvvm/utils/helper/date.dart';

import '../../../generated/assets.dart';
import 'component/event_card_vertical.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final events = Event.Events;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: false,
            snap: false,
            expandedHeight: 260,
            collapsedHeight: kToolbarHeight,
            // optional
            backgroundColor: Theme.of(context).primaryColor,
            // Common toolbar bits:
            // Add bottom widgets (eg. TabBar / search):
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(52),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: TextField(
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.white),
                    hintText: 'Cari Event…',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.secondary,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                // collapse %: 0=expanded, 1=collapsed
                final max = 260.0;
                final min = kToolbarHeight;
                final current = constraints.biggest.height;
                final t = ((max - current) / (max - min)).clamp(0.0, 1.0);

                // Simple lerp helpers
                double lerp(double a, double b) => a + (b - a) * t;

                return Stack(
                  children: [
                    // Background (can add parallax)

                    Container(
                      color: Theme.of(context).primaryColor,
                    ),

                    Positioned(
                      bottom: 0,
                      top: 0,
                      right: 0,
                      child: Image.asset(
                        width: 200,
                        Assets.imgHomeOrnamentMusic,
                        fit: BoxFit.contain,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withAlpha(150),
                        colorBlendMode: BlendMode.srcIn,
                      ),
                    ),

                    Positioned(
                      left: 16,
                      top: lerp(100, -260),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Halo, John Doe!",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            DateUtil().getCurrentDate("dd MMMM yyyy"),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    )
                    // Expanding title area
                  ],
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left : 16, top : 16),
                  child: Text(
                    "Event Akan Datang",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  height: 264,
                  width: double.infinity,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return EventCardHorizontal(
                        event: event,
                        onClick: () {
                          _showTicketDialog(context, event);
                        },
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left : 16, top : 16),
                  child: Text(
                    "Event Lainnya",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 76),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(16),
                    itemCount: events.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return EventCardVertical(
                        event: event,
                        onClick: () {
                          _showTicketDialog(context, event);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
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
