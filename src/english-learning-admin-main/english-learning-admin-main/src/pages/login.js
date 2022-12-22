import Head from "next/head";
import NextLink from "next/link";
import { useRouter } from "next/router";
import { useFormik } from "formik";
import * as Yup from "yup";
import { Box, Button, Container, Grid, Link, TextField, Typography } from "@mui/material";
import ArrowBackIcon from "@mui/icons-material/ArrowBack";
import { Facebook as FacebookIcon } from "../icons/facebook";
import { Google as GoogleIcon } from "../icons/google";
import axios from "axios";
import Cookie from "js-cookie";
import { useEffect } from "react";
// import { userService } from 'services';
const axiosApiCall = (url, method, body = {}) =>
  axios({
    method,
    url: `http://localhost:3001/${url}`,
    data: body,
  });

const Login = () => {
  const router = useRouter();
  const formik = useFormik({
    initialValues: {
      username: "",
      password: "",
    },
    validationSchema: Yup.object({
      username: Yup.string().max(255).required("username is required"),
      password: Yup.string().max(255).required("Password is required"),
    }),
    onSubmit: (values) => {
      console.log("hello");
      const data = { username: values.username, password: values.password };

      axiosApiCall(`auth/login`, "post", values)
        .then((res) => {
          console.log(res);
          if(res.data.error){
            alert(res.data.error)
          
          }else{
            console.log("login succeess",res.data);
            Cookie.set("user", JSON.stringify(res.data.user));
            Cookie.set("accesstoken", res.data.access_token);
            router.push("/");
          }
          
        })
        .catch(function (error) {
          alert(error);
          console.log(error);
        });
    },

   
  });

  useEffect(() => {
    if ((Cookie.get('accesstoken') != undefined || Cookie.get('accesstoken') != "") && Cookie.get('accesstoken')  ) {
      router.push("/");
    }
  }, []);
  return (
    <>
      <Head>
        <title>Login | Material Kit</title>
      </Head>
      <Box
        component="main"
        sx={{
          alignItems: "center",
          display: "flex",
          flexGrow: 1,
          minHeight: "100%",
        }}
      >
        <Container maxWidth="sm">
          <form onSubmit={formik.handleSubmit}>
            <Box sx={{ my: 3 }}>
              <Typography color="textPrimary" variant="h4">
                Sign in
              </Typography>
              <Typography color="textSecondary" gutterBottom variant="body2">
                Sign in to app TA management
              </Typography>
            </Box>
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
              required
            />
            <TextField
              error={Boolean(formik.touched.password && formik.errors.password)}
              fullWidth
              helperText={formik.touched.password && formik.errors.password}
              label="Password"
              margin="normal"
              name="password"
              onBlur={formik.handleBlur}
              onChange={formik.handleChange}
              type="password"
              value={formik.values.password}
              variant="outlined"
              required
            />
            <Box sx={{ py: 2 }}>
              <Button
                color="primary"
                fullWidth
                size="large"
                type="submit"
                variant="contained"
                onClick={formik.handleSubmit}
              >
                Sign In Now
              </Button>
            </Box>
          </form>
        </Container>
      </Box>
    </>
  );
};

export default Login;
