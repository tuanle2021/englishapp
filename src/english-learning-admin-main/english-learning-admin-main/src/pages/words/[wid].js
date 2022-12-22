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
import Cookie from "js-cookie";
import { ClassNames } from "@emotion/react";
import CheckCircleIcon from "@mui/icons-material/CheckCircle";
import CancelIcon from "@mui/icons-material/Cancel";

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

  let Tilte = "Add Word";

  if (wid != "add-word") {
    Tilte = "Edit Word";
  }

  const [image, setImage] = useState(null);
  const [createObjectURL, setCreateObjectURL] = useState("/no-image-icon-15.png");
  const [isAddWord, setIsAddWord] = useState(true);
  const [listCategories, setListCategories] = useState([]);

  let access_token = Cookie.get("accesstoken");
  const headers = { authorization: "Bearer " + access_token };

  const formik = useFormik({
    initialValues: {
      _id: "",
      word_id: "",
      word: "",
      lexicalCategory: "",
      type: "",
      ori_lang: "",
      tra_lang: "",
      definitions: "",
      shortDefinitions: "",
      examples: "",
      phoneticNotation: "",
      phoneticSpelling: "",
      audioFile: "",
      synonyms: "",
      pharses: "",
      mean: "",
      category: "",
      image: "",
      image_url: "",
      wordImage: "",
    },
    validationSchema: Yup.object({
      word: Yup.string().max(255).required("Word is required"),
    }),
    onSubmit: (values) => {
      console.log("formik");
      console.log(formik.values);
      console.log("Aaaaa");
      console.log(values);
      console.log("submit");

      let data = new FormData();

      for (const property in values) {
        data.append(property, values[property]);
      }

      if (isAddWord == true) {
        axiosApiCall(`word`, "post", headers, data)
          .then((res) => {
            console.log("new word ne");
            console.log(res.data);
            let result = res.data[0];
            router.push("/words/words-list");
          })
          .catch(function (error) {
            console.log("Bị lỗi tải");
          });
      } else {
        console.log("edit word");
        console.log(values);

        axiosApiCall(`word/update/${wid}`, "post", headers, data)
          .then((res) => {
            console.log("new word ne");
            console.log(res.data);
            router.push("/words/words-list");
          })
          .catch(function (error) {
            console.log("Bị lỗi tải");
          });
      }

      //
    },
  });

  // use effect fetch data

  useEffect(() => {
    if (access_token == undefined) {
      router.push("/login");
      return;
    }
    if (!wid) {
      return;
    }

    console.log(access_token);
    console.log(headers);

    //get all Categories
    axiosApiCall(`category/all`, "get", headers, "")
      .then((res) => {
        console.log("Category ne");
        //setWords(res.data);
        let results = [];
        if (res.data.length == 1) {
          console.log("hell");
          results = res.data;
          console.log(results);
        }
        console.log("ấdfsfsf");
        results.push(res.data);
        console.log("add ");
        console.log(results);
        console.log(res.data);
        setListCategories(res.data);
      })
      .catch(function (error) {
        console.log("Bị lỗi tải");
      });

    if (wid != "add-word") {
      setIsAddWord(false);
      console.log(`word/${wid}`);
      axiosApiCall(`word/${wid}`, "get", headers, "")
        .then((res) => {
          console.log("word detail ne");
          console.log(res.data[0]);
          let result = res.data[0];
          console.log(result.category);
          //setWords(res.data);
          formik.setFieldValue("_id", result._id);
          formik.setFieldValue("word_id", result.word_id);
          formik.setFieldValue("word", result.word);
          formik.setFieldValue("lexicalCategory", result.lexicalCategory);
          formik.setFieldValue("type", result.type);
          formik.setFieldValue("ori_lang", result.ori_lang);
          formik.setFieldValue("tra_lang", result.tra_lang);
          formik.setFieldValue("definitions", result.definitions);
          formik.setFieldValue("shortDefinitions", result.shortDefinitions);
          formik.setFieldValue("examples", result.examples);
          formik.setFieldValue("phoneticNotation", result.phoneticNotation);
          formik.setFieldValue("phoneticSpelling", result.phoneticSpelling);
          formik.setFieldValue("audioFile", result.audioFile);
          formik.setFieldValue("synonyms", result.synonyms);
          formik.setFieldValue("pharses", result.pharses);
          formik.setFieldValue("mean", result.mean);
          formik.setFieldValue("category", result.category._id);
          formik.setFieldValue("wordImage", result.wordImage);

          setImage(result.image);
          setCreateObjectURL(`data:image/jpeg;base64,${result.image}`);
        })
        .catch(function (error) {
          console.log("Bị lỗi tải");
        });
    }
  }, [wid]);
  const uploadToClient = (event) => {
    if (event.target.files && event.target.files[0]) {
      const i = event.target.files[0];
      setImage(i);

      setCreateObjectURL(URL.createObjectURL(i));
      console.log("add file");
      console.log(i);

      const image = new FormData();
      image.append("wordImage", i);

      formik.setFieldValue("wordImage", i);
    }
  };

  return (
    <>
      <Head>
        <title> Add Word | Material Kit </title>
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
                onClick={formik.handleSubmit}
              >
                Save
              </Button>
            </Box>
          </Box>
          <Box sx={{ mt: 3 }}>
            <form onSubmit={formik.handleSubmit}>
              <Grid container spacing={3}>
                <Grid item md={6} xs={12}>
                  <TextField
                    error={Boolean(formik.touched.word && formik.errors.word)}
                    fullWidth
                    helperText={formik.touched.word && formik.errors.word}
                    label="Word"
                    margin="normal"
                    name="word"
                    onBlur={formik.handleBlur}
                    onChange={formik.handleChange}
                    type="string"
                    value={formik.values.word}
                    variant="outlined"
                  />
                  <TextField
                    error={Boolean(formik.touched.definitions && formik.errors.definitions)}
                    fullWidth
                    helperText={formik.touched.definitions && formik.errors.definitions}
                    label="Definitions"
                    margin="normal"
                    name="definitions"
                    onBlur={formik.handleBlur}
                    onChange={formik.handleChange}
                    type="string"
                    value={formik.values.definitions}
                    variant="outlined"
                  />
                  <TextField
                    error={Boolean(formik.touched.synonyms && formik.errors.synonyms)}
                    fullWidth
                    helperText={formik.touched.synonyms && formik.errors.synonyms}
                    label="Synonyms"
                    margin="normal"
                    name="synonyms"
                    onBlur={formik.handleBlur}
                    onChange={formik.handleChange}
                    type="string"
                    value={formik.values.synonyms}
                    variant="outlined"
                  />
                  <TextField
                    error={Boolean(formik.touched.pharses && formik.errors.pharses)}
                    fullWidth
                    helperText={formik.touched.pharses && formik.errors.pharses}
                    label="Pharses"
                    margin="normal"
                    name="pharses"
                    onBlur={formik.handleBlur}
                    onChange={formik.handleChange}
                    type="string"
                    value={formik.values.pharses}
                    variant="outlined"
                  />
                  <TextField
                    error={Boolean(formik.touched.mean && formik.errors.mean)}
                    fullWidth
                    helperText={formik.touched.mean && formik.errors.mean}
                    label="Mean"
                    margin="normal"
                    name="mean"
                    onBlur={formik.handleBlur}
                    onChange={formik.handleChange}
                    type="string"
                    value={formik.values.mean}
                    variant="outlined"
                  />
                  <TextField
                    error={Boolean(formik.touched.category && formik.errors.category)}
                    fullWidth
                    helperText={formik.touched.category && formik.errors.category}
                    label="Category"
                    margin="normal"
                    name="category"
                    onBlur={formik.handleBlur}
                    onChange={formik.handleChange}
                    required
                    select
                    SelectProps={{ native: true }}
                    value={formik.values.category}
                    variant="outlined"
                  >
                    {listCategories.map((option) => (
                      <option key={option._id} value={option._id}>
                        {option.name}
                      </option>
                    ))}
                  </TextField>
                  <TextField
                    error={Boolean(formik.touched.audioFile && formik.errors.audioFile)}
                    fullWidth
                    helperText={formik.touched.audioFile && formik.errors.audioFile}
                    label="Audio File"
                    margin="normal"
                    name="audioFile"
                    onBlur={formik.handleBlur}
                    onChange={formik.handleChange}
                    type="string"
                    value={formik.values.audioFile}
                    variant="outlined"
                  />
                  <TextField
                    error={Boolean(
                      formik.touched.phoneticNotation && formik.errors.phoneticNotation
                    )}
                    fullWidth
                    helperText={formik.touched.phoneticNotation && formik.errors.phoneticNotation}
                    label="Phonetic Notation"
                    margin="normal"
                    name="phoneticNotation"
                    onBlur={formik.handleBlur}
                    onChange={formik.handleChange}
                    type="string"
                    value={formik.values.phoneticNotation}
                    variant="outlined"
                  />
                  <TextField
                    error={Boolean(
                      formik.touched.phoneticSpelling && formik.errors.phoneticSpelling
                    )}
                    fullWidth
                    helperText={formik.touched.phoneticSpelling && formik.errors.phoneticSpelling}
                    label="Phonetic Spelling"
                    margin="normal"
                    name="phoneticSpelling"
                    onBlur={formik.handleBlur}
                    onChange={formik.handleChange}
                    type="string"
                    value={formik.values.phoneticSpelling}
                    variant="outlined"
                  />
                  <TextField
                    error={Boolean(formik.touched.type && formik.errors.type)}
                    fullWidth
                    helperText={formik.touched.type && formik.errors.type}
                    label="Type"
                    margin="normal"
                    name="type"
                    onBlur={formik.handleBlur}
                    onChange={formik.handleChange}
                    type="string"
                    value={formik.values.type}
                    variant="outlined"
                  />
                
                </Grid>
                <Grid item md={6} xs={12}>
                  <Box
                    sx={{
                      alignItems: "center",
                      display: "flex",
                      flexDirection: "column",
                    }}
                  >
                    <Typography sx={{ m: 1 }} variant="h6">
                      Upload Image
                    </Typography>
                    <img
                      src={createObjectURL}
                      srcSet=""
                      alt=""
                      loading="lazy"
                      width={300}
                      height={300}
                    />
                    <label htmlFor="contained-button-file">
                      <Input
                        accept="image/*"
                        id="contained-button-file"
                        multiple
                        type="file"
                        onChange={uploadToClient}
                      />
                      <Button variant="contained" component="span" sx={{ mt: 2 }}>
                        Upload
                      </Button>
                    </label>
                  </Box>
                </Grid>
              </Grid>
            </form>
          </Box>
        </Container>
      </Box>
    </>
  );
};
WordInfo.getLayout = (page) => <DashboardLayout> {page} </DashboardLayout>;

export default WordInfo;
