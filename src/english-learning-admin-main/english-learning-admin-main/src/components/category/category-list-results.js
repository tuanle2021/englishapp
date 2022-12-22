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

export const CategoryListResults = ({ ...props }) => {
  const router = useRouter();

  const [selectedCategoryIds, setSelectedCategoryIds] = useState([]);
  const [Categories, setCategories] = useState(props.Categories);

  const [limit, setLimit] = useState(10);
  const [page, setPage] = useState(0);

  useEffect(() => {
    setCategories(props.Categories);
    console.log("fd", Categories);
  }, []);
  

  const handleLimitChange = (event) => {
    setLimit(event.target.value);
  };

  const handlePageChange = (event, newPage) => {
    setPage(newPage);
  };

  const handleEdit = (category_id) => {
    router.push("/categories/" + category_id);
  };

  const handleDeleteIcon = (id) => {
    props.handleDelete(id);
  };

  return (
    <Card {...props}>
      <PerfectScrollbar>
        <Box sx={{ minWidth: 1050 }}>
          <Table>
            <TableHead>
              <TableRow>
                <TableCell>Name</TableCell>
                <TableCell>ID </TableCell>
                <TableCell>Level Type </TableCell>
                <TableCell align="center">Edit</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {props.Categories.slice(0, limit).map((Category) => (
                <TableRow
                  hover
                  key={Category.id}
                  selected={selectedCategoryIds.indexOf(Category.id) !== -1}
                >
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
                        {Category.name}
                      </Typography>
                    </Box>
                  </TableCell>
                  <TableCell>{Category._id}</TableCell>
                  <TableCell>{Category.levelType}</TableCell>
                  <TableCell align="center">
                    <Button
                      variant="outlined"
                      size="small"
                      sx={{ mr: 2 }}
                      onClick={() => handleEdit(Category._id)}
                    >
                      <EditIcon sx={{ fontSize: 15 }}></EditIcon>
                    </Button>
                    <Button
                      variant="contained"
                      color="error"
                      size="small"
                      onClick={() => handleDeleteIcon(Category._id)}
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
        count={Categories.length}
        onPageChange={handlePageChange}
        onRowsPerPageChange={handleLimitChange}
        page={page}
        rowsPerPage={limit}
        rowsPerPageOptions={[5, 10, 25]}
      />
    </Card>
  );
};

CategoryListResults.propTypes = {
  Categories: PropTypes.array.isRequired,
};
