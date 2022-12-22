import Head from "next/head";
import { Box, Container } from "@mui/material";
import { CategoryListResults } from "../../components/category/category-list-results";
import { CategoryListToolbar } from "../../components/category/category-list-toolbar";
import { DashboardLayout } from "../../components/dashboard-layout";
import { useState, useEffect } from "react";
import axios from "axios";
import Cookie from "js-cookie";
import { Router } from "next/router";
import { useRouter } from "next/router";

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
const CategoriesList = () => {

  const router = useRouter();

  const [search, setSearch] = useState(null);
  const [Categories, setCategories] = useState([]);

  const onChange_Search = (event) => {
    setSearch(event.target.value);
  };

  const handleDelete = (id) => {
    alert("You want to delete this category");
    axiosApiCall(`category/delete/${id}`, "get", headers, "")
      .then((res) => {
        axiosApiCall(`category/all`, "get", headers, "")
          .then((res) => {
            console.log(res.data);
            setCategories(res.data);
          })
          .catch(function (error) {
            console.log("Bị lỗi tải");
          });
      })
      .catch(function (error) {
        console.log("Bị lỗi tải");
      });
  };

  useEffect(() => {
    /*async function fetchData() {
      let url = "../api/words/words-list";
      if (search) {
        url += "?search=" + search;
      }
      const repsonse = await fetch(url);
      const result = await repsonse.json();
      setWords(result.words);
    }
    fetchData();*/
    axiosApiCall(`category/all`, "get", headers, "")
      .then((res) => {
        console.log(res.data);
        setCategories(res.data);
      })
      .catch(function (error) {
        console.log("Bị lỗi tải");
      });
  }, [search]);



  return (
    <>
      <Head>
        <title>Words | Material Kit</title>
      </Head>
      {
        <Box
          component="main"
          sx={{
            flexGrow: 1,
            py: 8,
          }}
        >
          <Container maxWidth={false}>
            <CategoryListToolbar onChange={onChange_Search} />
            <Box sx={{ mt: 3 }}>
              <CategoryListResults {...{ Categories: Categories, search: search, handleDelete: handleDelete }} />
            </Box>
          </Container>
        </Box>
      }
    </>
  );
};
CategoriesList.getLayout = (page) => <DashboardLayout>{page}</DashboardLayout>;

export default CategoriesList;
