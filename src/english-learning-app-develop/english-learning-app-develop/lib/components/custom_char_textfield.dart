import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_for_extend.dart';
import 'package:learning_english_app/common/extensions.dart';
import 'package:learning_english_app/common/leareng_log.dart';

// ignore: must_be_immutable
class CustomCharTextField extends StatefulWidget {
  CustomCharTextField({Key? key}) : super(key: key);

  String? word;
  CallBack<bool, Map<String, dynamic>>? onCallBack;

  CustomCharTextField.fromWord({required this.word, required this.onCallBack});

  @override
  State<CustomCharTextField> createState() => _CustomCharTextFieldState();
}

class _CustomCharTextFieldState extends State<CustomCharTextField> {
  String? word;
  Map<String, dynamic> correctMap = Map();
  Map<String, dynamic> trueCorrectMap = Map();
  int missingChar = 1;
  List<Widget> renderWidgetVar = [];
  List<int> positionRemove = [];
  List<Widget> widgetList = [];
  List<bool> enableTextField = [];
  List<Widget> widgetResultList = [];
  int counterInput = 0;
  var _focusNodeList = [];
  Map<String, dynamic> dataForRenderResult = Map();

  // int showStatus = 4; //0: init 1: error 2: success

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //showStatus = 4;
    word = widget.word;
    dataForRenderResult["quizType"] = QuizType.FillChar;
    if (word != null) {

      missingChar = ExtensionMethod.random(missingChar, word!.length - 1);
      for (int i = 0; i < missingChar; i++) {
        var rand = ExtensionMethod.random(0, word!.length);
        while (positionRemove.contains(rand)) {
          rand = ExtensionMethod.random(0, word!.length);
        }
        trueCorrectMap[rand.toString()] = word![rand].toString();
        word = word.replaceCharAt(rand, "*");
        positionRemove.add(rand);
        correctMap[rand.toString()] = "";
      }
    }
    positionRemove.sort(((a, b) {
      return a.compareTo(b);
    }));

    _focusNodeList = List.generate(positionRemove.length, (index) {
      var focusNode = FocusNode();
      return focusNode;
    });

    enableTextField = List.generate(positionRemove.length, (index) => true);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (mounted) {
        setState(() {
          widgetList = renderWidget();
        });
      }
    });
  }

  void createDataForDisplayError() {
    dataForRenderResult["word"] = word;
    dataForRenderResult["trueCorrectMap"] = trueCorrectMap;
    dataForRenderResult["correctMap"] = correctMap;
    dataForRenderResult["positionRemove"] = positionRemove;
  }

  List<Widget> renderWidget() {
    var text = "";
    widgetList.clear();

    Color? statusColor;
    // if (showStatus == 0) {
    //   statusColor = null;
    // } else if (showStatus == 1) {
    //   statusColor = Theme.of(context).colorScheme.error;
    // } else if (showStatus == 2) {
    //   if (Theme.of(context).brightness == Brightness.light) {
    //     statusColor = CustomColor.lightCorrect;
    //   } else {
    //     statusColor = CustomColor.darkCorrect;
    //   }
    // }

    for (int i = 0; i < word!.length; i++) {
      if (word![i] == "*") {
        var indexOfPositionList =
            positionRemove.indexWhere((element) => element == i);
        widgetList.add(
          Text(text,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontWeight: FontWeight.w500, fontSize: 26)),
        );
        widgetList.add(
          Container(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.fromLTRB(4, 0, 0, 0),
              width: 55,
              height: 65,
              alignment: Alignment.center,
              child: TextField(
                key: Key(i.toString()),
                controller: correctMap[i.toString()] != null
                    ? TextEditingController(
                        text: correctMap[i.toString()] as String)
                    : null,
                textInputAction: TextInputAction.done,
                focusNode: _focusNodeList[indexOfPositionList],
                enabled: enableTextField[indexOfPositionList],
                onChanged: (value) {
                 
                
                  if (value.length >= 1 || value == "\s") {
                    if (indexOfPositionList + 1 >= positionRemove.length) {
                      FocusScope.of(context).unfocus();
                    } else {
                      LearnEngLog.logger.i(indexOfPositionList);
                      FocusScope.of(context).unfocus();
                      FocusScope.of(context).requestFocus(
                          _focusNodeList[indexOfPositionList + 1]);
                    }
                    correctMap[i.toString()] = value;
                    counterInput++;
                     bool isCorrect = true;
                  for (var key in trueCorrectMap.keys) {
                    if (trueCorrectMap[key] as String !=
                        correctMap[key] as String) {
                      createDataForDisplayError();
                      isCorrect = false;
                      widget.onCallBack!(false, dataForRenderResult);
                    }
                  }
                  if (isCorrect) {
                     widget.onCallBack!(true, correctMap);
                  }
                    return;
                  }

                  if (value.length == 0 &&
                      correctMap[i.toString()] as String != value) {
                    correctMap[i.toString()] = value;
                    counterInput--;
                  } else if (value.length == 0 &&
                      correctMap[i.toString] as String == value) {
                    correctMap[i.toString()] = value;
                    if (indexOfPositionList - 1 < 0) {
                      FocusScope.of(context).unfocus();
                    } else {
                      FocusScope.of(context).requestFocus(
                          _focusNodeList[indexOfPositionList - 1]);
                    }
                  }
                   bool isCorrect = true;
                  for (var key in trueCorrectMap.keys) {
                    if (trueCorrectMap[key] as String !=
                        correctMap[key] as String) {
                      createDataForDisplayError();
                      isCorrect = false;
                      widget.onCallBack!(false, dataForRenderResult);
                    }
                  }
                  if (isCorrect) {
                     widget.onCallBack!(true, correctMap);
                  }
                },
                maxLines: 1,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  LowerCaseTextFormatter()
                ],
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    fillColor: statusColor,
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        gapPadding: 0)),
                keyboardType: TextInputType.text,
                cursorColor: Theme.of(context).colorScheme.onBackground,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 26,
                    wordSpacing: 0,
                    letterSpacing: 0),
              )),
        );
        text = "";
      } else {
        text = text + word![i];
      }
    }
    widgetList.add(
      Text(text,
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(fontWeight: FontWeight.w500, fontSize: 26)),
    );
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
          alignment: Alignment.center,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: PaddingConstants.med),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: renderWidget()),
                  SizedBox(
                    height: PaddingConstants.large,
                  ),
                  //(showStatus == 1) ? Row(mainAxisAlignment: MainAxisAlignment.center,children: renderWidgetForDisplayError(),) : SizedBox.shrink(),
                  SizedBox(
                    height: 50,
                  ),
                  // showStatus == 0
                  //     ? Align(
                  //         alignment: Alignment.bottomCenter,
                  //         child: Center(
                  //           child: ElevatedButton(
                  //             onPressed: () async {
                  //               setState(() {
                  //                 enableTextField = List.generate(
                  //                     positionRemove.length, (index) => false);
                  //               });
                  //               for (var key in trueCorrectMap.keys) {
                  //                 if (trueCorrectMap[key] as String !=
                  //                     correctMap[key] as String) {
                  //                   setState(() {
                  //                     showStatus = 1;
                  //                   });
                  //                   createDataForDisplayError();
                  //                   widget.onCallBack!(
                  //                       false, dataForRenderResult);
                  //                   return;
                  //                 }
                  //               }
                  //               setState(() {
                  //                 showStatus = 2;
                  //               });
                  //               widget.onCallBack!(true, correctMap);
                  //               return;
                  //             },
                  //             child: Text(
                  //               AppLocalizations.of(context).complete,
                  //               style: Theme.of(context)
                  //                   .textTheme
                  //                   .titleLarge!
                  //                   .copyWith(
                  //                       color: Theme.of(context)
                  //                           .colorScheme
                  //                           .onPrimary),
                  //             ),
                  //             style: ElevatedButton.styleFrom(
                  //                 primary: Theme.of(context)
                  //                     .colorScheme
                  //                     .primaryContainer,
                  //                 shape: StadiumBorder(),
                  //                 padding: EdgeInsets.symmetric(
                  //                     horizontal: 30, vertical: 15)),
                  //           ),
                  //         ),
                  //       )
                  //     : SizedBox.shrink(),
                ],
              ))),
    );
  }
}
