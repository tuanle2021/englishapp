import Head from 'next/head';
import { useState, useEffect } from 'react';
import { DashboardLayout } from '../../components/dashboard-layout';
import { Box, Button, Container, Grid, Link, TextField, Typography } from '@mui/material';
import SaveIcon from '@mui/icons-material/Save';
import { useRouter } from 'next/router';
import { useFormik } from 'formik';
import * as Yup from 'yup';
import { styled } from '@mui/material/styles';
import Cookie from 'js-cookie';

import axios from 'axios';

// @refresh reset
const Input = styled('input')({
    display: 'none',
});
const statuses = [
    {
        value: 1,
        label: 'Enable'
    },
    {
        value: 0,
        label: 'Disable'
    },
];
let access_token = Cookie.get("accesstoken");
const headers = { authorization: "Bearer " + access_token };
const axiosApiCall = (url, method, headers = {}, data) =>
    axios({
        method,
        url: `http://localhost:3001/${url}`,
        data: data,
        headers: headers,
    });

const WordInfo = () => {
    const router = useRouter();

    const { aid } = router.query;

    let Tilte = "Add Admin";

    if (aid != "add-admin") {
        Tilte = "Edit Admin";
    }

    const [isAddAdmin, setisAddAdmin] = useState(true);
    const [createObjectURL, setCreateObjectURL] = useState("/no-image-icon-15.png");

    const formik = useFormik({
        initialValues: {
            username: '',
            name: '',
            password: '',
            repassword: '',
            status: 1,
        },
        validationSchema: Yup.object({
            name: Yup
            .string()
            .max(255)
            .required(
                'Name is required'),
            username: Yup
                .string()
                .max(255)
                .required(
                    'Username is required'),
            password: Yup.string()
                .required('No password provided.')
                .min(8, 'Password is too short - should be 8 chars minimum.')
                .matches(/[a-zA-Z]/, 'Password can only contain Latin letters.'),
            repassword: Yup.string()
                .oneOf([Yup.ref('password'), null], 'Passwords must match')

        }),
        onSubmit: (values) => {

            if (isAddAdmin == true) {
                let user = "";
                if (Cookie.get('user') !== "") {
                    user = JSON.parse(Cookie.get('user') ? Cookie.get('user') : "");


                }

                let data = {
                    username: values.username,
                    name: values.name,
                    password: values.password,
                    userType: user.userType,
                    status: values.status,
                }
                axiosApiCall(`user`, "post", headers, data)
                    .then((res) => {
                        if (res.data.error) {
                            alert(res.data.error)

                        } else {
                            router.push("/admins/admins-list");
                        }

                    })
                    .catch(function (error) {
                        console.log("Bị lỗi tải");
                    });
            } else {
                let user = "";
                if (Cookie.get('user') !== "") {
                    user = JSON.parse(Cookie.get('user') ? Cookie.get('user') : "");


                }

                let data = {
                    username: values.username,
                    name: values.name,
                    password: values.password,
                    userType: user.userType,
                    status: values.status,
                }
                axiosApiCall(`user/update/${aid}`, "post", headers, data)
                    .then((res) => {
                        if (res.data.error) {
                            alert(res.data.error)
                        } else {
                            router.push("/admins/admins-list");
                        }
                    })
                    .catch(function (error) {
                        console.log("Bị lỗi tải");
                    });
            }
        }
    });

    // use effect fetch data

    useEffect(() => {

        if (!aid) {
            return;
        }

        if (aid != "add-admin") {

            setisAddAdmin(false);
            axiosApiCall(`user/${aid}`, "get", headers, "")
                .then((res) => {
                    let results = res.data;
                    console.log(results);
                    formik.setFieldValue("name", results.name);
                    formik.setFieldValue("username", results.username);
                    formik.setFieldValue("status", results.status);
                })
                .catch(function (error) {
                    console.log("Bị lỗi tải");
                });
        }



    }, []);



    return (
        <>
            <Head>
                <title>Add Word | Material Kit</title>
            </Head>
            <Box
                component="main"
                sx={{
                    flexGrow: 1,
                    py: 8
                }}
            >
                <Container maxWidth={false}>
                    <Box
                        sx={{
                            alignItems: 'center',
                            display: 'flex',
                            justifyContent: 'space-between',
                            flexWrap: 'wrap',
                            m: -1
                        }}
                    >
                        <Typography
                            sx={{ m: 1 }}
                            variant="h4"
                        >
                            {Tilte}
                        </Typography>
                        <Box sx={{ m: 1 }}>

                            <Button
                                startIcon={(<SaveIcon fontSize="small" />)}
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
                            <Grid
                                container
                                spacing={3}
                            >
                                <Grid item
                                    md={6}
                                    xs={12}>
                                    <TextField
                                        error={Boolean(formik.touched.name && formik.errors.name)}
                                        fullWidth
                                        helperText={formik.touched.name && formik.errors.name}
                                        label="Name"
                                        margin="normal"
                                        name="name"
                                        onBlur={formik.handleBlur}
                                        onChange={formik.handleChange}
                                        type="name"
                                        value={formik.values.name}
                                        variant="outlined"
                                    />
                                    <TextField
                                        error={Boolean(formik.touched.username && formik.errors.username)}
                                        fullWidth
                                        helperText={formik.touched.username && formik.errors.username}
                                        label="Username"
                                        margin="normal"
                                        name="username"
                                        onBlur={formik.handleBlur}
                                        onChange={formik.handleChange}
                                        type="username"
                                        value={formik.values.username}
                                        variant="outlined"
                                    />
                                    <TextField
                                        error={Boolean(formik.touched.password && formik.errors.password)}
                                        fullWidth
                                        helperText={formik.touched.password && formik.errors.password}
                                        label="Passowrd"
                                        margin="normal"
                                        name="password"
                                        onBlur={formik.handleBlur}
                                        onChange={formik.handleChange}
                                        type="password"
                                        value={formik.values.password}
                                        variant="outlined"
                                    />
                                    <TextField
                                        error={Boolean(formik.touched.repassword && formik.errors.repassword)}
                                        fullWidth
                                        helperText={formik.touched.repassword && formik.errors.repassword}
                                        label="Repassword"
                                        margin="normal"
                                        name="repassword"
                                        onBlur={formik.handleBlur}
                                        onChange={formik.handleChange}
                                        type="password"
                                        value={formik.values.repassword}
                                        variant="outlined"
                                    />
                                    <TextField
                                        error={Boolean(formik.touched.status && formik.errors.status)}
                                        fullWidth
                                        helperText={formik.touched.status && formik.errors.status}
                                        label="Status"
                                        margin="normal"
                                        name="status"
                                        onBlur={formik.handleBlur}
                                        onChange={formik.handleChange}
                                        select
                                        SelectProps={{ native: true }}
                                        value={formik.values.status ? formik.values.status : 1}
                                        variant="outlined"
                                    >
                                        {statuses.map((status) => (
                                            <option
                                                key={status.value}
                                                value={status.value}
                                            >
                                                {status.label}
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
WordInfo.getLayout = (page) => (
    <DashboardLayout>
        {page}
    </DashboardLayout>
);

export default WordInfo;
