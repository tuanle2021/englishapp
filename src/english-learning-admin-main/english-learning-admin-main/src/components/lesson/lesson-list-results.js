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

export const LessonListResults = ({ ...props }) => {
  const router = useRouter();

  const [selectedLessonIds, setSelectedLessonIds] = useState([]);
  const [Lessons, setLessons] = useState(props.Lessons);

  const [limit, setLimit] = useState(10);
    // **pagination
    const [page, setPage] = useState(0);
    const [rowsPerPage, setRowsPerPage] = useState(10);

  useEffect(() => {
    setLessons(props.Lessons);
    console.log("fd", Lessons);
  }, []);
  const handleSelectAll = (event) => {
    let newSelectedLessonIds;

    if (event.target.checked) {
      newSelectedLessonIds = Lessons.map((Lesson) => Lesson.id);
    } else {
      newSelectedLessonIds = [];
    }

    setSelectedLessonIds(newSelectedLessonIds);
  };
  

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };

  const handleEdit = (lesson_id) => {
    // console.log(Lesson_id);
    router.push("/lessons/" + lesson_id);
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
               
                <TableCell>Name</TableCell>
                <TableCell>Description</TableCell>
                <TableCell>Subcategory</TableCell>
                <TableCell align="center">Edit</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
               {(rowsPerPage > 0
                ? props.Lessons.slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
                : props.Lessons).map((lesson) => (
                <TableRow hover key={lesson.id} selected={selectedLessonIds.indexOf(lesson.id) !== -1}>
                
                  <TableCell>{lesson.name}</TableCell>
                  <TableCell>{lesson.description !== null ? lesson.description : ""}</TableCell>

                  <TableCell>{lesson.subCategoryId !== null ? lesson.subCategoryId.name : ""}</TableCell>

                  <TableCell align="center">
                    <Button
                      variant="outlined"
                      size="small"
                      sx={{ mr: 2 }}
                      onClick={() => handleEdit(lesson._id)}
                    >
                      <EditIcon sx={{ fontSize: 15 }}></EditIcon>
                    </Button>
                    <Button
                      variant="contained"
                      color="error"
                      size="small"
                      onClick={() => handleDeleteIcon(lesson._id)}
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
       colSpan={5}
       count={props.Lessons.length}
       page={page}
       rowsPerPage={rowsPerPage}
       rowsPerPageOptions={[5, 10, 25, { label: 'All', value: -1 }]}
       onPageChange={handleChangePage}
       onRowsPerPageChange={handleChangeRowsPerPage}
      />
    </Card>
  );
};

LessonListResults.propTypes = {
  Lessons: PropTypes.array.isRequired,
};
