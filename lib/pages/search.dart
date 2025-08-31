import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blocs/search_bloc.dart';
import '../core/utils/empty.dart';
import '../core/utils/list_card.dart';
import '../core/utils/loading_cards.dart';
import '../core/utils/snackbar.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<SearchBloc>().saerchInitialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //search bar

            Container(
              alignment: Alignment.center,
              height: 56,
              width: w,
              decoration: const BoxDecoration(color: Colors.white),
              child: TextFormField(
                autofocus: true,
                controller: context.watch<SearchBloc>().textfieldCtrl,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "search & explore".tr(),
                  hintStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800]),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 15),
                    child: IconButton(
                      icon: Icon(
                        Icons.keyboard_backspace,
                        color: Colors.grey[800],
                      ),
                      color: Colors.grey[800],
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.grey[800],
                      size: 25,
                    ),
                    onPressed: () {
                      context.read<SearchBloc>().saerchInitialize();
                    },
                  ),
                ),
                textInputAction: TextInputAction.search,
                onFieldSubmitted: (value) {
                  if(value == ''){
                    openSnackbar(context, 'Type something!');
                  }else{
                    context.read<SearchBloc>().setSearchText(value);
                    context.read<SearchBloc>().addToSearchList(value);
                  }
                },
              ),
            ),

            SizedBox(
              height: 1,
              child: Divider(
                color: Colors.grey[300],
              ),
            ),

            // suggestion text

            Padding(
              padding: const EdgeInsets.only(top: 15, left: 15, bottom: 5),
              child: Text(
                context.watch<SearchBloc>().searchStarted == false
                    ? 'recent searchs'
                    : 'we have found',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ).tr(),
            ),
            context.watch<SearchBloc>().searchStarted == false
                ? const SuggestionsUI()
                : const AfterSearchUI()
          ],
        ),
      ),
    );
  }
}




class SuggestionsUI extends StatelessWidget {
  const SuggestionsUI({super.key});

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SearchBloc>();
    return Expanded(
      child: sb.recentSearchData.isEmpty
          ? EmptyPage(
        icon: Icons.search,
        message: 'search for places'.tr(),
        message1: "search-description".tr(),
      )

          : ListView.builder(
        itemCount: sb.recentSearchData.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(sb.recentSearchData[index], style: const TextStyle(
                fontSize: 17
            ),),
            leading: const Icon(CupertinoIcons.time_solid),
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                context
                    .read<SearchBloc>()
                    .removeFromSearchList(sb.recentSearchData[index]);
              },
            ),
            onTap: () {
              context
                  .read<SearchBloc>()
                  .setSearchText(sb.recentSearchData[index]);
            },
          );
        },
      ),
    );
  }
}

class AfterSearchUI extends StatelessWidget {
  const AfterSearchUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: context.watch<SearchBloc>().getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if ((snapshot.data as List).isEmpty) {
              return EmptyPage(
                icon: Icons.note,
                message: 'no places found'.tr(),
                message1: "try again".tr(),
              );
            } else {
              return ListView.separated(
                padding: const EdgeInsets.all(10),
                itemCount: snapshot.data.length,
                separatorBuilder: (context, index) => const SizedBox(
                  height: 5,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return ListCard(
                    d: snapshot.data[index],
                    tag: "search$index",
                    color: Colors.white,
                  );
                },
              );
            }
          }
          return ListView.separated(
            padding: const EdgeInsets.all(15),
            itemCount: 5,
            separatorBuilder: (BuildContext context, int index) => const SizedBox(
              height: 10,
            ),
            itemBuilder: (BuildContext context, int index) {
              return const LoadingCard(height: 120);
            },
          );
        },
      ),
    );
  }
}
