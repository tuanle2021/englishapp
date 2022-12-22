import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/common/dataset/category/category_dataset.dart';
import 'package:learning_english_app/common/extensions.dart';
import 'package:learning_english_app/components/theme.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CategoriesPage extends StatefulWidget {
  CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final double originalRadius = logicalWidth * 0.15;
  final ScrollController subjectListController = new ScrollController();
  int currentSelectedIndex = -1;
  List<CategoryDataset> subjectList = [];
  bool pressed = false;

  void handleUnlockCategoryList() {
    var index =
        subjectList.indexWhere((element) => element.calculatePercent() < 0.6);
    if (index != -1) {
      for (int i = 0; i < subjectList.length; i++) {
        if (i <= index) {
          subjectList[i].isPressOpacity = 1;
          subjectList[i].isLock = false;
        } else {
          subjectList[i].isPressOpacity = subjectList[i].disableOpacity;
          subjectList[i].isLock = true;
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subjectList = [];

    StorageController.database!.categoryDao
        .getCategoryAndUserScore(StorageController.getCurrentUserId()!)
        .then((value) {
      subjectList = value;
      subjectList.sort(
        (subjectA, subjectB) {
          if (subjectA.levelTypeValue != null &&
              subjectB.levelTypeValue != null) {
            var valueA = subjectA.levelTypeValue ?? 0;
            var valueB = subjectB.levelTypeValue ?? 0;
            return valueA.compareTo(valueB);
          }
          return 0;
        },
      );
      handleUnlockCategoryList();

      setState(() {});
    });

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      subjectListController.addListener(() {
        setState(() {
          if (currentSelectedIndex != -1) {
            subjectList[currentSelectedIndex].isOpenDialog = false;
            subjectList[currentSelectedIndex].scaleTransition = 0;
          }
        });
      });
    });
  }

  Widget displayCup(index) {
    List<Widget> listWidget = [];
    var completed = subjectList[index].completed ?? 0;
    for (int i = 0; i < subjectList[index].total!; i++) {
      if (completed > 0) {
        listWidget.add(Icon(FontAwesome.trophy,
            size: 18, color: Color.fromARGB(255, 255, 247, 0)));
        completed = completed - 1;
      } else {
        listWidget
            .add(Icon(FontAwesome.trophy, size: 18, color: Colors.black45));
      }
    }
    return Wrap(
      children: listWidget,
    );
  }

  void onOpenDialog(int index) {
    if (subjectList[index].isOpenDialog == true) {
      setState(() {
        subjectList[index].isOpenDialog = false;
        subjectList[index].isPressOpacity = 0;
        subjectList[index].scaleTransition = 0;
        if (currentSelectedIndex > -1 &&
            subjectList[currentSelectedIndex].isOpenDialog == true) {
          subjectList[currentSelectedIndex].isOpenDialog = false;
          subjectList[currentSelectedIndex].scaleTransition = 0;
        }
        currentSelectedIndex = -1;
        subjectList[index].radius = originalRadius;
        subjectList[index].isPressOpacity = 1;
      });
      return;
    }
    setState(() {
      subjectList[index].isOpenDialog = true;
      subjectList[index].isPressOpacity = 1;
      subjectList[index].scaleTransition = 1;
      if (currentSelectedIndex > -1 &&
          subjectList[currentSelectedIndex].isOpenDialog == true) {
        subjectList[currentSelectedIndex].isOpenDialog = false;
        subjectList[currentSelectedIndex].scaleTransition = 0;
      }
      currentSelectedIndex = index;
      subjectList[index].radius = originalRadius;
    });
  }

  void onStartLessonPage(int index) {
    Map<String, dynamic> parameters = Map();
    parameters["categoryId"] = subjectList[index].id;
    parameters["category"] = subjectList[index];
    Navigator.of(context)
        .pushNamed("/lesson_list", arguments: parameters)
        .then((_) {
      currentSelectedIndex = -1;
      pressed = false;
      subjectList = [];
      StorageController.database!.categoryDao
          .getCategoryAndUserScore(StorageController.getCurrentUserId()!)
          .then((value) {
        subjectList = value;
        subjectList.sort(
          (subjectA, subjectB) {
            if (subjectA.levelTypeValue != null &&
                subjectB.levelTypeValue != null) {
              var valueA = subjectA.levelTypeValue ?? 0;
              var valueB = subjectB.levelTypeValue ?? 0;
              return valueA.compareTo(valueB);
            }
            return 0;
          },
        );
        handleUnlockCategoryList();
        setState(() {});
      });
      //onOpenDialog(currentSelectedIndex);
    });
  }

  void animatePressCircle(int index) {
    setState(() {
      subjectList[index].radius = originalRadius * 0.97;
      subjectList[index].isPressOpacity = 0.6;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: PaddingConstants.med),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/background.png"))),
        child: ListView.builder(
          reverse: true,
          shrinkWrap: true,
          controller: subjectListController,
          itemBuilder: ((context, index) {
            var radius = subjectList[index].radius;

            if (index % 2 == 0) {
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  verticalOffset: 50,
                  child: FadeInAnimation(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: (radius * 0.83).ceil().toDouble()),
                      child: Stack(children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTapDown: (details) {
                              if (subjectList[index].isPressOpacity ==
                                  subjectList[index].disableOpacity) {
                                return;
                              }
                              animatePressCircle(index);
                            },
                            onLongPressDown: (details) {
                              if (subjectList[index].isPressOpacity ==
                                  subjectList[index].disableOpacity) {
                                return;
                              }
                              animatePressCircle(index);
                            },
                            onTapUp: (details) {
                              if (subjectList[index].isPressOpacity ==
                                  subjectList[index].disableOpacity) {
                                return;
                              }
                              onOpenDialog(index);
                            },
                            onLongPressUp: () {
                              if (subjectList[index].isPressOpacity ==
                                  subjectList[index].disableOpacity) {
                                return;
                              }
                              onOpenDialog(index);
                            },
                            child: AnimatedOpacity(
                              curve: Curves.fastOutSlowIn,
                              duration: Duration(seconds: 1),
                              opacity: subjectList[index].isPressOpacity,
                              child: CircularPercentIndicator(
                                circularStrokeCap: CircularStrokeCap.round,
                                animation: true,
                                radius: subjectList[index].radius,
                                lineWidth: 10.0,
                                percent:
                                    subjectList[index].calculatePercent(),
                                center: subjectList[index].image != null &&
                                        subjectList[index].image != ""
                                    ? subjectList[index].iconImage
                                    : SizedBox.shrink(),
                                backgroundColor: Colors.grey,
                                footer: Text(subjectList[index].name ?? "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.bold)),
                                progressColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            left: 1.4 * radius,
                            child: CircleAvatar(
                                backgroundColor: Colors.grey.shade700,
                                radius: 23,
                                child: Icon(
                                  FontAwesome.star,
                                  size: 28,
                                  color:
                                      subjectList[index].calculatePercent() >=
                                              1
                                          ? Colors.yellow
                                          : Colors.grey,
                                ))),
                        (index != subjectList.length - 1)
                            ? Positioned(
                                left: radius * 1.5,
                                bottom: radius * 1,
                                child:
                                    SvgPicture.asset("assets/svg/arrow.svg"))
                            : SizedBox.shrink(),
                        Positioned(
                          top: 10,
                          left: radius * 2.3,
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 200),
                            opacity:
                                subjectList[index].scaleTransition.toDouble(),
                            curve: Curves.easeIn,
                            child: Container(
                              width: radius * 2.6,
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.symmetric(
                                  horizontal: PaddingConstants.med,
                                  vertical: PaddingConstants.small),
                              decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  border: Border.all(
                                    color: Colors.transparent,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        "${AppLocalizations.of(context).lesson} ${subjectList[index].displayProgress()}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary)),
                                    SizedBox(
                                      height: PaddingConstants.small,
                                    ),
                                    displayCup(index),
                                    Center(
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            onSurface: (MediaQuery.of(context)
                                                        .platformBrightness ==
                                                    Brightness.light)
                                                ? CustomColor.lightCorrect
                                                : CustomColor.darkCorrect,
                                            onPrimary: Colors.white,
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(5))),
                                            minimumSize:
                                                Size(90, 30), //////// HERE
                                          ),
                                          onPressed: subjectList[index]
                                                      .scaleTransition
                                                      .toDouble() ==
                                                  0
                                              ? null
                                              : () {
                                                  onStartLessonPage(index);
                                                },
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary),
                                          )),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              );
            } else {
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  verticalOffset: 50,
                  child: FadeInAnimation(
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(
                          horizontal: (radius * 0.83).ceil().toDouble()),
                      width: MediaQuery.of(context).size.width,
                      child: Stack(children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTapDown: (details) {
                              if (subjectList[index].isPressOpacity ==
                                  subjectList[index].disableOpacity) {
                                return;
                              }
                              animatePressCircle(index);
                            },
                            onLongPressDown: (details) {
                              if (subjectList[index].isPressOpacity ==
                                  subjectList[index].disableOpacity) {
                                return;
                              }
                              animatePressCircle(index);
                            },
                            onTapUp: (details) {
                              if (subjectList[index].isPressOpacity ==
                                  subjectList[index].disableOpacity) {
                                return;
                              }
                              onOpenDialog(index);
                            },
                            onLongPressUp: () {
                              if (subjectList[index].isPressOpacity ==
                                  subjectList[index].disableOpacity) {
                                return;
                              }
                              onOpenDialog(index);
                            },
                            child: AnimatedOpacity(
                              duration: Duration(milliseconds: 200),
                              opacity: subjectList[index].isPressOpacity,
                              child: CircularPercentIndicator(
                                circularStrokeCap: CircularStrokeCap.round,
                                animation: true,
                                radius: subjectList[index].radius,
                                lineWidth: 10.0,
                                percent:
                                    subjectList[index].calculatePercent(),
                                center: Container(
                                    alignment: Alignment.center,
                                    child: subjectList[index].image != null &&
                                            subjectList[index].image != ""
                                        ?  subjectList[index].iconImage
                                        : SizedBox.shrink()),
                                footer: Text(subjectList[index].name ?? "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.bold)),
                                backgroundColor: Colors.grey,
                                progressColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            right: radius * 1.4,
                            child: CircleAvatar(
                                backgroundColor: Colors.grey.shade700,
                                radius: 23,
                                child: Icon(
                                  FontAwesome.star,
                                  size: 28,
                                  color:
                                      subjectList[index].calculatePercent() >=
                                              1
                                          ? Colors.yellow
                                          : Colors.grey,
                                ))),
                        (index != subjectList.length - 1)
                            ? Positioned(
                                bottom: radius * 1,
                                right: radius * 1.5,
                                child: Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.rotationY(math.pi),
                                    child: SvgPicture.asset(
                                        "assets/svg/arrow.svg")),
                              )
                            : SizedBox.shrink(),
                        Positioned(
                          top: 10,
                          right: radius * 2.25,
                          child: AnimatedOpacity(
                            opacity:
                                subjectList[index].scaleTransition.toDouble(),
                            curve: Curves.easeIn,
                            duration: Duration(milliseconds: 200),
                            child: Container(
                              width: radius * 2.6,
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.symmetric(
                                  horizontal: PaddingConstants.med,
                                  vertical: PaddingConstants.small),
                              decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  border: Border.all(
                                    color: Colors.transparent,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        "Bài học ${subjectList[index].displayProgress()}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary)),
                                    displayCup(index),
                                    Center(
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            onSurface: (MediaQuery.of(context)
                                                        .platformBrightness ==
                                                    Brightness.light)
                                                ? CustomColor.lightCorrect
                                                : CustomColor.darkCorrect,
                                            onPrimary: Colors.white,
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(5))),
                                            minimumSize:
                                                Size(90, 30), //////// HERE
                                          ),
                                          onPressed: subjectList[index]
                                                      .scaleTransition ==
                                                  0
                                              ? null
                                              : () {
                                                  onStartLessonPage(index);
                                                },
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary),
                                          )),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              );
            }
          }),
          itemCount: subjectList.length,
        ),
      ),
    );
  }
}
