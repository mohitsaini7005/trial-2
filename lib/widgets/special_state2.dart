import 'package:flutter/material.dart';
import '../blocs/sp_state_two.dart';
import '../models/colors.dart';
import '../core/config/config.dart';
import 'package:provider/provider.dart';
import '../pages/state_based_places.dart';
import '../core/utils/list_card.dart';
import '../core/utils/next_screen.dart';
import 'package:easy_localization/easy_localization.dart';



class SpecialStateTwo extends StatelessWidget {
  const SpecialStateTwo({super.key});





  @override
  Widget build(BuildContext context) {
    final spb = context.watch<SpecialStateTwoBloc>();



    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 15, top: 10, right: 15,),
          child: Row(children: <Widget>[
            Text('special state-2 places', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.grey[800]),).tr(),
            const Spacer(),
            IconButton(icon: const Icon(Icons.arrow_forward),
              onPressed: () => nextScreen(
                  context,
                  StateBasedPlaces(
                    stateName: Config().specialState2,
                    color: (ColorList().randomColors..shuffle()).first,
                  )),
            )
          ],),
        ),


        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 10, right: 10),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: spb.data.isEmpty ? 4 : spb.data.length,
            itemBuilder: (BuildContext context, int index) {
              if(spb.data.isEmpty) return Container();
              return ListCard1(d: spb.data[index], tag: 'sp2$index',);
            },
          ),
        )


      ],
    );
  }
}



