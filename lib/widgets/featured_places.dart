import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import '../blocs/featured_bloc.dart';
import '../models/place.dart';
import '../pages/place_details.dart';
import '../core/utils/next_screen.dart';
import '../widgets/custom_cache_image.dart';
import '../core/utils/loading_cards.dart';



class Featured extends StatefulWidget {
  const Featured({super.key});

  @override
  State<Featured> createState() => _FeaturedState();
}

class _FeaturedState extends State<Featured> {


  int listIndex = 2;

  @override
  Widget build(BuildContext context) {

    final fb = context.watch<FeaturedBloc>();
    double w = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        SizedBox(
          height: 260,
          width: w,
          child: PageView.builder(
            controller: PageController(
                initialPage: 2
            ),
            scrollDirection: Axis.horizontal,
            itemCount: fb.data.isEmpty ? 1 : fb.data.length,
            onPageChanged: (index) {
              setState(() {
                listIndex = index;

              });
            },
            itemBuilder: (BuildContext context, int index) {
              if(fb.data.isEmpty) return const LoadingFeaturedCard();
              return _FeaturedItemList(d: fb.data[index]);
            },
          ),
        ),

        const SizedBox(height: 8,),
        Center(
          child: DotsIndicator(
            dotsCount: 5,
            position: listIndex,
            decorator: DotsDecorator(
              color: Colors.black26,
              activeColor: Colors.black,
              spacing: const EdgeInsets.only(left: 6),
              size: const Size.square(5.0),
              activeSize: const Size(20.0, 4.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
          ),
        )
      ],
    );
  }
}


class _FeaturedItemList extends StatelessWidget {
  final Place d;
  const _FeaturedItemList({required this.d});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      width: w,
      child: InkWell(
        child: Stack(
          children: <Widget>[
            Hero(
              tag: 'featured${d.timestamp}',
              child: Container(
                  height: 220,
                  width: w,
                  decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CustomCacheImage(imageUrl: d.imageUrl1))
              ),
            ),
            Positioned(
              height: 120,
              width: w * 0.70,
              left: w * 0.11,
              bottom: 10,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0, 2),
                          blurRadius: 2)
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          d.name,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey,
                          ),
                          Expanded(
                            child: Text(d.location,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,),
                          )
                        ],
                      ),
                      Divider(
                        color: Colors.grey[300],
                        height: 20,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: <Widget>[
                            const Icon(
                              LineIcons.heart,
                              size: 18,
                              color: Colors.orange,
                            ),
                            Text(
                              d.loves.toString(),
                              style: TextStyle(

                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700]),
                            ),

                            const SizedBox(width: 30,),
                            const Icon(
                              LineIcons.comment,
                              size: 18,
                              color: Colors.orange,
                            ),
                            Text(
                              d.commentsCount.toString(),
                              style: TextStyle(

                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700]),
                            ),
                            const Spacer(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          nextScreen(context, PlaceDetails(data: d, tag: 'featured${d.timestamp}'));

        },
      ),

    );
  }
}