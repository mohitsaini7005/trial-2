import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import '/blocs/comments_bloc.dart';
import '/blocs/internet_bloc.dart';
import '/blocs/sign_in_bloc.dart';
import '/models/comment.dart';
import '/core/utils/empty.dart';
import '/core/utils/loading_cards.dart';
import '/core/utils/sign_in_dialog.dart';
//import '/core/utils/toast.dart';
import 'package:easy_localization/easy_localization.dart';

class CommentsPage extends StatefulWidget {
  final String collectionName;
  final String timestamp;
  const CommentsPage(
      {super.key, required this.collectionName, required this.timestamp});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late ScrollController controller;
  DocumentSnapshot? _lastVisible;
  late bool _isLoading;
  final List<DocumentSnapshot> _snap = List<DocumentSnapshot>.empty(growable: true);
  List<Comment> _data = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var textCtrl = TextEditingController();
  bool _hasData = true;

  @override
  void initState() {
    controller = ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
    _getData();
  }







  Future<void> _getData() async {
    setState(() => _hasData = true);
    QuerySnapshot data;
    if (_lastVisible == null) {
      data = await firestore
          .collection('${widget.collectionName}/${widget.timestamp}/comments')
          .orderBy('timestamp', descending: true)
          .limit(7)
          .get();
    } else {
      data = await firestore
          .collection('${widget.collectionName}/${widget.timestamp}/comments')
          .orderBy('timestamp', descending: true)
          .startAfter([_lastVisible!['timestamp']])
          .limit(7)
          .get();
    }

    if (data.docs.isNotEmpty) {
      _lastVisible = data.docs[data.docs.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          _snap.addAll(data.docs);
          _data = _snap.map((e) => Comment.fromFirestore(e)).toList();
          debugPrint('blog reviews : ${_data.length}');
        });
      }
    } else {
      if (_lastVisible == null) {
        setState(() {
          _isLoading = false;
          _hasData = false;
          debugPrint('no items');
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasData = true;
          debugPrint('no more items');
        });
      }
    }
  }





  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    textCtrl.dispose();
    super.dispose();
  }




  void _scrollListener() {
    if (!_isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        _getData();
      }
    }
  }





  void handleDelete(BuildContext context, Comment d) {
    final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);
    final ib = Provider.of<InternetBloc>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(50),
          elevation: 0,
          children: <Widget>[
            const Text(
              'delete?',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ).tr(),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'delete from database?',
              style: TextStyle(
                color: Color(0xFF9E9E9E),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ).tr(),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      )
                    ),
                    onPressed: () async {
                      // Capture references before awaiting to avoid using builder context across async gaps
                      final pop = Navigator.of(context).pop;
                      final commentsBloc = context.read<CommentsBloc>();
                      await ib.checkInternet();
                      if (!mounted) return;
                      if (!ib.hasInternet) {
                        pop();
                        //openToast(context, 'no internet'.tr());
                      } else {
                        if (sb.uid != d.uid) {
                          pop();
                          //openToast(context, 'You can not delete others comment');
                        } else {
                          await commentsBloc.deleteComment(
                            widget.collectionName,
                            widget.timestamp,
                            sb.uid,
                            d.timestamp,
                          );
                          if (!mounted) return;
                          onRefreshData();
                          pop();
                        }
                      }
                    },
                    child: Text(
                      'yes'.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ), 
                      backgroundColor: Colors.deepPurpleAccent,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'no'.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }






  Future handleSubmit() async {
    final ib = Provider.of<InternetBloc>(context, listen: false);
    final SignInBloc sb = context.read<SignInBloc>();
    if (sb.guestUser == true) {
      openSignInDialog(context);
    } else {
      await ib.checkInternet();
      if (!mounted) return;
      if (textCtrl.text.isEmpty) {
        debugPrint('Comment is empty');
      } else {
        if (ib.hasInternet == false) {
          //openToast(context, 'no internet'.tr());
        } else {
          context
              .read<CommentsBloc>()
              .saveNewComment(widget.collectionName, widget.timestamp, textCtrl.text);
          onRefreshData();
          textCtrl.clear();
          FocusScope.of(context).requestFocus(FocusNode());
        }
      }
    }
  }





  void onRefreshData() {
    setState(() {
      _isLoading = true;
      _snap.clear();
      _data.clear();
      _lastVisible = null;
    });
    _getData();
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
            widget.collectionName == 'places' ? 'user reviews' : 'comments').tr(),
        titleSpacing: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh, size: 22,), onPressed: ()=> onRefreshData())
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              child: _hasData == false
                  ? ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                  ),
                  EmptyPage(
                      icon: LineIcons.comments,
                      message: 'no comments found'.tr(),
                      message1: 'be the first to comment'.tr()),
                ],
              )
                  : ListView.separated(
                padding: const EdgeInsets.all(15),
                controller: controller,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _data.isNotEmpty ? _data.length + 1 : 10,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                      height: 10,
                    ),
                itemBuilder: (_, int index) {
                  if (index < _data.length) {
                    return reviewList(_data[index]);
                  }
                  return Opacity(
                    opacity: _isLoading ? 1.0 : 0.0,
                    child: _lastVisible == null
                        ? const LoadingCard(height: 100)
                        : const Center(
                      child: SizedBox(
                          width: 32.0,
                          height: 32.0,
                          child: CupertinoActivityIndicator()),
                    ),
                  );
                },
              ),
              onRefresh: () async {
                onRefreshData();
              },
            ),
          ),
          const Divider(
            height: 1,
            color: Colors.black26,
          ),
          SafeArea(
            child: SizedBox(
              height: 65,
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.only(top: 8, bottom: 10, right: 20, left: 20),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(25)),
                child: TextFormField(
                  decoration: InputDecoration(
                      errorStyle: const TextStyle(fontSize: 0),
                      contentPadding:
                      const EdgeInsets.only(left: 15, top: 10, right: 5),
                      border: InputBorder.none,
                      hintText: widget.collectionName == 'places' ? 'write a review'.tr() : 'write a comment'.tr(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Colors.grey[700],
                          size: 20,
                        ),
                        onPressed: () {
                          handleSubmit();
                        },
                      )),
                  controller: textCtrl,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget reviewList(Comment d) {
    return Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5)),
        child: ListTile(
          leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[200],
              backgroundImage: CachedNetworkImageProvider(d.imageUrl)),
          title: Row(
            children: <Widget>[
              Text(
                d.name,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(d.date,
                  style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 11,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          subtitle: Text(
            d.comment,
            style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500),
          ),
          onLongPress: () {
            handleDelete(context, d);
          },
        ));
  }
}
