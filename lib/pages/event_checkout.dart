import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lali/models/event.dart';
import 'package:lali/blocs/bookings_bloc.dart';
import 'package:lali/blocs/sign_in_bloc.dart';

class EventCheckoutPage extends StatefulWidget {
  const EventCheckoutPage({super.key});

  @override
  State<EventCheckoutPage> createState() => _EventCheckoutPageState();
}

class _EventCheckoutPageState extends State<EventCheckoutPage> {
  int qty = 1;
  int tierIndex = 0;

  @override
  Widget build(BuildContext context) {
    final EventModel item = ModalRoute.of(context)!.settings.arguments as EventModel;
    final tier = item.ticketTiers.isNotEmpty ? item.ticketTiers[tierIndex] : null;
    final amount = (tier?.price ?? 0) * qty;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            if (item.ticketTiers.isNotEmpty)
              DropdownButton<int>(
                value: tierIndex,
                items: [
                  for (int i = 0; i < item.ticketTiers.length; i++)
                    DropdownMenuItem(
                      value: i,
                      child: Text('${item.ticketTiers[i].name} - ₹${item.ticketTiers[i].price}'),
                    )
                ],
                onChanged: (v) => setState(() => tierIndex = v ?? 0),
              ),
            Row(
              children: [
                const Text('Tickets:'),
                IconButton(onPressed: () => setState(() => qty = (qty > 1) ? qty - 1 : 1), icon: const Icon(Icons.remove_circle_outline)),
                Text('$qty'),
                IconButton(onPressed: () => setState(() => qty += 1), icon: const Icon(Icons.add_circle_outline)),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (tier == null)
                    ? null
                    : () async {
                        final bloc = context.read<BookingsBloc>();
                        final signIn = context.read<SignInBloc>();
                        final uid = signIn.uid;
                        // Cache navigator and messenger before await to avoid using context after async gap
                        final navigator = Navigator.of(context);
                        final messenger = ScaffoldMessenger.of(context);
                        final bookingId = await bloc.createPending(
                          userId: uid.isNotEmpty ? uid : 'guest',
                          type: 'event',
                          refId: item.id,
                          placeId: item.placeId,
                          amount: amount,
                          currency: 'INR',
                          payload: {'tier': tier.name, 'qty': qty},
                        );
                        if (!mounted) return;
                        if (bookingId != null) {
                          // Payment integration placeholder: Razorpay to be added, then markConfirmed
                          messenger.showSnackBar(
                            const SnackBar(content: Text('Booking created (pending). Integrate payment next.')),
                          );
                          navigator.pop();
                        }
                      },
                child: Text('Pay ₹$amount'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
