import Head from "next/head";
import { useState, useEffect } from "react";
import { DashboardLayout } from "../../components/dashboard-layout";
import { Box, Button, Container, Grid, Link, TextField, Typography } from "@mui/material";
import SaveIcon from "@mui/icons-material/Save";
import { useRouter } from "next/router";
import { useFormik } from "formik";
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

const WordInfo = () => {
  const router = useRouter();

  const { wid } = router.query;

  let Tilte = "Add Sentence";

  if (wid != "add-word") {
    Tilte = "Edit Sentence";
  }

  const [image, setImage] = useState(null);
  const [createObjectURL, setCreateObjectURL] = useState("/no-image-icon-15.png");
  const [isAddSentence, setIsAddSentence] = useState(true);
  const [listLessons, setListLessons] = useState([]);
  const [listWords, setListWords] = useState([]);

  const testFunt = () => {
    console.log("submit test");
  };

  const formik = useFormik({
    initialValues: {
      _id: "",
      lesson: "",
      related_word_id: "",
      original: "",
      translated: "",
      isDeleted: "",
      updated_at: "",
      created_at: "",
    },
    validationSchema: Yup.object({
      word: Yup.string().max(255).required("Sentence is required"),
    }),
    onSubmit: (values) => {
      console.log("submit");
      console.log(values);
      if (isAddWord == true) {
        axiosApiCall(`word`, "post", "", values)
          .then((res) => {
            console.log("new word ne");
            console.log(res.data);
            let result = res.data[0];
          })
          .catch(function (error) {
            console.log("Bị lỗi tải");
          });
      } else {
        axiosApiCall(`word/update/${wid}`, "post", "", values)
          .then((res) => {
            console.log("new word ne");
            console.log(res.data);
            router.push("/words/words-list");
          })
          .catch(function (error) {
            console.log("Bị lỗi tải");
          });
      }
      console.log("savve");
      router.push("/sentences/sentences-list");
      //
    },
  });

  const HandleSubmitSentence = () => {
    let values = formik.values;
    console.log("submit");
    console.log(values);
    let data = {
      lesson: values.lesson,
      related_word_id: values.related_word_id,
      original: [{ language: "en-us", content: values.original }],
      translated: [
        {
          language: "vn",
          content: values.translated,
        },
      ],
    };
    console.log(data);
    if (isAddSentence == true) {
      axiosApiCall(`sentence`, "post", "", data)
        .then((res) => {
          console.log("new sentence ne");
          console.log(res.data);
        })
        .catch(function (error) {
          console.log("Bị lỗi tải");
        });
    } else {
      axiosApiCall(`sentence/update/${wid}`, "post", "", data)
        .then((res) => {
          console.log("new sentence ne");
          console.log(res.data);
          router.push("/sentences/sentences-list");
        })
        .catch(function (error) {
          console.log("Bị lỗi tải");
        });
    }
    console.log("savve");
    //router.push("/sentences/sentences-list");
  };

  // use effect fetch data

  useEffect(() => {
    if (!wid) {
      return;
    }

    //get all Lessons
    axiosApiCall(`lesson/all`, "get", "", "")
      .then((res) => {
        console.log("lesson ne");
        //setWords(res.data);
        let results = [];
        if (res.data.length == 1) {
          console.log("hell");
          results = res.data;
          console.log(results);
        }
        console.log("ấdfsfsf");
        results.push(res.data);
        setListLessons(res.data);
        console.log(res.data);
        console.log("add ");
      })
      .catch(function (error) {
        console.log("Bị lỗi tải");
      });

    if (wid != "add-word") {
      setIsAddSentence(false);
      console.log(`word/${wid}`);
      axiosApiCall(`sentence/${wid}?path=lesson`, "get", "", "")
        .then((res) => {
          console.log("sentence ne");
          console.log(res);
          console.log(res.data[0]);
          let result = res.data[0];
          //setWords(res.data);
          formik.setFieldValue("created_at", result.created_at);
          formik.setFieldValue("isDeleted", result.isDeleted);
          formik.setFieldValue("lesson", result.lesson);
          formik.setFieldValue("original", result.original[0].content);
          formik.setFieldValue("related_word_id", result.related_word_id.word);
          formik.setFieldValue("translated", result.translated[0].content);
          formik.setFieldValue("updated_at", result.updated_at);
          formik.setFieldValue("_id", result._id);
        })
        .catch(function (error) {
          console.log("Bị lỗi tải");
        });
    }

    /*async function fetchData() {
      let url = "../api/words/words-info";

      if (wid != "add-word" && wid != undefined) {
        wid += "?wid=" + wid;
        const repsonse = await fetch(url);
        const result = await repsonse.json();
        console.log(result);
        formik.setFieldValue("word", result.name);
        formik.setFieldValue("definition", result.definitions);
        formik.setFieldValue("synonyms", result.synonyms);
        formik.setFieldValue("pharses", result.phrases);
        formik.setFieldValue("mean", result.mean);
        formik.setFieldValue("category", result.category);
        formik.setFieldValue("level", result.category);

        
      }
    }

    //fetchData();*/
  }, [wid]);
  const uploadToClient = (event) => {
    if (event.target.files && event.target.files[0]) {
      const i = event.target.files[0];
      setImage(i);
      formik.setFieldValue("image", image);
      setCreateObjectURL(URL.createObjectURL(i));
    }
  };

  return (
    <>
      <Head>
        <title>Add Sentence | Material Kit</title>
      </Head>
      <Box
        component="main"
        sx={{
          flexGrow: 1,
          py: 8,
        }}
      >
        <Container maxWidth={false}>
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
                onClick={HandleSubmitSentence}
              >
                submit
              </Button>
            </Box>
          </Box>

          <Box sx={{ mt: 3 }}>
            <form onSubmit={formik.handleSubmit}>
              <Grid container spacing={3}>
                <Grid item md={6} xs={12}>
                  <TextField
                    error={Boolean(formik.touched.related_word_id && formik.errors.related_word_id)}
                    fullWidth
                    helperText={formik.touched.related_word_id && formik.errors.related_word_id}
                    label="Word"
                    margin="normal"
                    name="related_word_id"
                    onBlur={formik.handleBlur}
                    onChange={formik.handleChange}
                    type="string"
                    value={formik.values.related_word_id}
                    variant="outlined"
                  />
                  <TextField
                    error={Boolean(formik.touched.original && formik.errors.original)}
                    fullWidth
                    helperText={formik.touched.original && formik.errors.original}
                    label="Ogrional Content"
                    margin="normal"
                    name="original"
                    onBlur={formik.handleBlur}
                    onChange={formik.handleChange}
                    type="string"
                    value={formik.values.original}
                    variant="outlined"
                  />
                  <TextField
                    error={Boolean(formik.touched.translated && formik.errors.translated)}
                    fullWidth
                    helperText={formik.touched.translated && formik.errors.translated}
                    label="Translated Content"
                    margin="normal"
                    name="translated"
                    onBlur={formik.handleBlur}
                    onChange={formik.handleChange}
                    type="string"
                    value={formik.values.translated}
                    variant="outlined"
                  />

                  <TextField
                    error={Boolean(formik.touched.lesson && formik.errors.lesson)}
                    fullWidth
                    helperText={formik.touched.lesson && formik.errors.lesson}
                    label="Lesson"
                    margin="normal"
                    name="lesson"
                    onBlur={formik.handleBlur}
                    onChange={formik.handleChange}
                    required
                    select
                    SelectProps={{ native: true }}
                    value={formik.values.lesson}
                    variant="outlined"
                  >
                    {listLessons.map((option) => (
                      <option key={option._id} value={option._id}>
                        {option.name}
                      </option>
                    ))}
                  </TextField>
                  {/* <TextField
                    error={Boolean(formik.touched.level && formik.errors.level)}
                    fullWidth
                    helperText={formik.touched.level && formik.errors.level}
                    label="Level"
                    margin="normal"
                    name="level"
                    onBlur={formik.handleBlur}
                    onChange={formik.handleChange}
                    required
                    select
                    SelectProps={{ native: true }}
                    value={formik.values.level}
                    variant="outlined"
                  >
                    {levels.map((option) => (
                      <option key={option.value} value={option.value}>
                        {option.label}
                      </option>
                    ))}
                  </TextField> */}
                </Grid>
              </Grid>
            </form>
          </Box>
        </Container>
      </Box>
    </>
  );
};
WordInfo.getLayout = (page) => <DashboardLayout>{page}</DashboardLayout>;

export default WordInfo;
