const ROUTES = {
  DEFAULT: '/',
  WORD: {
    ROOT: '/word',
    GET_ALL: '/all',
    GET_BY_ID: '/:id',
    GET_BY_FIELD_ID: '/search',
    CREATE_ONE: '/',
    UPDATE_BY_ID: '/update/:id',
    UPDATE_ALL: '/update/all',
    DELETE_BY_ID: '/delete/:id',
    DELETE_ALL: '/delete/all'
  },
  CATEGORY: {
    ROOT: '/category',
    GET_ALL: '/all',
    GET_BY_FIELD_ID: '/search', // before :id
    GET_BY_ID: '/:id',
    CREATE_ONE: '/',
    UPDATE_BY_ID: '/update/:id',
    UPDATE_ALL: '/update/all',
    DELETE_BY_ID: '/delete/:id',
    DELETE_ALL: '/delete/all'
  },
  SENTENCE: {
    ROOT: '/sentence',
    GET_ALL: '/all',
    GET_BY_FIELD_ID: '/search', // before :id
    GET_BY_ID: '/:id',
    CREATE_ONE: '/',
    UPDATE_BY_ID: '/update/:id',
    UPDATE_ALL: '/update/all',
    DELETE_BY_ID: '/delete/:id',
    DELETE_ALL: '/delete/all'
  },
  QUIZ: {
    ROOT: '/quiz',
    GET_ALL: '/all',
    GET_BY_FIELD_ID: '/search', // before :id
    GET_BY_ID: '/:id',
    CREATE_ONE: '/',
    UPDATE_BY_ID: '/update/:id',
    UPDATE_ALL: '/update/all',
    DELETE_BY_ID: '/delete/:id',
    DELETE_ALL: '/delete/all',
    TYPE: {
      ROOT: '/type',
      GET_ALL: '/all',
      GET_BY_ID: '/:id',
      CREATE_ONE: '/',
      UPDATE_BY_ID: '/update/:id',
      DELETE_BY_ID: '/delete/:id',
      DELETE_ALL: '/delete/all'
    }
  },
  QUIZ_TRANS_ARRANGE: {
    ROOT: '/quiztransarrange',
    GET_ALL: '/all',
    GET_BY_FIELD_ID: '/search', // before :id
    GET_BY_ID: '/:id',
    CREATE_ONE: '/',
    UPDATE_BY_ID: '/update/:id',
    UPDATE_ALL: '/update/all',
    DELETE_BY_ID: '/delete/:id',
    DELETE_ALL: '/delete/all'
  },
  QUIZ_RIGHT_WORD: {
    ROOT: '/quizrightword',
    GET_ALL: '/all',
    GET_BY_FIELD_ID: '/search', // before :id
    GET_BY_ID: '/:id',
    CREATE_ONE: '/',
    UPDATE_BY_ID: '/update/:id',
    UPDATE_ALL: '/update/all',
    DELETE_BY_ID: '/delete/:id',
    DELETE_ALL: '/delete/all'
  },
  QUIZ_RIGHT_PRONOUNCE: {
    ROOT: '/quizrightpro',
    GET_ALL: '/all',
    GET_BY_FIELD_ID: '/search', // before :id
    GET_BY_ID: '/:id',
    CREATE_ONE: '/',
    UPDATE_BY_ID: '/update/:id',
    UPDATE_ALL: '/update/all',
    DELETE_BY_ID: '/delete/:id',
    DELETE_ALL: '/delete/all'
  },
  QUIZ_FILL_WORD: {
    ROOT: '/quizfillword',
    GET_ALL: '/all',
    GET_BY_FIELD_ID: '/search', // before :id
    GET_BY_ID: '/:id',
    CREATE_ONE: '/',
    UPDATE_BY_ID: '/update/:id',
    UPDATE_ALL: '/update/all',
    DELETE_BY_ID: '/delete/:id',
    DELETE_ALL: '/delete/all'
  },
  QUIZ_FILL_CHAR: {
    ROOT: '/quizfillchar',
    GET_ALL: '/all',
    GET_BY_FIELD_ID: '/search', // before :id
    GET_BY_ID: '/:id',
    CREATE_ONE: '/',
    UPDATE_BY_ID: '/update/:id',
    UPDATE_ALL: '/update/all',
    DELETE_BY_ID: '/delete/:id',
    DELETE_ALL: '/delete/all'
  },
  USER: {
    ROOT: '/user',
    GET_ALL: '/all',
    GET_BY_FIELD_ID: '/search', // before :id
    GET_BY_ID: '/:id',
    CREATE_ONE: '/',
    UPDATE_BY_ID: '/update/:id',
    UPDATE_ALL: '/update/all',
    DELETE_ALL: '/delete/all',
    DELETE_BY_ID: '/delete/:id'
  },
  LESSON: {
    ROOT: '/lesson',
    GET_ALL: '/all',
    GET_BY_FIELD_ID: '/search', // before :id
    GET_BY_ID: '/:id',
    CREATE_ONE: '/',
    UPDATE_BY_ID: '/update/:id',
    UPDATE_ALL: '/update/all',
    DELETE_ALL: '/delete/all',
    DELETE_BY_ID: '/delete/:id'
  },
  SUB_CATEGORY: {
    ROOT: '/subcategory',
    GET_ALL: '/all',
    GET_BY_FIELD_ID: '/search', // before :id
    GET_BY_ID: '/:id',
    CREATE_ONE: '/',
    UPDATE_BY_ID: '/update/:id',
    UPDATE_ALL: '/update/all',
    DELETE_ALL: '/delete/all',
    DELETE_BY_ID: '/delete/:id'
  },
  AUTH: {
    ROOT: '/auth',
    LOGIN: '/login'
  },
  APPVERSION: {
    ROOT: '/appversion',
    GET: '/',
    UPDATE: '/update',

  },
};

// only for development: apis document
const DOCS = {
  AUTH: '/auth-apis',
  WORD: '/word-apis',
  CATEGORY: '/category-apis',
  LEVEL: '/level-apis',
  SENTENCE: '/sentence-apis',
  QUIZ_TYPE: '/quiz-type-apis',
  QUIZ: '/quiz-apis',
  USER: '/user-apis',
  LESSON: '/lesson-apis',
  SUB_CATEGORY: '/subcategory-apis'
};

module.exports = {
  ROUTES,
  DOCS
};
