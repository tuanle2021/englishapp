import Head from "next/head";
import { Box, Container } from "@mui/material";
import { LessonListResults } from "../../components/lesson/lesson-list-results";
import { LessonListToolbar } from "../../components/lesson/lesson-list-toolbar";
import { DashboardLayout } from "../../components/dashboard-layout";
import { useState, useEffect } from "react";
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
const LessonsList = () => {
  const [search, setSearch] = useState(null);
  const [lessons, setLessons] = useState([]);

  const onChange_Search = (event) => {
    setSearch(event.target.value);
  };

  useEffect(() => {
    /*async function fetchData() {
      let url = "../api/Lessons/Lessons-list";
      if (search) {
        url += "?search=" + search;
      }
      const repsonse = await fetch(url);
      const result = await repsonse.json();
      setLessons(result.Lessons);
    }
    fetchData();*/
    axiosApiCall(`lesson/all`, "get", headers, "")
      .then((res) => {
        console.log("Bị lỗi tải",res.data);

        setLessons(res.data);
      })
      .catch(function (error) {
        console.log("Bị lỗi tải",error);
      });
  }, [search]);

  const handleDelete = (id) => {
    console.log(id);
    axiosApiCall(`lesson/delete/${id}`, "get", headers, "")
      .then((res) => {
        console.log("da delete");
        console.log(res.data);
        setLessons(res.data);
        console.log(Lessons);
      })
      .catch(function (error) {
        console.log("Bị lỗi tải");
      });
  };

  return (
    <>
      <Head>
        <title>Lessons | Material Kit</title>
      </Head>
      <Box
        component="main"
        sx={{
          flexGrow: 1,
          py: 8,
        }}
      >
        <Container maxWidth={false}>
          <LessonListToolbar onChange={onChange_Search} />
          <Box sx={{ mt: 3 }}>
            <LessonListResults {...{ Lessons: lessons, search: search, handleDelete: handleDelete }} />
          </Box>
        </Container>
      </Box>
    </>
  );
};
LessonsList.getLayout = (page) => <DashboardLayout>{page}</DashboardLayout>;

export default LessonsList;
