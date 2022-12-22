import Head from "next/head";
import NextLink from "next/link";
import { useRouter } from "next/router";
import { useFormik } from "formik";
import * as Yup from "yup";
import { Box, Button, Container, Grid, Link, TextField, Typography } from "@mui/material";
import Cookie from "js-cookie";
import { useEffect } from "react";


const Logout = () => {
  const router = useRouter();
 

  useEffect(() => {
    Cookie.set('user',"");
    Cookie.set('accesstoken',"");
    router.push("/login")
    
  }, []);
  return (
    <>
     
    </>
  );
};

export default Logout;
