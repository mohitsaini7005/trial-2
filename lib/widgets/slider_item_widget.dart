import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lali/core/utils/next_screen.dart';
import 'package:lali/pages/home.dart';
import 'package:get/get.dart';
import 'package:lali/router/app_routes.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'app_large_text.dart';
import 'app_text.dart';
import 'slider_item.dart';

class SliderItemWidget extends StatelessWidget {
  final SliderItem sliderItem;

  const SliderItemWidget({super.key, required this.sliderItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(sliderItem.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 150, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppLargeText(sliderItem.title, Colors.black),
                AppText(sliderItem.subtitle, Colors.black54, size: 25),
                const SizedBox(height: 20),
                SizedBox(
                  width: 250,
                  child: AppText(
                    "Discover joy in every bite, book your stay, and explore the flavors of the world.",
                    Colors.black54,
                    size: 16,
                  ),
                ),
                const SizedBox(height: 420),
                Container(
                  height: 45,
                  width: 30 * 0.70,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                    child: Text(
                      tr('get started'),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      // Fire-and-forget to avoid context usage after await
                      FirebaseAnalytics.instance.logEvent(name: 'onboarding_complete', parameters: {
                        'source': 'slider_get_started',
                        'index': sliderItem.index,
                      });
                      FirebaseCrashlytics.instance.log('Onboarding complete from slider index ${sliderItem.index}');
                      nextScreenReplace(context, const HomePage());
                    },
                  ),
                )
              ],
            ),
            Column(
              children: [
                // Quick access to language/region settings
                IconButton(
                  tooltip: tr('settings'),
                  icon: const Icon(Icons.language, color: Colors.white),
                  onPressed: () => Get.toNamed(AppRoutes.settings),
                ),
                ...List.generate(3, (indexDots) {
                  return Container(
                    margin: const EdgeInsets.only(right: 2),
                    width: 8,
                    height: indexDots == sliderItem.index ? 25 : 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: indexDots == sliderItem.index ? Colors.deepPurple : Colors.grey,
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
