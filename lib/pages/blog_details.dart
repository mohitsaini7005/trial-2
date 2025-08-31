import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lali/blocs/bookmark_bloc.dart';
//import 'package:share/share.dart';
//import '../blocs/bookmark_bloc.dart';
import '../blocs/sign_in_bloc.dart';
import '../models/blog.dart';
import '../pages/comments.dart';
import '../core/utils/next_screen.dart';
import '../core/utils/sign_in_dialog.dart';
import '../widgets/bookmark_icon.dart';
import '../widgets/custom_cache_image.dart';
import '../widgets/love_count.dart';
import '../widgets/love_icon.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class BlogDetails extends StatefulWidget {
  final Blog blogData;
  final String tag;

  const BlogDetails({super.key, required this.blogData, required this.tag});

  @override
  State<BlogDetails> createState() => _BlogDetailsState();
}

class _BlogDetailsState extends State<BlogDetails> {

  final String collectionName = 'blogs';

  handleLoveClick() {
    final bool guestUser = context.read<SignInBloc>().guestUser;

    if (guestUser == true) {
      openSignInDialog(context);
    } else {
      context.read<BookmarkBloc>().onLoveIconClick(collectionName, widget.blogData.timestamp);
    }
  }

  handleBookmarkClick() {
    final bool guestUser = context.read<SignInBloc>().guestUser;

    if (guestUser == true) {
      openSignInDialog(context);
    } else {
      context.read<BookmarkBloc>().onBookmarkIconClick(collectionName, widget.blogData.timestamp);
    }
  }


  handleSource(link) async {
    // if(await canLaunchUrl(link as Uri)){
    //   launchUrl(link);
    // }
  }

  handleShare (){
    //Share.share('${widget.blogData.title}, To read more install ${Config().appName} App. https://play.google.com/store/apps/details?id=');
  }

  @override
  void initState() {

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // post-frame work if needed
    });
  }


  @override
  Widget build(BuildContext context) {
    final SignInBloc sb = context.watch<SignInBloc>();
    final Blog d = widget.blogData;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const Spacer(),
                      Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.share,
                              size: 22,
                            ),
                            onPressed: () {
                              handleShare();
                            },
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Icon(
                            CupertinoIcons.time,
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            d.date,
                            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        d.title,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900, color: Colors.grey[800]),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 8),
                        height: 3,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(40)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () {
                               handleSource(d.sourceUrl);
                            },
                            icon: const Icon(Icons.exit_to_app,
                                size: 20, color: Colors.blueAccent),
                            label: Text(
                              d.sourceUrl.contains('www')
                                  ? d.sourceUrl
                                  .replaceAll('https://www.', '')
                                  .split('.')
                                  .first
                                  : d.sourceUrl
                                  .replaceAll('https://', '')
                                  .split('.')
                                  .first,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.grey[900],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          // TextButton(onPressed: () {
                          //   //handleSource(d.sourceUrl)
                          // },
                          //     child: Text(
                          //           d.sourceUrl.contains('www')
                          //               ? d.sourceUrl
                          //               .replaceAll('https://www.', '')
                          //               .split('.')
                          //               .first
                          //               : d.sourceUrl
                          //               .replaceAll('https://', '')
                          //               .split('.')
                          //               .first,
                          //           maxLines: 1,
                          //           overflow: TextOverflow.ellipsis,
                          //           style: TextStyle(
                          //               color: Colors.grey[900],
                          //               fontSize: 13,
                          //               fontWeight: FontWeight.w500),
                          //         ),),
                          const Spacer(),
                          IconButton(
                              icon: BuildLoveIcon(
                                  collectionName: collectionName,
                                  uid: sb.uid,
                                  timestamp: d.timestamp),
                              onPressed: () {
                                handleLoveClick();
                              }),
                          IconButton(
                              icon: BuildBookmarkIcon(
                                  collectionName: collectionName,
                                  uid: sb.uid,
                                  timestamp: d.timestamp),
                              onPressed: () {
                                handleBookmarkClick();
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Hero(
                  tag: widget.tag,
                  child: SizedBox(
                      height: 220, width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: CustomCacheImage(imageUrl: d.thumbUrl))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      LoveCount(
                          collectionName: collectionName,
                          timestamp: d.timestamp),
                      const SizedBox(
                        width: 15,
                      ),
                      TextButton(
                          onPressed: () {
                           nextScreen(context, CommentsPage(collectionName: collectionName, timestamp: d.timestamp));

                          }, child: Row(
                        children: <Widget>[
                          const Icon(
                            Icons.comment,
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            'comments'.tr(),
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Html(
                    data: '''  ${d.description}   '''),

                const SizedBox(
                  height: 30,
                )
              ]),

        ),
      ),
    );
  }
}
