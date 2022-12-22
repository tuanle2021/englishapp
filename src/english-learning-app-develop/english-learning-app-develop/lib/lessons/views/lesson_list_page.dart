import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/common/dataset/category/category_dataset.dart';
import 'package:learning_english_app/common/dataset/lesson/lesson_dataset.dart';
import 'package:learning_english_app/common/dataset/sub_category/subcategory_dataset.dart';
import 'package:learning_english_app/components/custom_app_bar.dart';
import 'package:learning_english_app/components/custom_bottom_bar.dart';
import 'package:learning_english_app/lessons/views/lesson_history_page.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LessonListPage extends StatefulWidget {
  final Map<String, dynamic> parameters;
  LessonListPage.fromScreenParam({required this.parameters});

  @override
  State<LessonListPage> createState() => _LessonListPageState();
}

class _LessonListPageState extends State<LessonListPage> {
  List<SubCategoryDataset?>? subCategoryList;
  CategoryDataset? categoryDataset;
  static var currentIndex = 0;
  List<Widget> pages = <Widget>[];
  Widget ListTileTap(
      {required LessonDataset lesson,
      required String title,
      bool? isLastType = false,
      IconData? leadingIcon = Icons.home}) {
    if (leadingIcon == null) {
      return InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        splashColor: (Theme.of(context).brightness == Brightness.light)
            ? Colors.grey.shade300
            : Colors.grey.shade500,
        child: ListTile(
            horizontalTitleGap: 0,
            title: Text(title, style: Theme.of(context).textTheme.titleMedium)),
      );
    }
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: (isLastType != null && isLastType)
            ? BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10))
            : BorderRadius.zero,
      ),
      splashColor: (Theme.of(context).brightness == Brightness.light)
          ? Colors.grey.shade300
          : Colors.grey.shade600,
      onTap: () {
        Map<String, dynamic> parameter = Map();
        parameter["lesson"] = lesson;
        parameter["categoryId"] = widget.parameters["categoryId"] as String;
        Navigator.of(context)
            .pushNamed('/lesson', arguments: parameter)
            .then((value) async {
          StorageController.database?.categoryDao
              .getCategoryAndUserScoreBaseOnCategoryId(
                  StorageController.getCurrentUserId() ?? "",
                  StorageController.getCurrentCategoryId() ?? "")
              .then((value) {
            categoryDataset = value;
            setState(() {
              
            });
          });
          final futureGroup = FutureGroup();
          StorageController.database?.subCategoryDao
              .findsubCategoryByCategoryId(
                  StorageController.getCurrentCategoryId() ?? "")
              .then((subCategoryList) {
            for (int i = 0; i < subCategoryList.length; i++) {
              futureGroup.add(StorageController.database!.lessonDao
                  .findLessonBysubCategory(subCategoryList[i]!.id ?? ""));
            }
            futureGroup.close();
            futureGroup.future.then((value) {
              var lessonList = value;
              for (int i = 0; i < subCategoryList.length; i++) {
                subCategoryList[i]?.lessonList =
                    lessonList[i] as List<LessonDataset>;
                if (subCategoryList[i]?.lessonList != null) {
                  for (int j = 0;
                      j < subCategoryList[i]!.lessonList!.length;
                      j++) {
                    StorageController.database!.lessonDao
                        .findLessonAndResultBySubCategory(
                            subCategoryList[i]!.lessonList![j]!.id ?? "")
                        .then((value) {
                      if (value != null) {
                        subCategoryList[i]!.lessonList![j]?.accuracy =
                            value.accuracy;
                        subCategoryList[i]!.lessonList![j]?.completedAt =
                            value.completedAt;
                        subCategoryList[i]!.lessonList![j]?.completionTime =
                            value.completionTime;
                        subCategoryList[i]!.lessonList![j]?.totalIncorrect =
                            value.totalIncorrect;
                        subCategoryList[i]!.lessonList![j]?.point = value.point;
                      }
                      setState(() {
                        this.subCategoryList = subCategoryList;
                        pages = [];
                        pages.add(buildLearningWidget());
                        pages.add(LessonHistoryPage());
                      });
                    });
                  }
                }
              }
            });
          });
        });
      },
      child: ListTile(
        title: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        visualDensity: VisualDensity(vertical: 3), //
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10))),
        horizontalTitleGap: 0,
        leading: Icon(
          Icons.book,
          size: 30,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            lesson.point != null
                ? Text(
                    "${lesson.point} ${AppLocalizations.of(context).point}",
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget renderLessonList(int positionIndex) {
    List<Widget> tileTapList = [];
    var length = subCategoryList?[positionIndex]?.lessonList?.length ?? 0;
    var lessonList = subCategoryList?[positionIndex]?.lessonList;
    for (int i = 0; i < length; i++) {
      if (lessonList != null && lessonList[i] != null) {
        tileTapList.add(ListTileTap(
          lesson: lessonList[i] ?? LessonDataset(),
          title: lessonList[i]?.name ?? "",
        ));
      }
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tileTapList,
    );
  }

  Widget buildLearningWidget() {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: PaddingConstants.large,
                vertical: PaddingConstants.med),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularPercentIndicator(
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                    radius: 60,
                    lineWidth: 10.0,
                    percent: categoryDataset?.calculatePercent() ?? 0,
                    center: Container(
                      alignment: Alignment.center,
                      child: categoryDataset?.iconImage != null ? categoryDataset!.iconImage : SizedBox.shrink()
                    ),
                    backgroundColor: Colors.grey,
                    progressColor: Theme.of(context).colorScheme.primary,
                  ),
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: PaddingConstants.med,
                              ),
                              child: Text(
                                  categoryDataset?.displayProgress() ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: PaddingConstants.med,
                                  vertical: PaddingConstants.med),
                              child: Text(
                                "${AppLocalizations.of(context).lessonRelated}${this.categoryDataset?.name ?? ""}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            )
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: subCategoryList?.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(
                        horizontal: PaddingConstants.large,
                        vertical: PaddingConstants.med),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Material(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              elevation: 5.0,
                              color: Theme.of(context).colorScheme.surface,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 15),
                                      child: Text(
                                          subCategoryList?[index]?.name ?? "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold)),
                                    ),
                                    Divider(
                                      height: 1,
                                    ),
                                    renderLessonList(index),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var parameter = widget.parameters;
    var categoryId = parameter["categoryId"] as String;
    categoryDataset = parameter["category"] as CategoryDataset;
    StorageController.setCurrentCategoryId(categoryId);
    final futureGroup = FutureGroup();
    StorageController.database?.subCategoryDao
        .findsubCategoryByCategoryId(categoryId)
        .then((subCategoryList) {
      for (int i = 0; i < subCategoryList.length; i++) {
        futureGroup.add(StorageController.database!.lessonDao
            .findLessonBysubCategory(subCategoryList[i]!.id ?? ""));
      }
      futureGroup.close();
      futureGroup.future.then((value) {
        var lessonList = value;

        for (int i = 0; i < subCategoryList.length; i++) {
          subCategoryList[i]?.lessonList = lessonList[i] as List<LessonDataset>;
          if (subCategoryList[i]?.lessonList != null) {
            for (int j = 0; j < subCategoryList[i]!.lessonList!.length; j++) {
              StorageController.database!.lessonDao
                  .findLessonAndResultBySubCategory(
                      subCategoryList[i]!.lessonList![j]!.id ?? "")
                  .then((value) {
                if (value != null) {
                  subCategoryList[i]!.lessonList![j]?.accuracy = value.accuracy;
                  subCategoryList[i]!.lessonList![j]?.completedAt =
                      value.completedAt;
                  subCategoryList[i]!.lessonList![j]?.completionTime =
                      value.completionTime;
                  subCategoryList[i]!.lessonList![j]?.totalIncorrect =
                      value.totalIncorrect;
                  subCategoryList[i]!.lessonList![j]?.point = value.point;
                }
                setState(() {
                  this.subCategoryList = subCategoryList;
                  pages = [];
                  pages.add(buildLearningWidget());
                  pages.add(LessonHistoryPage());
                });
              });
            }
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(categoryDataset?.name ?? "").customAppBar(context),
        bottomNavigationBar: CustomBottomBar(
            itemPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            currentIndex: currentIndex,
            onTap: (i) => setState(() => currentIndex = i),
            margin: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.001 * 10,
                horizontal: 10),
            items: [
              CustomBottomBarItem(
                icon: Icon(FontAwesomeIcons.bookOpen),
                title: Text(
                  AppLocalizations.of(context).subjectTab,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(fontWeight: FontWeight.w600, wordSpacing: -1),
                ),
                selectedColor: Theme.of(context).colorScheme.primary,
              ),
              CustomBottomBarItem(
                icon: Icon(FontAwesomeIcons.history),
                title: Text(
                  AppLocalizations.of(context).history,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(fontWeight: FontWeight.w600, wordSpacing: -1),
                ),
                selectedColor: Theme.of(context).colorScheme.primary,
              ),
            ]),
        body: pages.isEmpty ? SizedBox.shrink() :  pages[currentIndex]);
  }
}
