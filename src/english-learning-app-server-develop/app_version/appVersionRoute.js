const express = require('express');
const router = express.Router();
const isNil = require('lodash/fp/isNull');


const { VERSION, ROUTES } = require('../routes/constant');
const wrap = require('../shares/handleError');

const { verifyUser } = require('../authenticate/authenticate');
const appVersionModel = require('./appVersionModel');
const { updateUserData } = require('../services/synchronizeService');
const categoryModel = require('../Category/categoryModel');
const subCategoryModel = require('../SubCategory/subCategoryModel');
const lessonModel = require('../Lesson/lessonModel');
const wordModel = require('../words/wordModel');

const quizFillCharModel = require('../QuizFillChar/quizFillCharModel');
const quizTransArrangeModel = require('../QuizTransArrange/quizTransArrangeModel')
const quizFillWordModel = require('../QuizFillWord/quizFillWordModel')
const quizRightWordModel = require('../QuizRightWord/quizRightWordModel')
const quizRightPro = require('../QuizRightPro/quizRightProModel');
const quizRightProModel = require('../QuizRightPro/quizRightProModel');
// authenticate


router.get(`/${VERSION}${ROUTES.APP_VERSION.CHECK_APP_VERSION}`, wrap(async (req, res) => {
    const { version} = req.query;
    const firstRecord = await appVersionModel.find()
    console.log(version)
    if (firstRecord.length == 0) {
         const newAppVersion = new appVersionModel({appVersion: 0})
         await newAppVersion.save()
         res.send({update: false,appVersion: 0})
         return
    }
    if (version != firstRecord[0].appVersion) {
       
        const category = await categoryModel.find()
        const lesson = await lessonModel.find()
        const subCategory = await subCategoryModel.find()
        const word = await wordModel.find()
        const quizFillChar = await quizFillCharModel.find()
        const quizFillWord = await quizFillWordModel.find()
        const quizRightWord = await quizRightWordModel.find()
        const quizTransArrange = await quizTransArrangeModel.find()
        const quizRightPro = await quizRightProModel.find()
        res.send({
            update: true,
            appVersion: firstRecord[0].appVersion,
            category: category,
            lesson: lesson,
            subCategory: subCategory,
            word: word,
            quizFillChar: quizFillChar,
            quizFillWord: quizFillWord,
            quizRightWord: quizRightWord,
            quizTransArrange: quizTransArrange,
            quizRightPro: quizRightPro
        })
        return
    }
    else {
        res.send({update: false})
    }
  }));
module.exports = router;
