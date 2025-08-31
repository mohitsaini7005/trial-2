import 'package:flutter/material.dart';
import 'package:lali/models/event.dart';

class EventDetailsPage extends StatelessWidget {
  const EventDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final EventModel item = ModalRoute.of(context)!.settings.arguments as EventModel;
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.description),
            const SizedBox(height: 12),
            Text('Starts: ${item.start.toLocal()}'),
            Text('Ends: ${item.end.toLocal()}'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/eventCheckout', arguments: item),
                child: const Text('Book Tickets'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
