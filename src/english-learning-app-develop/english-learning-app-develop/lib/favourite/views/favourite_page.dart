import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/common/controller/toast_controller.dart';
import 'package:learning_english_app/common/dataset/word/word_dataset.dart';
import 'package:learning_english_app/common/environment.dart';
import 'package:learning_english_app/common/extensions.dart';
import 'package:learning_english_app/common/http_client_service.dart';
import 'package:learning_english_app/favourite/models/dataset/user_favourite_dataset.dart';
import 'package:learning_english_app/favourite/views/add_new_word_sheet.dart';
import 'package:learning_english_app/favourite/views/sort_modal_sheet.dart';
import 'package:learning_english_app/profile/models/dataset/setting_dataset.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FavouritePage extends StatefulWidget {
  static const String routeName = '/learnPage';

  @override
  FavouritePageState createState() => FavouritePageState();
}

class FavouritePageState extends State<FavouritePage> {
  List<UserFavouriteDataset> userFavouriteList = [];
  late PersistentBottomSheetController controller;
  PageController pageController = PageController();
  late SettingDataset userSetting;
  late PageView renderPageView;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String? sortValue;
  late List<String> sortItem = [];
  late List<int> searchIndex = [];
  ScrollController userFavouriteScrollController = ScrollController();
  ValueNotifier<List<Map>> filtered = ValueNotifier<List<Map>>([]);
  bool isExtend = false;

  Widget ListTileTap({
    required int index,
    required UserFavouriteDataset userFavouriteDataset,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: PaddingConstants.large),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          splashColor: (Theme.of(context).brightness == Brightness.light)
              ? Colors.grey.shade300
              : Colors.grey.shade600,
          onTap: () {
            if (pageController.hasClients) {
              pageController.jumpToPage(index);
            }
            pageController = PageController(initialPage: index);
            showModalSheet(index);
          },
          child: ListTile(
            tileColor: Theme.of(context).colorScheme.surface,
            title: Text(
              userFavouriteDataset.wordDataset?.word ?? "",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              userFavouriteDataset.wordDataset?.mean ?? "",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            visualDensity: VisualDensity(vertical: 3), //
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            horizontalTitleGap: 0,
            leading: null,
          ),
        ),
      ),
    );
  }

  Widget WordCardView(WordDataset word) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: PaddingConstants.large),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: PaddingConstants.med,
          ),
          Row(children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: word.word,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.titleLarge!.color,
                          fontSize: 35)),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            IconButton(
              icon: Icon(
                Icons.volume_up,
                size: 20,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              onPressed: () async {
                final player = AudioPlayer();
                var fileUrl = word.audioFile ?? "";
                try {
                  await player.setUrl(fileUrl);
                  await player.play();
                } on PlayerException catch (e) {
                  ToastController.showError(
                      AppLocalizations.of(context)
                          .somethingwentwrongpleasetryagainlater,
                      context);
                } on PlayerInterruptedException catch (e) {
                  ToastController.showError(
                      AppLocalizations.of(context)
                          .somethingwentwrongpleasetryagainlater,
                      context);
                } catch (e) {
                  ToastController.showError(
                      AppLocalizations.of(context)
                          .somethingwentwrongpleasetryagainlater,
                      context);
                }
              },
              splashRadius: 20,
            )
          ]),
          SizedBox(
            height: PaddingConstants.med,
          ),
          Text(word.phoneticNotation! + ": " + word.phoneticSpelling!,
              style: Theme.of(context).textTheme.bodyLarge),
          SizedBox(
            height: PaddingConstants.med,
          ),
          Text(typeOfWord(word.lexicalCategory!),
              style: Theme.of(context).textTheme.bodyLarge),
          SizedBox(
            height: PaddingConstants.med,
          ),
          (userSetting != null && userSetting?.appLanguage == Language.VN.name)
              ? Text(
                  AppLocalizations.of(context).definition + ": " + word.mean!,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold))
              : Text(
                  AppLocalizations.of(context).definition +
                      ": " +
                      word.definitions!,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold)),
          SizedBox(
            height: PaddingConstants.med,
          ),
          (word.examples != null && word.examples != "null")
              ? getExample(word.examples!, word.word!)
              : SizedBox.shrink(),
          SizedBox(
            height: PaddingConstants.large,
          ),
          (word.synonyms != null && word.synonyms != "")
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                      Text(AppLocalizations.of(context).synonyms,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.bodyMedium),
                      Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: convertSynosym(
                            word.synonyms!,
                          ))
                    ])
              : SizedBox.shrink(),
          SizedBox(
            height: PaddingConstants.extraLarge * 3.5,
          )
        ],
      ),
    );
  }

  RichText getExample(String example, String word) {
    var index = example.indexOf(word);
    var leftExample = example.substring(0, index);
    var rightExample = example.substring(index + word.length, example.length);
    return RichText(
        textAlign: TextAlign.start,
        text:
            TextSpan(style: Theme.of(context).textTheme.titleLarge, children: [
          TextSpan(
              text: leftExample, style: Theme.of(context).textTheme.bodyLarge),
          TextSpan(
              text: word,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.red)),
          TextSpan(
              text: rightExample, style: Theme.of(context).textTheme.bodyLarge!)
        ]));
  }

  List<Widget> convertSynosym(String sysnonyms) {
    List<Widget> returnWidget = [];
    List<String> wordList = sysnonyms.split(";");
    var length = wordList.length;
    for (int i = 0; i < length; i++) {
      var wordButton = ElevatedButton(
        onPressed: () {},
        child: Text(
          wordList[i],
        ),
      );
      returnWidget.add(wordButton);
    }
    return returnWidget;
  }

  String typeOfWord(String type) {
    switch (type) {
      case "Adjective":
        {
          return AppLocalizations.of(context).adjective;
        }
      case "Verb":
        {
          return AppLocalizations.of(context).verb;
        }
      case "Adverb":
        {
          return AppLocalizations.of(context).adverb;
        }
      case "Noun":
        {
          return AppLocalizations.of(context).noun;
        }
    }
    return "";
  }

  void showModalSheet(int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: PaddingConstants.large),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: SmoothPageIndicator(
                                controller: pageController,
                                count: this.userFavouriteList.length,
                                effect: SlideEffect(
                                    activeDotColor:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      padEnds: false,
                      controller: pageController,
                      children: userFavouriteList
                          .map<Widget>((e) => WordCardView(e.wordDataset!))
                          .toList(),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                        child: Text(AppLocalizations.of(context)
                            .doneButton
                            .toUpperCase()),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(150, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          primary: Color(0xff1877F2),
                          elevation: 2,
                          padding: const EdgeInsets.all(10),
                        )),
                  ),
                  SizedBox(
                    height: PaddingConstants.extraLarge,
                  )
                ],
              ));
        },
        isScrollControlled: true,
        isDismissible: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FutureGroup futureGroup = FutureGroup();
    futureGroup.add(StorageController.database!.settingDao
        .findSetting(DeviceInfo.deviceID));
    futureGroup.add(StorageController.database!.userFavouriteDao
        .getUserFavouriteByUserId(StorageController.getCurrentUserId() ?? ""));
    futureGroup.close();
    futureGroup.future.then((value) {
      userSetting = value[0] as SettingDataset;
      userFavouriteList = value[1] as List<UserFavouriteDataset>;
      FutureGroup futureGroupForWord = FutureGroup();
      for (int i = 0; i < userFavouriteList.length; i++) {
        futureGroupForWord.add(StorageController.database!.wordDao
            .findWordById(userFavouriteList[i].wordId ?? ""));
      }
      futureGroupForWord.close();
      futureGroupForWord.future.then((value) {
        for (int i = 0; i < userFavouriteList.length; i++) {
          userFavouriteList[i].wordDataset = value[i] as WordDataset;
        }
        sortFavourite();
        setState(() {});
      });
    });
    userFavouriteScrollController.addListener(() {
      if (userFavouriteScrollController.position.atEdge) {
        bool isTop = userFavouriteScrollController.position.pixels == 0;
        if (isTop) {
          setState(() {
            isExtend = false;
          });
          return;
        }
      }
      setState(() {
        isExtend = true;
      });
    });
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      sortValue = AppLocalizations.of(context).sortAToZ;
    });
  }

  void sortFavourite() {
    var value = sortValue;
    if (userFavouriteList.contains(null)) {
      return;
    }
    if (value == AppLocalizations.of(context).sortAToZ) {
      userFavouriteList.sort(((a, b) {
        return a.wordDataset!.word!.compareTo(b.wordDataset!.word!);
      }));
    } else if (value == AppLocalizations.of(context).sortZToA) {
      userFavouriteList.sort(((a, b) {
        return b.wordDataset!.word!.compareTo(a.wordDataset!.word!);
      }));
    } else if (value == AppLocalizations.of(context).sortDateNewToOld) {
      userFavouriteList.sort(((a, b) {
        return a.created_at
            .parseMongoDBDate()!
            .compareTo(b.created_at.parseMongoDBDate()!);
      }));
    } else if (value == AppLocalizations.of(context).sortDateOldToNew) {
      userFavouriteList.sort((a, b) {
        return b.created_at
            .parseMongoDBDate()!
            .compareTo(a.created_at.parseMongoDBDate()!);
      });
    } else {
      userFavouriteList.sort(((a, b) {
        return a.wordDataset!.word!.compareTo(b.wordDataset!.word!);
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showModalBottomSheet(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                context: context,
                builder: (context) {
                  return AddNewWordSheet(
                    onCallBack: (value) {
                      Navigator.of(context).pop();
                      var dataset = UserFavouriteDataset();
                      dataset.id = "";
                      dataset.userId = StorageController.getCurrentUserId();
                      dataset.wordId = value.id;
                      var url = Environment.apiUrl +
                          '/user-favourite/${AppInfo.apiVersion}/';
                      Map<String, dynamic> parameter = dataset.toJson();
                      HttpClientService().requestTo(
                          url: url,
                          method: HttpMethod.POST,
                          parameters: parameter,
                          success: (result) {
                            var resultMap = result as Map<String, dynamic>;
                            var dataset = UserFavouriteDataset.fromJson(
                                resultMap["userFavourite"]
                                    as Map<String, dynamic>);
                            StorageController.database?.userFavouriteDao
                                .insertOneRecord(dataset);
                            dataset.wordDataset = value;
                            userFavouriteList.add(dataset);
                            sortFavourite();
                            setState(() {});
                          },
                          failure: (error) {});
                    },
                  );
                });
          },
          label: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) =>
                FadeTransition(
              opacity: animation,
              child: SizeTransition(
                child: child,
                sizeFactor: animation,
                axis: Axis.horizontal,
              ),
            ),
            child: isExtend
                ? Icon(Icons.add)
                : Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Icon(Icons.add),
                      ),
                      Text(AppLocalizations.of(context).addNewFavouriteWord)
                    ],
                  ),
          )),
      appBar: AppBar(
        leading: null,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: TextFormField(
          onChanged: ((value) {
            if (value.length > 0) {
              searchIndex = [];
              for (int i = 0; i < userFavouriteList.length; i++) {
                if (userFavouriteList[i].wordDataset != null) {
                  if (userFavouriteList[i]
                      .wordDataset!
                      .word!
                      .toLowerCase()
                      .contains(value.toLowerCase())) {
                    searchIndex.add(i);
                  }
                }
              }
            } else {
              searchIndex = [];
            }
            setState(() {});
          }),
          cursorColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.search,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: AppLocalizations.of(context).search,
            filled: true,
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(30))),
            contentPadding: EdgeInsetsDirectional.only(start: 15),
          ),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: SafeArea(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.sort),
                iconSize: 24,
                splashRadius: 40,
                onPressed: () {
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      context: context,
                      builder: (context) {
                        return SortModalSheet(
                            defaultSearchValue: sortValue,
                            sortItem: [
                              AppLocalizations.of(context).sortAToZ,
                              AppLocalizations.of(context).sortZToA,
                              AppLocalizations.of(context).sortDateNewToOld,
                              AppLocalizations.of(context).sortDateOldToNew
                            ],
                            onClickCallBack: (value) {
                              sortValue = value;
                              Navigator.of(context).pop();
                              sortFavourite();
                              setState(() {});
                            });
                      });
                },
              ),
            ),
            Expanded(
                child: ListView.builder(
                    controller: userFavouriteScrollController,
                    itemCount: userFavouriteList.length,
                    itemBuilder: ((context, index) {
                      if (searchIndex.length > 0) {
                        if (searchIndex.contains(index)) {
                          return Slidable(
                            endActionPane:
                                ActionPane(motion: ScrollMotion(), children: [
                              SlidableAction(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.error,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                  onPressed: (context) {})
                            ]),
                            child: ListTileTap(
                                index: index,
                                userFavouriteDataset: userFavouriteList[index]),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      } else {
                        return Slidable(
                          endActionPane: ActionPane(
                              extentRatio: 0.3,
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                    flex: 1,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.error,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: AppLocalizations.of(context)
                                        .deleteButton,
                                    onPressed: (context) {
                                      var url = Environment.apiUrl +
                                          '/user-favourite/${AppInfo.apiVersion}/deleteByUserIdWordId';
                                      var parameter = Map<String, dynamic>();
                                      parameter["userId"] =
                                          StorageController.getCurrentUserId();
                                      parameter["wordId"] =
                                          userFavouriteList[index].id;
                                      HttpClientService().requestTo(
                                          url: url,
                                          method: HttpMethod.POST,
                                          parameters: parameter,
                                          success: (result) {
                                            var resultMap =
                                                result as Map<String, dynamic>;
                                            if (resultMap["success"] as bool ==
                                                true) {
                                              StorageController
                                                  .database?.userFavouriteDao
                                                  .deleteBaseOnUserIdAndWord(
                                                      parameter["userId"]
                                                          as String,
                                                      parameter["wordId"]
                                                          as String);
                                              userFavouriteList.removeAt(index);
                                              setState(() {});
                                            }
                                          },
                                          failure: (error) {
                                            ToastController.showError(
                                                AppLocalizations.of(context)
                                                    .somethingwentwrongpleasetryagainlater,
                                                context);
                                          });
                                    })
                              ]),
                          child: ListTileTap(
                              index: index,
                              userFavouriteDataset: userFavouriteList[index]),
                        );
                      }
                    })))
          ],
        ),
      )),
    );
  }
}
