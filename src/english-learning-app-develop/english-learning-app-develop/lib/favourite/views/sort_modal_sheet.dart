import 'package:flutter/material.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/leareng_log.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SortModalSheet extends StatefulWidget {
  ValueSetter<String> onClickCallBack;
  String? defaultSearchValue;
  List<String> sortItem;
  SortModalSheet(
      {Key? key,
      required this.onClickCallBack,
      this.defaultSearchValue,
      required this.sortItem})
      : super(key: key);

  @override
  State<SortModalSheet> createState() => _SortModalSheetState();
}

class _SortModalSheetState extends State<SortModalSheet> {
  List<String> sortItem = [];
  String? selectedValue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedValue = widget.defaultSearchValue;
    sortItem = widget.sortItem;
    setState(() {});
  }

  List<Widget> renderSortItem() {
    List<Widget> sortItemWidget = [];
    for (var item in sortItem) {
      sortItemWidget.add(
        RadioListTile<String>(
            value: item,
            title: Text(item),
            groupValue: selectedValue,
            onChanged: (String? value) {
              setState(() {
                selectedValue = item;
                LearnEngLog.logger.i(selectedValue);
                widget.onClickCallBack(item);
              });
            }),
      );
    }
    return sortItemWidget;
  }

  @override
  Widget build(BuildContext context) {
    if (sortItem.length <= 0) {
      return Column();
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: PaddingConstants.med),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: 
          renderSortItem()
        ,
      ),
    );
  }
}
