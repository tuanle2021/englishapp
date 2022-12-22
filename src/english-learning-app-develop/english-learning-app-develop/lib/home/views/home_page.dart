import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:learning_english_app/common/leareng_log.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/components/custom_bottom_bar.dart';
import 'package:learning_english_app/favourite/views/favourite_page.dart';

import 'package:learning_english_app/practice/views/practice_page.dart';
import 'package:learning_english_app/profile/models/dataset/userprofile_dataset.dart';
import 'package:learning_english_app/profile/models/services/profile_service.dart';
import 'package:learning_english_app/profile/views/profile_page.dart';
import 'package:learning_english_app/subject/views/categories_page.dart';
import 'package:learning_english_app/leaderboard/views/leaderboard_page.dart';



class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static var currentIndex = 0;
  final List<Widget> pages = <Widget>[
    CategoriesPage(),
    PracticePage(),
    FavouritePage(),
    LeaderboardPage(),
    ProfilePage(),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var profileService = ProfileService();
    StorageController.database?.userProfileDao
        .findUserProfile(StorageController.getCurrentUserId() ?? "")
        .then((value) {
      if (value == null) {
        profileService.getUserProfile((result) {
          var resultMap = result as Map<String, dynamic>;
          setState(() {
            resultMap["user"]["id"] = resultMap["user"]["_id"];
          
            var userProfile = UserProfileDataset.fromJson(resultMap["user"] as Map<String,dynamic>);
            StorageController.database?.userProfileDao
                .insertUserProfile(userProfile)
                .then((value) {
              StorageController.setCurrentUserId(userProfile.id ?? "");
            });
          });
        }, (error) {
          var errorMap = error as Map<String, dynamic>;
          LearnEngLog.logger.e(errorMap["error"]);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: CustomBottomBar(
        itemPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 14),
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.001 * 10,
            horizontal: 16),
        items: [
          CustomBottomBarItem(
            icon: Icon(FontAwesomeIcons.map),
            title: Text(
              AppLocalizations.of(context).subjectTab,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontWeight: FontWeight.w600,wordSpacing: -1),
            ),
            selectedColor: Theme.of(context).colorScheme.primary,
          ),
          CustomBottomBarItem(
            icon: Icon(FontAwesomeIcons.penNib),
            title: Text(
              AppLocalizations.of(context).reviewTab,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontWeight: FontWeight.w600, wordSpacing: -1),
            ),
            selectedColor: Theme.of(context).colorScheme.primary,
          ),
          CustomBottomBarItem(
            icon: Icon(FontAwesomeIcons.heart),
            title: Text(
              AppLocalizations.of(context).favouriteTab,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontWeight: FontWeight.w600,wordSpacing: -1),
            ),
            selectedColor: Theme.of(context).colorScheme.primary,
          ),
          CustomBottomBarItem(
            icon: Icon(FontAwesomeIcons.medal),
            title: Text(
              AppLocalizations.of(context).navbar_leaderboard,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontWeight: FontWeight.w600,wordSpacing: -1),
            ),
            selectedColor: Theme.of(context).colorScheme.primary,
          ),
          CustomBottomBarItem(
            icon: Icon(FontAwesomeIcons.user),
            title: Text(
              AppLocalizations.of(context).profileTab,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontWeight: FontWeight.w600,wordSpacing: -1),
            ),
            selectedColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
