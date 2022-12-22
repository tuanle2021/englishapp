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

let access_token = Cookie.get("accesstoken");
const headers = { authorization: "Bearer " + access_token };
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


const LessonInfo = () => {
    const router = useRouter();

    const { lid } = router.query;

    let Tilte = "Add Lessons";

    if (lid != "add-lesson") {
        Tilte = "Edit Lessons";
    }
    const [createObjectURL, setCreateObjectURL] = useState("/no-image-icon-15.png");
    const [isAddCategory, setIsAddCategory] = useState(true);
    const [subcategories, setSubcategories] = useState([]);

    const formik = useFormik({
        initialValues: {
            _id: "",
            isDeleted: "",
            name: "",
            subcategory: "",
            description: "",
        },
        validationSchema: Yup.object({
            word: Yup.string().max(255).required("Word is required"),
        }),
    });

    const HandleSubmitForm = () => {
        const values = {
            name: formik.values.name,
            description: formik.values.description,
            subCategoryId: formik.values.subcategory,
        };
        if (lid == "add-lesson") {
            axiosApiCall(`lesson`, "post", headers, values)
                .then((res) => {
                    console.log(res.data);
                    let result = res.data[0];
                    router.push("/lessons/lessons-list");
                })
                .catch(function (error) {
                    console.log("Bị lỗi tải");
                });
        } else {
            axiosApiCall(`lesson/update/${lid}`, "post",headers, values)
                .then((res) => {
                    console.log(res.data);
                    router.push("/lessons/lessons-list");
                })
                .catch(function (error) {
                    console.log("Bị lỗi tải");
                });
        }
    };

    // use effect fetch data

    useEffect(() => {
        if (!lid) {
            return;
        }
        // console.log(lid);

        if (lid != "add-lesson") {
            axiosApiCall(`lesson/${lid}`, "get", headers, "")
                .then((res) => {
                    //setWords(res.data);
                    let results = res.data;
                    console.log("data",results);
                    formik.setFieldValue("name", results.name);
                    formik.setFieldValue("description", results.description);
                    formik.setFieldValue("subcategory", results.subCategoryId._id);
                })
                .catch(function (error) {
                    console.log("Bị lỗi tải",error);
                });
        }

        // get list category
        axiosApiCall(`subcategory/all`, "get", headers, "").then((res) => {
            // console.log("lesson", res.data);

            let data_subcategories = []

            res.data.forEach(subcategory => {
              data_subcategories.push({ id: subcategory._id, name: subcategory.name })
            })

            setSubcategories(data_subcategories);
            console.log(data_subcategories)
        }).catch((error) => {
            console.log("Bị lỗi tải", error);
        });
    }, [lid]);
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
                <title>Add Category | Material Kit</title>
            </Head>
            <Box
                component="main"
                sx={{
                    flexGrow: 1,
                    py: 8,
                }}
            >
                <Container maxlidth={false}>
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
                                onClick={HandleSubmitForm}
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
                                        label="Name"
                                        margin="normal"
                                        name="name"
                                        onBlur={formik.handleBlur}
                                        onChange={formik.handleChange}
                                        type="string"
                                        value={formik.values.name}
                                        variant="outlined"
                                    />
                                    {/* <TextField
                                        error={Boolean(formik.touched.description && formik.errors.description)}
                                        fullWidth
                                        helperText={formik.touched.description && formik.errors.description}
                                        label="Description"
                                        margin="normal"
                                        name="description"
                                        onBlur={formik.handleBlur}
                                        onChange={formik.handleChange}
                                        type="string"
                                        value={formik.values.description}
                                        variant="outlined"
                                    /> */}
                                    <TextField
                                        error={Boolean(formik.touched.subcategory && formik.errors.subcategory)}
                                        fullWidth
                                        helperText={formik.touched.subcategory && formik.errors.subcategory}
                                        label="Subcategory"
                                        margin="normal"
                                        name="subcategory"
                                        onBlur={formik.handleBlur}
                                        onChange={formik.handleChange}
                                        required
                                        select
                                        SelectProps={{ native: true }}
                                        value={formik.values.subcategory}
                                        variant="outlined"
                                    >
                                        {subcategories.map((subcategory) => (
                                            <option key={subcategory.id} value={subcategory.id}>
                                                {subcategory.name}
                                            </option>
                                        ))}
                                    </TextField>
                                </Grid>
                            </Grid>
                        </form>
                    </Box>
                </Container>
            </Box>
        </>
    );
};
LessonInfo.getLayout = (page) => <DashboardLayout>{page}</DashboardLayout>;

export default LessonInfo;
