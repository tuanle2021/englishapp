import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/common/controller/toast_controller.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_fill_word_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_for_extend.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_right_word_dataset.dart';
import 'package:learning_english_app/common/dataset/word/word_dataset.dart';
import 'package:learning_english_app/common/environment.dart';
import 'package:learning_english_app/common/http_client_service.dart';
import 'package:learning_english_app/common/leareng_log.dart';
import 'package:learning_english_app/components/custom_app_bar.dart';
import 'package:learning_english_app/components/flash_card/cards.dart';
import 'package:learning_english_app/components/flash_card/controller.dart';
import 'package:learning_english_app/practice/service/user_card_dataset.dart';
import 'package:learning_english_app/profile/models/dataset/setting_dataset.dart';
import 'package:learning_english_app/profile/models/services/profile_service.dart';
import 'package:learning_english_app/quiz/views/quiz_fill_word_screen.dart';
import 'package:learning_english_app/quiz/views/quiz_right_word_screen.dart';
import 'package:learning_english_app/quiz/views/quiz_right_word_vietnamese.dart';

class PracticePage extends StatefulWidget {
  PracticePage({Key? key}) : super(key: key);

  @override
  State<PracticePage> createState() => PracticePageState();
}

class PracticePageState extends State<PracticePage> {
  final TCardController tCardController = TCardController();
  List<Widget> wordCards = [];
  List<UserCardDataset> userCardList = [];

  var userSetting;
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

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    ProfileService().getUserSetting().then((value) {
      userSetting = value;
    });

    var url = Environment.apiUrl +
        "/usercard/due/${StorageController.getCurrentUserId()}";
    HttpClientService().requestTo(
        url: url,
        method: HttpMethod.GET,
        success: (result) {
          var resultMap = result as List<dynamic>;
          for (int i = 0; i < resultMap.length; i++) {
            var userCard =
                UserCardDataset.fromJson(resultMap[i] as Map<String, dynamic>);
            StorageController.database?.wordDao
                .findWordById(userCard.wordId ?? "")
                .then((value) {
              userCard.word = value;
              userCardList.add(userCard);
              setState(() {
                renderLearningCard();
              });
            });
          }
        },
        failure: (error) {});
  }

  Widget WordCardView(WordDataset word) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow()],
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.surface,
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: PaddingConstants.large),
      width: MediaQuery.of(context).size.width * 0.8,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: PaddingConstants.extraLarge,
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
            (userSetting != null &&
                    userSetting?.appLanguage == Language.VN.name)
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
      ),
    );
  }

  List<Widget> renderLearningCard() {
    for (int i = 0; i < userCardList.length; i++) {
      wordCards.add(FlipCard(
          speed: 600,
          front: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: userCardList[i].word?.word,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .color,
                                      fontSize: 35)),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: IconButton(
                          onPressed: () async {
                            var quizRightWordList = await StorageController
                                .database!.quizRightWordDao
                                .findQuizByWordIdForPracticePage(
                                    userCardList[i].word?.id ?? "");
                            List<QuizExtend> quizList = [];
                            for (var item in quizRightWordList) {
                              quizList.add(item);
                            }
                            quizList.shuffle();
                            showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                context: context,
                                builder: (context) {
                                  return QuizRightWordVietnameseScreen.fromDataset(
                                      quizRightWordDataset: quizList.first
                                          as QuizRightWordDataset,
                                      onClick: (result, dataPass) {
                                        Navigator.of(context).pop();
                                        if (result == true) {
                                          ToastController.showSuccess(
                                              AppLocalizations.of(context)
                                                  .youKnowThisWord,
                                              context);
                                        } else {
                                          ToastController.showError(
                                              AppLocalizations.of(context)
                                                  .youNotKnowThisWord,
                                              context);
                                        }
                                      },
                                      key: UniqueKey());
                                });
                          },
                          icon: Icon(
                            Icons.question_answer,
                          )),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                boxShadow: [BoxShadow()],
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.surface,
              )),
          back: userCardList[i].word == null
              ? SizedBox.shrink()
              : WordCardView(userCardList[i].word!)));
    }
    return this.wordCards;
  }

  void updateRating(int rating) {
    LearnEngLog.logger.i(tCardController.index);
    var parameter = userCardList[tCardController.index].toJson();
    parameter["_id"] = parameter["id"];
    parameter["cardId"] = parameter["id"];
    parameter["rating"] = rating;
    var url = Environment.apiUrl + '/usercard/review';
    HttpClientService().requestTo(
        url: url,
        parameters: parameter,
        method: HttpMethod.POST,
        success: (result) {
          if (tCardController.index + 1 >= userCardList.length) {
            var url = Environment.apiUrl +
                "/usercard/due/${StorageController.getCurrentUserId()}";
            HttpClientService().requestTo(
                url: url,
                method: HttpMethod.GET,
                success: (result) {
                  var resultMap = result as List<dynamic>;
                  userCardList = [];
                  if (resultMap.isEmpty) {
                    setState(() {
                      userCardList = [];
                    });
                  }
                  for (int i = 0; i < resultMap.length; i++) {
                    var userCard = UserCardDataset.fromJson(
                        resultMap[i] as Map<String, dynamic>);
                    StorageController.database?.wordDao
                        .findWordById(userCard.wordId ?? "")
                        .then((value) {
                      userCard.word = value;
                      userCardList.add(userCard);
                      setState(() {
                        renderLearningCard();
                      });
                    });
                  }
                },
                failure: (error) {});
            return;
          }
          tCardController.forward();
        },
        failure: (error) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar.transparentAppBar().transparentAppbar(context),
        body: SafeArea(
          child: Container(
            color: Theme.of(context).colorScheme.background,
            child: userCardList.length > 0
                ? Column(
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height * 0.77,
                          color: Theme.of(context).colorScheme.background,
                          child: userCardList.length > 0
                              ? Center(
                                  child: TCard(
                                  controller: tCardController,
                                  size: Size(
                                      MediaQuery.of(context).size.width * 0.9,
                                      MediaQuery.of(context).size.height),
                                  cards: renderLearningCard(),
                                  onBack: null,
                                  onForward: (index, info) {},
                                ))
                              : SizedBox.shrink()),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                primary: Colors.red,
                                elevation: 2,
                                padding: const EdgeInsets.all(10),
                              ),
                              onPressed: () {
                                updateRating(0);
                              },
                              child: Text(
                                  AppLocalizations.of(context).againButton)),
                          SizedBox(
                            width: PaddingConstants.extraSmall,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                primary: Color.fromARGB(255, 197, 205, 41),
                                elevation: 2,
                                padding: const EdgeInsets.all(10),
                              ),
                              onPressed: () {
                                updateRating(1);
                              },
                              child: Text(
                                  AppLocalizations.of(context).hardButton)),
                          SizedBox(
                            width: PaddingConstants.extraSmall,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                primary: Color(0xff1877F2),
                                elevation: 2,
                                padding: const EdgeInsets.all(10),
                              ),
                              onPressed: () {
                                updateRating(2);
                              },
                              child: Text(
                                  AppLocalizations.of(context).goodButton)),
                          SizedBox(
                            width: PaddingConstants.extraSmall,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                primary: Colors.green,
                                elevation: 2,
                                padding: const EdgeInsets.all(10),
                              ),
                              onPressed: () {
                                updateRating(3);
                              },
                              child: Text(
                                  AppLocalizations.of(context).easyButton)),
                        ],
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      AppLocalizations.of(context).completeLessonToHaveWord,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
          ),
        ));
  }
}
