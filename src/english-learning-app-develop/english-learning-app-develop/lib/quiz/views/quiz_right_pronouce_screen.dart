import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:just_audio/just_audio.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_for_extend.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_right_pronouce_dataset.dart';
import 'package:learning_english_app/common/dataset/word/word_dataset.dart';
import 'package:learning_english_app/common/extensions.dart';
import 'package:learning_english_app/components/theme.dart';

class QuizRightPronouceScreen extends StatefulWidget {
  final QuizRightPronouceDataset quizRightPronouceDataset;
  final CallBack<bool, Map<String, dynamic>> onClick;

  QuizRightPronouceScreen.fromDataset({
    required Key? key,
    required this.quizRightPronouceDataset,
    required this.onClick,
  }) : super(key: key);

  @override
  State<QuizRightPronouceScreen> createState() =>
      _QuizRightPronouceScreenState();
}

class _QuizRightPronouceScreenState extends State<QuizRightPronouceScreen> {
  late QuizRightPronouceDataset quizRightPronouceDataset;
  late Widget renderWidget = CircularProgressIndicator();
  late List<WordDataset> choices = [];
  List<int> intPos = [0, 1];
  int correctChoicePos = -1;
  int userChoicePos = -1;
  bool isPressedChoice = false;

  WordDataset? wordOne;
  WordDataset? wordTwo;

  Map<String, dynamic> dataForRenderResult = Map();

  @override
  void initState() {
    super.initState();
    quizRightPronouceDataset = widget.quizRightPronouceDataset;

    FutureGroup futureGroup = FutureGroup();
    futureGroup.add(StorageController.database!.wordDao
        .findWordById(quizRightPronouceDataset.wordId ?? ""));
    futureGroup.add(StorageController.database!.wordDao
        .findWordById(quizRightPronouceDataset.wordIdOne ?? ""));
    futureGroup.close();
    futureGroup.future.then((value) {
      wordOne = value[0] as WordDataset;
      wordTwo = value[1] as WordDataset;
      while (intPos[0] != -1 || intPos[1] != -1) {
        var randomPos = ExtensionMethod.random(0, intPos.length);
        if (intPos[randomPos] == -1) {
          continue;
        } else if (intPos[randomPos] == 0) {
          choices.add(wordOne!);
          correctChoicePos = choices.length - 1;
        } else if (intPos[randomPos] == 1) {
          choices.add(wordTwo!);
        }
        intPos[randomPos] = -1;
        setState(() {});
      }
      dataForRenderResult["quizType"] = QuizType.RightPronouce;
      dataForRenderResult["correctWord"] = choices[correctChoicePos];
    });
  }

  Widget createQuizRightPronouce(
      QuizRightPronouceDataset quizRightPronouceDataset) {
    List<Color> color = List.generate(2, (index) => Colors.grey.shade500);
    if (isPressedChoice) {
        color[userChoicePos] = Theme.of(context).colorScheme.primaryContainer;
    }
    if (wordOne != null && wordTwo != null) {
      return Container(
          child: Column(
        children: [
          SizedBox(
            height: PaddingConstants.large,
          ),
          Text(AppLocalizations.of(context).chooseRightPronouce,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(
            height: PaddingConstants.large,
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Text(wordOne!.word ?? "",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 25,fontWeight: FontWeight.bold)),
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Text(wordOne!.phoneticSpelling ?? "",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 23)),
          ),
          SizedBox(
            height: PaddingConstants.extraLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: color[0],
                      onPrimary: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      minimumSize: Size(150, 100), //////// HERE
                    ),
                    onPressed: ()async {
                      setState(() {
                        userChoicePos = 0;
                        isPressedChoice = true;
                      });
                      if (choices[0].id == quizRightPronouceDataset.wordId) {
                        widget.onClick(true, dataForRenderResult);
                      }
                      else {
                        widget.onClick(false, dataForRenderResult);
                      }
                      
                       final audioPlayer = AudioPlayer();
                        var url = choices[0].audioFile ?? "";
                        try {
                          await audioPlayer.setUrl(url);
                          await audioPlayer.play();
                        } on PlayerException catch (e) {
                          print("Error code: ${e.code}");
                          print("Error message: ${e.message}");
                        } on PlayerInterruptedException catch (e) {
                          print("Connection aborted: ${e.message}");
                        } catch (e) {
                          print(e);
                        } 
                      
                    },
                    child: Icon(Icons.volume_up,size: 48,),
                  )
                ],
              ),
              SizedBox(
                width: PaddingConstants.med,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: color[1],
                        onPrimary: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        minimumSize: Size(150, 100), //////// HERE
                      ),
                      onPressed: () async {
                        setState(() {
                          userChoicePos = 1;
                          isPressedChoice = true;
                        });
                        if (choices[1].id == quizRightPronouceDataset.wordId) {
                          widget.onClick(true, dataForRenderResult);
                        }
                        else {
                           widget.onClick(false, dataForRenderResult);
                        }
                        final audioPlayer = AudioPlayer();
                        var url = choices[1].audioFile ?? "";
                        try {
                          await audioPlayer.setUrl(url);
                          await audioPlayer.play();
                        } on PlayerException catch (e) {
                          print("Error code: ${e.code}");
                          print("Error message: ${e.message}");
                        } on PlayerInterruptedException catch (e) {
                          print("Connection aborted: ${e.message}");
                        } catch (e) {
                          print(e);
                        }
                      
                       
                      },
                      child: Icon(Icons.volume_up,size: 48,)),
                ],
              ),
            ],
          ),
          SizedBox(
            height: PaddingConstants.large,
          ),
        ],
      ));
    }
    return CircularProgressIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return createQuizRightPronouce(quizRightPronouceDataset);
  }
}
