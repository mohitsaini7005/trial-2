import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lali/blocs/bookings_bloc.dart';
import 'package:lali/blocs/sign_in_bloc.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final signIn = context.read<SignInBloc>();
      final uid = signIn.uid;
      if (uid.isNotEmpty) {
        context.read<BookingsBloc>().fetchForUser(uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<BookingsBloc>();
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: bloc.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: bloc.items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (ctx, i) {
                final b = bloc.items[i];
                return ListTile(
                  title: Text('${b.type.name.toUpperCase()} • ${b.status.name}'),
                  subtitle: Text('Amount: ${b.currency} ${b.amount}'),
                );
              },
            ),
    );
  }
}
