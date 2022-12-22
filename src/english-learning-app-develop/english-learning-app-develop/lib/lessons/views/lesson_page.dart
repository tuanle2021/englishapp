import 'dart:ffi';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:just_audio/just_audio.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/common/controller/toast_controller.dart';
import 'package:learning_english_app/common/dataset/lesson/lesson_dataset.dart';
import 'package:learning_english_app/common/dataset/word/word_dataset.dart';
import 'package:learning_english_app/common/environment.dart';
import 'package:learning_english_app/common/http_client_service.dart';
import 'package:learning_english_app/common/leareng_log.dart';
import 'package:learning_english_app/components/login_button.dart';
import 'package:learning_english_app/favourite/models/dataset/user_favourite_dataset.dart';
import 'package:learning_english_app/profile/models/dataset/setting_dataset.dart';
import 'package:learning_english_app/profile/models/services/profile_service.dart';
import 'package:learning_english_app/quiz/services/quiz_service.dart';
import 'package:like_button/like_button.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LessonPage extends StatefulWidget {
  final Map<String, dynamic> parameter;
  LessonPage.fromParameter({required this.parameter});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  final controller = PageController(viewportFraction: 1.0, keepPage: false);
  List<WordDataset?> listLessonWord = [];
  var isShowEnglish = false;
  SettingDataset? userSetting = null;
  LessonDataset lesson = LessonDataset();
  String categoryId = "";

  bool isFavourite = false;

  int index = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.parameter["lesson"] != null) {
      lesson = widget.parameter["lesson"] as LessonDataset;
    }
    if (widget.parameter["categoryId"] != null) {
      categoryId = widget.parameter["categoryId"] as String;
    }
    index = 0;
    controller.addListener(() async {
      index = controller.page!.toInt();
      var lesson = await StorageController.database!.userFavouriteDao
          .getUserFavouriteByUserIdAndWordId(
              StorageController.getCurrentUserId() ?? "",
              listLessonWord[index]?.id ?? "");
      if (lesson != null) {
        isFavourite = true;
      } else {
        isFavourite = false;
      }

      setState(() {});
    });

    FutureGroup futureGroup = FutureGroup();
    futureGroup.add(ProfileService().getUserSetting());
    futureGroup.add(
        StorageController.database!.wordDao.getWordByLessonId(lesson.id ?? ""));
    LearnEngLog.logger.i("lesson id ${lesson.id}");
    futureGroup.close();
    futureGroup.future.then((value) {
      userSetting = value[0] as SettingDataset;
      listLessonWord = value[1] as List<WordDataset>;
      StorageController.database!.userFavouriteDao
          .getUserFavouriteByUserIdAndWordId(
              StorageController.getCurrentUserId() ?? "",
              listLessonWord[index]?.id ?? "")
          .then((lesson) {
        if (lesson != null) {
          isFavourite = true;
        } else {
          isFavourite = false;
        }
        setState(() {});
      });

      setState(() {});
    });
  }

  Widget WordCardView(WordDataset word) {
    RoundedLoadingButtonController lastButton =
        RoundedLoadingButtonController();
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: PaddingConstants.large),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: PaddingConstants.extraLarge,
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
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: (word.id == listLessonWord.last?.id)
                  ? LoginButton(
                      onPressed: () {
                        lastButton.reset();
                        Map<String, dynamic> parameters = Map();
                        parameters["lesson"] = lesson;
                        parameters["categoryId"] = categoryId;
                        Navigator.of(context)
                            .pushNamed('/lesson_quiz', arguments: parameters);
                      },
                      buttonLabel: AppLocalizations.of(context).startQuiz,
                      roundedLoadingButtonController: lastButton)
                  : SizedBox.shrink(),
            ),
          ),
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

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    if (!isLiked == true) {
      var dataset = UserFavouriteDataset();
      dataset.id = "";
      dataset.userId = StorageController.getCurrentUserId();
      dataset.wordId = listLessonWord[index]!.id;
      var url = Environment.apiUrl + '/user-favourite/${AppInfo.apiVersion}/';
      Map<String, dynamic> parameter = dataset.toJson();
      HttpClientService().requestTo(
          url: url,
          method: HttpMethod.POST,
          parameters: parameter,
          success: (result) {
            var resultMap = result as Map<String, dynamic>;
            var dataset = UserFavouriteDataset.fromJson(
                resultMap["userFavourite"] as Map<String, dynamic>);
            StorageController.database?.userFavouriteDao
                .insertOneRecord(dataset);
          },
          failure: (error) {});
    } else {
      var url = Environment.apiUrl +
          '/user-favourite/${AppInfo.apiVersion}/deleteByUserIdWordId';
      var parameter = Map<String, dynamic>();
      parameter["userId"] = StorageController.getCurrentUserId();
      parameter["wordId"] = listLessonWord[index]!.id;
      HttpClientService().requestTo(
          url: url,
          method: HttpMethod.POST,
          parameters: parameter,
          success: (result) {
            var resultMap = result as Map<String, dynamic>;
            if (resultMap["success"] as bool == true) {
              StorageController.database?.userFavouriteDao
                  .deleteBaseOnUserIdAndWord(parameter["userId"] as String,
                      parameter["wordId"] as String);
            }
          },
          failure: (error) {
            ToastController.showError(
                AppLocalizations.of(context)
                    .somethingwentwrongpleasetryagainlater,
                context);
          });
    }
    return !isLiked;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    QuizService.timer != null ? QuizService.timer?.stop() : 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: SmoothPageIndicator(
              controller: controller,
              count: listLessonWord.length,
              effect: SlideEffect(
                  activeDotColor: Theme.of(context).colorScheme.primary),
            ),
          ),
          actions: [
            LikeButton(
              isLiked: isFavourite,
              likeBuilder: (bool isLiked) {
                return Icon(
                  Icons.favorite,
                  color: isLiked
                      ? Theme.of(context).colorScheme.onBackground
                      : Colors.grey.shade700,
                  size: 24,
                );
              },
              circleColor:
                  CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
              bubblesColor: BubblesColor(
                dotPrimaryColor: Color(0xff33b5e5),
                dotSecondaryColor: Color(0xff0099cc),
              ),
              onTap: onLikeButtonTapped,
            ),
            IconButton(
              icon: Icon(
                Icons.volume_up,
                size: 24,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              onPressed: () async {
                final player = AudioPlayer();
                var fileUrl =
                    listLessonWord[controller.page?.toInt() ?? 0]?.audioFile ??
                        "";
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
          ],
          systemOverlayStyle: SystemUiOverlayStyle(
            // Status bar color
            // Status bar brightness (optional)
            statusBarIconBrightness:
                Theme.of(context).brightness, // For Android (dark icons)
            statusBarBrightness:
                Theme.of(context).brightness, // For iOS (dark icons)
          ),
          leading: IconButton(
            splashRadius: 20,
            icon: Icon(Icons.close,
                color: Theme.of(context).colorScheme.onBackground),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          centerTitle: (Platform.isIOS) ? true : false,
          bottomOpacity: 0,
          shadowColor: Colors.transparent,
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            color: Theme.of(context).colorScheme.background,
            child: Stack(
              fit: StackFit.expand,
              children: [
                SizedBox(
                  height: PaddingConstants.extraLarge,
                ),
                (listLessonWord.length > 0)
                    ? PageView(
                        padEnds: false,
                        controller: controller,
                        children: listLessonWord
                            .map<Widget>((e) => WordCardView(e!))
                            .toList(),
                      )
                    : SizedBox.shrink(),
              ],
            )));
  }
}
