import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_fill_char_dataset.dart';
import 'package:learning_english_app/common/dataset/word/word_dataset.dart';
import 'package:learning_english_app/common/extensions.dart';
import 'package:learning_english_app/components/custom_char_textfield.dart';


class QuizFillCharView extends StatefulWidget {
  final QuizFillCharDataset quizFillCharDataset;
  final CallBack<bool, Map<String,dynamic>> onCompleted;

  QuizFillCharView.fromDataset(
      {required this.quizFillCharDataset,
      required this.onCompleted,
      required Key key})
      : super(key: key);

  @override
  State<QuizFillCharView> createState() => _QuizFillCharViewState();
}

class _QuizFillCharViewState extends State<QuizFillCharView> {
  late QuizFillCharDataset quizFillCharDataset;
  late Widget renderWidget = CircularProgressIndicator();
  WordDataset? word = null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quizFillCharDataset = widget.quizFillCharDataset;
    StorageController.database?.wordDao
        .findWordById(quizFillCharDataset.wordId ?? "")
        .then((value) {
      if (value != null) {
        setState(() {
          word = value;
        });
      }
    });
  }

  Widget createQuizFillChar(QuizFillCharDataset quizFillCharDataset) {
    if (word == null) {
      return CircularProgressIndicator();
    }
    return Container(
      padding: EdgeInsets.fromLTRB(0, PaddingConstants.extraLarge, 0, 0),
      child: Column(
        children: [
         
          SizedBox(
            height: PaddingConstants.large,
          ),
          Text(word!.mean ?? "",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground,fontWeight: FontWeight.bold)),
          SizedBox(
            height: PaddingConstants.large,
          ),
          CustomCharTextField.fromWord(
              word: word!.word, onCallBack: widget.onCompleted),
          SizedBox(
            height: PaddingConstants.large,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return createQuizFillChar(quizFillCharDataset);
  }
}
