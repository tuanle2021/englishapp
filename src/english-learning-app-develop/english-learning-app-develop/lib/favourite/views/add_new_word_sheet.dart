import 'package:flutter/material.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/common/dataset/word/word_dataset.dart';
import 'package:learning_english_app/common/leareng_log.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english_app/profile/models/dataset/setting_dataset.dart';

class AddNewWordSheet extends StatefulWidget {
  AddNewWordSheet({Key? key, required this.onCallBack}) : super(key: key);

  ValueSetter<WordDataset> onCallBack;

  @override
  State<AddNewWordSheet> createState() => _AddNewWordSheetState();
}

class _AddNewWordSheetState extends State<AddNewWordSheet> {
  late List<String> sortItem = [];
  List<WordDataset> searchItem = [];
  WordDataset? selectedWord;
  late SettingDataset settingDataset;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StorageController.database!.settingDao
        .findSetting(DeviceInfo.deviceID)
        .then((value) {
      if (value != null) {
        settingDataset = value;
      }
    });
  }

  String typeOfWord(String type) {
    switch (type) {
      case "Adjective":
        {
          return AppLocalizations.of(context).adjective;
        }
      case "Verb":
        {
          return AppLocalizations.of(context).verb;
        }
      case "Adverb":
        {
          return AppLocalizations.of(context).adverb;
        }
      case "Noun":
        {
          return AppLocalizations.of(context).noun;
        }
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            onChanged: ((value) async {
              if (value.length > 0) {
                searchItem = await StorageController.database!.wordDao
                    .searchWordByText(value);
                setState(() {});
              }
            }),
            cursorColor: Theme.of(context).colorScheme.onSurface,
            textInputAction: TextInputAction.search,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: AppLocalizations.of(context).search,
              filled: true,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              contentPadding: EdgeInsetsDirectional.only(start: 15),
            ),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: searchItem.length,
              itemBuilder: (context, index) {
                return RadioListTile<WordDataset>(
                  title: Text(
                    searchItem[index].word! +
                        " (" +
                        typeOfWord(searchItem[index].lexicalCategory!) +
                        ")",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: settingDataset.appLanguage == Language.VN.name
                      ? Text(searchItem[index].mean ?? "")
                      : Text(searchItem[index].definitions ?? ""),
                  onChanged: ((value) {
                    setState(() {
                      selectedWord = value;
                      widget.onCallBack(value!);
                    });
                  }),
                  value: searchItem[index],
                  groupValue: selectedWord,
                );
              }),
        )
      ],
    );
  }
}
