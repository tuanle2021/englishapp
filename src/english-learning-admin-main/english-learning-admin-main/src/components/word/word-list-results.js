import { useState, useEffect } from "react";
import PerfectScrollbar from "react-perfect-scrollbar";
import PropTypes from "prop-types";
import DeleteIcon from "@mui/icons-material/Delete";
import NotificationsIcon from "@mui/icons-material/Notifications";
import EditIcon from "@mui/icons-material/Edit";
import AddIcon from "@mui/icons-material/Add";
import { useRouter } from "next/router";
import axios from "axios";
import AddWordDialog from "../../components/word/addWordDialog";
import AddSentenceDialog from "../../components/sentence/addSentenceDialog";
import CheckCircleIcon from "@mui/icons-material/CheckCircle";
import CancelIcon from "@mui/icons-material/Cancel";

import { format } from "date-fns";
import {
  Avatar,
  Button,
  Box,
  Card,
  Checkbox,
  Table,
  TableBody,
  TableCell,
  TableHead,
  TablePagination,
  TableContainer,
  TableRow,
  Typography,
} from "@mui/material";
import { getInitials } from "../../utils/get-initials";
import { words } from "src/_datas_/words";

import popUpAddWord from "./addWordDialog";

const axiosApiCall = (url, method, headers = {}, data) =>
  axios({
    method,
    url: `http://localhost:3001/${url}`,
    data: data,
    headers: headers,
  });

export const WordListResults = ({ ...props }) => {
  const router = useRouter();

  const [selectedWordIds, setSelectedWordIds] = useState([]);
  const [Words, setWords] = useState(props.Words);

  const [limit, setLimit] = useState(10);

  const [openEdit, setOpenEdit] = useState(false);

  // **pagination
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(10);

  useEffect(() => {
    setWords(props.Words);
    console.log("fd", Words);
  }, []);

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };

  const handleEdit = (word_id) => {
    // console.log(word_id);
    router.push("/words/" + word_id);
  };
  const handleAddSentence = (word_id) => {
    console.log(word_id);
    router.push("/sentences/add-sentence/" + word_id);
  };

  const handleAddQuiz = (word_id) => {
    // console.log(word_id);
    router.push("/quizzes/add-quizz?word_id=" + word_id);
  };

  

  

 

  return (
    <Card {...props}>
      <PerfectScrollbar>
        <Box sx={{ minWidth: 1050 }}>
          <TableContainer >
            <Table sx={{tableLayout:"auto"}}>
              <TableHead>
                <TableRow>

                  <TableCell>Word</TableCell>
                  <TableCell>Definitions </TableCell>
                  <TableCell>Synonyms</TableCell>
                  <TableCell>Pharses</TableCell>
                  <TableCell>Mean</TableCell>
                  <TableCell>Image</TableCell>
                  {/* <TableCell>Sentences</TableCell> */}
                  <TableCell>Quiz</TableCell>
                  <TableCell>Quick Edit</TableCell>
                  <TableCell align="center">Edit</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {(rowsPerPage > 0
                  ? props.Words.slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
                  : props.Words).map((Word) => (
                    <TableRow hover key={Word.id} selected={selectedWordIds.indexOf(Word.id) !== -1}>

                      <TableCell>
                        <Box
                          sx={{
                            alignItems: "center",
                            display: "flex",
                          }}
                        >
                          {/* <Avatar
                                                src={Word.avatarUrl}
                                                sx={{ mr: 2 }}
                                            >
                                                {getInitials(Word.name)}
                                            </Avatar> */}
                          <Typography color="textPrimary" variant="body1">
                            {Word.word}
                          </Typography>
                        </Box>
                      </TableCell>
                      <TableCell style={{ width: 50 }}>{Word.definitions}</TableCell>
                      <TableCell style={{ width: 50 }}>{(Word.synonyms && Word.synonyms.length) > 50 ? Word.synonyms.slice(0, 50) :Word.synonyms}</TableCell>
                      <TableCell style={{ width: 50 }}>{Word.phrases}</TableCell>
                      <TableCell style={{ width: 50 }}>{Word.mean}</TableCell>
                     
                      {Word.image != undefined ? (
                        <TableCell>
                          <CheckCircleIcon color="secondary"></CheckCircleIcon>
                        </TableCell>
                      ) : (
                        <TableCell>
                          <CancelIcon color="action"></CancelIcon>
                        </TableCell>
                      )}
                      {/* <TableCell>
                    <AddSentenceDialog
                      handleAddSentence={props.handleAddSentence}
                      Word={Word}
                      listLessons={props.listLessons}
                    ></AddSentenceDialog>
                  </TableCell> */}

                      {/* add Quiz through word list */}
                      <TableCell>
                        <Button
                          variant="outlined"
                          size="small"
                          sx={{ mr: 2 }}
                          onClick={() => handleAddQuiz(Word._id)}
                        >
                          <AddIcon sx={{ fontSize: 15 }}></AddIcon>
                        </Button>
                      </TableCell>
                      {/* add Quiz through word list */}

                      <TableCell>
                        <AddWordDialog
                          handleEditWord={props.handleEditWord}
                          Word={Word}
                          listCategories={props.listCategories}
                        ></AddWordDialog>
                      </TableCell>
                      <TableCell align="center">
                        <Button
                          variant="outlined"
                          size="small"
                          sx={{ mr: 2 }}
                          onClick={() => handleEdit(Word._id)}
                        >
                          <EditIcon sx={{ fontSize: 15 }}></EditIcon>
                        </Button>
                        {/* <Button
                      variant="contained"
                      color="error"
                      size="small"
                      onClick={() => handleDeleteIcon(Word._id)}
                    >
                      <DeleteIcon sx={{ fontSize: 15 }}></DeleteIcon>
                    </Button> */}
                      </TableCell>
                    </TableRow>
                  ))}
              </TableBody>
            </Table>
          </TableContainer>
        </Box>
      </PerfectScrollbar>
      <TablePagination
        component="div"
        colSpan={5}
        count={props.Words.length}
        page={page}
        rowsPerPage={rowsPerPage}
        rowsPerPageOptions={[5, 10, 25, { label: 'All', value: -1 }]}
        onPageChange={handleChangePage}
        onRowsPerPageChange={handleChangeRowsPerPage}
      />
    </Card>
  );
};

WordListResults.propTypes = {
  Words: PropTypes.array.isRequired,
};
