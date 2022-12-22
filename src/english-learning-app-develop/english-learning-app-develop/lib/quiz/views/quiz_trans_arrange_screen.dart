import 'package:async/async.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/common/dataset/quiz/phrase_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_for_extend.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_trans_arrange_dataset.dart';
import 'package:learning_english_app/common/dataset/word/word_dataset.dart';
import 'package:learning_english_app/common/extensions.dart';
import 'package:learning_english_app/common/leareng_log.dart';
import 'package:learning_english_app/components/theme.dart';

class QuizTransArrangeScreen extends StatefulWidget {
  final QuizTransArrangeDataset quizTransArrangeDataset;
  final CallBack<bool, Map<String, dynamic>> onClick;

  QuizTransArrangeScreen.fromDataset(
      {required this.quizTransArrangeDataset,
      required this.onClick,
      required Key key})
      : super(key: key);

  @override
  State<QuizTransArrangeScreen> createState() => _QuizTransArrangeScreenState();
}

class _QuizTransArrangeScreenState extends State<QuizTransArrangeScreen> {
  late QuizTransArrangeDataset quizTransArrangeDataset;
  late Widget renderWidget = CircularProgressIndicator();

  final scaleWidthRatio = 0.25;
  final verticalHeight = 10.0;

  WordDataset? word;
  List<ViPhraseDataset> viPhraseList = [];
  List<ViPhraseDataset?> viPhraseChooseList = [];
  List<ViPhraseDataset?> correctPhraseChooseList = [];
  List<bool> onDragState = [];
  List<ViPhraseDataset> trueCorrectPhraseList = [];

  List<Color> resultColor = [];
  List<Color> textResultColor = [];

  int correctPhrase = 0;
  bool displayCompleteButton = false;
  bool pressCompleteButton = false;
  Map<String, dynamic> dataForRenderResult = Map();

  void checkResult() {
    if (!viPhraseChooseList.contains(null)) {
      bool result = true;
      for (var i = 0; i < quizTransArrangeDataset.numRightPhrase!; i++) {
        if (viPhraseChooseList[i]?.viPhrase !=
            trueCorrectPhraseList[i].viPhrase) {
          LearnEngLog.logger
              .i("choose item ${viPhraseChooseList[i]?.viPhrase}");
          LearnEngLog.logger.i("item ${viPhraseList[i].viPhrase}");
          result = false;
        }
      }
      if (result == true) {
        widget.onClick(true, dataForRenderResult);
        setState(() {});
      } else {
        widget.onClick(false, dataForRenderResult);
        setState(() {});
      }
    } else {
      widget.onClick(false, dataForRenderResult);
      setState(() {});
    }
  }

  Widget getUserSentence() {
    List<InlineSpan> textList = [];
    if (!pressCompleteButton) {
      textList = List.generate(viPhraseChooseList.length, (index) {
        return TextSpan(
            text: "${viPhraseChooseList[index]?.viPhrase ?? ""} ",
            style: Theme.of(context).textTheme.titleLarge);
      });
    } else {
      textList = List.generate(viPhraseChooseList.length, (index) {
        return TextSpan(
            text: "${viPhraseChooseList[index]?.viPhrase ?? ""} ",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: resultColor[index]));
      });
    }

    return Text.rich(
      TextSpan(children: textList),
      textAlign: TextAlign.center,
    );
  }

  @override
  void initState() {
    super.initState();
    quizTransArrangeDataset = widget.quizTransArrangeDataset;

    FutureGroup futureGroup = FutureGroup();
    futureGroup.add(StorageController.database!.viPhraseDao
        .findViPhraseByQuizId(quizTransArrangeDataset.id ?? ""));
    futureGroup.add(StorageController.database!.wordDao
        .findWordById(quizTransArrangeDataset.wordId ?? ""));
    futureGroup.close();
    futureGroup.future.then((value) {
      viPhraseList = value[0] as List<ViPhraseDataset>;
      word = value[1] as WordDataset;

      correctPhrase = quizTransArrangeDataset.numRightPhrase ?? 0;
      onDragState = List.generate(viPhraseList.length, (index) => false);
      viPhraseChooseList = List.generate(correctPhrase, (index) => null);
      textResultColor = List.generate(
          correctPhrase, (index) => Theme.of(context).colorScheme.onPrimaryContainer);
      resultColor = List.generate(correctPhrase, (index) {
        if (Theme.of(context).brightness == Brightness.light) {
          return CustomColor.lightCorrect;
        } else {
          return CustomColor.darkCorrect;
        }
      });
      for (int i = 0; i < correctPhrase; i++) {
        trueCorrectPhraseList.add(viPhraseList[i]);
      }
      dataForRenderResult["quizType"] = QuizType.TransArrange;
      dataForRenderResult["correctSentence"] =
          quizTransArrangeDataset.viSentence;
      dataForRenderResult["trueCorrectPhraseList"] = trueCorrectPhraseList;
      viPhraseList.shuffle();
      setState(() {});
    });
  }

  List<Widget> createDragable() {
    List<Widget> widgetList = [];

    for (int i = 0; i < viPhraseList.length; i++) {
      widgetList.add(Draggable(
          maxSimultaneousDrags: pressCompleteButton ? 0 : 1,
          onDraggableCanceled: ((velocity, offset) {
            setState(() {
              onDragState[i] = false;
            });
          }),
          childWhenDragging: UnconstrainedBox(
            child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: PaddingConstants.med,
                    horizontal: PaddingConstants.med),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    boxShadow: [BoxShadow()],
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.grey
                        : Colors.grey.shade600,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Text(
                  viPhraseList[i].viPhrase ?? "",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Colors.transparent, fontWeight: FontWeight.bold),
                )),
          ),
          data: viPhraseList[i],
          child: !onDragState[i]
              ? UnconstrainedBox(
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: PaddingConstants.med,
                          horizontal: PaddingConstants.med),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          boxShadow: [BoxShadow()],
                          color: Theme.of(context).colorScheme.secondary,
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Text(
                        viPhraseList[i].viPhrase ?? "",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontWeight: FontWeight.bold),
                      )),
                )
              : UnconstrainedBox(
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: PaddingConstants.med,
                          horizontal: PaddingConstants.med),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          boxShadow: [BoxShadow()],
                          color: MediaQuery.of(context).platformBrightness ==
                                  Brightness.dark
                              ? Colors.grey
                              : Colors.grey.shade600,
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Text(
                        viPhraseList[i].viPhrase ?? "",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Colors.transparent,
                            fontWeight: FontWeight.bold),
                      )),
                ),
          feedback: UnconstrainedBox(
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                    vertical: PaddingConstants.med,
                    horizontal: PaddingConstants.med),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Text(viPhraseList[i].viPhrase ?? "",
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontWeight: FontWeight.bold))),
          )));
    }
    return widgetList;
  }

  List<Widget> createDragTarget() {
    List<Widget> widgetList = [];

    for (int i = 0; i < correctPhrase; i++) {
      widgetList.add(DragTarget<ViPhraseDataset>(
          onMove: (details) {},
          onWillAccept: (data) {
            return true;
          },
          onAccept: (data) {
            var castData = data;
            if (viPhraseChooseList[i] != null) {
              onDragState[viPhraseList.indexWhere((element) =>
                  viPhraseChooseList[i] != null &&
                  element.id == viPhraseChooseList[i]!.id)] = false;
              var indexForSwapping = viPhraseChooseList
                  .indexWhere((element) => element?.id == castData.id);
              if (indexForSwapping != -1) {
                viPhraseChooseList[indexForSwapping] = null;
              }
              viPhraseChooseList[i] = data;
              setState(() {});
              return;
            }

            var indexAlready = viPhraseChooseList
                .indexWhere((element) => element?.id == castData.id);
            if (indexAlready != -1) {
              viPhraseChooseList[i] = castData;
              viPhraseChooseList[indexAlready] = null;
              setState(() {});
              return;
            }

            setState(() {
              viPhraseChooseList[i] = castData;
              onDragState[viPhraseList.indexWhere((element) =>
                  viPhraseChooseList[i] != null &&
                  element.id == viPhraseChooseList[i]!.id)] = true;
            });
            checkResult();
          },
          builder: ((context, candidateData, rejectedData) {
            var index = viPhraseList.indexWhere(
                (element) => element.id == viPhraseChooseList[i]?.id);
            if (index > -1 && onDragState[index] == true) {
              return Draggable(
                  maxSimultaneousDrags: pressCompleteButton ? 0 : 1,
                  onDragCompleted: () {},
                  childWhenDragging: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(15),
                      color: Colors.black,
                      strokeWidth: 1,
                      strokeCap: StrokeCap.butt,
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: verticalHeight),
                          width: MediaQuery.of(context).size.width *
                              scaleWidthRatio *
                              0.45,
                          height: MediaQuery.of(context).size.width *
                              scaleWidthRatio *
                              0.45)),
                  onDraggableCanceled: (velocity, offset) {
                    setState(() {
                      onDragState[viPhraseList.indexWhere((element) =>
                          element.id == viPhraseChooseList[i]?.id)] = false;
                      viPhraseChooseList[i] = null;
                    });
                    if (!viPhraseChooseList.contains(null)) {
                      setState(() {
                        displayCompleteButton = true;
                      });
                    } else {
                      setState(() {
                        displayCompleteButton = false;
                      });
                    }
                  },
                  data: viPhraseChooseList[i],
                  child: UnconstrainedBox(
                    child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                            vertical: PaddingConstants.med,
                            horizontal: PaddingConstants.med),
                        decoration: BoxDecoration(
                            color: !pressCompleteButton
                                ? Theme.of(context).colorScheme.primaryContainer
                                : resultColor[i],
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Text(viPhraseChooseList[i]?.viPhrase ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                    color: pressCompleteButton
                                        ? textResultColor[i]
                                        : Theme.of(context).colorScheme.onError,
                                    fontWeight: FontWeight.bold))),
                  ),
                  feedback: UnconstrainedBox(
                    child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                            vertical: PaddingConstants.med,
                            horizontal: PaddingConstants.med),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Text(viPhraseChooseList[i]?.viPhrase ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    fontWeight: FontWeight.bold))),
                  ));
            } else {
              return DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(15),
                color: Colors.black,
                strokeWidth: 1,
                strokeCap: StrokeCap.butt,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: verticalHeight),
                  width: MediaQuery.of(context).size.width *
                      scaleWidthRatio *
                      0.45,
                  height: MediaQuery.of(context).size.width *
                      scaleWidthRatio *
                      0.45,
                ),
              );
            }
          })));
    }
    return widgetList;
  }

  Widget createQuizTransArrange(
      QuizTransArrangeDataset quizTransArrangeDataset) {
    if (word != null) {
      return Container(
          child: Column(children: [
        SizedBox(
          height: PaddingConstants.large,
        ),
        Text(
          AppLocalizations.of(context).arrangeWord,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: PaddingConstants.large,
        ),
        Text(
          quizTransArrangeDataset.originSentence ?? "",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: PaddingConstants.large,
        ),
        Divider(
          thickness: 2,
          indent: 20,
          endIndent: 20,
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          children: createDragTarget(),
        ),
        Divider(
          thickness: 2,
          indent: 20,
          endIndent: 20,
        ),
        SizedBox(
          height: PaddingConstants.large,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: PaddingConstants.med),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.center,
            children: createDragable(),
          ),
        ),
        SizedBox(
          height: PaddingConstants.large,
        ),
      ]));
    }
    return CircularProgressIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return createQuizTransArrange(quizTransArrangeDataset);
  }
}
