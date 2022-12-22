import Head from "next/head";
import { Box, Container } from "@mui/material";
import { SentenceListResults } from "../../components/sentence/sentence-list-results";
import { SentenceListToolbar } from "../../components/sentence/sentence-list-toolbar";
import { DashboardLayout } from "../../components/dashboard-layout";
import { useState, useEffect } from "react";
import axios from "axios";

const axiosApiCall = (url, method, headers = {}, data) =>
  axios({
    method,
    url: `http://localhost:3001/${url}`,
    data: data,
    headers: headers,
  });
// @refresh reset
const SentencesList = () => {
  const [search, setSearch] = useState(null);
  const [Sentences, setSentences] = useState([]);

  const onChange_Search = (event) => {
    setSearch(event.target.value);
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

    axiosApiCall(`sentence/all?path=lesson,related_word_id`, "get", "", "")
      .then((res) => {
        console.log("sentence");
        console.log(res.data);
        setSentences(res.data);
      })
      .catch(function (error) {
        console.log("Bị lỗi tải");
      });
  }, [search]);

  /*const handleDelete = (id) => {
    console.log(id);
    axiosApiCall(`word/delete/${id}`, "get", "", "")
      .then((res) => {
        console.log("da delete");
        console.log(res.data);
        setWords(res.data);
        console.log(words);
      })
      .catch(function (error) {
        console.log("Bị lỗi tải");
      });
  };*/

  return (
    <>
      <Head>
        <title> Sentences | Material Kit </title>
      </Head>
      <Box
        component="main"
        sx={{
          flexGrow: 1,
          py: 8,
        }}
      >
        <Container maxWidth={false}>
          <SentenceListToolbar onChange={onChange_Search} />
          <Box sx={{ mt: 3 }}>
            <SentenceListResults {...{ Sentences: Sentences, search: search }} />
          </Box>
        </Container>
      </Box>
    </>
  );
};
SentencesList.getLayout = (page) => <DashboardLayout> {page} </DashboardLayout>;

export default SentencesList;
