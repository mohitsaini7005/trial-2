import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '/blocs/featured_bloc.dart';
import '/blocs/popular_places_bloc.dart';
import '/blocs/recent_places_bloc.dart';
import '/blocs/recommanded_places_bloc.dart';
import '/blocs/sign_in_bloc.dart';
import '/blocs/sp_state_one.dart';
import '/blocs/sp_state_two.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/core/config/config.dart';
import '/pages/profile.dart';
import '/pages/search.dart';
import '/core/utils/next_screen.dart';
import '/widgets/featured_places.dart';
import '/widgets/popular_places.dart';
import '/widgets/recent_places.dart';
import '/widgets/recommended_places.dart';
import '/widgets/special_state1.dart';
import '/widgets/special_state2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0)).then((_) {
      if (!mounted) return;
      context.read<FeaturedBloc>().getData();
      context.read<PopularPlacesBloc>().getData();
      context.read<RecentPlacesBloc>().getData();
      context.read<SpecialStateOneBloc>().getData();
      context.read<SpecialStateTwoBloc>().getData();
      context.read<RecommandedPlacesBloc>().getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              if (!mounted) return;
              context.read<FeaturedBloc>().onRefresh();
              context.read<PopularPlacesBloc>().onRefresh(mounted);
              context.read<RecentPlacesBloc>().onRefresh(mounted);
              context.read<SpecialStateOneBloc>().onRefresh(mounted);
              context.read<SpecialStateTwoBloc>().onRefresh(mounted);
              context.read<RecommandedPlacesBloc>().onRefresh(mounted);
            },
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ClipPath(
                    clipper: WaveClipperTwo(flip: true),
                    child: Container(
                      height: 210,
                      width: 500,
                      color: Colors.blue[50],
                      child: const Header(),
                    ),
                  ),
                  const Featured(),
                  const PopularPlaces(),
                  const RecentPlaces(),
                  const SpecialStateOne(),
                  const SpecialStateTwo(),
                  const RecommendedPlaces()
                ],
              ),
            ),
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final SignInBloc sb = Provider.of<SignInBloc>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Config().appName,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.blue)
                  ),
                  Text(
                    'explore country',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).shadowColor),
                  ).tr()
                ],
              ),
              const Spacer(),
              InkWell(
                child: sb.isSignedIn == false
                    ? Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, size: 28),
                      )
                    : Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.blueAccent.withValues(alpha: 0.7),
                                  blurRadius: 5,
                                  offset: const Offset(2, 2))
                            ],
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(sb.imageUrl),
                                fit: BoxFit.cover)),
                      ),
                onTap: () {
                  nextScreen(context, const ProfilePage());
                },
              )
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          InkWell(
            child: Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 5, right: 5),
              padding: const EdgeInsets.only(left: 15, right: 15),
              height: 40,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: Colors.blueAccent, width: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.search,
                      color: Colors.blueAccent,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'search places',
                      style:
                          TextStyle(fontSize: 15, color: Colors.blueAccent),
                    ).tr(),
                  ],
                ),
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SearchPage()));
            },
          )
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.green,
      padding: const EdgeInsets.only(top: 10, bottom: 5, left: 15, right: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Config().appName,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700]),
              ),
              Text(
                'Explore ${Config().countryName}',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600]),
              )
            ],
          ),
          const Spacer(),
          IconButton(
              icon: const Icon(
                Icons.notification_add,
                size: 20,
              ),
              onPressed: () {}),
          IconButton(
              icon: const Icon(
                Icons.search,
                size: 20,
              ),
              onPressed: () {})
        ],
      ),
    );
  }
}
