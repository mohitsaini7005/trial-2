import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';
import '/blocs/notification_bloc.dart';
import '/models/notification.dart';
import '/core/utils/next_screen.dart';
import '/pages/notification_details.dart';
import 'package:easy_localization/easy_localization.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late ScrollController controller;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    controller = ScrollController()..addListener(_scrollListener);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<NotificationBloc>().onRefresh(mounted);
    });
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final db = context.read<NotificationBloc>();

    if (!db.isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        context.read<NotificationBloc>().setLoading(true);
        context.read<NotificationBloc>().getData(mounted);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final nb = context.watch<NotificationBloc>();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('notifications').tr(),
        actions: [
          IconButton(
            icon: const Icon(Icons.rotate_90_degrees_ccw, size: 22,),
            onPressed: () =>
                context.read<NotificationBloc>().onReload(mounted),
          )
        ],
      ),
      body: RefreshIndicator(
        child: ListView.separated(
          padding: const EdgeInsets.only(top: 15, bottom: 20),
          controller: controller,
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: nb.data.length + 1,
          separatorBuilder: (context, index) => const SizedBox(
            height: 10,
          ),
          itemBuilder: (_, int index) {
            if (index < nb.data.length) {
              return _ListItem(key: ValueKey(nb.data[index].timestamp), d: nb.data[index]);
            }
            return Center(
              child: Opacity(
                opacity: nb.isLoading ? 1.0 : 0.0,
                child: const SizedBox(
                    width: 32.0,
                    height: 32.0,
                    child: CircularProgressIndicator()),
              ),
            );
          },
        ),
        onRefresh: () async {
          context.read<NotificationBloc>().onRefresh(mounted);
        },
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final NotificationModel d;
  const _ListItem({super.key, required this.d});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
              offset: Offset(0, 3))
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 5,
              constraints: const BoxConstraints(minHeight: 140),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor
              ),
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                        HtmlUnescape().convert(
                            parse(d.description).documentElement!.text),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey[600]
                        )
                    ),
                    const SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(CupertinoIcons.time_solid,
                            size: 16, color: Colors.grey),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          d.createdAt,
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: ()=> nextScreen(context, NotificationDetails(data: d)),
    );
  }
}
