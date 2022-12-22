import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/common/dataset/lesson_user_score/lesson_user_score_dataset.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english_app/common/extensions.dart';
import 'package:learning_english_app/components/theme.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class LessonHistoryDialog extends StatefulWidget {
  LessonUserScoreDataset lessonUserScoreDataset;
  LessonHistoryDialog({Key? key, required this.lessonUserScoreDataset})
      : super(key: key);

  @override
  State<LessonHistoryDialog> createState() => _LessonHistoryDialogState();
}

class _LessonHistoryDialogState extends State<LessonHistoryDialog> {
  LessonUserScoreDataset? lessonUserScoreDataset;
  String totalWordLearn = "0";
  String totalQuiz = "0";
  String accuracy = "0";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lessonUserScoreDataset = widget.lessonUserScoreDataset;
    StorageController.database!.wordDao
        .getWordByLessonId(lessonUserScoreDataset?.lessonId ?? "")
        .then((value) {
      totalWordLearn = value.length.toString();
      setState(() {});
    });
    StorageController.database!.quizDao
        .countNumberQuiz(lessonUserScoreDataset?.lessonId ?? "")
        .then((value) {
      totalQuiz = value.toString();
      setState(() {});
    });
    accuracy =
        ((lessonUserScoreDataset!.accuracy ?? 0) * 100).toStringAsFixed(2);
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    Color percentColor;
    var accuracy1 = lessonUserScoreDataset?.accuracy ?? 0;
    accuracy1 = 1 - accuracy1;
    if (accuracy1 < 0.2) {
      percentColor =
          MediaQuery.of(context).platformBrightness == Brightness.light
              ? CustomColor.lightCorrect
              : CustomColor.darkCorrect;
    } else if (accuracy1 >= 0.2 && accuracy1 <= 0.7) {
      percentColor = Colors.yellow.shade700;
    } else {
      percentColor = Theme.of(context).colorScheme.error;
    }
    String locale = Localizations.localeOf(context).languageCode;
    var date = lessonUserScoreDataset?.completedAt?.parseMongoDBDate();
    var formattedDate = DateFormat.yMMMMEEEEd(locale).format(date!) + " " + DateFormat.Hms(locale).format(date!);
    var time = int.parse(lessonUserScoreDataset?.completionTime ?? "0") ;
    var timeElapse = _printDuration(Duration(milliseconds: time));
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      color: Colors.transparent,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: PaddingConstants.large,
            ),
            Center(
              child: Text(
                lessonUserScoreDataset?.lessonDataset?.name ?? "",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: PaddingConstants.large,
            ),
            Center(
              child: Text(
                '${formattedDate}',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: PaddingConstants.large,
            ),
            Center(
              child: Text(
                '${timeElapse}',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: PaddingConstants.large,
            ),
            Center(
              child: Text(
                AppLocalizations.of(context).accuracy,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(
              height: PaddingConstants.large,
            ),
            Center(
                child: CircularPercentIndicator(
              radius: 50,
              percent: lessonUserScoreDataset?.accuracy ?? 0,
              center: Text('${accuracy}%'),
              progressColor: percentColor,
              lineWidth: 10,
              circularStrokeCap: CircularStrokeCap.round,
            )),
            SizedBox(
              height: PaddingConstants.large,
            ),
            Center(
              child: Text(
                AppLocalizations.of(context).point,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Center(
              child: Text(
                '${lessonUserScoreDataset?.point ?? 0}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(
              height: PaddingConstants.large,
            ),
            Container(
              decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: PaddingConstants.large),
                child: ListTile(
                  tileColor: Theme.of(context).colorScheme.surface,
                  title: Text(
                    AppLocalizations.of(context).totalWordLearn,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  trailing: Text(
                    totalWordLearn,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            SizedBox(
              height: PaddingConstants.large,
            ),
            Container(
              decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: PaddingConstants.large),
                child: ListTile(
                  tileColor: Theme.of(context).colorScheme.surface,
                  title: Text(
                    AppLocalizations.of(context).totalQuestion,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  trailing: Text(
                    totalQuiz,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            SizedBox(
              height: PaddingConstants.large,
            ),
            Container(
              decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: PaddingConstants.large),
                child: ListTile(
                  tileColor: Theme.of(context).colorScheme.surface,
                  title: Text(
                    AppLocalizations.of(context).incorrect,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  trailing: Text(
                    '${lessonUserScoreDataset?.totalIncorrect ?? 0}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            SizedBox(
              height: PaddingConstants.large,
            ),
            SizedBox(
              height: PaddingConstants.extraLarge,
            )
          ],
        ),
      ),
    );
  }
}
