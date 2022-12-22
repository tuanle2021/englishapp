const ROUTES = {
  ROOT: '/',
  WORD: {
    ROOT: '/word',
    GET_ALL_WORD: '/getAllWord'
  },
  APP_VERSION: {
    ROOT: '/app_version',
    CHECK_APP_VERSION: '/checkVersion'
  },
  AUTH: {
    ROOT: '/auth',
    REFRESH_TOKEN: '/refreshToken',
    SIGNUP: '/signup',
    GOOGLE_TOKEN: '/google-token',
    FACEBOOK_TOKEN: '/facebook-token',
    VERIFY_ACTIVATION_CODE: '/verifyActivationCode',
    SEND_ACTIVATION_CODE: '/sendActivationCode',
    LOGIN: '/login',
    LINK_GOOGLE: '/link-google',
    LINK_FACEBOOK: '/link-facebook'
  },
  USER: {
    ROOT: '/user',
    PROFILE: '/profile',
    CHECK_EMAIL: '/check-email',
    UPDATE_PROFILE: '/updateProfile',
    FORGOT_PASSWORD: '/forgot-password',
    RESET_PASSWORD: '/reset-password',
    GEN_RESET_LINK: '/gen-reset-link',
    UPDATE_PASSWORD: '/update-password',
    FETCH_USER_DATA: '/fetch-user-data'
  },
  USER_CARD: {
    ROOT: '/usercard',
    GET_ALL: '/getall',
    GET_BY_VALUE: '/',
    GET_BY_ID: '/id',
    CREATE_ONE: '/',
    REVIEW_OUTCOME: '/review',
    GET_DUE: '/due/:userid'
  },
  LESSON_USER: {
    ROOT: '/lesson-user',
    GET_ALL: '/all',
    GET_BY_FIELD_ID: '/search',
    GET_BY_ID: '/:id',
    CREATE_ONE: '/',
    UPDATE_BY_ID: '/update/:id',
    UPDATE_ALL: '/update/all',
    DELETE_ALL: '/delete/all',
    DELETE_BY_ID: '/delete/:id'
  },
  LESSON_USER_SCORE: {
    ROOT: '/lesson-user-score',
    GET_ALL: '/all',
    GET_BY_FIELD_ID: '/search',
    GET_BY_ID: '/:id',
    CREATE_ONE: '/',
    UPDATE_BY_ID: '/update/:id',
    UPDATE_ALL: '/update/all',
    DELETE_ALL: '/delete/all',
    DELETE_BY_ID: '/delete/:id'
  },
  CATEGORY_USER: {
    ROOT: '/category-user',
    GET_ALL: '/all',
    GET_BY_FIELD_ID: '/search',
    GET_BY_ID: '/:id',
    CREATE_ONE: '/',
    UPDATE_BY_ID: '/update/:id',
    UPDATE_ALL: '/update/all',
    DELETE_ALL: '/delete/all',
    DELETE_BY_ID: '/delete/:id'
  },
  USER_FAVOURITE: {
    ROOT: '/user-favourite',
    GET_ALL: '/all',
    GET_BY_USER_ID: 'userId/:id',
    GET_BY_FIELD_ID: '/search',
    GET_BY_ID: '/:id',
    CREATE_ONE: '/',
    UPDATE_BY_ID: '/update/:id',
    UPDATE_ALL: '/update/all',
    DELETE_ALL: '/delete/all',
    DELETE_BY_ID: '/delete/:id',
    DELETE_BY_USER: '/deleteByUserIdWordId'
  },
  FACEBOOK_TOKEN: {
    ROOT: '/facebook-token',
    GET_ALL: '/all',
    GET_BY_FIELD_ID: '/search',
    GET_BY_ID: '/:id',
    CREATE_ONE: '/',
    UPDATE_BY_ID: '/update/:id',
    UPDATE_ALL: '/update/all',
    DELETE_ALL: '/delete/all',
    DELETE_BY_ID: '/delete/:id',
    GET_FRIEND_LIST: '/friend-list',
    GET_FRIEND_SCORE: '/friend-score'
  },
  FEEDBACK: {
    ROOT: '/feedback',
    GET_ALL: '/all',
    GET_BY_FIELD_ID: '/search',
    GET_BY_ID: '/:id',
    CREATE_ONE: '/',
    UPDATE_BY_ID: '/update/:id',
    UPDATE_ALL: '/update/all',
    DELETE_ALL: '/delete/all',
    DELETE_BY_ID: '/delete/:id',
    GET_FRIEND_LIST: '/friend-list',
    GET_FRIEND_SCORE: '/friend-score'
  },
};

const VERSION = 'v1';

module.exports = {
  ROUTES: ROUTES,
  VERSION: VERSION
};
