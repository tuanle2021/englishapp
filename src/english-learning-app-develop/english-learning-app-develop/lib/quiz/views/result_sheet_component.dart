import 'package:flutter/material.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english_app/components/theme.dart';
import 'package:learning_english_app/quiz/views/quiz_result_component.dart';

class ResultBottomSheet extends StatefulWidget {
 

  final VoidCallback onClickNext;
  final Map<String, dynamic> renderWidget;
  final bool result;

  ResultBottomSheet.fromParameter(
      {
        required this.result,
        required this.onClickNext,
      required this.renderWidget,
      required Key? key})
      : super(key: key);

  @override
  State<ResultBottomSheet> createState() => _ResultBottomSheetState();
}

class _ResultBottomSheetState extends State<ResultBottomSheet> {
  @override
  Widget build(BuildContext context) {
    if (widget.result == true) {
      return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: PaddingConstants.extraLarge),
        child: Column(
          key: widget.key,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: PaddingConstants.large,
            ),
            Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    AppLocalizations.of(context).correct,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color:  (MediaQuery.of(context).platformBrightness ==
                      Brightness.light)
                  ? CustomColor.lightCorrect
                  : CustomColor.darkCorrect,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: PaddingConstants.med,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    AppLocalizations.of(context).wellDoneKeepGoing,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color:  (MediaQuery.of(context).platformBrightness ==
                      Brightness.light)
                  ? CustomColor.lightCorrect
                  : CustomColor.darkCorrect,
                        ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: PaddingConstants.large,
            ),
            Container(
              padding:
                  EdgeInsets.fromLTRB(0, 0, 0, PaddingConstants.extraLarge),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      primary:  (MediaQuery.of(context).platformBrightness ==
                      Brightness.light)
                  ? CustomColor.lightCorrect
                  : CustomColor.darkCorrect,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
                  onPressed: () {
                    widget.onClickNext();
                  },
                  child: Text(
                    AppLocalizations.of(context).next.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Theme.of(context).colorScheme.onError),
                  )),
            )
          ],
        ),
      ),
    );
    }
    
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: PaddingConstants.extraLarge),
        child: Column(
          key: widget.key,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: PaddingConstants.large,
            ),
            Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    AppLocalizations.of(context).incorrect,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: PaddingConstants.med,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    AppLocalizations.of(context).trueAnswer,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: PaddingConstants.large,
            ),
            QuizResult.fromParameter(
              key: UniqueKey(),
              rebuildWidget: widget.renderWidget,
            ),
            SizedBox(
              height: PaddingConstants.large,
            ),
            Container(
              padding:
                  EdgeInsets.fromLTRB(0, 0, 0, PaddingConstants.extraLarge),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      primary: Theme.of(context).colorScheme.error,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
                  onPressed: () {
                    widget.onClickNext();
                  },
                  child: Text(
                    AppLocalizations.of(context).next.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Theme.of(context).colorScheme.onError),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
