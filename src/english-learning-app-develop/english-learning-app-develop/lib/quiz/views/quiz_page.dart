import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:just_audio/just_audio.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/controller/dialog_controller.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/common/controller/toast_controller.dart';
import 'package:learning_english_app/common/dataset/lesson/lesson_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_fill_char_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_fill_word_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_for_extend.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_right_pronouce_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_right_word_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_trans_arrange_dataset.dart';
import 'package:learning_english_app/components/login_button.dart';
import 'package:learning_english_app/components/theme.dart';
import 'package:learning_english_app/quiz/services/quiz_service.dart';
import 'package:learning_english_app/quiz/views/quiz_fill_char_screen.dart';
import 'package:learning_english_app/quiz/views/quiz_fill_word_screen.dart';
import 'package:learning_english_app/quiz/views/quiz_right_pronouce_screen.dart';
import 'package:learning_english_app/quiz/views/quiz_right_word_screen.dart';
import 'package:learning_english_app/quiz/views/quiz_trans_arrange_screen.dart';
import 'package:learning_english_app/quiz/views/result_sheet_component.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:timelines/timelines.dart';

import '../../common/dataset/lesson_user_score/lesson_user_score_dataset.dart';

enum QuizState { completed, focus, remain }

class _QuizTypeAndState {
  QuizType quizType;
  QuizState quizState;
  _QuizTypeAndState({required this.quizState, required this.quizType});
}

class QuizPage extends StatefulWidget {
  QuizPage({Key? key}) : super(key: key);

  Map<String, dynamic> parameter = Map();
  QuizPage.fromParameter({required this.parameter});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  LessonDataset lesson = LessonDataset();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<QuizFillCharDataset?> quizFillCharList = [];
  List<QuizFillWordDataset?> quizFillWordList = [];
  List<QuizRightPronouceDataset?> quizRightPronouceList = [];
  List<QuizRightWordDataset?> quizRightWordList = [];
  List<QuizTransArrangeDataset?> quizTransArrangeList = [];
  List<QuizExtend> quizList = [];
  late PersistentBottomSheetController controller;
  bool isHideOpacity = false;
  int trackingQuiz = 0;
  List<_QuizTypeAndState> quizTypeList = [];
  List<Widget> quizWidget = [];

  String categoryId = "";

  bool isBlockUserInput = false;

  bool? currentSelectedAnswer = null;
  Map<String, dynamic>? currentSelectedMap = null;
  QuizExtend? currentQuizExtend = null;

  bool displaySetNextButton = false;
  RoundedLoadingButtonController roundedLoadingButtonController =
      RoundedLoadingButtonController();

  void determineShowDialog(QuizType lastQuizType, QuizType nextQuizType) {
    var lastIndex =
        quizTypeList.indexWhere((element) => element.quizType == lastQuizType);
    var nextIndex =
        quizTypeList.indexWhere((element) => element.quizType == nextQuizType);
    quizTypeList[lastIndex].quizState = QuizState.completed;
    quizTypeList[nextIndex].quizState = QuizState.focus;
    setState(() {
      showGeneralDialog(
          transitionDuration: Duration(milliseconds: 200),
          context: context,
          pageBuilder: (context, anim1, anim2) {
            return createDialog();
          },
          transitionBuilder: (context, a1, a2, widget) {
            return Transform.scale(
              scale: a1.value,
              child: createDialog(),
            );
          });
    });
  }

  void setCurrentAnswer(
      bool result, Map<String, dynamic> data, QuizExtend item) {
    setState(() {
      currentQuizExtend = item;
      currentSelectedAnswer = result;
      currentSelectedMap = data;
    });
  }

  void onNextButton(bool result, QuizExtend item) async {
    if (result == true) {
      setState(() {
        QuizService.onCorrectQuiz(quiz: item);
      });
    } else {
      setState(() {
        QuizService.onInCorrectQuiz(quiz: item);
      });
    }
    setState(() {
      isHideOpacity = true;
    });
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      isHideOpacity = false;
      displaySetNextButton = false;
    });
    if (QuizService.getTotalCorrect() == QuizService.getMaxSelectedIndex()) {
      showGeneralDialog(
          transitionDuration: Duration(milliseconds: 200),
          context: context,
          pageBuilder: (context, anim1, anim2) {
            return createCompletedDialog();
          },
          transitionBuilder: (context, a1, a2, widget) {
            return Transform.scale(
              scale: a1.value,
              child: createCompletedDialog(),
            );
          });
      ;
      return;
    } else {
      setState(() {
        this.currentQuizExtend = null;
        this.currentSelectedAnswer = null;
        this.currentSelectedMap = null;
      });
      roundedLoadingButtonController.reset();
      if (result == true) {
        setState(() {
          QuizService.setSelectedIndex(QuizService.getSelectedIndex() + 1);
        });
      } else {
        setState(() {
          var item = quizWidget.removeAt(QuizService.getSelectedIndex());
          if (item is QuizRightPronouceScreen) {
            quizWidget.add(QuizRightPronouceScreen.fromDataset(
              key: Key(item.quizRightPronouceDataset.id ?? ""),
              quizRightPronouceDataset: item.quizRightPronouceDataset,
              onClick: (result, dataMap) {
                setCurrentAnswer(
                    result, dataMap, item.quizRightPronouceDataset);
              },
            ));
          } else if (item is QuizRightWordScreen) {
            quizWidget.add(QuizRightWordScreen.fromDataset(
              key: Key(item.quizRightWordDataset.id ?? ""),
              quizRightWordDataset: item.quizRightWordDataset,
              onClick: (result, dataMap) {
                setCurrentAnswer(result, dataMap, item.quizRightWordDataset);
              },
            ));
          } else if (item is QuizFillWordView) {
            quizWidget.add(QuizFillWordView.fromDataset(
              key: Key(item.quizFillWordDataset.id ?? ""),
              quizFillWordDataset: item.quizFillWordDataset,
              onClick: (result, dataMap) {
                setCurrentAnswer(result, dataMap, item.quizFillWordDataset);
              },
            ));
          } else if (item is QuizFillCharView) {
            quizWidget.add(QuizFillCharView.fromDataset(
              key: Key(item.quizFillCharDataset.id ?? ""),
              quizFillCharDataset: item.quizFillCharDataset,
              onCompleted: (result, dataMap) {
                setCurrentAnswer(result, dataMap, item.quizFillCharDataset);
              },
            ));
          } else if (item is QuizTransArrangeScreen) {
            quizWidget.add(QuizTransArrangeScreen.fromDataset(
              key: Key(item.quizTransArrangeDataset.id ?? ""),
              quizTransArrangeDataset: item.quizTransArrangeDataset,
              onClick: (result, dataMap) {
                setCurrentAnswer(result, dataMap, item.quizTransArrangeDataset);
              },
            ));
          }
        });
      }
    }
  }

  void showModalSheet(
      bool result, Map<String, dynamic> mapString, QuizExtend item) {
    setState(() {
      controller = scaffoldKey.currentState!.showBottomSheet(
        (context) => ResultBottomSheet.fromParameter(
          result: result,
          onClickNext: () {
            this.controller.close();
            isBlockUserInput = false;
            onNextButton(result, item);
          },
          renderWidget: mapString,
          key: UniqueKey(),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        enableDrag: false,
      );
    });
  }

  void checkResult(
      bool result, QuizExtend item, Map<String, dynamic> data) async {
    setState(() {
      displaySetNextButton = true;
      showModalSheet(result, data, item);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    QuizService.startClock();
    if (widget.parameter["categoryId"] != null) {
      categoryId = widget.parameter["categoryId"] as String;
    }
    if (widget.parameter["lesson"] != null) {
      lesson = widget.parameter["lesson"] as LessonDataset;
      QuizService.lesson = lesson;

      FutureGroup futureGroup = FutureGroup();
      futureGroup.add(StorageController.database!.quizFillCharDao
          .findQuizByLessonId(lesson.id ?? ""));
      futureGroup.add(StorageController.database!.quizFillWordDao
          .findQuizByLessonId(lesson.id ?? ""));
      futureGroup.add(StorageController.database!.quizRightPronouceDao
          .findQuizByLessonId(lesson.id ?? ""));
      futureGroup.add(StorageController.database!.quizRightWordDao
          .findQuizByLessonId(lesson.id ?? ""));
      futureGroup.add(StorageController.database!.quizTransArrageDao
          .findQuizByLessonId(lesson.id ?? ""));

      futureGroup.close();
      futureGroup.future.then((resultList) {
        quizFillCharList = resultList[0] as List<QuizFillCharDataset?>;
        quizFillWordList = resultList[1] as List<QuizFillWordDataset?>;
        quizRightPronouceList =
            resultList[2] as List<QuizRightPronouceDataset?>;
        quizRightWordList = resultList[3] as List<QuizRightWordDataset?>;
        quizTransArrangeList = resultList[4] as List<QuizTransArrangeDataset?>;
        FutureGroup futuregroupForWidget = FutureGroup();
        if (quizFillCharList.length > 0) {
          quizTypeList.add(_QuizTypeAndState(
              quizState: QuizState.focus, quizType: QuizType.FillChar));
          for (var item in quizFillCharList) {
            if (item != null) {
              item.quizType = QuizType.FillChar;
              quizWidget.add(QuizFillCharView.fromDataset(
                key: Key(item.id ?? ""),
                quizFillCharDataset: item,
                onCompleted: (result, dataMap) {
                  setCurrentAnswer(result, dataMap, item);
                },
              ));
              quizList.add(item);
            }
          }
        }
        if (quizFillWordList.length > 0) {
          quizTypeList.add(_QuizTypeAndState(
              quizState: QuizState.remain, quizType: QuizType.FillWord));
          for (var item in quizFillWordList) {
            if (item != null) {
              item.quizType = QuizType.FillWord;
              quizWidget.add(QuizFillWordView.fromDataset(
                key: Key(item.id ?? ""),
                quizFillWordDataset: item,
                onClick: (result, dataMap) {
                  setCurrentAnswer(result, dataMap, item);
                },
              ));
              quizList.add(item);
            }
          }
        }
        if (quizRightPronouceList.length > 0) {
          quizTypeList.add(_QuizTypeAndState(
            quizState: QuizState.remain,
            quizType: QuizType.RightPronouce,
          ));
          for (var item in quizRightPronouceList) {
            if (item != null) {
              item.quizType = QuizType.RightPronouce;
              quizWidget.add(QuizRightPronouceScreen.fromDataset(
                  key: Key(item.id ?? ""),
                  quizRightPronouceDataset: item,
                  onClick: (result, dataMap) {
                    // checkResult(result, item, dataMap);
                    // //checkResult(result, item);
                    setCurrentAnswer(result, dataMap, item);
                  }));
              quizList.add(item);
            }
          }
        }
        if (quizRightWordList.length > 0) {
          quizTypeList.add(_QuizTypeAndState(
              quizState: QuizState.remain, quizType: QuizType.RightWord));
          for (var item in quizRightWordList) {
            if (item != null) {
              quizWidget.add(QuizRightWordScreen.fromDataset(
                  key: Key(item.id ?? ""),
                  quizRightWordDataset: item,
                  onClick: (result, dataMap) {
                    setCurrentAnswer(result, dataMap, item);
                    // checkResult(result, item, dataMap);
                  }));
              item.quizType = QuizType.RightWord;
              quizList.add(item);
            }
          }
        }
        if (quizTransArrangeList.length > 0) {
          quizTypeList.add(_QuizTypeAndState(
              quizState: QuizState.remain, quizType: QuizType.TransArrange));
          for (var item in quizTransArrangeList) {
            if (item != null) {
              quizWidget.add(QuizTransArrangeScreen.fromDataset(
                  quizTransArrangeDataset: item,
                  onClick: (result, dataMap) {
                    setCurrentAnswer(result, dataMap, item);
                    //checkResult(result, item, dataMap);
                  },
                  key: Key(item.id ?? "")));
              item.quizType = QuizType.TransArrange;
              quizList.add(item);
            }
          }
        }
        futuregroupForWidget.close();
        futuregroupForWidget.future.then((value) {
          QuizService.setMaxQuizIndex(quizFillCharList.length +
              quizFillWordList.length +
              quizRightPronouceList.length +
              quizRightWordList.length +
              quizTransArrangeList.length);
          for (var item in value) {
            quizWidget.add(item as Widget);
          }
          quizWidget.shuffle();

          setState(() {});
        });
      });
    }
  }

  Widget createIndicatorDialog({required QuizState quizState}) {
    switch (quizState) {
      case QuizState.focus:
        {
          return CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey.shade700,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                radius: 13,
              ));
        }
      case QuizState.completed:
        {
          return CircleAvatar(
            radius: 16,
            backgroundColor: Colors.greenAccent,
            child: Icon(Icons.check,
                color: Theme.of(context).colorScheme.onBackground),
          );
        }
      case QuizState.remain:
        {
          return CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey.shade700,
          );
        }
    }
  }

  Widget createRowForDialog(
      {required QuizState quizState, required QuizType quizType}) {
    String title = "";
    switch (quizType) {
      case QuizType.FillChar:
        {
          title = AppLocalizations.of(context).quizFillChar;
          break;
        }
      case QuizType.FillWord:
        {
          title = AppLocalizations.of(context).quizFillWord;
          break;
        }
      case QuizType.RightPronouce:
        {
          title = AppLocalizations.of(context).quizRightPronouce;
          break;
        }
      case QuizType.RightWord:
        {
          title = AppLocalizations.of(context).quizRightWord;
          break;
        }
      case QuizType.TransArrange:
        {
          title = AppLocalizations.of(context).quizTransArrage;
          break;
        }
    }

    if (quizState == QuizState.focus) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: PaddingConstants.small),
        child: Row(children: [
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
        ]),
      );
    } else if (quizState == QuizState.completed) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: PaddingConstants.small),
        child: Row(children: [
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
        ]),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: PaddingConstants.small),
        child: Row(children: [
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
        ]),
      );
    }
  }

  Widget createDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: PaddingConstants.extraLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: PaddingConstants.large,
            ),
            FixedTimeline.tileBuilder(
              theme: TimelineThemeData.vertical().copyWith(nodePosition: 0),
              mainAxisSize: MainAxisSize.min,
              builder: TimelineTileBuilder.connected(
                contentsAlign: ContentsAlign.basic,
                contentsBuilder: (context, index) {
                  return createRowForDialog(
                      quizState: quizTypeList[index].quizState,
                      quizType: quizTypeList[index].quizType);
                },
                connectorBuilder: (context, index, type) {
                  return SizedBox(
                    height: 5.0,
                    child: SolidLineConnector(
                      thickness: 2,
                      color: Colors.grey,
                    ),
                  );
                },
                indicatorBuilder: (context, index) {
                  return createIndicatorDialog(
                      quizState: quizTypeList[index].quizState);
                },
                itemCount: quizTypeList.length,
              ),
            ),
            SizedBox(
              height: PaddingConstants.small,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context).start),
                style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 25)),
              ),
            ),
            SizedBox(
              height: PaddingConstants.med,
            )
          ],
        ),
      ),
    );
  }

  Widget createCompletedDialog() {
    String result = "";
    double resultPercent = QuizService.getTotalIncorrect().toDouble() /
        QuizService.getMaxSelectedIndex().toDouble();
    Color percentColor;
    if (resultPercent < 0.2) {
      result = AppLocalizations.of(context).veryGood;
      percentColor =
          MediaQuery.of(context).platformBrightness == Brightness.light
              ? CustomColor.lightCorrect
              : CustomColor.darkCorrect;
    } else if (resultPercent >= 0.2 && resultPercent <= 0.7) {
      result = AppLocalizations.of(context).keepTrying;
      percentColor = Colors.yellow.shade700;
    } else {
      result = AppLocalizations.of(context).bad;
      percentColor = Theme.of(context).colorScheme.error;
    }
    var resultPercentForDisplay = 1 - resultPercent;
    if (resultPercentForDisplay <= 0) {
      resultPercentForDisplay = 0;
    }
    roundedLoadingButtonController.success();
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: PaddingConstants.extraLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: PaddingConstants.extraLarge,
            ),
            CircularPercentIndicator(
                radius: 60,
                lineWidth: 11,
                percent: resultPercentForDisplay,
                progressColor: percentColor,
                circularStrokeCap: CircularStrokeCap.round,
                animation: true,
                animationDuration: 1000,
                center: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context).accuracy,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: PaddingConstants.extraSmall,
                    ),
                    Text(
                      '${(resultPercentForDisplay * 100).toStringAsFixed(2)}%',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            SizedBox(
              height: PaddingConstants.extraLarge,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).totalQuiz,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(
                      height: PaddingConstants.large,
                    ),
                    Text(
                      AppLocalizations.of(context).wrongPint,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                SizedBox(
                  width: PaddingConstants.med,
                ),
                Column(
                  children: [
                    Text(
                      QuizService.getMaxSelectedIndex().toString(),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: PaddingConstants.large,
                    ),
                    Text(
                      QuizService.getTotalIncorrect().toString(),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: PaddingConstants.large,
            ),
            SizedBox(
              height: PaddingConstants.large,
            ),
            Text(
              result,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: PaddingConstants.large,
            ),
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Retry'),
                    style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        padding: EdgeInsets.symmetric(horizontal: 25)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      QuizService.updateProgress(
                          StorageController.getCurrentUserId() ?? "",
                          lesson.id ?? "", (result) {
                        var resultMap = result as Map<String, dynamic>;
                        if (result["success"] as bool == true) {
                          LessonUserScoreDataset lessonUserScoreDataset =
                              LessonUserScoreDataset.fromJson(
                                  resultMap["lessonUserScoreDataset"]);
                          StorageController.database!.lessonUserScoreDao
                              .insertOneRecord(lessonUserScoreDataset)
                              .then((value) {
                            Navigator.of(context).pop();
                            Navigator.popUntil(
                                context, ModalRoute.withName('/lesson_list'));
                          });
                        }
                      }, (error) {
                        ToastController.showError(
                            AppLocalizations.of(context)
                                .somethingwentwrongpleasetryagainlater,
                            context);
                      });
                    },
                    child: Text(AppLocalizations.of(context).complete),
                    style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        padding: EdgeInsets.symmetric(horizontal: 25)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: PaddingConstants.med,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
            leading: IconButton(
              splashRadius: 20,
              color: Theme.of(context).colorScheme.onBackground,
              icon: Icon(
                Icons.close,
              ),
              onPressed: () {
                DialogController.showWarningDialog(
                    title: AppLocalizations.of(context).areYouSureProgressLost,
                    context: context,
                    actionNegative: () {
                      DialogController.dismisDialog();
                    },
                    actionPositive: () {
                      QuizService.resetQuizSection();
                      Navigator.popUntil(
                          context, ModalRoute.withName('/lesson_list'));
                    },
                    buttonNamePositive: AppLocalizations.of(context).yes,
                    buttonNameNegative: AppLocalizations.of(context).no);
              },
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            bottomOpacity: 0,
            shadowColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Theme.of(context).brightness,
              statusBarBrightness: Theme.of(context).brightness,
            ),
            centerTitle: false,
            title: Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              width: 250,
              height: 30,
              child: LinearPercentIndicator(
                animationDuration: 700,
                progressColor: Theme.of(context).colorScheme.primary,
                animation: true,
                lineHeight: 30,
                barRadius: Radius.circular(15),
                animateFromLastPercent: true,
                percent: QuizService.getTotalCorrect().toDouble() /
                    QuizService.getMaxSelectedIndex().toDouble(),
                backgroundColor: Color(0xffD6D6D6),
              ),
            )),
        body: SafeArea(
            bottom: false,
            child: Container(
                color: Theme.of(context).colorScheme.background,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 23,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: AnimatedFlipCounter(
                        duration: Duration(milliseconds: 500),
                        value: QuizService.getTotalPoint(),
                        textStyle: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(
                                fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                        child: (quizWidget.length > 0)
                            ? AnimatedOpacity(
                                duration: Duration(seconds: 1),
                                opacity: isHideOpacity ? 0.0 : 1.0,
                                child: IgnorePointer(
                                  ignoring: isBlockUserInput,
                                  child: Center(
                                      child: quizWidget[
                                          QuizService.getSelectedIndex()]),
                                ))
                            : Center(child: CircularProgressIndicator())),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: PaddingConstants.extraLarge,
                          vertical: PaddingConstants.extraLarge * 1.05),
                      child: LoginButton(
                          onPressed: this.currentQuizExtend != null &&
                                  this.currentSelectedAnswer != null &&
                                  this.currentSelectedMap != null
                              ? () {
                                  final audioPlayer = AudioPlayer();
                                  audioPlayer.setAsset("assets/sound/tick.mp4");
                                  audioPlayer.play();
                                  isBlockUserInput = true;
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  checkResult(
                                      this.currentSelectedAnswer!,
                                      this.currentQuizExtend!,
                                      this.currentSelectedMap!);
                                }
                              : null,
                          buttonLabel: AppLocalizations.of(context).check,
                          roundedLoadingButtonController:
                              roundedLoadingButtonController),
                    )
                  ],
                ))));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    QuizService.resetQuizSection();
  }
}
