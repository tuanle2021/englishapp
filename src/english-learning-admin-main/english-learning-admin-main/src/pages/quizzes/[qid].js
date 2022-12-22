import Head from "next/head";
import { useState, useEffect } from "react";
import { DashboardLayout } from "../../components/dashboard-layout";

import { TranslateAndArrange } from "../../components/quizz/translate-and-arrange.js";

import { ReadAndPick } from "../../components/quizz/read-and-pick";
import { FillWord } from "../../components/quizz/fill-word";
import { FillChar } from "../../components/quizz/fill-char";
import { RightWord } from "../../components/quizz/right-word";
import { RightPronounce } from "../../components/quizz/right-pronounce";

import Cookie from "js-cookie";


import { Box, Button, Container, Grid, Link, TextField, Typography } from "@mui/material";
import SaveIcon from "@mui/icons-material/Save";

import { useRouter } from "next/router";
import { Formik, Form } from 'formik';
import * as Yup from "yup";
import { styled } from "@mui/material/styles";
import axios from "axios";

const axiosApiCall = (url, method, headers = {}, data) =>
  axios({
    method,
    url: `http://localhost:3001/${url}`,
    data: data,
    headers: headers,
  });


// @refresh reset
const Input = styled("input")({
  display: "none",
});

const quizzes_type = [
  {
    value: "TRANS_ARRANGE",
    label: "TRANS_ARRANGE",
  },
  {
    value: "FILL_WORD",
    label: "FILL_WORD",
  },
  {
    value: "FILL_CHAR",
    label: "FILL_CHAR",
  },
  {
    value: "RIGHT_WORD",
    label: "RIGHT_WORD",
  },
  {
    value: "RIGHT_PRONOUNCE",
    label: "RIGHT_PRONOUNCE",
  },
];

const getFormDataSubmit = (values) => {


  let form_data = {};


  switch (values.quiz_type) {

    case 'TRANS_ARRANGE':
      form_data = {

        name: values.name,

        wordId: values.word_id,

        lessonId: values.lesson,

        originSentence: values.quizz_detail.originSentence,
        viSentence: values.quizz_detail.viSentence,
        viPhrase: values.quizz_detail.viPharse,
        // number of right word
        numRightPhrase: values.quizz_detail.numRightPhrase,


      }
      break;
    case 'FILL_WORD':
      form_data = {

        name: values.name,

        wordId: values.word_id,

        lessonId: values.lesson,

        leftOfWord: values.quizz_detail.leftOfWord,
        rightOfWord: values.quizz_detail.rightOfWord,

        viSentence: values.quizz_detail.viSentence,

        correctChoice: values.quizz_detail.correctChoice,
        firstChoice: values.quizz_detail.firstChoice,
        secondChoice: values.quizz_detail.secondChoice,
        thirdChoice: values.quizz_detail.thirdChoice,

      }
      break;
    case 'FILL_CHAR':
      form_data = {

        name: values.name,

        wordId: values.word_id,

        lessonId: values.lesson,

      }
      break;
    case 'RIGHT_WORD':
      form_data = {

        name: values.name,

        wordId: values.word_id,

        lessonId: values.lesson,

        correctChoice: values.quizz_detail.correctChoice,
        firstChoice: values.quizz_detail.firstChoice,
        secondChoice: values.quizz_detail.secondChoice,
        thirdChoice: values.quizz_detail.thirdChoice,

      }
      break;
    case 'RIGHT_PRONOUNCE':
      form_data = {

        name: values.name,

        wordId: values.word_id,

        lessonId: values.lesson,

        wordIdOne: values.quizz_detail.wordIdOne,

      }
      break;


  }

  return form_data;
}

const getRouteQuizzType = (code) => {
  switch (code) {
    case 'TRANS_ARRANGE':
      return "quiztransarrange";
    case 'FILL_CHAR':
      return "quizfillchar";
    case 'FILL_WORD':
      return "quizfillword";
    case 'RIGHT_WORD':
      return "quizrightword";
    case 'RIGHT_PRONOUNCE':
      return "quizrightpro";
  }
}

const QuizzInfo = () => {


  const router = useRouter();

  const { qid, word_id, quizz_type } = router.query;

  let Tilte = "Add Quizz";

  if (qid != "add-quiz") {
    Tilte = "Edit Quizz";
  }

  const [image, setImage] = useState(null);
  const [createObjectURL, setCreateObjectURL] = useState("/no-image-icon-15.png");
  const [quizzType, setQuizzType] = useState("");
  const [lessons, setLessons] = useState([]);

  const [word, setWord] = useState([]);

  let access_token = Cookie.get("accesstoken");
  const headers = { authorization: "Bearer " + access_token };


  const [quizzDetail, setQuizzDetail] = useState({
    _id: "",

    name: "",

    quiz_type: "TRANS_ARRANGE",

    word_id: "",

    word_name: "",


    lesson: "",

    quizz_detail: {


      correctChoice: "",
      firstChoice: "",
      secondChoice: "",
      thirdChoice: "",

      leftOfWord: "",
      rightOfWord: "",
      viSentence: "",
      originSentence: "",

      viPharse: [],
      numRightPhrase: 0,
      wordIdOne: "",


    }


  })


  const validationSchema = Yup.object({
    // word: Yup.string().max(255).required("Word is required"),
  })


  const onSubmit = (values) => {


    if (qid != "add-quizz") {
      // get form by quizz type
      let FormData = getFormDataSubmit(values, "add");
      // get url submit  by quizz type
      let route_quiz_type = getRouteQuizzType(quizz_type);
      alert(JSON.stringify(quizz_type, null, 2));

      axiosApiCall(`${route_quiz_type}/update/${qid}`, "post", headers, FormData)
        .then((res) => {
          router.push("/quizzes/quizzes-list");

        })
        .catch(function (error) {
          console.log("Bị lỗi tải", error);
        });
    } else {
      // get form by quizz type
      let FormData = getFormDataSubmit(values, "add");
      // get url submit  by quizz type
      let route_quiz_type = getRouteQuizzType(values.quiz_type);

      alert(JSON.stringify(values, null, 2));

      axiosApiCall(`${route_quiz_type}`, "post", headers, FormData)
        .then((res) => {
          router.push("/quizzes/quizzes-list");

        })
        .catch(function (error) {
          console.log("Bị lỗi tải", error);
        });
    }
  }




  // use effect fetch data

  useEffect(() => {
    if (!qid) {
      return;
    }

    // set default for quizz type
    let temp_quizz_detail = quizzDetail;
    temp_quizz_detail.type = "TRANS_ARRANGE";
    setQuizzDetail(temp_quizz_detail);


    // get word info
    axiosApiCall(`word/${word_id}`, "get", headers, "").then((res) => {

      console.log("wordsss", res.data[0]);
      const res_word_info = res.data[0];


      let temp_quizz_detail = quizzDetail;
      temp_quizz_detail.word_name = res_word_info.word;
      temp_quizz_detail.word_id = res_word_info._id;

      setQuizzDetail(temp_quizz_detail)

      console.log(quizzDetail)


    }).catch((error) => {
      console.log("Bị lỗi tải", error);
    });

    // get list of lesson
    axiosApiCall(`lesson/all`, "get", headers, "").then((res) => {
      // console.log("lesson", res.data);

      let data_lessons = []

      res.data.forEach(lesson => {
        data_lessons.push({ id: lesson._id, name: lesson.name })
      })

      setLessons(data_lessons)

    }).catch((error) => {
      console.log("Bị lỗi tải", error);
    });


    // get info of quiz

    const route_quiz_type = getRouteQuizzType(quizz_type);
    if (qid != "add-quizz") {

      axiosApiCall(`${route_quiz_type}/${qid}`, "get", headers, "").then((res) => {
        let result = res.data[0];
        console.log("hello word", result)
        if (result) {

          let quizz_res = {

            _id: result._id ? result._id : "",

            name: result.name ? result.name : "",

            quiz_type: result.type ? result.type : "",

            word_id: result.wordId ? result.wordId._id : "",

            word_name: result.wordId ? result.wordId.word : "",

            lesson: result.lessonId ? result.lessonId._id : "",

            quizz_detail: {


              correctChoice: result.correctChoice ? result.correctChoice : "",
              firstChoice: result.firstChoice ? result.firstChoice : "",
              secondChoice: result.secondChoice ? result.secondChoice : "",
              thirdChoice: result.thirdChoice ? result.thirdChoice : "",

              leftOfWord: result.leftOfWord ? result.leftOfWord : "",
              rightOfWord: result.rightOfWord ? result.rightOfWord : "",
              viSentence: result.viSentence ? result.viSentence : "",
              originSentence: result.originSentence ? result.originSentence : "",

              viPharse: result.viPhrase ? result.viPhrase : [],

              numRightPhrase: result.numRightPhrase ? result.numRightPhrase : 0,

              wordIdOne: result.wordIdOne ? result.wordIdOne._id : "",
            }
          }
          setQuizzDetail(quizz_res);

          console.log("Bị lỗi tải", quizz_res);

          setQuizzType(result.type);
        }

      }).catch((error) => {
        console.log("Bị lỗi tải", error);
      });
    }




  }, [qid]);



  const renderSwitch = (props) => {

    switch (quizzType) {

      case 'TRANS_ARRANGE':
        return <TranslateAndArrange />;
      case 'FILL_CHAR':
        return <FillChar />;
      case 'FILL_WORD':
        return <FillWord />;
      case 'RIGHT_WORD':
        return <RightWord />;
      case 'RIGHT_PRONOUNCE':
        return <RightPronounce />;
      default:
        return <TranslateAndArrange {...{ values: props.values }} />;
    }

  }
  return (
    <>
      <Head>
        <title>Add Word | Material Kit</title>
      </Head>
      <Box
        component="main"
        sx={{
          flexGrow: 1,
          py: 8,
        }}
      >
        <Container maxWidth={false}>


          <Box sx={{ mt: 3 }}>
            <Formik
              initialValues={quizzDetail}
              onSubmit={async (values) => onSubmit(values)}
              validationSchema={validationSchema}
              enableReinitialize={true}
            >

              {props => (
                <Form>
                  <Box
                    sx={{
                      alignItems: "center",
                      display: "flex",
                      justifyContent: "space-between",
                      flexWrap: "wrap",
                      m: -1,
                    }}
                  >
                    <Typography sx={{ m: 1 }} variant="h4">
                      {Tilte}
                    </Typography>
                    <Box sx={{ m: 1 }}>
                      <Button
                        startIcon={<SaveIcon fontSize="small" />}
                        color="primary"
                        variant="contained"
                        type="submit"
                      >
                        Save
                      </Button>
                    </Box>
                  </Box>
                  <Grid container spacing={3}>
                    <Grid item md={12} xs={12}>

                      {/* Quiz Name */}
                      <TextField
                        error={Boolean(props.touched.name && props.errors.name)}
                        fullWidth
                        helperText={props.touched.name && props.errors.name}
                        label="Quiz Name"
                        margin="normal"
                        name="name"
                        onBlur={props.handleBlur}
                        onChange={props.handleChange}
                        type="string"
                        value={props.values.name}
                        variant="outlined"
                      />
                      {/* Quiz Name */}

                      {/* Word */}
                      <TextField
                        error={Boolean(props.touched.name && props.errors.name)}
                        fullWidth
                        disabled
                        helperText={props.touched.name && props.errors.name}
                        label="Word"
                        margin="normal"
                        name="word"
                        onBlur={props.handleBlur}
                        onChange={props.handleChange}
                        type="string"
                        value={props.values.word_name}
                        variant="filled"
                      />
                      {/* Word */}


                      <TextField
                        error={Boolean(props.touched.lesson && props.errors.lesson)}
                        fullWidth
                        helperText={props.touched.lesson && props.errors.lesson}
                        label="Lesson"
                        margin="normal"
                        name="lesson"
                        onBlur={props.handleBlur}
                        onChange={props.handleChange}
                        required
                        select
                        SelectProps={{ native: true }}
                        value={props.values.lesson == "" ? (lessons.length > 0 ? lessons[0].id : "") : props.values.lesson}
                        variant="outlined"
                      >
                        {lessons.map((lesson) => (
                          <option key={lesson.id} value={lesson.id}>
                            {lesson.name}
                          </option>
                        ))}
                      </TextField>

                      <TextField
                        error={Boolean(props.touched.quiz_type && props.errors.quiz_type)}
                        fullWidth
                        helperText={props.touched.quiz_type && props.errors.quiz_type}
                        label="Quiz Type"
                        margin="normal"
                        name="quiz_type"
                        onBlur={props.handleBlur}
                        required
                        select
                        onChange={(event) => {
                          props.setFieldValue("quiz_type", event.target.value);
                          setQuizzType(event.target.value);
                        }}
                        SelectProps={{ native: true }}
                        value={props.values.quiz_type}
                        variant="outlined"
                      >
                        {quizzes_type.map((quizz) => (
                          <option key={quizz.value} value={quizz.value}>
                            {quizz.label}
                          </option>
                        ))}
                      </TextField>


                      {renderSwitch(props.values)}
                    </Grid>
                  </Grid>

                </Form>
              )}
            </Formik>
          </Box>
        </Container>
      </Box>
    </>
  );
};
QuizzInfo.getLayout = (page) => <DashboardLayout>{page}</DashboardLayout>;

export default QuizzInfo;
