import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/dataset/quiz/phrase_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_for_extend.dart';
import 'package:learning_english_app/common/dataset/word/word_dataset.dart';
import 'package:learning_english_app/components/theme.dart';

class QuizResult extends StatefulWidget {
  late Map<String, dynamic> rebuildWidget;

  QuizResult.fromParameter({Key? key, required this.rebuildWidget})
      : super(key: key);

  @override
  State<QuizResult> createState() => _QuizResultState();
}

class _QuizResultState extends State<QuizResult> {
  late var rebuildWidget;
  late Map<String, dynamic> data;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rebuildWidget = widget.rebuildWidget;
    data = widget.rebuildWidget;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetResultList = [];
    var quizType = data["quizType"] as QuizType;
    if (quizType == QuizType.FillChar) {
      var text = "";
      var word = data["word"] as String;
      var positionRemove = data["positionRemove"] as List<int>;
      var trueCorrectMap = data["trueCorrectMap"] as Map<String, dynamic>;
      for (int i = 0; i < word!.length; i++) {
        if (word![i] == "*") {
          var indexOfPositionList =
              positionRemove.indexWhere((element) => element == i);
          widgetResultList.add(
            Text(text,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 26)),
          );
          widgetResultList.add(
            Container(
                margin: EdgeInsets.fromLTRB(4, 0, 0, 0),
                width: 55,
                height: 65,
                alignment: Alignment.center,
                child: TextField(
                  key: Key(i.toString()),
                  controller: TextEditingController(
                      text: trueCorrectMap[i.toString()] as String),
                  textInputAction: TextInputAction.done,
                  enabled: false,
                  onChanged: null,
                  maxLines: 1,
                  textCapitalization: TextCapitalization.none,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      fillColor: (MediaQuery.of(context).platformBrightness ==
                              Brightness.light)
                          ? CustomColor.lightCorrect
                          : CustomColor.darkCorrect,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                  keyboardType: TextInputType.name,
                  cursorColor: Theme.of(context).colorScheme.onBackground,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 26,
                      color: Theme.of(context).colorScheme.onError),
                )),
          );
          text = "";
        } else {
          text = text + word![i];
        }
      }
      widgetResultList.add(
        Text(text,
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(fontWeight: FontWeight.w500, fontSize: 26)),
      );
      return Row(
        children: widgetResultList,
      );
    } else if (quizType == QuizType.RightWord) {
      var word = data["correctWord"] as WordDataset;
      return Align(
        alignment: Alignment.topLeft,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: (MediaQuery.of(context).platformBrightness ==
                      Brightness.light)
                  ? CustomColor.lightCorrect
                  : CustomColor.darkCorrect,
              onSurface: (MediaQuery.of(context).platformBrightness ==
                      Brightness.light)
                  ? CustomColor.lightCorrect
                  : CustomColor.darkCorrect,
              onPrimary: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              minimumSize: Size(150, 100),
            ),
            onPressed: () {},
            child: Text(
              word.word ?? "",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onError),
            )),
      );
    } else if (quizType == QuizType.FillWord) {
      var word = data["correctWord"] as String;
      return Align(
        alignment: Alignment.topLeft,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: (MediaQuery.of(context).platformBrightness ==
                      Brightness.light)
                  ? CustomColor.lightCorrect
                  : CustomColor.darkCorrect,
              onSurface: (MediaQuery.of(context).platformBrightness ==
                      Brightness.light)
                  ? CustomColor.lightCorrect
                  : CustomColor.darkCorrect,
              onPrimary: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              minimumSize: Size(150, 100), //////// HERE
            ),
            onPressed: () {},
            child: Text(
              word,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onError),
            )),
      );
    } else if (quizType == QuizType.RightPronouce) {
      var word = data["correctWord"] as WordDataset;
      return Align(
        alignment: Alignment.topLeft,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary:
                (MediaQuery.of(context).platformBrightness == Brightness.light)
                    ? CustomColor.lightCorrect
                    : CustomColor.darkCorrect,
            onSurface:
                (MediaQuery.of(context).platformBrightness == Brightness.light)
                    ? CustomColor.lightCorrect
                    : CustomColor.darkCorrect,
            onPrimary: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(),
            minimumSize: Size(150, 100), //////// HERE
          ),
          onPressed: () async {
            final audioPlayer = AudioPlayer();
            var url = word.audioFile ?? "";
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
          child: Icon(
            Icons.volume_up,
            size: 48,
          ),
        ),
      );
    } else if (quizType == QuizType.TransArrange) {
      List<Widget> widget = [];
      var trueCorrectPhraseList =
          data["trueCorrectPhraseList"] as List<ViPhraseDataset>;
      for (var phrase in trueCorrectPhraseList) {
        widget.add(UnconstrainedBox(
          child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                  vertical: PaddingConstants.med,
                  horizontal: PaddingConstants.small),
              decoration: BoxDecoration(
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.dark
                      ? CustomColor.darkCorrect
                      : CustomColor.lightCorrect,
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Text(phrase.viPhrase ?? "",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onError,
                      fontWeight: FontWeight.bold))),
        ));
      }
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        children: widget,
      );
    }
    return Container(key: widget.key, child: rebuildWidget);
  }
}
