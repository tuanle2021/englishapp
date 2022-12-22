import { useState, useEffect } from "react";
import PerfectScrollbar from "react-perfect-scrollbar";
import PropTypes from "prop-types";
import DeleteIcon from "@mui/icons-material/Delete";
import EditIcon from "@mui/icons-material/Edit";
import { useRouter } from "next/router";
import axios from "axios";
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
  TableRow,
  Typography,
} from "@mui/material";
import { getInitials } from "../../utils/get-initials";
import { words } from "src/_datas_/words";

const axiosApiCall = (url, method, headers = {}, data) =>
  axios({
    method,
    url: `http://localhost:3001/${url}`,
    data: data,
    headers: headers,
  });

export const SentenceListResults = ({ ...props }) => {
  const router = useRouter();

  //const [selectedWordIds, setSelectedWordIds] = useState([]);
  //const [Words, setWords] = useState(props.Words);
  const [Sentences, setSentences] = useState(props.Sentences);

  const [limit, setLimit] = useState(10);
  const [page, setPage] = useState(0);

  useEffect(() => {
    console.log("hello");
    setSentences(props.Sentences);
    console.log("fd", Sentences);
  }, []);
  /*const handleSelectAll = (event) => {
    let newSelectedWordIds;

    if (event.target.checked) {
      newSelectedWordIds = Words.map((Word) => Word.id);
    } else {
      newSelectedWordIds = [];
    }

    setSelectedWordIds(newSelectedWordIds);
  };*/

  /*const handleSelectOne = (event, id) => {
    const selectedIndex = selectedWordIds.indexOf(id);
    let newSelectedWordIds = [];

    if (selectedIndex === -1) {
      newSelectedWordIds = newSelectedWordIds.concat(selectedWordIds, id);
    } else if (selectedIndex === 0) {
      newSelectedWordIds = newSelectedWordIds.concat(selectedWordIds.slice(1));
    } else if (selectedIndex === selectedWordIds.length - 1) {
      newSelectedWordIds = newSelectedWordIds.concat(selectedWordIds.slice(0, -1));
    } else if (selectedIndex > 0) {
      newSelectedWordIds = newSelectedWordIds.concat(
        selectedWordIds.slice(0, selectedIndex),
        selectedWordIds.slice(selectedIndex + 1)
      );
    }

    setSelectedWordIds(newSelectedWordIds);
  };*/

  const handleLimitChange = (event) => {
    setLimit(event.target.value);
  };

  const handlePageChange = (event, newPage) => {
    setPage(newPage);
  };

  const handleEdit = (sentence_id) => {
    // console.log(word_id);
    router.push("/sentences/" + sentence_id);
  };

  /*const handleDeleteIcon = (id) => {
    props.handleDelete(id);
  };*/

  return (
    <Card {...props}>
      <PerfectScrollbar>
        <Box sx={{ minWidth: 1050 }}>
          <Table>
            <TableHead>
              <TableRow>
                <TableCell padding="checkbox"></TableCell>
                <TableCell>Word</TableCell>
                <TableCell>Content </TableCell>
                <TableCell>Translate</TableCell>
                <TableCell>Lesson</TableCell>
                <TableCell align="center">Edit</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {props.Sentences.slice(0, limit).map((Sentence) => (
                <TableRow
                  hover
                  key={Sentence._id}
                  //selected={selectedWordIds.indexOf(Sentence._id) !== -1}
                >
                  <TableCell padding="checkbox">
                    <Checkbox
                      //checked={selectedWordIds.indexOf(Sentence._id) !== -1}
                      onChange={(event) => handleSelectOne(event, Sentence._id)}
                      value="true"
                    />
                  </TableCell>
                  <TableCell>
                    <Box
                      sx={{
                        alignItems: "center",
                        display: "flex",
                      }}
                    >
                      <Typography color="textPrimary" variant="body1">
                        {Sentence.related_word_id !== null  ? Sentence.related_word_id.word : ""}
                      </Typography>
                    </Box>
                  </TableCell>
                  <TableCell>{Sentence.original[0].content}</TableCell>
                  <TableCell>{Sentence.translated[0].content}</TableCell>
                  <TableCell>{Sentence.lesson !== null ?Sentence.lesson.name: ""}</TableCell>
                  <TableCell align="center">
                    <Button
                      variant="outlined"
                      size="small"
                      sx={{ mr: 2 }}
                      onClick={() => handleEdit(Sentence._id)}
                    >
                      <EditIcon sx={{ fontSize: 15 }}></EditIcon>
                    </Button>
                    <Button
                      variant="contained"
                      color="error"
                      size="small"
                      onClick={() => handleDeleteIcon(Word._id)}
                    >
                      <DeleteIcon sx={{ fontSize: 15 }}></DeleteIcon>
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </Box>
      </PerfectScrollbar>
      <TablePagination
        component="div"
        count={Sentences.length}
        onPageChange={handlePageChange}
        onRowsPerPageChange={handleLimitChange}
        page={page}
        rowsPerPage={limit}
        rowsPerPageOptions={[5, 10, 25]}
      />
    </Card>
  );
};

SentenceListResults.propTypes = {
  Sentences: PropTypes.array.isRequired,
};
