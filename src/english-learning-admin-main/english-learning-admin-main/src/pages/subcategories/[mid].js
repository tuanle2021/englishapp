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


const SubcategoryInfo = () => {
    const router = useRouter();

    const { mid } = router.query;

    let Tilte = "Add Subcategory";

    if (mid != "add-subcategory") {
        Tilte = "Edit Subcategory";
    }
    const [createObjectURL, setCreateObjectURL] = useState("/no-image-icon-15.png");
    const [isAddCategory, setIsAddCategory] = useState(true);
    const [categories, setCategories] = useState([]);

    const formik = useFormik({
        initialValues: {
            _id: "",
            isDeleted: "",
            name: "",
            category: "",
        },
        validationSchema: Yup.object({
            word: Yup.string().max(255).required("Word is required"),
        }),
    });

    const HandleSubmitForm = () => {
        const values = {
            name: formik.values.name,
            category: formik.values.category,
        };
        if (mid == "add-subcategory") {
            axiosApiCall(`subcategory`, "post", headers, values)
                .then((res) => {
                    console.log(res.data);
                    let result = res.data[0];
                    router.push("/subcategories/subcategories-list");
                })
                .catch(function (error) {
                    console.log("Bị lỗi tải");
                });
        } else {
            axiosApiCall(`subcategory/update/${mid}`, "post", headers, values)
                .then((res) => {
                    console.log(res.data);
                    router.push("/subcategories/subcategories-list");
                })
                .catch(function (error) {
                    console.log("Bị lỗi tải");
                });
        }
    };

    // use effect fetch data

    useEffect(() => {
        if (!mid) {
            return;
        }
        // console.log(mid);

        if (mid != "add-category") {
            axiosApiCall(`subcategory/${mid}`, "get", headers, "")
                .then((res) => {
                    //setWords(res.data);
                    let results = res.data;
                    console.log(results);
                    formik.setFieldValue("name", results.name);
                    formik.setFieldValue("category", results.category._id);
                })
                .catch(function (error) {
                    console.log("Bị lỗi tải",error);
                });
        }

        // get list category
        axiosApiCall(`category/all`, "get", headers, "").then((res) => {
            // console.log("lesson", res.data);

            let data_categories = []

            res.data.forEach(category => {
                data_categories.push({ id: category._id, name: category.name })
            })

            setCategories(data_categories);
            console.log(data_categories)
        }).catch((error) => {
            console.log("Bị lỗi tải", error);
        });
    }, [mid]);
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
                <Container maxmidth={false}>
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
                                        {categories.map((category) => (
                                            <option key={category.id} value={category.id}>
                                                {category.name}
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
SubcategoryInfo.getLayout = (page) => <DashboardLayout>{page}</DashboardLayout>;

export default SubcategoryInfo;
