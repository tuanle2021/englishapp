import 'package:async/async.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learning_english_app/common/controller/dialog_controller.dart';
import 'package:learning_english_app/common/controller/notification_controller.dart';
import 'package:learning_english_app/common/dao/sub_category_dao.dart';
import 'package:learning_english_app/common/dataset/category/category_dataset.dart';
import 'package:learning_english_app/common/dataset/category_user/category_user_dataset.dart';
import 'package:learning_english_app/common/dataset/lesson/lesson_dataset.dart';
import 'package:learning_english_app/common/dataset/lesson_user/lesson_user_dataset.dart';
import 'package:learning_english_app/common/dataset/lesson_user_score/lesson_user_score_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_fill_char_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_fill_word_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_right_pronouce_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_right_word_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_trans_arrange_dataset.dart';
import 'package:learning_english_app/common/dataset/sub_category/subcategory_dataset.dart';
import 'package:learning_english_app/common/dataset/word/word_dataset.dart';
import 'package:learning_english_app/common/extensions.dart';
import 'package:learning_english_app/common/http_client_service.dart';
import 'package:learning_english_app/common/leareng_log.dart';
import 'package:learning_english_app/common/nagivation_service.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/environment.dart';
import 'package:learning_english_app/components/theme.dart';
import 'package:learning_english_app/favourite/models/dataset/user_favourite_dataset.dart';
import 'package:learning_english_app/home/views/home_page.dart';
import 'package:learning_english_app/lessons/views/lesson_list_page.dart';
import 'package:learning_english_app/lessons/views/lesson_page.dart';
import 'package:learning_english_app/login/views/forgot_password_page.dart';
import 'package:learning_english_app/login/views/introduce_page.dart';
import 'package:learning_english_app/login/views/login_page.dart';
import 'package:learning_english_app/login/views/otp_page.dart';
import 'package:learning_english_app/login/views/sign_up_page.dart';
import 'package:learning_english_app/profile/models/dataset/setting_dataset.dart';
import 'package:learning_english_app/profile/models/dataset/userprofile_dataset.dart';
import 'package:learning_english_app/profile/models/services/profile_service.dart';
import 'package:learning_english_app/profile/views/feedback_page.dart';
import 'package:learning_english_app/profile/views/notification_page.dart';
import 'package:learning_english_app/profile/views/personal_info_page.dart';
import 'package:learning_english_app/profile/views/setting_page.dart';
import 'package:learning_english_app/profile/views/feedback_page.dart';
import 'package:learning_english_app/profile/views/subsetting_page/app_language_setting.dart';
import 'package:learning_english_app/profile/views/subsetting_page/app_theme_setting.dart';
import 'package:learning_english_app/quiz/views/quiz_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelGroupKey: 'MyVocabKey',
            channelKey: 'NotificationForLearnApp',
            channelName: 'NotificationForCheckApp',
            channelDescription: 'Checking app detail',
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'MyVocabKey', channelGroupName: 'MyVocab')
      ],
      debug: false);
  try {
    await dotenv.load(fileName: Environment.fileName);
    StorageController.userDefaultService =
        await SharedPreferences.getInstance();
    await StorageController.buildDatabase();
    await DeviceInfo.getDeviceId();
    await AppInfo.getAppVersion();
    await StorageController.initAppDataFromJson();
    await Firebase.initializeApp();
  } catch (e) {
    LearnEngLog.logger.e(e.toString());
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.changeLanguage(newLocale);
  }

  static void setThemeMode(BuildContext context, ThemeMode themeMode) async {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.changeThemeMode(themeMode);
  }
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  ThemeMode _themeMode = ThemeMode.system;
  TextTheme parentLightTxtTheme = ThemeData.light().textTheme;

  TextTheme parentDarkTxtTheme = ThemeData.dark().textTheme;
  Locale? _locale = null;

  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  changeThemeMode(ThemeMode themeMode) {
    setState(() {
      this._themeMode = themeMode;
    });
  }

  void fetchCommonData(result) async {
    // handle token



    List<CategoryUserDataset> categoryUserDatasetList = [];
    var categoryUserList = result["category_user"] as List<dynamic>;
    var categoryUserLength = categoryUserList.length;
    for (int i = 0; i < categoryUserLength; i++) {
      var map = categoryUserList[i] as Map<String, dynamic>;
      map.parseApiResponse();
      categoryUserDatasetList.add(CategoryUserDataset.fromJson(map));
    }

    List<UserFavouriteDataset> userFavouriteDatasetList = [];
    var userFavouriteList = result["user_favourite"] as List<dynamic>;
    var userFavouriteLength = userFavouriteList.length;
    for (int i = 0; i < userFavouriteLength; i++) {
      var map = userFavouriteList[i] as Map<String, dynamic>;
      map.parseApiResponse();
      userFavouriteDatasetList.add(UserFavouriteDataset.fromJson(map));
    }

    List<LessonUserDataset> lessonUserDatasetList = [];
    var lessonUserList = result["lesson_user"] as List<dynamic>;
    var lessonUserLength = lessonUserList.length;
    for (int i = 0; i < lessonUserLength; i++) {
      var map = lessonUserList[i] as Map<String, dynamic>;
      map.parseApiResponse();
      lessonUserDatasetList.add(LessonUserDataset.fromJson(map));
    }

    List<LessonUserScoreDataset> lessonUserScoreDatasetList = [];
    var lessonUserScoreList = result["lesson_user_score"] as List<dynamic>;
    var lessonUserScoreLength = lessonUserScoreList.length;
    for (int i = 0; i < lessonUserScoreLength; i++) {
      var map = lessonUserScoreList[i] as Map<String, dynamic>;
      map.parseApiResponse();
      lessonUserScoreDatasetList.add(LessonUserScoreDataset.fromJson(map));
    }
    final futureGroup = FutureGroup();
    futureGroup.add(StorageController.database!.categoryUserDao
        .insertListCategoryTransaction(categoryUserDatasetList));
    futureGroup.add(StorageController.database!.userFavouriteDao
        .insertListUserFavouriteTransaction(userFavouriteDatasetList));
    futureGroup.add(StorageController.database!.lessonUserScoreDao
        .insertLessonUserScoreTransaction(lessonUserScoreDatasetList));
    futureGroup.add(StorageController.database!.lessonUserDao
        .insertListLessonTransaction(lessonUserDatasetList));
    futureGroup.close();

    futureGroup.future.then((value) {});
  }

  @override
  void initState() {
    super.initState();
    EasyLoading.init();
    HttpClientService.connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile ||
          event == ConnectivityResult.wifi) {
        HttpClientService.isHasInternetConnection = true;
      } else if (event == ConnectivityResult.none) {
        HttpClientService.isHasInternetConnection = false;
      }
    });
    StorageController.database!.settingDao
        .findSetting(DeviceInfo.deviceID)
        .then((value) {
      if (value == null) {
        SettingDataset settingEntity = SettingDataset(
            Language.VN.name, ThemeSetting.System.name,
            deviceId: DeviceInfo.deviceID);
        StorageController.database!.settingDao.insertSetting(settingEntity);
        _locale = Locale('vi', '');
        changeLanguage(_locale!);
        changeThemeMode(ThemeMode.system);
      } else {
        //Setting Language
        LearnEngLog.logger.e(value.toString());
        if (value.appLanguage == Language.EN.name) {
          _locale = Locale('en', '');
        } else if (value.appLanguage == Language.VN.name) {
          _locale = Locale('vi', '');
        }
        changeLanguage(_locale!);

        //Setting thememode
        if (value.themeMode == ThemeSetting.Light.name) {
          changeThemeMode(ThemeMode.light);
        } else if (value.themeMode == ThemeSetting.Dark.name) {
          changeThemeMode(ThemeMode.dark);
        } else if (value.themeMode == ThemeSetting.System) {
          changeThemeMode(ThemeMode.system);
        }
      }
    });

    var tokenResult = StorageController.database!.tokenDao
        .getRefreshToken("ACCESS_TOKEN")
        .first;
    tokenResult.then((value) {
      var url =
          Environment.apiUrl + '/user/${AppInfo.apiVersion}/fetch-user-data';
      HttpClientService().requestTo(
          url: url,
          method: HttpMethod.GET,
          success: (result) {
            var resultMap = result as Map<String, dynamic>;
            if (resultMap["success"] as bool == true) {
              fetchCommonData(resultMap["result"] as Map<String, dynamic>);
            }
          },
          failure: (error) {});
    });

    if (StorageController.getCurrentUserId() == null ||
        StorageController.getCurrentUserId() == "") {
      ProfileService profileService = ProfileService();
      profileService.getUserProfile((result) {
        var resultMap = result as Map<String, dynamic>;
        setState(() {
          resultMap["user"]["id"] = resultMap["user"]["_id"];
          var userProfile = UserProfileDataset.fromJson(
              resultMap["user"] as Map<String, dynamic>);
          StorageController.database?.userProfileDao
              .insertUserProfile(userProfile)
              .then((value) {
            StorageController.setCurrentUserId(userProfile.id ?? "");
          });
        });
      }, (error) {
        var errorMap = error as Map<String, dynamic>;
        LearnEngLog.logger.e(errorMap["error"]);
      });
    }
    NotificationController.setUpAction(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_themeMode == ThemeMode.light) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light, statusBarColor: Colors.white));
    } else if (_themeMode == ThemeMode.dark) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark, statusBarColor: Colors.black));
    } else {
      final ThemeData theme = Theme.of(context);
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(statusBarBrightness: theme.brightness));
    }

    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode: this._themeMode,
      theme: CustomTheme.getLightTheme(),
      darkTheme: CustomTheme.getDarkTheme(),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: [
        Locale('en', ''), // English, no country code
        Locale('vi', ''), // Vietnamese, no country code
      ],
      home: MyHomePage(title: 'My English Learning App'),
      builder: EasyLoading.init(),
      onGenerateRoute: (settings) {
        WidgetBuilder builder = (BuildContext _) => new IntroducePage();
        switch (settings.name) {
          case '/login':
            builder = (BuildContext _) => new LoginPage();
            break;
          case '/sign_up':
            builder = (BuildContext _) => new SignUpPage();
            break;
          case '/forgot_password':
            builder = (BuildContext _) => new ForgotPasswordPage();
            break;
          case '/home':
            builder = (BuildContext _) => new HomePage();
            break;
          case '/otp':
            builder = (BuildContext _) => new OtpPage();
            break;
          case '/introduce':
            builder = (BuildContext _) => new IntroducePage();
            break;
          case '/setting':
            builder = (BuildContext _) => new SettingPage();
            break;
          case '/feedback':
            builder = (BuildContext _) => new FeedbackPage();
            break;
          case '/app_language_setting':
            var profileService = settings.arguments as ProfileService;
            builder = (BuildContext _) => new SettingAppLanguagePage(
                  service: profileService,
                );
            break;
          case '/app_theme_setting':
            var profileService = settings.arguments as ProfileService;
            builder = (BuildContext _) =>
                new SettingAppThemePage(service: profileService);
            break;
          case '/personal_info':
            var profileService = settings.arguments as ProfileService;
            builder = (BuildContext _) =>
                new PersonalInfoPage(profileService: profileService);
            break;
          case '/lesson_list':
            var parameters = settings.arguments as Map<String, dynamic>;
            builder = (BuildContext _) =>
                new LessonListPage.fromScreenParam(parameters: parameters);
            break;
          case '/lesson':
            var parameters = settings.arguments as Map<String, dynamic>;
            builder = (BuildContext _) =>
                new LessonPage.fromParameter(parameter: parameters);
            break;
          case '/lesson_quiz':
            var parameters = settings.arguments as Map<String, dynamic>;
            builder = (BuildContext _) =>
                new QuizPage.fromParameter(parameter: parameters);
            break;
          case '/notification':
            builder = (BuildContext _) => new NotificationPage();
            break;
          default:
            break;
        }
        return new MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final tokenDao = StorageController.database?.tokenDao;
  String? accessToken = null;
  bool? completeInit = null;

  bool isUpdate = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    completeInit = StorageController.getCompleteInit();
    var url = Environment.apiUrl +
        '/app_version/${AppInfo.apiVersion}/checkVersion?version=${StorageController.getVersionUpdateApp()}';
    HttpClientService().requestTo(
        url: url,
        method: HttpMethod.GET,
        success: (result) {
          var resultMap = result as Map<String, dynamic>;
          if (resultMap["update"] as bool == true) {
            StorageController.setVersionUpdateApp(
                resultMap["appVersion"] as String);
            List<CategoryDataset> categoryDatasetList = [];
            var categoryList = resultMap["category"] as List<dynamic>;
            var categoryLength = categoryList.length;
            for (int i = 0; i < categoryLength; i++) {
              var map = categoryList[i] as Map<String, dynamic>;
              map.parseApiResponse();
              categoryDatasetList.add(CategoryDataset.fromJson(map));
            }

            List<LessonDataset> lessonDatasetList = [];
            var lessonList = resultMap["lesson"] as List<dynamic>;
            var lessonLength = lessonList.length;
            for (int i = 0; i < lessonLength; i++) {
              var map = lessonList[i] as Map<String, dynamic>;
              map.parseApiResponse();
              lessonDatasetList.add(LessonDataset.fromJson(map));
            }

            List<SubCategoryDataset> subCategoryDatasetList = [];
            var subCategoryList = resultMap["subCategory"] as List<dynamic>;
            var subCategoryLength = subCategoryList.length;
            for (int i = 0; i < subCategoryLength; i++) {
              var map = subCategoryList[i] as Map<String, dynamic>;
              map.parseApiResponse();
              subCategoryDatasetList.add(SubCategoryDataset.fromJson(map));
            }

            List<WordDataset> wordDatasetList = [];
            var wordList = resultMap["word"] as List<dynamic>;
            var wordLength = wordList.length;
            for (int i = 0; i < wordLength; i++) {
              var map = wordList[i] as Map<String, dynamic>;
              map.parseApiResponse();
              wordDatasetList.add(WordDataset.fromJson(map));
            }

            List<QuizFillCharDataset> quizFillCharDatasetList = [];
            var quizFillCharList = resultMap["quizFillChar"] as List<dynamic>;
            var quizFillCharLength = quizFillCharList.length;
            for (int i = 0; i < quizFillCharLength; i++) {
              var map = quizFillCharList[i] as Map<String, dynamic>;
              map.parseApiResponse();
              quizFillCharDatasetList.add(QuizFillCharDataset.fromJson(map));
            }

            List<QuizFillWordDataset> quizFillWordDatasetList = [];
            var quizFillWordList = resultMap["quizFillWord"] as List<dynamic>;
            var quizFillWordLength = quizFillWordList.length;
            for (int i = 0; i < quizFillWordLength; i++) {
              var map = quizFillWordList[i] as Map<String, dynamic>;
              map.parseApiResponse();
              quizFillWordDatasetList.add(QuizFillWordDataset.fromJson(map));
            }

            List<QuizRightWordDataset> quizRightWordDatasetList = [];
            var quizRightWordList = resultMap["quizRightWord"] as List<dynamic>;
            var quizRightWordLength = quizRightWordList.length;
            for (int i = 0; i < quizRightWordLength; i++) {
              var map = quizRightWordList[i] as Map<String, dynamic>;
              map.parseApiResponse();
              quizRightWordDatasetList.add(QuizRightWordDataset.fromJson(map));
            }

            List<QuizTransArrangeDataset> quizTransArrangeDatasetList = [];
            var quizTransArrangeList =
                resultMap["quizTransArrange"] as List<dynamic>;
            var quizTransArrangeLength = quizTransArrangeList.length;
            for (int i = 0; i < quizTransArrangeLength; i++) {
              var map = quizTransArrangeList[i] as Map<String, dynamic>;
              map.parseApiResponse();
              quizTransArrangeDatasetList
                  .add(QuizTransArrangeDataset.fromJson(map));
            }

            List<QuizRightPronouceDataset> quizRightPronouceDatasetList = [];
            var quizRightPronouceList =
                resultMap["quizRightPro"] as List<dynamic>;
            var quizRightPronouceLength = quizRightPronouceList.length;
            for (int i = 0; i < quizRightPronouceLength; i++) {
              var map = quizRightPronouceList[i] as Map<String, dynamic>;
              map.parseApiResponse();
              quizRightPronouceDatasetList
                  .add(QuizRightPronouceDataset.fromJson(map));
            }

            FutureGroup futureGroup = FutureGroup();
            futureGroup.add(StorageController.database!.lessonDao
                .insertListCategoryTransaction(lessonDatasetList));
            futureGroup.add(StorageController.database!.categoryDao
                .insertListCategoryTransaction(categoryDatasetList));
            futureGroup.add(StorageController.database!.subCategoryDao
                .insertListCategoryTransaction(subCategoryDatasetList));
            futureGroup.add(StorageController.database!.wordDao
                .insertListWordTransaction(wordDatasetList));
            futureGroup.add(StorageController.database!.quizFillCharDao
                .insertListQuizTransaction(quizFillCharDatasetList));
            futureGroup.add(StorageController.database!.quizFillWordDao
                .insertListQuizTransaction(quizFillWordDatasetList));
            futureGroup.add(StorageController.database!.quizRightWordDao
                .insertListQuizTransaction(quizRightWordDatasetList));
            futureGroup.add(StorageController.database!.quizTransArrageDao
                .insertListQuizTransaction(quizTransArrangeDatasetList));
            futureGroup.add(StorageController.database!.quizRightPronouceDao
                .insertListQuizTransaction(quizRightPronouceDatasetList));
            futureGroup.close();
            futureGroup.future.then((value) {
              setState(() {
                isUpdate = true;
              });
            });
          } else {
            setState(() {
              isUpdate = true;
            });
          }
        },
        failure: (error) {
           setState(() {
              isUpdate = true;
            });
        });
  }

  @override
  Widget build(BuildContext context) {
    if (isUpdate == false) {
      return Scaffold(
          body: Container(
              color: Theme.of(context).colorScheme.primary,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: DialogController.loadingDialog(context: context)));
    }
    return Scaffold(
        body: FutureBuilder(
            future: tokenDao!.getRefreshToken("ACCESS_TOKEN").first,
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData &&
                  snapshot.data != null) {
                return HomePage();
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    color: Theme.of(context).colorScheme.primary,
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: DialogController.loadingDialog(context: context));
              } else if (snapshot.connectionState == ConnectionState.done &&
                  !snapshot.hasData) {
                return IntroducePage();
              } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData &&
                  snapshot.data == null) {
                return IntroducePage();
              }
              if (StorageController.getCompleteInit() == false) {
                return IntroducePage();
              }
              return IntroducePage();
            })));
  }
}
