import Head from "next/head";
import { Box, Container } from "@mui/material";
import { SubcategoryListResults } from "../../components/subcategory/subcategory-list-results";
import { SubcategoryListToolbar } from "../../components/subcategory/subcategory-list-toolbar";
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
const SubcategoriesList = () => {
  const [search, setSearch] = useState(null);
  const [subcategories, setSubcategories] = useState([]);

  const onChange_Search = (event) => {
    setSearch(event.target.value);
  };
 
  const handleDelete = (id) => {
    alert("You want to delete this Subcategory");
    axiosApiCall(`subcategory/delete/${id}`, "get", headers, "")
      .then((res) => {
        axiosApiCall(`category/all`, "get", headers, "")
          .then((res) => {
            console.log(res.data);
            setSubcategories(res.data);
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
      let url = "../api/Minilevels/Minilevels-list";
      if (search) {
        url += "?search=" + search;
      }
      const repsonse = await fetch(url);
      const result = await repsonse.json();
      setMinilevels(result.Minilevels);
    }
    fetchData();*/
    axiosApiCall(`subcategory/all`, "get", headers, "")
      .then((res) => {
        setSubcategories(res.data);
      })
      .catch(function (error) {
        console.log("Bị lỗi tải");
      });
  }, [search]);

  

  return (
    <>
      <Head>
        <title>Subcategories | Material Kit</title>
      </Head>
      <Box
        component="main"
        sx={{
          flexGrow: 1,
          py: 8,
        }}
      >
        <Container maxWidth={false}>
          <SubcategoryListToolbar onChange={onChange_Search} />
          <Box sx={{ mt: 3 }}>
            <SubcategoryListResults {...{ Subcategories: subcategories, search: search, handleDelete: handleDelete }} />
          </Box>
        </Container>
      </Box>
    </>
  );
};
SubcategoriesList.getLayout = (page) => <DashboardLayout>{page}</DashboardLayout>;

export default SubcategoriesList;
