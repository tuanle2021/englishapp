const QUIZ_TYPES = {
  TRANS_ARRANGE: 'TRANS_ARRANGE', // Dịch & sắp xếp câu
  FILL_WORD: 'FILL_WORD', // Điền từ còn thiếu
  FILL_CHAR: 'FILL_CHAR', // Điền ký tự còn thiếu
  RIGHT_WORD: 'RIGHT_WORD', // Chọn từ đúng
  RIGHT_PRONOUNCE: 'RIGHT_PRONOUNCE' // Chọn phát âm đúng
};

const USER_TYPES = {
  SYSTEM_ADMIN: 'SYSTEM_ADMIN', // Have all permission and only 1 user with that type in system
  ADMIN: 'ADMIN', // Admin have permission to manage
  USER: 'USER' // User of application
};

const LEVEL_TYPES = {
  BEGINNER: 'BEGINNER',
  INTERMEDIATE: 'INTERMEDIATE',
  ADVANCED: 'ADVANCED',
  PROFESSIONAL: 'PROFESSIONAL'
};

module.exports = {
  QUIZ_TYPES,
  USER_TYPES,
  LEVEL_TYPES
};
