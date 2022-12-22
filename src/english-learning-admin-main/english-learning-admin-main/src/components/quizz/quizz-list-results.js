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

const axiosApiCall = (url, method, headers = {}, data) =>
  axios({
    method,
    url: `http://localhost:3001/${url}`,
    data: data,
    headers: headers,
  });

export const QuizzListResults = ({ ...props }) => {
  const router = useRouter();

  const [selectedQuizzIds, setSelectedQuizzIds] = useState([]);
  const [Quizzes, setQuizzes] = useState([]);

  const [limit, setLimit] = useState(10);
  // const [page, setPage] = useState(0);

  // **pagination
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(10);

  // Avoid a layout jump when reaching the last page with empty rows.
  const emptyRows =
    page > 0 ? Math.max(0, (1 + page) * rowsPerPage - props.Quizzes.length) : 0;

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };


  useEffect(() => {
    setQuizzes(props.Quizzes);
    console.log("fd", Quizzes);
  }, []);




  const handleLimitChange = (event) => {
    setLimit(event.target.value);
  };

  const handlePageChange = (event, newPage) => {
    setPage(newPage);
  };

 

  const handleDeleteIcon = (id) => {
    console.log(id);
    axiosApiCall(`Quizz/delete/${id}`, "get", "", "")
      .then((res) => {
        setQuizzes(res.data);
      })
      .catch(function (error) {
        console.log("Bị lỗi tải");
      });
  };

  return (
    <Card {...props}>
      <PerfectScrollbar>
        <Box sx={{ minWidth: 1050 }}>
          <Table>
            <TableHead>
              <TableRow>
                {/* <TableCell padding="checkbox">
                  <Checkbox
                    checked={selectedQuizzIds.length === Quizzes.length}
                    color="primary"
                    indeterminate={
                      selectedQuizzIds.length > 0 && selectedQuizzIds.length < Quizzes.length
                    }
                    onChange={handleSelectAll}
                  />
                </TableCell> */}
                <TableCell>Quizz</TableCell>
                <TableCell>Quizz Type </TableCell>
                <TableCell>Word </TableCell>

                <TableCell align="center">Edit</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>

              {(rowsPerPage > 0
                ? props.Quizzes.slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
                : props.Quizzes).map((Quizz) => (
                  <TableRow hover key={Quizz.id} selected={selectedQuizzIds.indexOf(Quizz.id) !== -1}>
                    <TableCell>
                      <Box
                        sx={{
                          alignItems: "center",
                          display: "flex",
                        }}
                      >
                        <Typography color="textPrimary" variant="body1">
                          {Quizz.name}
                        </Typography>
                      </Box>
                    </TableCell>
                    <TableCell>{Quizz.quizz_type}</TableCell>
                    <TableCell ><a href={"/words/" + Quizz.word_id}>{Quizz.word}</a></TableCell>

                    <TableCell align="center">
                      <Button
                        variant="outlined"
                        size="small"
                        sx={{ mr: 2 }}
                        // onClick={() => handleEdit(Quizz.id, Quizz.word_id, Quizz.quizz_type)}
                        href={"/quizzes/" + Quizz.id + "?quizz_type=" + Quizz.quizz_type + "&word_id=" + Quizz.word_id}
                        target="_blank"
                      >
                        <EditIcon sx={{ fontSize: 15 }}></EditIcon>
                      </Button>
                      <Button
                        variant="contained"
                        color="error"
                        size="small"
                        onClick={() => props.handleDelete(Quizz.id)}
                      >
                        <DeleteIcon sx={{ fontSize: 15 }}></DeleteIcon>
                      </Button>
                    </TableCell>
                  </TableRow>
                ))}
              {emptyRows > 0 && (
                <TableRow style={{ height: 53 * emptyRows }}>
                  <TableCell colSpan={6} />
                </TableRow>
              )}
            </TableBody>
          </Table>
        </Box>
      </PerfectScrollbar>
      <TablePagination
        component="div"
        colSpan={5}
        count={props.Quizzes.length}
        // onPageChange={handlePageChange}
        // onRowsPerPageChange={handleLimitChange}
        page={page}
        rowsPerPage={rowsPerPage}
        rowsPerPageOptions={[5, 10, 25, { label: 'All', value: -1 }]}
        onPageChange={handleChangePage}
        onRowsPerPageChange={handleChangeRowsPerPage}
      />
    </Card>
  );
};

QuizzListResults.propTypes = {
  Quizzes: PropTypes.array.isRequired,
};
