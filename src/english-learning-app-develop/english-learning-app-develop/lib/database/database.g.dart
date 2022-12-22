// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TokenDao? _tokenDaoInstance;

  SettingDao? _settingDaoInstance;

  UserProfileDao? _userProfileDaoInstance;

  WordDao? _wordDaoInstance;

  CategoryDao? _categoryDaoInstance;

  LessonDao? _lessonDaoInstance;

  SubCategoryDao? _subCategoryDaoInstance;

  QuizDao? _quizDaoInstance;

  QuizFillCharDao? _quizFillCharDaoInstance;

  QuizFillWordDao? _quizFillWordDaoInstance;

  QuizRightPronouceDao? _quizRightPronouceDaoInstance;

  QuizRightWordDao? _quizRightWordDaoInstance;

  QuizTransArrageDao? _quizTransArrageDaoInstance;

  ViPhraseDao? _viPhraseDaoInstance;

  CategoryUserDao? _categoryUserDaoInstance;

  LessonUserDao? _lessonUserDaoInstance;

  LessonUserScoreDao? _lessonUserScoreDaoInstance;

  UserFavouriteDao? _userFavouriteDaoInstance;

  UserCardDao? _userCardDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TOKEN` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `device_id` TEXT NOT NULL, `token` TEXT NOT NULL, `expiry_date` TEXT NOT NULL, `type` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `SETTING` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `device_id` TEXT NOT NULL, `app_language` TEXT NOT NULL, `theme_mode` TEXT NOT NULL, `notificationPermit` INTEGER NOT NULL, `dayInWeek` TEXT NOT NULL, `notiTime` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `USER` (`first_name` TEXT, `last_name` TEXT, `auth_strategy` TEXT, `email` TEXT, `device_id` TEXT, `google_id` TEXT, `facebook_id` TEXT, `otp_number` TEXT, `isActive` INTEGER, `isSharedData` INTEGER, `isLock` INTEGER, `isActivated` INTEGER, `created_time` TEXT, `id` TEXT, `photo_url` TEXT, `main_auth_strategy` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `WORD` (`id` TEXT, `wordId` TEXT, `word` TEXT, `lexicalCategory` TEXT, `type` TEXT, `ori_lang` TEXT, `tra_lang` TEXT, `definitions` TEXT, `shortDefinitions` TEXT, `examples` TEXT, `phoneticNotation` TEXT, `phoneticSpelling` TEXT, `audioFile` TEXT, `synonyms` TEXT, `phrases` TEXT, `mean` TEXT, `category` TEXT, `level` TEXT, `image` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CATEGORIES` (`id` TEXT, `name` TEXT, `isDeleted` INTEGER, `updated_at` TEXT, `created_at` TEXT, `levelType` TEXT, `image` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `LESSON` (`id` TEXT, `name` TEXT, `subCategory` TEXT, `isDeleted` INTEGER, `updated_at` TEXT, `created_at` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `SUBCATEGORY` (`id` TEXT, `name` TEXT, `category` TEXT, `isDeleted` INTEGER, `updated_at` TEXT, `created_at` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `QUIZ` (`id` TEXT, `quiz_id` TEXT, `quiz_type` TEXT, `isDeleted` INTEGER, `updated_at` TEXT, `created_at` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `QUIZ_FILL_CHAR` (`id` TEXT, `name` TEXT, `type` TEXT, `lessonId` TEXT, `wordId` TEXT, `isDeleted` INTEGER, `updated_at` TEXT, `created_at` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `QUIZ_FILL_WORD` (`id` TEXT, `name` TEXT, `lessonId` TEXT, `type` TEXT, `left_of_word` TEXT, `right_of_word` TEXT, `vi_sentence` TEXT, `wordId` TEXT, `correctChoice` TEXT, `firstChoice` TEXT, `secondChoice` TEXT, `thirdChoice` TEXT, `isDeleted` INTEGER, `updated_at` TEXT, `created_at` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `QUIZ_RIGHT_PRONOUCE` (`id` TEXT, `name` TEXT, `type` TEXT, `lessonId` TEXT, `wordId` TEXT, `wordIdOne` TEXT, `isDeleted` INTEGER, `updated_at` TEXT, `created_at` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `QUIZ_RIGHT_WORD` (`id` TEXT, `name` TEXT, `lessonId` TEXT, `type` TEXT, `wordId` TEXT, `correctChoice` TEXT, `firstChoice` TEXT, `secondChoice` TEXT, `thirdChoice` TEXT, `isDeleted` INTEGER, `updated_at` TEXT, `created_at` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `QUIZ_TRANS_ARRANGE` (`id` TEXT, `name` TEXT, `lessonId` TEXT, `type` TEXT, `wordId` TEXT, `origin_sentence` TEXT, `vi_sentence` TEXT, `isDeleted` INTEGER, `updated_at` TEXT, `created_at` TEXT, `numRightPhrase` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `VI_PHRASE` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `quiz_id` TEXT, `viPhrase` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CATEGORY_USER` (`id` TEXT NOT NULL, `userId` TEXT, `categoryId` TEXT, `progress` INTEGER, `isDeleted` INTEGER, `updated_at` TEXT, `created_at` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `LESSON_USER` (`id` TEXT NOT NULL, `lessonId` TEXT, `userId` TEXT, `isBlock` INTEGER, `isCompleted` INTEGER, `updated_at` TEXT, `created_at` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `LESSON_USER_SCORE` (`id` TEXT NOT NULL, `totalIncorrect` INTEGER, `totalCorrect` INTEGER, `point` INTEGER, `completionTime` TEXT, `completedAt` TEXT, `accuracy` REAL, `userId` TEXT NOT NULL, `lessonId` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `USER_FAVOURITE` (`id` TEXT, `wordId` TEXT, `userId` TEXT, `updated_at` TEXT, `created_at` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `USER_CARD` (`id` TEXT, `wordId` TEXT, `catId` TEXT, `userId` TEXT, `phase` INTEGER, `interval` REAL, `originInterval` REAL, `ease` REAL, `due` REAL, `step` REAL, `isDeleted` INTEGER, `updated_at` TEXT, `created_at` TEXT, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TokenDao get tokenDao {
    return _tokenDaoInstance ??= _$TokenDao(database, changeListener);
  }

  @override
  SettingDao get settingDao {
    return _settingDaoInstance ??= _$SettingDao(database, changeListener);
  }

  @override
  UserProfileDao get userProfileDao {
    return _userProfileDaoInstance ??=
        _$UserProfileDao(database, changeListener);
  }

  @override
  WordDao get wordDao {
    return _wordDaoInstance ??= _$WordDao(database, changeListener);
  }

  @override
  CategoryDao get categoryDao {
    return _categoryDaoInstance ??= _$CategoryDao(database, changeListener);
  }

  @override
  LessonDao get lessonDao {
    return _lessonDaoInstance ??= _$LessonDao(database, changeListener);
  }

  @override
  SubCategoryDao get subCategoryDao {
    return _subCategoryDaoInstance ??=
        _$SubCategoryDao(database, changeListener);
  }

  @override
  QuizDao get quizDao {
    return _quizDaoInstance ??= _$QuizDao(database, changeListener);
  }

  @override
  QuizFillCharDao get quizFillCharDao {
    return _quizFillCharDaoInstance ??=
        _$QuizFillCharDao(database, changeListener);
  }

  @override
  QuizFillWordDao get quizFillWordDao {
    return _quizFillWordDaoInstance ??=
        _$QuizFillWordDao(database, changeListener);
  }

  @override
  QuizRightPronouceDao get quizRightPronouceDao {
    return _quizRightPronouceDaoInstance ??=
        _$QuizRightPronouceDao(database, changeListener);
  }

  @override
  QuizRightWordDao get quizRightWordDao {
    return _quizRightWordDaoInstance ??=
        _$QuizRightWordDao(database, changeListener);
  }

  @override
  QuizTransArrageDao get quizTransArrageDao {
    return _quizTransArrageDaoInstance ??=
        _$QuizTransArrageDao(database, changeListener);
  }

  @override
  ViPhraseDao get viPhraseDao {
    return _viPhraseDaoInstance ??= _$ViPhraseDao(database, changeListener);
  }

  @override
  CategoryUserDao get categoryUserDao {
    return _categoryUserDaoInstance ??=
        _$CategoryUserDao(database, changeListener);
  }

  @override
  LessonUserDao get lessonUserDao {
    return _lessonUserDaoInstance ??= _$LessonUserDao(database, changeListener);
  }

  @override
  LessonUserScoreDao get lessonUserScoreDao {
    return _lessonUserScoreDaoInstance ??=
        _$LessonUserScoreDao(database, changeListener);
  }

  @override
  UserFavouriteDao get userFavouriteDao {
    return _userFavouriteDaoInstance ??=
        _$UserFavouriteDao(database, changeListener);
  }

  @override
  UserCardDao get userCardDao {
    return _userCardDaoInstance ??= _$UserCardDao(database, changeListener);
  }
}

class _$TokenDao extends TokenDao {
  _$TokenDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _tokenDatasetInsertionAdapter = InsertionAdapter(
            database,
            'TOKEN',
            (TokenDataset item) => <String, Object?>{
                  'id': item.id,
                  'device_id': item.deviceId,
                  'token': item.token,
                  'expiry_date': item.expiryDate,
                  'type': item.tokenType
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TokenDataset> _tokenDatasetInsertionAdapter;

  @override
  Stream<TokenDataset?> getRefreshToken(String type) {
    return _queryAdapter.queryStream('SELECT * FROM TOKEN WHERE type = ?1',
        mapper: (Map<String, Object?> row) => TokenDataset(
            id: row['id'] as int?,
            deviceId: row['device_id'] as String,
            token: row['token'] as String,
            expiryDate: row['expiry_date'] as String,
            tokenType: row['type'] as String),
        arguments: [type],
        queryableName: 'TOKEN',
        isView: false);
  }

  @override
  Future<void> deleteRToken(String type) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM TOKEN where type = ?1', arguments: [type]);
  }

  @override
  Future<int> insertToken(TokenDataset token) {
    return _tokenDatasetInsertionAdapter.insertAndReturnId(
        token, OnConflictStrategy.abort);
  }
}

class _$SettingDao extends SettingDao {
  _$SettingDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _settingDatasetInsertionAdapter = InsertionAdapter(
            database,
            'SETTING',
            (SettingDataset item) => <String, Object?>{
                  'id': item.id,
                  'device_id': item.deviceId,
                  'app_language': item.appLanguage,
                  'theme_mode': item.themeMode,
                  'notificationPermit': item.notificationPermit ? 1 : 0,
                  'dayInWeek': item.dayInWeek,
                  'notiTime': item.notiTime
                }),
        _settingDatasetUpdateAdapter = UpdateAdapter(
            database,
            'SETTING',
            ['id'],
            (SettingDataset item) => <String, Object?>{
                  'id': item.id,
                  'device_id': item.deviceId,
                  'app_language': item.appLanguage,
                  'theme_mode': item.themeMode,
                  'notificationPermit': item.notificationPermit ? 1 : 0,
                  'dayInWeek': item.dayInWeek,
                  'notiTime': item.notiTime
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SettingDataset> _settingDatasetInsertionAdapter;

  final UpdateAdapter<SettingDataset> _settingDatasetUpdateAdapter;

  @override
  Future<SettingDataset?> findSetting(String deviceId) async {
    return _queryAdapter.query('SELECT * FROM SETTING WHERE device_id = ?1',
        mapper: (Map<String, Object?> row) => SettingDataset(
            row['app_language'] as String, row['theme_mode'] as String,
            id: row['id'] as int?,
            dayInWeek: row['dayInWeek'] as String,
            notiTime: row['notiTime'] as String,
            notificationPermit: (row['notificationPermit'] as int) != 0,
            deviceId: row['device_id'] as String),
        arguments: [deviceId]);
  }

  @override
  Future<int> insertSetting(SettingDataset settingEntity) {
    return _settingDatasetInsertionAdapter.insertAndReturnId(
        settingEntity, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateSetting(SettingDataset settingEntity) {
    return _settingDatasetUpdateAdapter.updateAndReturnChangedRows(
        settingEntity, OnConflictStrategy.replace);
  }
}

class _$UserProfileDao extends UserProfileDao {
  _$UserProfileDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _userProfileDatasetInsertionAdapter = InsertionAdapter(
            database,
            'USER',
            (UserProfileDataset item) => <String, Object?>{
                  'first_name': item.firstName,
                  'last_name': item.lastName,
                  'auth_strategy': item.authStrategy,
                  'email': item.email,
                  'device_id': item.deviceIdString,
                  'google_id': item.googleId,
                  'facebook_id': item.facebookId,
                  'otp_number': item.otpNumber,
                  'isActive':
                      item.isActive == null ? null : (item.isActive! ? 1 : 0),
                  'isSharedData': item.isSharedData == null
                      ? null
                      : (item.isSharedData! ? 1 : 0),
                  'isLock': item.isLock == null ? null : (item.isLock! ? 1 : 0),
                  'isActivated': item.isActivated == null
                      ? null
                      : (item.isActivated! ? 1 : 0),
                  'created_time': item.createdTime,
                  'id': item.id,
                  'photo_url': item.photoUrl,
                  'main_auth_strategy': item.mainAuthStrategy
                }),
        _userProfileDatasetUpdateAdapter = UpdateAdapter(
            database,
            'USER',
            ['id'],
            (UserProfileDataset item) => <String, Object?>{
                  'first_name': item.firstName,
                  'last_name': item.lastName,
                  'auth_strategy': item.authStrategy,
                  'email': item.email,
                  'device_id': item.deviceIdString,
                  'google_id': item.googleId,
                  'facebook_id': item.facebookId,
                  'otp_number': item.otpNumber,
                  'isActive':
                      item.isActive == null ? null : (item.isActive! ? 1 : 0),
                  'isSharedData': item.isSharedData == null
                      ? null
                      : (item.isSharedData! ? 1 : 0),
                  'isLock': item.isLock == null ? null : (item.isLock! ? 1 : 0),
                  'isActivated': item.isActivated == null
                      ? null
                      : (item.isActivated! ? 1 : 0),
                  'created_time': item.createdTime,
                  'id': item.id,
                  'photo_url': item.photoUrl,
                  'main_auth_strategy': item.mainAuthStrategy
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserProfileDataset>
      _userProfileDatasetInsertionAdapter;

  final UpdateAdapter<UserProfileDataset> _userProfileDatasetUpdateAdapter;

  @override
  Future<UserProfileDataset?> findUserProfile(String id) async {
    return _queryAdapter.query('SELECT * FROM USER WHERE id = ?1',
        mapper: (Map<String, Object?> row) => UserProfileDataset(
            firstName: row['first_name'] as String?,
            lastName: row['last_name'] as String?,
            authStrategy: row['auth_strategy'] as String?,
            createdTime: row['created_time'] as String?,
            email: row['email'] as String?,
            facebookId: row['facebook_id'] as String?,
            googleId: row['google_id'] as String?,
            isActivated: row['isActivated'] == null
                ? null
                : (row['isActivated'] as int) != 0,
            isActive:
                row['isActive'] == null ? null : (row['isActive'] as int) != 0,
            isSharedData: row['isSharedData'] == null
                ? null
                : (row['isSharedData'] as int) != 0,
            isLock: row['isLock'] == null ? null : (row['isLock'] as int) != 0,
            otpNumber: row['otp_number'] as String?,
            photoUrl: row['photo_url'] as String?,
            mainAuthStrategy: row['main_auth_strategy'] as String?,
            id: row['id'] as String?),
        arguments: [id]);
  }

  @override
  Future<void> deleteUserProfile(String userId) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM USER where id = ?1', arguments: [userId]);
  }

  @override
  Future<int> insertUserProfile(UserProfileDataset userProfileDataset) {
    return _userProfileDatasetInsertionAdapter.insertAndReturnId(
        userProfileDataset, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateUserProfile(UserProfileDataset userProfileDataset) {
    return _userProfileDatasetUpdateAdapter.updateAndReturnChangedRows(
        userProfileDataset, OnConflictStrategy.replace);
  }
}

class _$WordDao extends WordDao {
  _$WordDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _wordDatasetInsertionAdapter = InsertionAdapter(
            database,
            'WORD',
            (WordDataset item) => <String, Object?>{
                  'id': item.id,
                  'wordId': item.word_id,
                  'word': item.word,
                  'lexicalCategory': item.lexicalCategory,
                  'type': item.type,
                  'ori_lang': item.ori_lang,
                  'tra_lang': item.tra_lang,
                  'definitions': item.definitions,
                  'shortDefinitions': item.shortDefinitions,
                  'examples': item.examples,
                  'phoneticNotation': item.phoneticNotation,
                  'phoneticSpelling': item.phoneticSpelling,
                  'audioFile': item.audioFile,
                  'synonyms': item.synonyms,
                  'phrases': item.phrases,
                  'mean': item.mean,
                  'category': item.category,
                  'level': item.level,
                  'image': item.image
                }),
        _wordDatasetUpdateAdapter = UpdateAdapter(
            database,
            'WORD',
            ['id'],
            (WordDataset item) => <String, Object?>{
                  'id': item.id,
                  'wordId': item.word_id,
                  'word': item.word,
                  'lexicalCategory': item.lexicalCategory,
                  'type': item.type,
                  'ori_lang': item.ori_lang,
                  'tra_lang': item.tra_lang,
                  'definitions': item.definitions,
                  'shortDefinitions': item.shortDefinitions,
                  'examples': item.examples,
                  'phoneticNotation': item.phoneticNotation,
                  'phoneticSpelling': item.phoneticSpelling,
                  'audioFile': item.audioFile,
                  'synonyms': item.synonyms,
                  'phrases': item.phrases,
                  'mean': item.mean,
                  'category': item.category,
                  'level': item.level,
                  'image': item.image
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<WordDataset> _wordDatasetInsertionAdapter;

  final UpdateAdapter<WordDataset> _wordDatasetUpdateAdapter;

  @override
  Future<WordDataset?> findWordById(String wordId) async {
    return _queryAdapter.query('SELECT * FROM WORD WHERE id = ?1',
        mapper: (Map<String, Object?> row) => WordDataset(
            row['id'] as String?,
            row['wordId'] as String?,
            row['word'] as String?,
            row['lexicalCategory'] as String?,
            row['type'] as String?,
            row['ori_lang'] as String?,
            row['tra_lang'] as String?,
            row['definitions'] as String?,
            row['shortDefinitions'] as String?,
            row['examples'] as String?,
            row['phoneticNotation'] as String?,
            row['phoneticSpelling'] as String?,
            row['audioFile'] as String?,
            row['synonyms'] as String?,
            row['phrases'] as String?,
            row['mean'] as String?,
            row['category'] as String?,
            row['level'] as String?),
        arguments: [wordId]);
  }

  @override
  Future<List<WordDataset?>?> getListWordById(List<String> listId) async {
    const offset = 1;
    final _sqliteVariablesForListId =
        Iterable<String>.generate(listId.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'SELECT * FROM WORD WHERE id IN (' + _sqliteVariablesForListId + ')',
        mapper: (Map<String, Object?> row) => WordDataset(
            row['id'] as String?,
            row['wordId'] as String?,
            row['word'] as String?,
            row['lexicalCategory'] as String?,
            row['type'] as String?,
            row['ori_lang'] as String?,
            row['tra_lang'] as String?,
            row['definitions'] as String?,
            row['shortDefinitions'] as String?,
            row['examples'] as String?,
            row['phoneticNotation'] as String?,
            row['phoneticSpelling'] as String?,
            row['audioFile'] as String?,
            row['synonyms'] as String?,
            row['phrases'] as String?,
            row['mean'] as String?,
            row['category'] as String?,
            row['level'] as String?),
        arguments: [...listId]);
  }

  @override
  Future<List<WordDataset>> searchWordByText(String search) async {
    return _queryAdapter.queryList(
        'SELECT * FROM WORD WHERE word LIKE  ?1 || \'%\'',
        mapper: (Map<String, Object?> row) => WordDataset(
            row['id'] as String?,
            row['wordId'] as String?,
            row['word'] as String?,
            row['lexicalCategory'] as String?,
            row['type'] as String?,
            row['ori_lang'] as String?,
            row['tra_lang'] as String?,
            row['definitions'] as String?,
            row['shortDefinitions'] as String?,
            row['examples'] as String?,
            row['phoneticNotation'] as String?,
            row['phoneticSpelling'] as String?,
            row['audioFile'] as String?,
            row['synonyms'] as String?,
            row['phrases'] as String?,
            row['mean'] as String?,
            row['category'] as String?,
            row['level'] as String?),
        arguments: [search]);
  }

  @override
  Future<int?> deleteAllWord() async {
    await _queryAdapter.queryNoReturn('DELETE FROM WORD');
  }

  @override
  Future<List<WordDataset>> getWordByLessonId(String lessonId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM WORD where id IN ( SELECT distinct wordId from ( \t\tSELECT wordId FROM QUIZ_FILL_CHAR where lessonId = ?1 \t\tUNION ALL \t\tSELECT wordId FROM QUIZ_FILL_WORD where lessonId = ?1 \t\tUNION ALL \t\tSELECT wordId FROM QUIZ_RIGHT_WORD WHERE lessonId = ?1 \t\tUNION ALL \t\tSELECT wordId FROM QUIZ_RIGHT_PRONOUCE WHERE lessonId = ?1 \t\tUNION ALL \t\tSELECT wordId FROM QUIZ_TRANS_ARRANGE WHERE lessonId = ?1   ))',
        mapper: (Map<String, Object?> row) => WordDataset(row['id'] as String?, row['wordId'] as String?, row['word'] as String?, row['lexicalCategory'] as String?, row['type'] as String?, row['ori_lang'] as String?, row['tra_lang'] as String?, row['definitions'] as String?, row['shortDefinitions'] as String?, row['examples'] as String?, row['phoneticNotation'] as String?, row['phoneticSpelling'] as String?, row['audioFile'] as String?, row['synonyms'] as String?, row['phrases'] as String?, row['mean'] as String?, row['category'] as String?, row['level'] as String?),
        arguments: [lessonId]);
  }

  @override
  Future<List<int>> insertWord(List<WordDataset> words) {
    return _wordDatasetInsertionAdapter.insertListAndReturnIds(
        words, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateWord(WordDataset word) {
    return _wordDatasetUpdateAdapter.updateAndReturnChangedRows(
        word, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertListWordTransaction(List<WordDataset> words) async {
    if (database is sqflite.Transaction) {
      await super.insertListWordTransaction(words);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.wordDao.insertListWordTransaction(words);
      });
    }
  }
}

class _$CategoryDao extends CategoryDao {
  _$CategoryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _categoryDatasetInsertionAdapter = InsertionAdapter(
            database,
            'CATEGORIES',
            (CategoryDataset item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'isDeleted':
                      item.isDeleted == null ? null : (item.isDeleted! ? 1 : 0),
                  'updated_at': item.updated_at,
                  'created_at': item.created_at,
                  'levelType': item.levelType,
                  'image': item.image
                }),
        _categoryDatasetUpdateAdapter = UpdateAdapter(
            database,
            'CATEGORIES',
            ['id'],
            (CategoryDataset item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'isDeleted':
                      item.isDeleted == null ? null : (item.isDeleted! ? 1 : 0),
                  'updated_at': item.updated_at,
                  'created_at': item.created_at,
                  'levelType': item.levelType,
                  'image': item.image
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CategoryDataset> _categoryDatasetInsertionAdapter;

  final UpdateAdapter<CategoryDataset> _categoryDatasetUpdateAdapter;

  @override
  Future<CategoryDataset?> findCategoryById(String categoryId) async {
    return _queryAdapter.query('SELECT * FROM CATEGORIES WHERE id = ?1',
        mapper: (Map<String, Object?> row) => CategoryDataset(
            id: row['id'] as String?,
            name: row['name'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            updated_at: row['updated_at'] as String?,
            created_at: row['created_at'] as String?,
            image: row['image'] as String?,
            levelType: row['levelType'] as String?),
        arguments: [categoryId]);
  }

  @override
  Future<List<CategoryDataset>> getAllCategory() async {
    return _queryAdapter.queryList('SELECT * FROM CATEGORIES',
        mapper: (Map<String, Object?> row) => CategoryDataset(
            id: row['id'] as String?,
            name: row['name'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            updated_at: row['updated_at'] as String?,
            created_at: row['created_at'] as String?,
            image: row['image'] as String?,
            levelType: row['levelType'] as String?));
  }

  @override
  Future<int?> deleteAllCategory() async {
    await _queryAdapter.queryNoReturn('DELETE FROM CATEGORIES');
  }

  @override
  Future<void> insertCategory(List<CategoryDataset> categories) async {
    await _categoryDatasetInsertionAdapter.insertList(
        categories, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateCategory(CategoryDataset categoryDataset) {
    return _categoryDatasetUpdateAdapter.updateAndReturnChangedRows(
        categoryDataset, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertListCategoryTransaction(
      List<CategoryDataset> categories) async {
    if (database is sqflite.Transaction) {
      await super.insertListCategoryTransaction(categories);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.categoryDao
            .insertListCategoryTransaction(categories);
      });
    }
  }
}

class _$LessonDao extends LessonDao {
  _$LessonDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _lessonDatasetInsertionAdapter = InsertionAdapter(
            database,
            'LESSON',
            (LessonDataset item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'subCategory': item.subCategory,
                  'isDeleted':
                      item.isDeleted == null ? null : (item.isDeleted! ? 1 : 0),
                  'updated_at': item.updated_at,
                  'created_at': item.created_at
                }),
        _lessonDatasetUpdateAdapter = UpdateAdapter(
            database,
            'LESSON',
            ['id'],
            (LessonDataset item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'subCategory': item.subCategory,
                  'isDeleted':
                      item.isDeleted == null ? null : (item.isDeleted! ? 1 : 0),
                  'updated_at': item.updated_at,
                  'created_at': item.created_at
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<LessonDataset> _lessonDatasetInsertionAdapter;

  final UpdateAdapter<LessonDataset> _lessonDatasetUpdateAdapter;

  @override
  Future<LessonDataset?> findLessonByLessonId(String lessonId) async {
    return _queryAdapter.query('SELECT * FROM LESSON WHERE id = ?1',
        mapper: (Map<String, Object?> row) => LessonDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            name: row['name'] as String?,
            updated_at: row['updated_at'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            subCategory: row['subCategory'] as String?),
        arguments: [lessonId]);
  }

  @override
  Future<List<LessonDataset>> getAllCategory() async {
    return _queryAdapter.queryList('SELECT * FROM LESSON',
        mapper: (Map<String, Object?> row) => LessonDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            name: row['name'] as String?,
            updated_at: row['updated_at'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            subCategory: row['subCategory'] as String?));
  }

  @override
  Future<int?> deleteAllCategory() async {
    await _queryAdapter.queryNoReturn('DELETE FROM LESSON');
  }

  @override
  Future<List<LessonDataset?>> findLessonBysubCategory(
      String subCategory) async {
    return _queryAdapter.queryList(
        'SELECT * FROM LESSON WHERE subCategory = ?1',
        mapper: (Map<String, Object?> row) => LessonDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            name: row['name'] as String?,
            updated_at: row['updated_at'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            subCategory: row['subCategory'] as String?),
        arguments: [subCategory]);
  }

  @override
  Future<void> insertLesson(List<LessonDataset> categories) async {
    await _lessonDatasetInsertionAdapter.insertList(
        categories, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateLesson(LessonDataset word) {
    return _lessonDatasetUpdateAdapter.updateAndReturnChangedRows(
        word, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertListCategoryTransaction(
      List<LessonDataset> lessonList) async {
    if (database is sqflite.Transaction) {
      await super.insertListCategoryTransaction(lessonList);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.lessonDao
            .insertListCategoryTransaction(lessonList);
      });
    }
  }
}

class _$SubCategoryDao extends SubCategoryDao {
  _$SubCategoryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _subCategoryDatasetInsertionAdapter = InsertionAdapter(
            database,
            'SUBCATEGORY',
            (SubCategoryDataset item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'category': item.category,
                  'isDeleted':
                      item.isDeleted == null ? null : (item.isDeleted! ? 1 : 0),
                  'updated_at': item.updated_at,
                  'created_at': item.created_at
                }),
        _subCategoryDatasetUpdateAdapter = UpdateAdapter(
            database,
            'SUBCATEGORY',
            ['id'],
            (SubCategoryDataset item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'category': item.category,
                  'isDeleted':
                      item.isDeleted == null ? null : (item.isDeleted! ? 1 : 0),
                  'updated_at': item.updated_at,
                  'created_at': item.created_at
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SubCategoryDataset>
      _subCategoryDatasetInsertionAdapter;

  final UpdateAdapter<SubCategoryDataset> _subCategoryDatasetUpdateAdapter;

  @override
  Future<SubCategoryDataset?> findsubCategoryBysubCategoryId(
      String lessonId) async {
    return _queryAdapter.query('SELECT * FROM SUBCATEGORY WHERE id = ?1',
        mapper: (Map<String, Object?> row) => SubCategoryDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            name: row['name'] as String?,
            updated_at: row['updated_at'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            category: row['category'] as String?),
        arguments: [lessonId]);
  }

  @override
  Future<List<SubCategoryDataset>> getAllCategory() async {
    return _queryAdapter.queryList('SELECT * FROM SUBCATEGORY',
        mapper: (Map<String, Object?> row) => SubCategoryDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            name: row['name'] as String?,
            updated_at: row['updated_at'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            category: row['category'] as String?));
  }

  @override
  Future<int?> deleteAllCategory() async {
    await _queryAdapter.queryNoReturn('DELETE FROM SUBCATEGORY');
  }

  @override
  Future<List<SubCategoryDataset?>> findsubCategoryByCategoryId(
      String categoryId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM SUBCATEGORY WHERE category = ?1',
        mapper: (Map<String, Object?> row) => SubCategoryDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            name: row['name'] as String?,
            updated_at: row['updated_at'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            category: row['category'] as String?),
        arguments: [categoryId]);
  }

  @override
  Future<void> insertsubCategory(
      List<SubCategoryDataset> subCategoryList) async {
    await _subCategoryDatasetInsertionAdapter.insertList(
        subCategoryList, OnConflictStrategy.replace);
  }

  @override
  Future<int> updatesubCategory(SubCategoryDataset subCategoryDataset) {
    return _subCategoryDatasetUpdateAdapter.updateAndReturnChangedRows(
        subCategoryDataset, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertListCategoryTransaction(
      List<SubCategoryDataset> subCategoryList) async {
    if (database is sqflite.Transaction) {
      await super.insertListCategoryTransaction(subCategoryList);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.subCategoryDao
            .insertListCategoryTransaction(subCategoryList);
      });
    }
  }
}

class _$QuizDao extends QuizDao {
  _$QuizDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _quizDatasetInsertionAdapter = InsertionAdapter(
            database,
            'QUIZ',
            (QuizDataset item) => <String, Object?>{
                  'id': item.id,
                  'quiz_id': item.quiz_id,
                  'quiz_type': item.quiz_type,
                  'isDeleted':
                      item.isDeleted == null ? null : (item.isDeleted! ? 1 : 0),
                  'updated_at': item.updated_at,
                  'created_at': item.created_at
                }),
        _quizDatasetUpdateAdapter = UpdateAdapter(
            database,
            'QUIZ',
            ['id'],
            (QuizDataset item) => <String, Object?>{
                  'id': item.id,
                  'quiz_id': item.quiz_id,
                  'quiz_type': item.quiz_type,
                  'isDeleted':
                      item.isDeleted == null ? null : (item.isDeleted! ? 1 : 0),
                  'updated_at': item.updated_at,
                  'created_at': item.created_at
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<QuizDataset> _quizDatasetInsertionAdapter;

  final UpdateAdapter<QuizDataset> _quizDatasetUpdateAdapter;

  @override
  Future<QuizDataset?> findQuizByQuizId(String quizId) async {
    return _queryAdapter.query('SELECT * FROM QUIZ WHERE quiz_id = ?1',
        mapper: (Map<String, Object?> row) => QuizDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            quiz_id: row['quiz_id'] as String?,
            updated_at: row['updated_at'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            quiz_type: row['quiz_type'] as String?),
        arguments: [quizId]);
  }

  @override
  Future<List<QuizDataset>> getAllQuiz() async {
    return _queryAdapter.queryList('SELECT * FROM QUIZ',
        mapper: (Map<String, Object?> row) => QuizDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            quiz_id: row['quiz_id'] as String?,
            updated_at: row['updated_at'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            quiz_type: row['quiz_type'] as String?));
  }

  @override
  Future<int?> deleteAllQuiz() async {
    await _queryAdapter.queryNoReturn('DELETE FROM QUIZ');
  }

  @override
  Future<List<QuizDataset?>> findQuizByQuizType(String quizType) async {
    return _queryAdapter.queryList('SELECT * FROM QUIZ WHERE quiz_type = ?1',
        mapper: (Map<String, Object?> row) => QuizDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            quiz_id: row['quiz_id'] as String?,
            updated_at: row['updated_at'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            quiz_type: row['quiz_type'] as String?),
        arguments: [quizType]);
  }

  @override
  Future<void> insertQuiz(List<QuizDataset> subCategoryList) async {
    await _quizDatasetInsertionAdapter.insertList(
        subCategoryList, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateQuiz(QuizDataset quizDataset) {
    return _quizDatasetUpdateAdapter.updateAndReturnChangedRows(
        quizDataset, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertListQuizTransaction(List<QuizDataset> quizList) async {
    if (database is sqflite.Transaction) {
      await super.insertListQuizTransaction(quizList);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.quizDao.insertListQuizTransaction(quizList);
      });
    }
  }
}

class _$QuizFillCharDao extends QuizFillCharDao {
  _$QuizFillCharDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _quizFillCharDatasetInsertionAdapter = InsertionAdapter(
            database,
            'QUIZ_FILL_CHAR',
            (QuizFillCharDataset item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'type': item.type,
                  'lessonId': item.lessonId,
                  'wordId': item.wordId,
                  'isDeleted':
                      item.isDeleted == null ? null : (item.isDeleted! ? 1 : 0),
                  'updated_at': item.updated_at,
                  'created_at': item.created_at
                }),
        _quizFillCharDatasetUpdateAdapter = UpdateAdapter(
            database,
            'QUIZ_FILL_CHAR',
            ['id'],
            (QuizFillCharDataset item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'type': item.type,
                  'lessonId': item.lessonId,
                  'wordId': item.wordId,
                  'isDeleted':
                      item.isDeleted == null ? null : (item.isDeleted! ? 1 : 0),
                  'updated_at': item.updated_at,
                  'created_at': item.created_at
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<QuizFillCharDataset>
      _quizFillCharDatasetInsertionAdapter;

  final UpdateAdapter<QuizFillCharDataset> _quizFillCharDatasetUpdateAdapter;

  @override
  Future<QuizFillCharDataset?> findQuizByQuizId(String quizId) async {
    return _queryAdapter.query('SELECT * FROM QUIZ_FILL_CHAR WHERE id = ?1',
        mapper: (Map<String, Object?> row) => QuizFillCharDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            lessonId: row['lessonId'] as String?,
            wordId: row['wordId'] as String?,
            type: row['type'] as String?,
            updated_at: row['updated_at'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            name: row['name'] as String?),
        arguments: [quizId]);
  }

  @override
  Future<int?> deleteAllQuiz() async {
    await _queryAdapter.queryNoReturn('DELETE FROM QUIZ_FILL_CHAR');
  }

  @override
  Future<List<QuizFillCharDataset?>> findQuizByLessonId(String lessonId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM QUIZ_FILL_CHAR WHERE lessonId = ?1',
        mapper: (Map<String, Object?> row) => QuizFillCharDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            lessonId: row['lessonId'] as String?,
            wordId: row['wordId'] as String?,
            type: row['type'] as String?,
            updated_at: row['updated_at'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            name: row['name'] as String?),
        arguments: [lessonId]);
  }

  @override
  Future<List<QuizFillCharDataset>> findQuizByWordId(String wordId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM QUIZ_FILL_CHAR WHERE wordId =?1',
        mapper: (Map<String, Object?> row) => QuizFillCharDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            lessonId: row['lessonId'] as String?,
            wordId: row['wordId'] as String?,
            type: row['type'] as String?,
            updated_at: row['updated_at'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            name: row['name'] as String?),
        arguments: [wordId]);
  }

  @override
  Future<void> insertQuiz(List<QuizFillCharDataset> quizList) async {
    await _quizFillCharDatasetInsertionAdapter.insertList(
        quizList, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateQuiz(QuizFillCharDataset quizDataset) {
    return _quizFillCharDatasetUpdateAdapter.updateAndReturnChangedRows(
        quizDataset, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertListQuizTransaction(
      List<QuizFillCharDataset> quizList) async {
    if (database is sqflite.Transaction) {
      await super.insertListQuizTransaction(quizList);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.quizFillCharDao
            .insertListQuizTransaction(quizList);
      });
    }
  }
}

class _$QuizFillWordDao extends QuizFillWordDao {
  _$QuizFillWordDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _quizFillWordDatasetInsertionAdapter = InsertionAdapter(
            database,
            'QUIZ_FILL_WORD',
            (QuizFillWordDataset item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'lessonId': item.lessonId,
                  'type': item.type,
                  'left_of_word': item.leftOfWord,
                  'right_of_word': item.rightOfWord,
                  'vi_sentence': item.viSentence,
                  'wordId': item.wordId,
                  'correctChoice': item.correctChoice,
                  'firstChoice': item.firstChoice,
                  'secondChoice': item.secondChoice,
                  'thirdChoice': item.thirdChoice,
                  'isDeleted':
                      item.isDeleted == null ? null : (item.isDeleted! ? 1 : 0),
                  'updated_at': item.updated_at,
                  'created_at': item.created_at
                }),
        _quizFillWordDatasetUpdateAdapter = UpdateAdapter(
            database,
            'QUIZ_FILL_WORD',
            ['id'],
            (QuizFillWordDataset item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'lessonId': item.lessonId,
                  'type': item.type,
                  'left_of_word': item.leftOfWord,
                  'right_of_word': item.rightOfWord,
                  'vi_sentence': item.viSentence,
                  'wordId': item.wordId,
                  'correctChoice': item.correctChoice,
                  'firstChoice': item.firstChoice,
                  'secondChoice': item.secondChoice,
                  'thirdChoice': item.thirdChoice,
                  'isDeleted':
                      item.isDeleted == null ? null : (item.isDeleted! ? 1 : 0),
                  'updated_at': item.updated_at,
                  'created_at': item.created_at
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<QuizFillWordDataset>
      _quizFillWordDatasetInsertionAdapter;

  final UpdateAdapter<QuizFillWordDataset> _quizFillWordDatasetUpdateAdapter;

  @override
  Future<QuizFillWordDataset?> findQuizByQuizId(String quizId) async {
    return _queryAdapter.query('SELECT * FROM QUIZ_FILL_WORD WHERE id = ?1',
        mapper: (Map<String, Object?> row) => QuizFillWordDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            lessonId: row['lessonId'] as String?,
            wordId: row['wordId'] as String?,
            type: row['type'] as String?,
            updated_at: row['updated_at'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            correctChoice: row['correctChoice'] as String?,
            firstChoice: row['firstChoice'] as String?,
            leftOfWord: row['left_of_word'] as String?,
            name: row['name'] as String?,
            rightOfWord: row['right_of_word'] as String?,
            secondChoice: row['secondChoice'] as String?,
            thirdChoice: row['thirdChoice'] as String?,
            viSentence: row['vi_sentence'] as String?),
        arguments: [quizId]);
  }

  @override
  Future<int?> deleteAllQuiz() async {
    await _queryAdapter.queryNoReturn('DELETE FROM QUIZ_FILL_WORD');
  }

  @override
  Future<List<QuizFillWordDataset?>> findQuizByLessonId(String lessonId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM QUIZ_FILL_WORD WHERE lessonId = ?1',
        mapper: (Map<String, Object?> row) => QuizFillWordDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            lessonId: row['lessonId'] as String?,
            wordId: row['wordId'] as String?,
            type: row['type'] as String?,
            updated_at: row['updated_at'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            correctChoice: row['correctChoice'] as String?,
            firstChoice: row['firstChoice'] as String?,
            leftOfWord: row['left_of_word'] as String?,
            name: row['name'] as String?,
            rightOfWord: row['right_of_word'] as String?,
            secondChoice: row['secondChoice'] as String?,
            thirdChoice: row['thirdChoice'] as String?,
            viSentence: row['vi_sentence'] as String?),
        arguments: [lessonId]);
  }

  @override
  Future<List<QuizFillWordDataset>> findQuizByWordId(String wordId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM QUIZ_FILL_WORD WHERE wordId =?1',
        mapper: (Map<String, Object?> row) => QuizFillWordDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            lessonId: row['lessonId'] as String?,
            wordId: row['wordId'] as String?,
            type: row['type'] as String?,
            updated_at: row['updated_at'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            correctChoice: row['correctChoice'] as String?,
            firstChoice: row['firstChoice'] as String?,
            leftOfWord: row['left_of_word'] as String?,
            name: row['name'] as String?,
            rightOfWord: row['right_of_word'] as String?,
            secondChoice: row['secondChoice'] as String?,
            thirdChoice: row['thirdChoice'] as String?,
            viSentence: row['vi_sentence'] as String?),
        arguments: [wordId]);
  }

  @override
  Future<void> insertQuiz(List<QuizFillWordDataset> quizList) async {
    await _quizFillWordDatasetInsertionAdapter.insertList(
        quizList, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateQuiz(QuizFillWordDataset quizDataset) {
    return _quizFillWordDatasetUpdateAdapter.updateAndReturnChangedRows(
        quizDataset, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertListQuizTransaction(
      List<QuizFillWordDataset> quizList) async {
    if (database is sqflite.Transaction) {
      await super.insertListQuizTransaction(quizList);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.quizFillWordDao
            .insertListQuizTransaction(quizList);
      });
    }
  }
}

class _$QuizRightPronouceDao extends QuizRightPronouceDao {
  _$QuizRightPronouceDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _quizRightPronouceDatasetInsertionAdapter = InsertionAdapter(
            database,
            'QUIZ_RIGHT_PRONOUCE',
            (QuizRightPronouceDataset item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'type': item.type,
                  'lessonId': item.lessonId,
                  'wordId': item.wordId,
                  'wordIdOne': item.wordIdOne,
                  'isDeleted':
                      item.isDeleted == null ? null : (item.isDeleted! ? 1 : 0),
                  'updated_at': item.updated_at,
                  'created_at': item.created_at
                }),
        _quizRightPronouceDatasetUpdateAdapter = UpdateAdapter(
            database,
            'QUIZ_RIGHT_PRONOUCE',
            ['id'],
            (QuizRightPronouceDataset item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'type': item.type,
                  'lessonId': item.lessonId,
                  'wordId': item.wordId,
                  'wordIdOne': item.wordIdOne,
                  'isDeleted':
                      item.isDeleted == null ? null : (item.isDeleted! ? 1 : 0),
                  'updated_at': item.updated_at,
                  'created_at': item.created_at
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<QuizRightPronouceDataset>
      _quizRightPronouceDatasetInsertionAdapter;

  final UpdateAdapter<QuizRightPronouceDataset>
      _quizRightPronouceDatasetUpdateAdapter;

  @override
  Future<QuizRightPronouceDataset?> findQuizByQuizId(String quizId) async {
    return _queryAdapter.query(
        'SELECT * FROM QUIZ_RIGHT_PRONOUCE WHERE id = ?1',
        mapper: (Map<String, Object?> row) => QuizRightPronouceDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            lessonId: row['lessonId'] as String?,
            wordId: row['wordId'] as String?,
            type: row['type'] as String?,
            updated_at: row['updated_at'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            name: row['name'] as String?,
            wordIdOne: row['wordIdOne'] as String?),
        arguments: [quizId]);
  }

  @override
  Future<int?> deleteAllQuiz() async {
    await _queryAdapter.queryNoReturn('DELETE FROM QUIZ_RIGHT_PRONOUCE');
  }

  @override
  Future<List<QuizRightPronouceDataset?>> findQuizByLessonId(
      String lessonId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM QUIZ_RIGHT_PRONOUCE WHERE lessonId = ?1',
        mapper: (Map<String, Object?> row) => QuizRightPronouceDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            lessonId: row['lessonId'] as String?,
            wordId: row['wordId'] as String?,
            type: row['type'] as String?,
            updated_at: row['updated_at'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            name: row['name'] as String?,
            wordIdOne: row['wordIdOne'] as String?),
        arguments: [lessonId]);
  }

  @override
  Future<List<QuizRightPronouceDataset>> findQuizByWordId(String wordId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM QUIZ_RIGHT_PRONOUCE WHERE wordId =?1',
        mapper: (Map<String, Object?> row) => QuizRightPronouceDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            lessonId: row['lessonId'] as String?,
            wordId: row['wordId'] as String?,
            type: row['type'] as String?,
            updated_at: row['updated_at'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            name: row['name'] as String?,
            wordIdOne: row['wordIdOne'] as String?),
        arguments: [wordId]);
  }

  @override
  Future<void> insertQuiz(List<QuizRightPronouceDataset> quizList) async {
    await _quizRightPronouceDatasetInsertionAdapter.insertList(
        quizList, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateQuiz(QuizRightPronouceDataset quizDataset) {
    return _quizRightPronouceDatasetUpdateAdapter.updateAndReturnChangedRows(
        quizDataset, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertListQuizTransaction(
      List<QuizRightPronouceDataset> quizList) async {
    if (database is sqflite.Transaction) {
      await super.insertListQuizTransaction(quizList);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.quizRightPronouceDao
            .insertListQuizTransaction(quizList);
      });
    }
  }
}

class _$QuizRightWordDao extends QuizRightWordDao {
  _$QuizRightWordDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _quizRightWordDatasetInsertionAdapter = InsertionAdapter(
            database,
            'QUIZ_RIGHT_WORD',
            (QuizRightWordDataset item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'lessonId': item.lessonId,
                  'type': item.type,
                  'wordId': item.wordId,
                  'correctChoice': item.correctChoice,
                  'firstChoice': item.firstChoice,
                  'secondChoice': item.secondChoice,
                  'thirdChoice': item.thirdChoice,
                  'isDeleted':
                      item.isDeleted == null ? null : (item.isDeleted! ? 1 : 0),
                  'updated_at': item.updated_at,
                  'created_at': item.created_at
                }),
        _quizRightWordDatasetUpdateAdapter = UpdateAdapter(
            database,
            'QUIZ_RIGHT_WORD',
            ['id'],
            (QuizRightWordDataset item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'lessonId': item.lessonId,
                  'type': item.type,
                  'wordId': item.wordId,
                  'correctChoice': item.correctChoice,
                  'firstChoice': item.firstChoice,
                  'secondChoice': item.secondChoice,
                  'thirdChoice': item.thirdChoice,
                  'isDeleted':
                      item.isDeleted == null ? null : (item.isDeleted! ? 1 : 0),
                  'updated_at': item.updated_at,
                  'created_at': item.created_at
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<QuizRightWordDataset>
      _quizRightWordDatasetInsertionAdapter;

  final UpdateAdapter<QuizRightWordDataset> _quizRightWordDatasetUpdateAdapter;

  @override
  Future<QuizRightWordDataset?> findQuizByQuizId(String quizId) async {
    return _queryAdapter.query('SELECT * FROM QUIZ_RIGHT_WORD WHERE id = ?1',
        mapper: (Map<String, Object?> row) => QuizRightWordDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            lessonId: row['lessonId'] as String?,
            wordId: row['wordId'] as String?,
            type: row['type'] as String?,
            updated_at: row['updated_at'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            correctChoice: row['correctChoice'] as String?,
            firstChoice: row['firstChoice'] as String?,
            name: row['name'] as String?,
            secondChoice: row['secondChoice'] as String?,
            thirdChoice: row['thirdChoice'] as String?),
        arguments: [quizId]);
  }

  @override
  Future<int?> deleteAllQuiz() async {
    await _queryAdapter.queryNoReturn('DELETE FROM QUIZ_RIGHT_WORD');
  }

  @override
  Future<List<QuizRightWordDataset?>> findQuizByLessonId(
      String lessonId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM QUIZ_RIGHT_WORD WHERE lessonId = ?1',
        mapper: (Map<String, Object?> row) => QuizRightWordDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            lessonId: row['lessonId'] as String?,
            wordId: row['wordId'] as String?,
            type: row['type'] as String?,
            updated_at: row['updated_at'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            correctChoice: row['correctChoice'] as String?,
            firstChoice: row['firstChoice'] as String?,
            name: row['name'] as String?,
            secondChoice: row['secondChoice'] as String?,
            thirdChoice: row['thirdChoice'] as String?),
        arguments: [lessonId]);
  }

  @override
  Future<List<QuizRightWordDataset>> findQuizByWordId(String wordId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM QUIZ_RIGHT_WORD WHERE wordId =?1',
        mapper: (Map<String, Object?> row) => QuizRightWordDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            lessonId: row['lessonId'] as String?,
            wordId: row['wordId'] as String?,
            type: row['type'] as String?,
            updated_at: row['updated_at'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            correctChoice: row['correctChoice'] as String?,
            firstChoice: row['firstChoice'] as String?,
            name: row['name'] as String?,
            secondChoice: row['secondChoice'] as String?,
            thirdChoice: row['thirdChoice'] as String?),
        arguments: [wordId]);
  }

  @override
  Future<List<QuizRightWordDataset>> findQuizByWordIdForPracticePage(
      String wordId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM QUIZ_RIGHT_WORD WHERE wordId =?1 and name LIKE \"%FLASHCARD%\"',
        mapper: (Map<String, Object?> row) => QuizRightWordDataset(id: row['id'] as String?, created_at: row['created_at'] as String?, lessonId: row['lessonId'] as String?, wordId: row['wordId'] as String?, type: row['type'] as String?, updated_at: row['updated_at'] as String?, isDeleted: row['isDeleted'] == null ? null : (row['isDeleted'] as int) != 0, correctChoice: row['correctChoice'] as String?, firstChoice: row['firstChoice'] as String?, name: row['name'] as String?, secondChoice: row['secondChoice'] as String?, thirdChoice: row['thirdChoice'] as String?),
        arguments: [wordId]);
  }

  @override
  Future<void> insertQuiz(List<QuizRightWordDataset> quizList) async {
    await _quizRightWordDatasetInsertionAdapter.insertList(
        quizList, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateQuiz(QuizRightWordDataset quizDataset) {
    return _quizRightWordDatasetUpdateAdapter.updateAndReturnChangedRows(
        quizDataset, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertListQuizTransaction(
      List<QuizRightWordDataset> quizList) async {
    if (database is sqflite.Transaction) {
      await super.insertListQuizTransaction(quizList);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.quizRightWordDao
            .insertListQuizTransaction(quizList);
      });
    }
  }
}

class _$QuizTransArrageDao extends QuizTransArrageDao {
  _$QuizTransArrageDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _quizTransArrangeDatasetInsertionAdapter = InsertionAdapter(
            database,
            'QUIZ_TRANS_ARRANGE',
            (QuizTransArrangeDataset item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'lessonId': item.lessonId,
                  'type': item.type,
                  'wordId': item.wordId,
                  'origin_sentence': item.originSentence,
                  'vi_sentence': item.viSentence,
                  'isDeleted':
                      item.isDeleted == null ? null : (item.isDeleted! ? 1 : 0),
                  'updated_at': item.updated_at,
                  'created_at': item.created_at,
                  'numRightPhrase': item.numRightPhrase
                }),
        _quizTransArrangeDatasetUpdateAdapter = UpdateAdapter(
            database,
            'QUIZ_TRANS_ARRANGE',
            ['id'],
            (QuizTransArrangeDataset item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'lessonId': item.lessonId,
                  'type': item.type,
                  'wordId': item.wordId,
                  'origin_sentence': item.originSentence,
                  'vi_sentence': item.viSentence,
                  'isDeleted':
                      item.isDeleted == null ? null : (item.isDeleted! ? 1 : 0),
                  'updated_at': item.updated_at,
                  'created_at': item.created_at,
                  'numRightPhrase': item.numRightPhrase
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<QuizTransArrangeDataset>
      _quizTransArrangeDatasetInsertionAdapter;

  final UpdateAdapter<QuizTransArrangeDataset>
      _quizTransArrangeDatasetUpdateAdapter;

  @override
  Future<QuizTransArrangeDataset?> findQuizByQuizId(String quizId) async {
    return _queryAdapter.query('SELECT * FROM QUIZ_TRANS_ARRANGE WHERE id = ?1',
        mapper: (Map<String, Object?> row) => QuizTransArrangeDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            lessonId: row['lessonId'] as String?,
            wordId: row['wordId'] as String?,
            type: row['type'] as String?,
            updated_at: row['updated_at'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            name: row['name'] as String?,
            originSentence: row['origin_sentence'] as String?,
            viSentence: row['vi_sentence'] as String?,
            numRightPhrase: row['numRightPhrase'] as int?),
        arguments: [quizId]);
  }

  @override
  Future<int?> deleteAllQuiz() async {
    await _queryAdapter.queryNoReturn('DELETE FROM QUIZ_TRANS_ARRANGE');
  }

  @override
  Future<List<QuizTransArrangeDataset?>> findQuizByLessonId(
      String lessonId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM QUIZ_TRANS_ARRANGE WHERE lessonId = ?1',
        mapper: (Map<String, Object?> row) => QuizTransArrangeDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            lessonId: row['lessonId'] as String?,
            wordId: row['wordId'] as String?,
            type: row['type'] as String?,
            updated_at: row['updated_at'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            name: row['name'] as String?,
            originSentence: row['origin_sentence'] as String?,
            viSentence: row['vi_sentence'] as String?,
            numRightPhrase: row['numRightPhrase'] as int?),
        arguments: [lessonId]);
  }

  @override
  Future<List<QuizTransArrangeDataset>> findQuizByWordId(String wordId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM QUIZ_TRANS_ARRANGE WHERE wordId =?1',
        mapper: (Map<String, Object?> row) => QuizTransArrangeDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            lessonId: row['lessonId'] as String?,
            wordId: row['wordId'] as String?,
            type: row['type'] as String?,
            updated_at: row['updated_at'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            name: row['name'] as String?,
            originSentence: row['origin_sentence'] as String?,
            viSentence: row['vi_sentence'] as String?,
            numRightPhrase: row['numRightPhrase'] as int?),
        arguments: [wordId]);
  }

  @override
  Future<void> insertQuiz(List<QuizTransArrangeDataset> quizList) async {
    await _quizTransArrangeDatasetInsertionAdapter.insertList(
        quizList, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateQuiz(QuizTransArrangeDataset quizDataset) {
    return _quizTransArrangeDatasetUpdateAdapter.updateAndReturnChangedRows(
        quizDataset, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertListQuizTransaction(
      List<QuizTransArrangeDataset> quizList) async {
    if (database is sqflite.Transaction) {
      await super.insertListQuizTransaction(quizList);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.quizTransArrageDao
            .insertListQuizTransaction(quizList);
      });
    }
  }
}

class _$ViPhraseDao extends ViPhraseDao {
  _$ViPhraseDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _viPhraseDatasetInsertionAdapter = InsertionAdapter(
            database,
            'VI_PHRASE',
            (ViPhraseDataset item) => <String, Object?>{
                  'id': item.id,
                  'quiz_id': item.quizId,
                  'viPhrase': item.viPhrase
                }),
        _viPhraseDatasetUpdateAdapter = UpdateAdapter(
            database,
            'VI_PHRASE',
            ['id'],
            (ViPhraseDataset item) => <String, Object?>{
                  'id': item.id,
                  'quiz_id': item.quizId,
                  'viPhrase': item.viPhrase
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ViPhraseDataset> _viPhraseDatasetInsertionAdapter;

  final UpdateAdapter<ViPhraseDataset> _viPhraseDatasetUpdateAdapter;

  @override
  Future<List<ViPhraseDataset>?> findViPhraseByQuizId(String quizId) async {
    return _queryAdapter.queryList('SELECT * FROM VI_PHRASE WHERE quiz_id = ?1',
        mapper: (Map<String, Object?> row) => ViPhraseDataset(
            quizId: row['quiz_id'] as String?,
            viPhrase: row['viPhrase'] as String?,
            id: row['id'] as int?),
        arguments: [quizId]);
  }

  @override
  Future<void> deleteViPhraseByQuizId(String quizId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM VI_PHRASE WHERE quiz_id = ?1',
        arguments: [quizId]);
  }

  @override
  Future<void> insertPhrase(List<ViPhraseDataset> phraseDataset) async {
    await _viPhraseDatasetInsertionAdapter.insertList(
        phraseDataset, OnConflictStrategy.replace);
  }

  @override
  Future<int> updatePhrase(ViPhraseDataset phraseDataset) {
    return _viPhraseDatasetUpdateAdapter.updateAndReturnChangedRows(
        phraseDataset, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertListQuizTransaction(
      List<ViPhraseDataset> phraseList) async {
    if (database is sqflite.Transaction) {
      await super.insertListQuizTransaction(phraseList);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.viPhraseDao
            .insertListQuizTransaction(phraseList);
      });
    }
  }
}

class _$CategoryUserDao extends CategoryUserDao {
  _$CategoryUserDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _categoryUserDatasetInsertionAdapter = InsertionAdapter(
            database,
            'CATEGORY_USER',
            (CategoryUserDataset item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'categoryId': item.categoryId,
                  'progress': item.progress,
                  'isDeleted':
                      item.isDeleted == null ? null : (item.isDeleted! ? 1 : 0),
                  'updated_at': item.updated_at,
                  'created_at': item.created_at
                }),
        _categoryUserDatasetUpdateAdapter = UpdateAdapter(
            database,
            'CATEGORY_USER',
            ['id'],
            (CategoryUserDataset item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'categoryId': item.categoryId,
                  'progress': item.progress,
                  'isDeleted':
                      item.isDeleted == null ? null : (item.isDeleted! ? 1 : 0),
                  'updated_at': item.updated_at,
                  'created_at': item.created_at
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CategoryUserDataset>
      _categoryUserDatasetInsertionAdapter;

  final UpdateAdapter<CategoryUserDataset> _categoryUserDatasetUpdateAdapter;

  @override
  Future<CategoryUserDataset?> findCategoryUserByUserId(String userId) async {
    return _queryAdapter.query('SELECT * FROM CATEGORY_USER WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => CategoryUserDataset(
            id: row['id'] as String,
            categoryId: row['categoryId'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            progress: row['progress'] as int?,
            userId: row['userId'] as String?),
        arguments: [userId]);
  }

  @override
  Future<CategoryUserDataset?> findCategoryUserByUserIdAndCategoryId(
      String userId, String categoryId) async {
    return _queryAdapter.query(
        'SELECT * FROM CATEGORY_USER WHERE userId = ?1 AND categoryId = ?2',
        mapper: (Map<String, Object?> row) => CategoryUserDataset(
            id: row['id'] as String,
            categoryId: row['categoryId'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            progress: row['progress'] as int?,
            userId: row['userId'] as String?),
        arguments: [userId, categoryId]);
  }

  @override
  Future<List<CategoryUserDataset>> getAllCategory() async {
    return _queryAdapter.queryList('SELECT * FROM CATEGORY_USER',
        mapper: (Map<String, Object?> row) => CategoryUserDataset(
            id: row['id'] as String,
            categoryId: row['categoryId'] as String?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            progress: row['progress'] as int?,
            userId: row['userId'] as String?));
  }

  @override
  Future<int?> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM CATEGORY_USER');
  }

  @override
  Future<void> insertCategoryUser(
      List<CategoryUserDataset> categoryUsers) async {
    await _categoryUserDatasetInsertionAdapter.insertList(
        categoryUsers, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateCategoryUser(CategoryUserDataset categoryUserDataset) {
    return _categoryUserDatasetUpdateAdapter.updateAndReturnChangedRows(
        categoryUserDataset, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertListCategoryTransaction(
      List<CategoryUserDataset> categories) async {
    if (database is sqflite.Transaction) {
      await super.insertListCategoryTransaction(categories);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.categoryUserDao
            .insertListCategoryTransaction(categories);
      });
    }
  }
}

class _$LessonUserDao extends LessonUserDao {
  _$LessonUserDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _lessonUserDatasetInsertionAdapter = InsertionAdapter(
            database,
            'LESSON_USER',
            (LessonUserDataset item) => <String, Object?>{
                  'id': item.id,
                  'lessonId': item.lessonId,
                  'userId': item.userId,
                  'isBlock':
                      item.isBlock == null ? null : (item.isBlock! ? 1 : 0),
                  'isCompleted': item.isCompleted == null
                      ? null
                      : (item.isCompleted! ? 1 : 0),
                  'updated_at': item.updated_at,
                  'created_at': item.created_at
                }),
        _lessonUserDatasetUpdateAdapter = UpdateAdapter(
            database,
            'LESSON_USER',
            ['id'],
            (LessonUserDataset item) => <String, Object?>{
                  'id': item.id,
                  'lessonId': item.lessonId,
                  'userId': item.userId,
                  'isBlock':
                      item.isBlock == null ? null : (item.isBlock! ? 1 : 0),
                  'isCompleted': item.isCompleted == null
                      ? null
                      : (item.isCompleted! ? 1 : 0),
                  'updated_at': item.updated_at,
                  'created_at': item.created_at
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<LessonUserDataset> _lessonUserDatasetInsertionAdapter;

  final UpdateAdapter<LessonUserDataset> _lessonUserDatasetUpdateAdapter;

  @override
  Future<LessonUserDataset?> findLessonUserByUserId(String userId) async {
    return _queryAdapter.query('SELECT * FROM LESSON_USER WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => LessonUserDataset(
            id: row['id'] as String,
            isBlock:
                row['isBlock'] == null ? null : (row['isBlock'] as int) != 0,
            isCompleted: row['isCompleted'] == null
                ? null
                : (row['isCompleted'] as int) != 0,
            userId: row['userId'] as String?,
            lessonId: row['lessonId'] as String?),
        arguments: [userId]);
  }

  @override
  Future<LessonUserDataset?> findLessonUserByUserIdAndLessonId(
      String userId, String lessonId) async {
    return _queryAdapter.query(
        'SELECT * FROM LESSON_USER WHERE userId = ?1 AND lessonId = ?2',
        mapper: (Map<String, Object?> row) => LessonUserDataset(
            id: row['id'] as String,
            isBlock:
                row['isBlock'] == null ? null : (row['isBlock'] as int) != 0,
            isCompleted: row['isCompleted'] == null
                ? null
                : (row['isCompleted'] as int) != 0,
            userId: row['userId'] as String?,
            lessonId: row['lessonId'] as String?),
        arguments: [userId, lessonId]);
  }

  @override
  Future<List<LessonUserDataset>> getAllLessonUser() async {
    return _queryAdapter.queryList('SELECT * FROM LESSON_USER',
        mapper: (Map<String, Object?> row) => LessonUserDataset(
            id: row['id'] as String,
            isBlock:
                row['isBlock'] == null ? null : (row['isBlock'] as int) != 0,
            isCompleted: row['isCompleted'] == null
                ? null
                : (row['isCompleted'] as int) != 0,
            userId: row['userId'] as String?,
            lessonId: row['lessonId'] as String?));
  }

  @override
  Future<int?> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM LESSON_USER');
  }

  @override
  Future<void> insertLessonUser(List<LessonUserDataset> lessonUsers) async {
    await _lessonUserDatasetInsertionAdapter.insertList(
        lessonUsers, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertOneLessonUser(LessonUserDataset lessonUsers) async {
    await _lessonUserDatasetInsertionAdapter.insert(
        lessonUsers, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateLessonUser(LessonUserDataset lessonUserDataset) {
    return _lessonUserDatasetUpdateAdapter.updateAndReturnChangedRows(
        lessonUserDataset, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertListLessonTransaction(
      List<LessonUserDataset> lessonUsers) async {
    if (database is sqflite.Transaction) {
      await super.insertListLessonTransaction(lessonUsers);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.lessonUserDao
            .insertListLessonTransaction(lessonUsers);
      });
    }
  }
}

class _$LessonUserScoreDao extends LessonUserScoreDao {
  _$LessonUserScoreDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _lessonUserScoreDatasetInsertionAdapter = InsertionAdapter(
            database,
            'LESSON_USER_SCORE',
            (LessonUserScoreDataset item) => <String, Object?>{
                  'id': item.id,
                  'totalIncorrect': item.totalIncorrect,
                  'totalCorrect': item.totalCorrect,
                  'point': item.point,
                  'completionTime': item.completionTime,
                  'completedAt': item.completedAt,
                  'accuracy': item.accuracy,
                  'userId': item.userId,
                  'lessonId': item.lessonId
                }),
        _lessonUserScoreDatasetUpdateAdapter = UpdateAdapter(
            database,
            'LESSON_USER_SCORE',
            ['id'],
            (LessonUserScoreDataset item) => <String, Object?>{
                  'id': item.id,
                  'totalIncorrect': item.totalIncorrect,
                  'totalCorrect': item.totalCorrect,
                  'point': item.point,
                  'completionTime': item.completionTime,
                  'completedAt': item.completedAt,
                  'accuracy': item.accuracy,
                  'userId': item.userId,
                  'lessonId': item.lessonId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<LessonUserScoreDataset>
      _lessonUserScoreDatasetInsertionAdapter;

  final UpdateAdapter<LessonUserScoreDataset>
      _lessonUserScoreDatasetUpdateAdapter;

  @override
  Future<LessonUserScoreDataset?> findRecord(String lessonId) async {
    return _queryAdapter.query('SELECT * FROM LESSON_USER_SCORE WHERE id = ?1',
        mapper: (Map<String, Object?> row) => LessonUserScoreDataset(
            id: row['id'] as String,
            lessonId: row['lessonId'] as String,
            userId: row['userId'] as String,
            completedAt: row['completedAt'] as String?,
            completionTime: row['completionTime'] as String?,
            point: row['point'] as int?,
            accuracy: row['accuracy'] as double?,
            totalCorrect: row['totalCorrect'] as int?,
            totalIncorrect: row['totalIncorrect'] as int?),
        arguments: [lessonId]);
  }

  @override
  Future<List<LessonUserScoreDataset>> getAllRecord() async {
    return _queryAdapter.queryList('SELECT * FROM LESSON_USER_SCORE',
        mapper: (Map<String, Object?> row) => LessonUserScoreDataset(
            id: row['id'] as String,
            lessonId: row['lessonId'] as String,
            userId: row['userId'] as String,
            completedAt: row['completedAt'] as String?,
            completionTime: row['completionTime'] as String?,
            point: row['point'] as int?,
            accuracy: row['accuracy'] as double?,
            totalCorrect: row['totalCorrect'] as int?,
            totalIncorrect: row['totalIncorrect'] as int?));
  }

  @override
  Future<List<LessonUserScoreDataset>> getRecordByLessonId(
      String lessonId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM LESSON_USER_SCORE WHERE lessonId = ?1',
        mapper: (Map<String, Object?> row) => LessonUserScoreDataset(
            id: row['id'] as String,
            lessonId: row['lessonId'] as String,
            userId: row['userId'] as String,
            completedAt: row['completedAt'] as String?,
            completionTime: row['completionTime'] as String?,
            point: row['point'] as int?,
            accuracy: row['accuracy'] as double?,
            totalCorrect: row['totalCorrect'] as int?,
            totalIncorrect: row['totalIncorrect'] as int?),
        arguments: [lessonId]);
  }

  @override
  Future<int?> deleteAllCategory() async {
    await _queryAdapter.queryNoReturn('DELETE FROM LESSON_USER_SCORE');
  }

  @override
  Future<List<LessonUserScoreDataset>?> findLessonUserScoreBaseOnCatIdAndUserId(
      String categoryId, String userId) async {
    return _queryAdapter.queryList(
        'SELECT LUS.* FROM LESSON_USER_SCORE LUS INNER JOIN LESSON L ON L.id = LUS.lessonId    INNER JOIN SUBCATEGORY SUB ON SUB.id = L.subCategory    INNER JOIN CATEGORIES CAT ON CAT.id = SUB.category    WHERE CAT.id = ?1   AND LUS.userId = ?2',
        mapper: (Map<String, Object?> row) => LessonUserScoreDataset(id: row['id'] as String, lessonId: row['lessonId'] as String, userId: row['userId'] as String, completedAt: row['completedAt'] as String?, completionTime: row['completionTime'] as String?, point: row['point'] as int?, accuracy: row['accuracy'] as double?, totalCorrect: row['totalCorrect'] as int?, totalIncorrect: row['totalIncorrect'] as int?),
        arguments: [categoryId, userId]);
  }

  @override
  Future<void> insertOneRecord(LessonUserScoreDataset lessonScore) async {
    await _lessonUserScoreDatasetInsertionAdapter.insert(
        lessonScore, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertRecord(
      List<LessonUserScoreDataset> lessonScoreList) async {
    await _lessonUserScoreDatasetInsertionAdapter.insertList(
        lessonScoreList, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateRecord(LessonUserScoreDataset lessonScore) {
    return _lessonUserScoreDatasetUpdateAdapter.updateAndReturnChangedRows(
        lessonScore, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertLessonUserScoreTransaction(
      List<LessonUserScoreDataset> lessonList) async {
    if (database is sqflite.Transaction) {
      await super.insertLessonUserScoreTransaction(lessonList);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.lessonUserScoreDao
            .insertLessonUserScoreTransaction(lessonList);
      });
    }
  }
}

class _$UserFavouriteDao extends UserFavouriteDao {
  _$UserFavouriteDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _userFavouriteDatasetInsertionAdapter = InsertionAdapter(
            database,
            'USER_FAVOURITE',
            (UserFavouriteDataset item) => <String, Object?>{
                  'id': item.id,
                  'wordId': item.wordId,
                  'userId': item.userId,
                  'updated_at': item.updated_at,
                  'created_at': item.created_at
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserFavouriteDataset>
      _userFavouriteDatasetInsertionAdapter;

  @override
  Future<UserFavouriteDataset?> findUserFavouriteById(String id) async {
    return _queryAdapter.query('SELECT * FROM USER_FAVOURITE WHERE id = ?1',
        mapper: (Map<String, Object?> row) => UserFavouriteDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            updated_at: row['updated_at'] as String?,
            userId: row['userId'] as String?,
            wordId: row['wordId'] as String?),
        arguments: [id]);
  }

  @override
  Future<List<UserFavouriteDataset>> getUserFavouriteByUserId(
      String userId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM USER_FAVOURITE WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => UserFavouriteDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            updated_at: row['updated_at'] as String?,
            userId: row['userId'] as String?,
            wordId: row['wordId'] as String?),
        arguments: [userId]);
  }

  @override
  Future<UserFavouriteDataset?> getUserFavouriteByUserIdAndWordId(
      String userId, String wordId) async {
    return _queryAdapter.query(
        'SELECT * FROM USER_FAVOURITE WHERE userId = ?1 and wordId = ?2',
        mapper: (Map<String, Object?> row) => UserFavouriteDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            updated_at: row['updated_at'] as String?,
            userId: row['userId'] as String?,
            wordId: row['wordId'] as String?),
        arguments: [userId, wordId]);
  }

  @override
  Future<int?> deleteFromUserFavourite() async {
    await _queryAdapter.queryNoReturn('DELETE FROM USER_FAVOURITE');
  }

  @override
  Future<void> deleteBaseOnUserIdAndWord(String userId, String wordId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM USER_FAVOURITE WHERE userId = ?1 and wordId = ?2',
        arguments: [userId, wordId]);
  }

  @override
  Future<void> insertUserFavouriteDataset(
      List<UserFavouriteDataset> userFavourites) async {
    await _userFavouriteDatasetInsertionAdapter.insertList(
        userFavourites, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertOneRecord(
      UserFavouriteDataset userFavouriteDataset) async {
    await _userFavouriteDatasetInsertionAdapter.insert(
        userFavouriteDataset, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertListUserFavouriteTransaction(
      List<UserFavouriteDataset> userFavouriteList) async {
    if (database is sqflite.Transaction) {
      await super.insertListUserFavouriteTransaction(userFavouriteList);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.userFavouriteDao
            .insertListUserFavouriteTransaction(userFavouriteList);
      });
    }
  }
}

class _$UserCardDao extends UserCardDao {
  _$UserCardDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _userCardDatasetInsertionAdapter = InsertionAdapter(
            database,
            'USER_CARD',
            (UserCardDataset item) => <String, Object?>{
                  'id': item.id,
                  'wordId': item.wordId,
                  'catId': item.catId,
                  'userId': item.userId,
                  'phase': item.phase,
                  'interval': item.interval,
                  'originInterval': item.original_interval,
                  'ease': item.ease,
                  'due': item.due,
                  'step': item.step,
                  'isDeleted':
                      item.isDeleted == null ? null : (item.isDeleted! ? 1 : 0),
                  'updated_at': item.updated_at,
                  'created_at': item.created_at
                }),
        _userCardDatasetUpdateAdapter = UpdateAdapter(
            database,
            'USER_CARD',
            ['id'],
            (UserCardDataset item) => <String, Object?>{
                  'id': item.id,
                  'wordId': item.wordId,
                  'catId': item.catId,
                  'userId': item.userId,
                  'phase': item.phase,
                  'interval': item.interval,
                  'originInterval': item.original_interval,
                  'ease': item.ease,
                  'due': item.due,
                  'step': item.step,
                  'isDeleted':
                      item.isDeleted == null ? null : (item.isDeleted! ? 1 : 0),
                  'updated_at': item.updated_at,
                  'created_at': item.created_at
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserCardDataset> _userCardDatasetInsertionAdapter;

  final UpdateAdapter<UserCardDataset> _userCardDatasetUpdateAdapter;

  @override
  Future<UserCardDataset?> findUserCardByUserId(String userId) async {
    return _queryAdapter.query('SELECT * FROM USER_CARD WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => UserCardDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            catId: row['catId'] as String?,
            wordId: row['wordId'] as String?,
            due: row['due'] as double?,
            ease: row['ease'] as double?,
            interval: row['interval'] as double?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            original_interval: row['originInterval'] as double?,
            phase: row['phase'] as int?,
            step: row['step'] as double?,
            updated_at: row['updated_at'] as String?,
            userId: row['userId'] as String?),
        arguments: [userId]);
  }

  @override
  Future<List<UserCardDataset>> getAllLessonUser() async {
    return _queryAdapter.queryList('SELECT * FROM USER_CARD',
        mapper: (Map<String, Object?> row) => UserCardDataset(
            id: row['id'] as String?,
            created_at: row['created_at'] as String?,
            catId: row['catId'] as String?,
            wordId: row['wordId'] as String?,
            due: row['due'] as double?,
            ease: row['ease'] as double?,
            interval: row['interval'] as double?,
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0,
            original_interval: row['originInterval'] as double?,
            phase: row['phase'] as int?,
            step: row['step'] as double?,
            updated_at: row['updated_at'] as String?,
            userId: row['userId'] as String?));
  }

  @override
  Future<int?> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM USER_CARD');
  }

  @override
  Future<void> insertUserCard(List<UserCardDataset> userCards) async {
    await _userCardDatasetInsertionAdapter.insertList(
        userCards, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertOneUserCard(UserCardDataset userCard) async {
    await _userCardDatasetInsertionAdapter.insert(
        userCard, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateUserCard(UserCardDataset userCardDataset) {
    return _userCardDatasetUpdateAdapter.updateAndReturnChangedRows(
        userCardDataset, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertListLessonTransaction(
      List<UserCardDataset> userCards) async {
    if (database is sqflite.Transaction) {
      await super.insertListLessonTransaction(userCards);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.userCardDao
            .insertListLessonTransaction(userCards);
      });
    }
  }
}
