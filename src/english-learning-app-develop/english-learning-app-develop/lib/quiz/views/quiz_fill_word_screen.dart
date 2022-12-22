import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_fill_word_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_for_extend.dart';
import 'package:learning_english_app/common/extensions.dart';
import 'package:learning_english_app/components/theme.dart';

class QuizFillWordView extends StatefulWidget {
  final QuizFillWordDataset quizFillWordDataset;
  final CallBack<bool, Map<String, dynamic>> onClick;

  QuizFillWordView.fromDataset(
      {required this.quizFillWordDataset,
      required this.onClick,
      required Key key})
      : super(key: key);

  @override
  State<QuizFillWordView> createState() => _QuizFillWordViewState();
}

class _QuizFillWordViewState extends State<QuizFillWordView> {
  late QuizFillWordDataset quizFillWordDataset;
  late List<String> choices = [];
  Map<String, dynamic> dataForRenderResult = Map();
  List<int> intPos = [0, 1, 2, 3];
  int correctChoicePos = -1;
  int userChoicePos = -1;
  bool isPressedChoice = false;
  @override
  void initState() {
    super.initState();

    quizFillWordDataset = widget.quizFillWordDataset;
    while (intPos[0] != -1 ||
        intPos[1] != -1 ||
        intPos[2] != -1 ||
        intPos[3] != -1) {
      var randomPos = ExtensionMethod.random(0, intPos.length);
      if (intPos[randomPos] == -1) {
        continue;
      } else if (intPos[randomPos] == 0) {
        choices.add(quizFillWordDataset.firstChoice ?? "");
      } else if (intPos[randomPos] == 1) {
        choices.add(quizFillWordDataset.secondChoice ?? "");
      } else if (intPos[randomPos] == 2) {
        choices.add(quizFillWordDataset.thirdChoice ?? "");
      } else if (intPos[randomPos] == 3) {
        choices.add(quizFillWordDataset.correctChoice ?? "");
        correctChoicePos = choices.length - 1;
      }
      intPos[randomPos] = -1;
    }
    dataForRenderResult["quizType"] = QuizType.FillWord;
    dataForRenderResult["correctWord"] = quizFillWordDataset.correctChoice;
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) {
        // Execute callback if page is mounted
        if (mounted) {
          createQuizFillWord(quizFillWordDataset);
        }
        ;
      },
    );
  }

  Widget createQuizFillWord(QuizFillWordDataset quizFillWordDataset) {
    List<Color> color = List.generate(4, (index) => Colors.grey.shade500);
    if (isPressedChoice) {
      color[userChoicePos] = Theme.of(context).colorScheme.primaryContainer;
    }

    return Container(
        child: Column(
      children: [
        SizedBox(
          height: PaddingConstants.large,
        ),
        Text(
          AppLocalizations.of(context).fillMissingWord,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(
          height: PaddingConstants.large,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: "${quizFillWordDataset.leftOfWord} ",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 25)),
                  WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Container(
                          alignment: Alignment.center,
                          width: 50,
                          height: 30,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))))),
                  TextSpan(
                      text: " ${quizFillWordDataset.rightOfWord}",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 25)),
                ],
              ),
              textAlign: TextAlign.center,
              softWrap: true),
        ),
        SizedBox(
          height: PaddingConstants.large,
        ),
        Container(
            width: MediaQuery.of(context).size.width * 0.8,
            alignment: Alignment.center,
            child: Center(
                child: Text(
              "(${quizFillWordDataset.viSentence})",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 15),
            ))),
        SizedBox(
          height: PaddingConstants.extraLarge,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: color[0],
                  onSurface: color[0],
                  onPrimary: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  minimumSize: Size(150, 100), //////// HERE
                ),
                onPressed: () {
                  userChoicePos = 0;

                  setState(() {
                    isPressedChoice = true;
                  });
                  if (choices[0].toLowerCase() == quizFillWordDataset.correctChoice!.toLowerCase()) {
                    widget.onClick(true, dataForRenderResult);
                    return;
                  }

                  widget.onClick(false, dataForRenderResult);
                },
                child: Text(
                  choices[0],
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                )),
            SizedBox(
              width: PaddingConstants.med,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: color[1],
                onSurface: color[1],
                onPrimary: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                minimumSize: Size(150, 100), //////// HERE
              ),
              onPressed: () {
                userChoicePos = 1;
                setState(() {
                  isPressedChoice = true;
                });
                if (choices[1].toLowerCase() == quizFillWordDataset.correctChoice!.toLowerCase()) {
                  widget.onClick(true, dataForRenderResult);
                  return;
                }
                widget.onClick(false, dataForRenderResult);
              },
              child: Text(choices[1],
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      )),
            )
          ],
        ),
        SizedBox(
          height: PaddingConstants.large,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: color[2],
                  onPrimary: Colors.white,
                  onSurface: color[2],
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  minimumSize: Size(150, 100), //////// HERE
                ),
                onPressed: () {
                  userChoicePos = 2;
                  setState(() {
                    isPressedChoice = true;
                  });

                  if (choices[2].toLowerCase() == quizFillWordDataset.correctChoice!.toLowerCase()) {
                    widget.onClick(true, dataForRenderResult);
                    return;
                  }
                  widget.onClick(false, dataForRenderResult);
                },
                child: Text(
                  choices[2],
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                )),
            SizedBox(
              width: PaddingConstants.med,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: color[3],
                onPrimary: Colors.white,
                onSurface: color[3],
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                minimumSize: Size(150, 100),
              ),
              onPressed: () {
                userChoicePos = 3;
                setState(() {
                  isPressedChoice = true;
                });
                if (choices[3].toLowerCase() == quizFillWordDataset.correctChoice!.toLowerCase()) {
                  widget.onClick(true, dataForRenderResult);
                  return;
                }
                widget.onClick(false, dataForRenderResult);
              },
              child: Text(choices[3],
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      )),
            )
          ],
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return createQuizFillWord(quizFillWordDataset);
  }
}
