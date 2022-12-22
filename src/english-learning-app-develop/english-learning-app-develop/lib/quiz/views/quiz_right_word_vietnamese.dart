import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_for_extend.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_right_word_dataset.dart';
import 'package:learning_english_app/common/dataset/word/word_dataset.dart';
import 'package:learning_english_app/common/extensions.dart';
import 'package:learning_english_app/components/theme.dart';

class QuizRightWordVietnameseScreen extends StatefulWidget {
  final QuizRightWordDataset quizRightWordDataset;
  final CallBack<bool, Map<String, dynamic>> onClick;

  QuizRightWordVietnameseScreen.fromDataset(
      {required this.quizRightWordDataset,
      required this.onClick,
      required Key key})
      : super(key: key);

  @override
  State<QuizRightWordVietnameseScreen> createState() => _QuizRightWordVietnamScreenState();
}

class _QuizRightWordVietnamScreenState extends State<QuizRightWordVietnameseScreen> {
  late QuizRightWordDataset quizRightWordDataset;
  late Widget renderWidget = CircularProgressIndicator();

  late List<String> choices = [];
  List<int> intPos = [0, 1, 2, 3];
  int correctChoicePos = -1;
  int userChoicePos = -1;
  bool isPressedChoice = false;
  WordDataset? word;
  Map<String, dynamic> dataForRenderResult = Map();

  @override
  void initState() {
    super.initState();
    quizRightWordDataset = widget.quizRightWordDataset;

    StorageController.database!.wordDao
        .findWordById(quizRightWordDataset.wordId ?? "")
        .then((value) {
      if (value != null) {
        word = value;
        dataForRenderResult["quizType"] = QuizType.RightWord;
        dataForRenderResult["correctWord"] = word;
        while (intPos[0] != -1 ||
            intPos[1] != -1 ||
            intPos[2] != -1 ||
            intPos[3] != -1) {
          var randomPos = ExtensionMethod.random(0, intPos.length);
          if (intPos[randomPos] == -1) {
            continue;
          } else if (intPos[randomPos] == 0) {
            choices.add(quizRightWordDataset.firstChoice ?? "");
          } else if (intPos[randomPos] == 1) {
            choices.add(quizRightWordDataset.secondChoice ?? "");
          } else if (intPos[randomPos] == 2) {
            choices.add(quizRightWordDataset.thirdChoice ?? "");
          } else if (intPos[randomPos] == 3) {
            choices.add(quizRightWordDataset.correctChoice ?? "");
            correctChoicePos = choices.length - 1;
          }
          intPos[randomPos] = -1;
        }
        setState(() {});
      }
    });
  }

  Widget createQuizRightWord(QuizRightWordDataset quizRightWordDataset) {
    List<Color> color = List.generate(4, (index) => Colors.grey.shade500);
    if (isPressedChoice) {
      color[userChoicePos] = Theme.of(context).colorScheme.primaryContainer;
    }
    if (word != null) {
      return Container(
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            SizedBox(
              height: PaddingConstants.large,
            ),
             Text(
              word?.word ?? "",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: PaddingConstants.med,
            ),
            Text(
              AppLocalizations.of(context).whichWordMeanVn,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: PaddingConstants.extraLarge,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: color[0],
                  onPrimary: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.7,
                      50), //////// HERE
                ),
                onPressed: () {
                  
                  setState(() {
                    isPressedChoice = true;
                    userChoicePos = 0;
                  });
                  if (choices[0].toLowerCase() == quizRightWordDataset.correctChoice!.toLowerCase()) {
                    widget.onClick(true, dataForRenderResult);
                    return;
                  }
                  widget.onClick(false, dataForRenderResult);
                },
                child: Text(
                  choices[0],
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 25),
                )),
            SizedBox(
              height: PaddingConstants.extraLarge,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: color[1],
                  onPrimary: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.7,
                      50), //////// HERE
                ),
                onPressed: () {
                   setState(() {
                    isPressedChoice = true;
                    userChoicePos = 1;
                  });
                  if (choices[1].toLowerCase() == quizRightWordDataset.correctChoice!.toLowerCase()) {
                    widget.onClick(true, dataForRenderResult);
                    return;
                  }
                  widget.onClick(false, dataForRenderResult);
                },
                child: Text(
                  choices[1],
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 25),
                )),
            SizedBox(
              height: PaddingConstants.extraLarge,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: color[2],
                  onPrimary: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.7,
                      50), //////// HERE
                ),
                onPressed: () {
                 
                  setState(() {
                    isPressedChoice = true;
                    userChoicePos = 2;
                  });
                  if (choices[2].toLowerCase() == quizRightWordDataset.correctChoice!.toLowerCase()) {
                    widget.onClick(true, dataForRenderResult);
                    return;
                  }
                  widget.onClick(false, dataForRenderResult);
                },
                child: Text(
                  choices[2],
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 25),
                )),
            SizedBox(
              height: PaddingConstants.extraLarge,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: color[3],
                  onPrimary: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.7,
                      50), //////// HERE
                ),
                onPressed: () {
                
                  setState(() {
                    isPressedChoice = true;
                    userChoicePos = 3;
                  });
                  if (choices[3].toLowerCase() == quizRightWordDataset.correctChoice!.toLowerCase()) {
                    widget.onClick(true, dataForRenderResult);
                    return;
                  }
                  widget.onClick(false, dataForRenderResult);
                },
                child: Text(
                  choices[3],
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 25),
                )),
          ]));
    }
    return CircularProgressIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return createQuizRightWord(quizRightWordDataset);
  }
}
