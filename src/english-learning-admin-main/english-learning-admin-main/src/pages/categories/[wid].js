import Head from "next/head";
import { useState, useEffect } from "react";
import { DashboardLayout } from "../../components/dashboard-layout";
import { Box, Button, Container, Grid, Link, TextField, Typography } from "@mui/material";
import SaveIcon from "@mui/icons-material/Save";
import { useRouter } from "next/router";
import { useFormik } from "formik";
import * as Yup from "yup";
import { styled } from "@mui/material/styles";
import Cookie from "js-cookie";
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
let access_token = Cookie.get("accesstoken");
const headers = { authorization: "Bearer " + access_token };

const ListLevelTypes = ["Beginner", "Intermediate", "Advanced", "Professional"];

const CategoryInfo = () => {
  const router = useRouter();

  const { wid } = router.query;

  let Tilte = "Add Category";

  if (wid != "add-category") {
    Tilte = "Edit Category";
  }
  const [createObjectURL, setCreateObjectURL] = useState("/no-image-icon-15.png");
  const [isAddCategory, setIsAddCategory] = useState(true);

  const formik = useFormik({
    initialValues: {
      _id: "",
      isDeleted: "",
      name: "",
      levelType: "BEGINNER",
      // categoryImage: "",
    },
  
    onSubmit: (values) => {
      console.log("submit click")
      let data = new FormData();

      for (const property in values) {
        data.append(property, values[property]);
      }

      if (isAddCategory == true) {
        axiosApiCall(`category`, "post", headers, data)
          .then((res) => {
            console.log("new category ne");
            console.log(res.data);
            router.push("/categories/categories-list");

          })
          .catch(function (error) {
            console.log("Bị lỗi tải");
          });
      } else {
        axiosApiCall(`category/update/${wid}`, "post", headers, data)
          .then((res) => {
            console.log("new category ne");
            console.log(res.data);
            router.push("/categories/categories-list");
          })
          .catch(function (error) {
            console.log("Bị lỗi tải");
          });
      }

      //
    },
  });

  const HandleSubmitForm = () => {
    
    let data = new FormData();

    for (const property in values) {
      data.append(property, values[property]);
    }
    if (isAddCategory == true) {
      axiosApiCall(`category`, "post", headers, data)
        .then((res) => {
          console.log("add category ne");
          console.log(res.data);

          router.push("/categories/categories-list");
        })
        .catch(function (error) {
          console.log("Bị lỗi tải");
        });
    } else {
      axiosApiCall(`category/update/${wid}`, "post", headers, data)
        .then((res) => {
          console.log("new category ne");
          console.log(res.data);
          router.push("/categories/categories-list");
        })
        .catch(function (error) {
          console.log("Bị lỗi tải");
        });
    }
  };

  // use effect fetch data

  useEffect(() => {
    if (!wid) {
      return;
    }

    if (wid != "add-category") {
      setIsAddCategory(false);

      axiosApiCall(`category/${wid}`, "get", headers, "")
        .then((res) => {
          console.log("Category ne");
          //setWords(res.data);
          let results = res.data;
          console.log(results);
          formik.setFieldValue("_id", results[0]._id);
          formik.setFieldValue("name", results[0].name);
          formik.setFieldValue("isDeleted", results[0].isDeleted);
          formik.setFieldValue("levelType", results[0].levelType);
          setCreateObjectURL(`data:image/jpeg;base64,${results[0].image}`)
        })
        .catch(function (error) {
          console.log("Bị lỗi tải");
        });
    }

    //fetchData();*/
  }, [wid]);
  const uploadToClient = (event) => {
    if (event.target.files && event.target.files[0]) {
      const i = event.target.files[0];

      setCreateObjectURL(URL.createObjectURL(i));
     

      formik.setFieldValue("categoryImage", i);
    }
  };

  return (
    <>
      <Head>
        <title>Add Category | Material Kit</title>
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
                    error={Boolean(formik.touched.name && formik.errors.name)}
                    fullWidth
                    helperText={formik.touched.name && formik.errors.name}
                    label="name"
                    margin="normal"
                    name="name"
                    onBlur={formik.handleBlur}
                    onChange={formik.handleChange}
                    type="string"
                    value={formik.values.name}
                    variant="outlined"
                  />
                  <TextField
                    error={Boolean(formik.touched.levelType && formik.errors.levelType)}
                    fullWidth
                    helperText={formik.touched.levelType && formik.errors.levelType}
                    label="Level Type"
                    margin="normal"
                    name="levelType"
                    onBlur={formik.handleBlur}
                    onChange={formik.handleChange}
                    required
                    select
                    SelectProps={{ native: true }}
                    value={formik.values.levelType}
                    variant="outlined"
                  >
                    {ListLevelTypes.map((option) => (
                      <option key={option} value={option}>
                        {option}
                      </option>
                    ))}
                  </TextField>
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
                      <Button variant="contained" component="span" sx={{ mt: 2 }} >
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
CategoryInfo.getLayout = (page) => <DashboardLayout>{page}</DashboardLayout>;

export default CategoryInfo;
