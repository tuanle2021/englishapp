import Head from "next/head";
import { Box, Container } from "@mui/material";
import { QuizzListResults } from "../../components/quizz/quizz-list-results";
import { QuizzListToolbar } from "../../components/quizz/quizz-list-toolbar";
import { DashboardLayout } from "../../components/dashboard-layout";
import { useState, useEffect } from "react";
import axios from "axios";

const axiosApiCall = (url, method, headers = {}, data) =>
  axios({
    method,
    url: `http://localhost:3001/${url}`,
    data: data,
    headers: headers,
    withCredentials: false,
  });

// @refresh reset
const QuizzesList = () => {
  const [search, setSearch] = useState(null);
  const [quizzes, setquizzes] = useState([]);
  const [quizzeslist, setQuizzeslist] = useState([]);

  const onChange_Search = (event) => {
    if (event.target.value != "") {
      const searchQuizz = event.target.value ;
      const quizz_filter_list = quizzes.filter(quizz =>{
        return quizz.name.includes(searchQuizz) ;
      })

      setQuizzeslist(quizz_filter_list);
    }else{
      setQuizzeslist(quizzes);
      
    }
  };

  const handleDelete = (id) => {
    alert("You want to delete this quizzes");
    axiosApiCall(`quiz/delete/${id}`, "get", "", "")
      .then((res) => {
        setquizzes(res.data);
      })
      .catch(function (error) {
        console.log("Bị lỗi tải");
      });
  };

  useEffect(() => {
   
    axiosApiCall(`quiz/all`, "get", "", "")
      .then((res) => {

        let quizz_list_state = [];
        res.data.forEach((quizz_list) => {
          quizz_list.forEach((quizz) => quizz_list_state.push({
            id: quizz._id, name: quizz.name,
            quizz_type: quizz.type,
            word:  quizz.wordId.word,
            word_id:quizz.wordId._id 
          }));
        });


        setquizzes(quizz_list_state);
        setQuizzeslist(quizz_list_state)
      })
      .catch(function (error) {
        console.log("Bị lỗi tải", error);
      });
  }, [search]);

  return (
    <>
      <Head>
        <title>quizzes | Material Kit</title>
      </Head>
      <Box
        component="main"
        sx={{
          flexGrow: 1,
          py: 8,
        }}
      >
        <Container maxWidth={false}>
          <QuizzListToolbar onChange={onChange_Search} />
          <Box sx={{ mt: 3 }}>
            <QuizzListResults {...{ Quizzes: quizzeslist, search: search, handleDelete: handleDelete }} />
          </Box>
        </Container>
      </Box>
    </>
  );
};
QuizzesList.getLayout = (page) => <DashboardLayout>{page}</DashboardLayout>;

export default QuizzesList;