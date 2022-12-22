// import '../styles/globals.css'
import Head from 'next/head';
import { CacheProvider } from '@emotion/react';
import LocalizationProvider from '@mui/lab/LocalizationProvider';
import AdapterDateFns from '@mui/lab/AdapterDateFns';
import { CssBaseline } from '@mui/material';
import { ThemeProvider } from '@mui/material/styles';
import { createEmotionCache } from '../utils/create-emotion-cache';
import { theme } from '../theme';
import { Box, Container } from '@mui/material';
import { useState, useEffect } from 'react';
import { useRouter } from 'next/router';
import Cookie from "js-cookie";
import axios from "axios";


let access_token = Cookie.get("accesstoken");
const headers = { authorization: "Bearer " + access_token };

const clientSideEmotionCache = createEmotionCache();
const axiosApiCall = (url, method, headers = {}, data) =>
  axios({
    method,
    url: `http://localhost:3001/${url}`,
    data: data,
    headers: headers,
  });
const App = (props) => {
  const { Component, emotionCache = clientSideEmotionCache, pageProps } = props;
  const [user, setUser] = useState(null);
  const router = useRouter();

  const getLayout = Component.getLayout ?? ((page) => page);

  useEffect(() => {
    authCheck(router.asPath);

  }, []);


  function authCheck(url) {
    // redirect to login page if accessing a private page and not logged in 
    const publicPaths = ['/login'];
    const path = url.split('?')[0];
    if ((Cookie.get('accesstoken') == undefined || Cookie.get('accesstoken') == "") && !publicPaths.includes(path)) {
      router.push({
        pathname: '/login',
        query: { returnUrl: router.asPath }
      });
    } else {


      if (Cookie.get('user') != undefined && Cookie.get('user') != "") {
        const user_id = JSON.parse(Cookie.get('user'))._id;

        axiosApiCall(`user/${user_id}`, "get", headers, "")
          .then((res) => {

          })
          .catch(function (error) {
            Cookie.set('user', "");
            Cookie.set('accesstoken', "");
            router.push("/login");

          });
      }
    }


    // check session available

  }
  return (
    <CacheProvider value={emotionCache}>

      <Head>
        <title>
          Material Kit Pro
        </title>
        <meta
          name="viewport"
          content="initial-scale=1, width=device-width"
        />
      </Head>
      <LocalizationProvider dateAdapter={AdapterDateFns}>
        <ThemeProvider theme={theme}>
          <CssBaseline />
          {getLayout(<Component {...pageProps} />)}
        </ThemeProvider>
      </LocalizationProvider>
    </CacheProvider>
  );
};
export default App
