import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lali/blocs/events_bloc.dart';
import 'package:lali/models/event.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventsBloc>().fetchUpcoming();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<EventsBloc>();
    return Scaffold(
      appBar: AppBar(title: const Text('Tribal Events')),
      body: bloc.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: bloc.events.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (ctx, i) => _EventTile(item: bloc.events[i]),
            ),
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({required this.item});
  final EventModel item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title),
      subtitle: Text(
          '${item.start.toLocal()} - ${item.end.toLocal()}'),
      onTap: () => Navigator.of(context).pushNamed('/eventDetails', arguments: item),
    );
  }
}
