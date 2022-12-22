import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/common/dataset/lesson_user/lesson_user_dataset.dart';
import 'package:learning_english_app/common/dataset/lesson_user_score/lesson_user_score_dataset.dart';
import 'package:learning_english_app/common/extensions.dart';
import 'package:learning_english_app/components/theme.dart';
import 'package:learning_english_app/favourite/views/sort_modal_sheet.dart';
import 'package:learning_english_app/lessons/views/lesson_history_summaray_dialog.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LessonHistoryPage extends StatefulWidget {
  LessonHistoryPage({Key? key}) : super(key: key);

  @override
  State<LessonHistoryPage> createState() => _LessonHistoryPageState();
}

class _LessonHistoryPageState extends State<LessonHistoryPage> {
  List<LessonUserScoreDataset> lessonUserScoreList = [];

  int totalWordLearn = 0;
  double averageAccuracy = 0.0;
  int totalTimeSpent = 0;
  String? sortValue;
  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String categoryId = StorageController.getCurrentCategoryId() ?? "";
    String userId = StorageController.getCurrentUserId() ?? "";
    FutureGroup futureGroup = FutureGroup();
    futureGroup.add(StorageController.database!.lessonUserScoreDao
        .findLessonUserScoreBaseOnCatIdAndUserId(categoryId, userId));
    futureGroup.close();
    futureGroup.future.then((value) {
      lessonUserScoreList = value[0] as List<LessonUserScoreDataset>;
      for (var item in lessonUserScoreList) {
        totalTimeSpent += int.parse(item.completionTime ?? "0");
        averageAccuracy += item.accuracy ?? 0;
      }
      averageAccuracy =
          averageAccuracy.toDouble() / lessonUserScoreList.length.toDouble();

      List<String> alreadyId = [];
      for (int i = 0; i < lessonUserScoreList.length; i++) {
        StorageController.database!.lessonDao
            .findLessonByLessonId(lessonUserScoreList[i].lessonId)
            .then((value) {
          lessonUserScoreList[i].lessonDataset = value;

          if (!alreadyId.contains(value?.id as String)) {
            alreadyId.add(value?.id ?? "");
            StorageController.database!.wordDao
                .getWordByLessonId(value?.id ?? "")
                .then((totalWord) {
              setState(() {
                totalWordLearn += totalWord.length;
              });
            });
          }

          setState(() {});
        });
      }
    });
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      sortValue = AppLocalizations.of(context).sortCompleteNewToOld;
      sortHistory();
      setState(() {
        
      });
    });
  }

  void sortHistory() {
    if (lessonUserScoreList.contains(null)) {
      return;
    }
    var value = sortValue;
    if (value == AppLocalizations.of(context).sortCompleteNewToOld) {
      lessonUserScoreList.sort(((a, b) {
        return b.completionTime!.compareTo(a.completionTime!);
      }));
    } else if (value == AppLocalizations.of(context).sortCompleteOldToNew) {
      lessonUserScoreList.sort(((a, b) {
        return a.completionTime!.compareTo(b.completionTime!);
      }));
    }
  }

  Widget buildHistory(int index) {
    var date = lessonUserScoreList[index].completedAt!.parseMongoDBDate();
    String locale = Localizations.localeOf(context).languageCode;
    var formattedDate = DateFormat.yMMMMEEEEd(locale).format(date!);
    Color percentColor;

    var accuracy = lessonUserScoreList[index].accuracy ?? 0;
    accuracy = 1 - accuracy;

    if (accuracy < 0.2) {
      percentColor =
          MediaQuery.of(context).platformBrightness == Brightness.light
              ? CustomColor.lightCorrect
              : CustomColor.darkCorrect;
    } else if (accuracy >= 0.2 && accuracy <= 0.7) {
      percentColor = Colors.yellow.shade700;
    } else {
      percentColor = Theme.of(context).colorScheme.error;
    }

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            context: context,
            builder: (context) {
              return LessonHistoryDialog(
                lessonUserScoreDataset: lessonUserScoreList[index],
              );
            });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: PaddingConstants.large, vertical: PaddingConstants.med),
        child: Material(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 5.0,
            color: Theme.of(context).colorScheme.surface,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: PaddingConstants.med),
              child: Row(
                children: [
                  CircularPercentIndicator(
                    radius: 35,
                    lineWidth: 7.0,
                    animation: true,
                    circularStrokeCap: CircularStrokeCap.round,
                    percent: lessonUserScoreList[index].accuracy ?? 0.0,
                    progressColor: percentColor,
                    center: Text(
                      '${(lessonUserScoreList[index].accuracy! * 100).toStringAsFixed(2)}%',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  SizedBox(
                    width: PaddingConstants.large,
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                            lessonUserScoreList[index].lessonDataset?.name ??
                                "",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 22)),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          height: 1,
                        ),
                        Text(
                          "${lessonUserScoreList[index].point.toString()} point",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Divider(
                          height: 1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${formattedDate}",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ]),
                ],
              ),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                              AppLocalizations.of(context).sortCompleteNewToOld,
                              AppLocalizations.of(context).sortCompleteOldToNew
                            ],
                            onClickCallBack: (value) {
                              sortValue = value;
                              Navigator.of(context).pop();
                              sortHistory();
                              setState(() {});
                            });
                      });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: PaddingConstants.large),
              child: Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                elevation: 5.0,
                color: Theme.of(context).colorScheme.surface,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: Text(
                          totalWordLearn.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            AppLocalizations.of(context)
                                .totalWordLearn
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12.0)),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(
                          averageAccuracy.toStringAsFixed(2),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            AppLocalizations.of(context)
                                .averageAccuracy
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12.0)),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(
                          _printDuration(
                              Duration(milliseconds: totalTimeSpent)),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            AppLocalizations.of(context)
                                .totalTimeSpent
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12.0)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: PaddingConstants.large,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: lessonUserScoreList.length,
                  itemBuilder: (context, index) {
                    return buildHistory(index);
                  }),
            )
          ],
        ));
  }
}
