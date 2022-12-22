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

const AppVersion = () => {



    const Tilte = "App version"



    const formik = useFormik({
        initialValues: {
            AppVersion: 0,
        },
        validationSchema: Yup.object({
            AppVersion: Yup
                .number()
                .required(
                    'App version is required'),
            
        }),
        onSubmit: (values) => {
            axiosApiCall(`appversion/update`, "post", headers, {appVersion:values.AppVersion})
                .then((res) => {
                    if(res.data.appVersion){
                        alert("Đã cập nhập phiên bản lên " + res.data.appVersion);
                        formik.setFieldValue("AppVersion",res.data.appVersion )
                    }
                })
                .catch(function (error) {
                });
        },
    });
    // use effect fetch data

    useEffect(() => {

        axiosApiCall(`appversion`, "get", headers, "")
            .then((res) => {

                formik.setFieldValue("AppVersion",res.data.appVersion )
            })
            .catch(function (error) {

            });




    }, []);


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
                                onClick={formik.handleSubmit}
                            >
                                Submit
                            </Button>
                        </Box>
                    </Box>

                    <Box sx={{ mt: 3 }}>
                        <form onSubmit={formik.handleSubmit}>
                            <Grid container spacing={3}>
                                <Grid item md={6} xs={12}>
                                    <TextField
                                        error={Boolean(formik.touched.AppVersion && formik.errors.AppVersion)}
                                        fullWidth
                                        helperText={formik.touched.AppVersion && formik.errors.AppVersion}
                                        label="App Version"
                                        margin="normal"
                                        name="AppVersion"
                                        onBlur={formik.handleBlur}
                                        onChange={formik.handleChange}
                                        type="number"
                                        value={formik.values.AppVersion}
                                        variant="outlined"
                                    />




                                </Grid>
                            </Grid>
                        </form>
                    </Box>
                </Container>
            </Box>
        </>
    );
};
AppVersion.getLayout = (page) => <DashboardLayout>{page}</DashboardLayout>;

export default AppVersion;
