import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/components/custom_app_bar.dart';
import 'package:learning_english_app/profile/models/services/facebookuser_service.dart';
import 'package:learning_english_app/profile/models/services/profile_service.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final service = ProfileService();
  // get facebook user data
  final facebookuser_service = FacebookuserService();
  List<FacebookUser> facebook_friends = <FacebookUser>[];
  final Future<bool> _loaded = Future<bool>.delayed(
    const Duration(seconds: 2),
    () => true,
  );
  final imagePicker = ImagePicker();
  var storage = FirebaseStorage.instance;
  @override
  void initState() {
    facebookuser_service
        .getListFacebookUser(StorageController.getCurrentUserId(), (result) {
      var resultMap = result as List<dynamic>;

      setState(() {
        List<FacebookUser> facebook_friend_list = <FacebookUser>[];
        resultMap.forEach((item) {
          var facebook_user = item as Map<String, dynamic>;
          facebook_friend_list.add(FacebookUser(
              name:
                  facebook_user["firstName"] + " " + facebook_user["lastName"],
              imageUrl: facebook_user["photoUrl"],
              point: facebook_user["point"]));
        });
        facebook_friends = facebook_friend_list;
      });
      // set State
    }, (error) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.transparentAppBar().transparentAppbar(context),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).colorScheme.background,
          child: Column(
            children: [
              _buildFacebookListFriend(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderFacebookListFriend() {
    if (facebook_friends.length == 0) {
      return Center(
          child: FutureBuilder<bool>(
              future: _loaded,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData) {
                  return Text("Không có dữ liệu");
                } else {
                  return CircularProgressIndicator();
                }
              }));
    } else {
      return ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: facebook_friends.length,
        itemBuilder: (context, index) {
          var friend = facebook_friends[index];
          return ListTile(
            leading: new Text("# ${index + 1}"),
            title: new Row(children: <Widget>[
              SizedBox(
                width: PaddingConstants.large,
              ),
              Hero(
                tag: index,
                child: new CircleAvatar(
                  backgroundImage: new NetworkImage(friend.imageUrl),
                  radius: 15,
                ),
              ),
              SizedBox(
                width: PaddingConstants.small,
              ),
              Text(friend.name),
            ]),
            trailing: new Text(friend.point.toString()),
          );
        },
        separatorBuilder: (context, index) => Divider(),
      );
    }
  }

  Widget _buildFacebookListFriend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Material(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 5.0,
          color: Theme.of(context).colorScheme.surface,
          child: Column(children: [
            InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              splashColor: (Theme.of(context).brightness == Brightness.light)
                  ? Colors.grey.shade300
                  : Colors.grey.shade500,
              child: ListTile(
                  horizontalTitleGap: 0,
                  leading: Icon(
                    Icons.facebook,
                    color: (Theme.of(context).brightness == Brightness.light)
                        ? Color.fromARGB(255, 66, 103, 178)
                        : Color.fromARGB(255, 66, 103, 178),
                    size: 30,
                  ),
                  title: Text(AppLocalizations.of(context).leaderboard,
                      style: Theme.of(context).textTheme.titleMedium)),
            ),
            Divider(height: 0, indent: 0, thickness: 0, color: Colors.black54),
            _renderFacebookListFriend(),
          ]),
        ),
      ),
    );
  }
}
