import Head from "next/head";
import { Box, Container } from "@mui/material";
import { WordListResults } from "../../components/word/word-list-results";
import { WordListToolbar } from "../../components/word/word-list-toolbar";
import { DashboardLayout } from "../../components/dashboard-layout";
import { useState, useEffect } from "react";
import { useRouter } from "next/router";
import axios from "axios";
import Cookie from "js-cookie";

const axiosApiCall = (url, method, headers = {}, data) =>
  axios({
    method,
    url: `http://localhost:3001/${url}`,
    data: data,
    headers: headers,
  });
// @refresh reset
const WordsList = () => {
  const router = useRouter();
  const [search, setSearch] = useState(null);
  const [Words, setWords] = useState([]);

  const [wordlist, setwordlist] = useState([]);
  let access_token = Cookie.get("accesstoken");
  const headers = { authorization: "Bearer " + access_token };

  const [listCategories, setListCategories] = useState([]);
  const [listLessons, setListLessons] = useState([]);

  const onChange_Search = (event) => {
    if (event.target.value != "") {
      const searchWord = event.target.value ;
      const word_filter_list = Words.filter(word =>{
        return word.word.includes(searchWord) ;
      })

      setwordlist(word_filter_list);
    }
  };

  useEffect(() => {
    if (access_token == undefined) {
      router.push("/login");
      return;
    }
    axiosApiCall(`category/all`, "get", headers, "")
      .then((res) => {
        //setWords(res.data);
        let results = [];
        if (res.data.length == 1) {
          results = res.data;
        }

        results.push(res.data);

        setListCategories(res.data);
      })
      .catch(function (error) {
        console.log("Bị lỗi tải");
      });

    axiosApiCall(`lesson/all`, "get", headers, "")
      .then((res) => {
        console.log("lesson ne");
        //setWords(res.data);
        let results = [];
        if (res.data.length == 1) {
          console.log("hell");
          results = res.data;
          console.log(results);
        }
        console.log("ấdfsfsf");
        results.push(res.data);
        setListLessons(res.data);
        console.log(res.data);
        console.log("add ");
      })
      .catch(function (error) {
        console.log("Bị lỗi tải");
      });

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
    axiosApiCall(`word/all`, "get", headers, "")
      .then((res) => {
        setWords(res.data);
        setwordlist(res.data);
        console.log(res.data)
      })
      .catch(function (error) {
        console.log("Bị lỗi tải");
        console.log(error);
      });
  }, [search]);

  const handleDelete = (id) => {
    axiosApiCall(`word/delete/${id}`, "get", headers, "")
      .then((res) => {
        setWords(res.data);
      })
      .catch(function (error) {
        console.log("Bị lỗi tải");
        console.log(error);
      });
  };

  const handleEditWord = (values) => {
    axiosApiCall(`word/update/${values._id}`, "post", headers, values)
      .then((res) => {
        //router.push("/words/words-list");

        let newWords = [];

        for (let i = 0; i < Words.length; i++) {
          if (Words[i]._id === res.data._id) {
            newWords.push(res.data);
          } else {
            newWords.push(Words[i]);
          }
        }

        setWords(newWords);
      })
      .catch(function (error) {
        console.log("Bị lỗi tải");
      });
  };

  const handleAddSentence = (values) => {
    let data = {
      lesson: values.lesson,
      related_word_id: values.related_word_id,
      original: [{ language: "en-us", content: values.original }],
      translated: [
        {
          language: "vn",
          content: values.translated,
        },
      ],
    };
    console.log("add sentence");
    console.log(data);
    axiosApiCall(`sentence`, "post", headers, data)
      .then((res) => {
        console.log("new sentence ne");
        console.log(res.data);
      })
      .catch(function (error) {
        console.log("Bị lỗi tải");
      });
  };

  return (
    <>
      <Head>
        <title>Words | Material Kit</title>
      </Head>
      <Box
        component="main"
        sx={{
          flexGrow: 1,
          py: 8,
        }}
      >
        <Container maxWidth={false}>
          <WordListToolbar onChange={onChange_Search} />
          <Box sx={{ mt: 3 }}>
            <WordListResults
              {...{
                Words: wordlist,
                search: search,
                handleDelete: handleDelete,
                handleEditWord: handleEditWord,
                handleAddSentence: handleAddSentence,
                listCategories: listCategories,
                listLessons: listLessons,
              }}
            />
          </Box>
        </Container>
      </Box>
    </>
  );
};
WordsList.getLayout = (page) => <DashboardLayout>{page}</DashboardLayout>;

export default WordsList;
