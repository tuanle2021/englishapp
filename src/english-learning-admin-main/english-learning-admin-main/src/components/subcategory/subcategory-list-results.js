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

export const SubcategoryListResults = ({ ...props }) => {
  const router = useRouter();

  const [selectedSubcategoryIds, setSelectedSubcategoryIds] = useState([]);
  const [Subcategories, setSubcategories] = useState(props.Subcategories);

  const [limit, setLimit] = useState(10);
  const [page, setPage] = useState(0);

  useEffect(() => {
    setSubcategories(props.Subcategories);
    console.log("fd", Subcategories);
  }, []);
  const handleSelectAll = (event) => {
    let newSelectedSubcategoryIds;

    if (event.target.checked) {
      newSelectedSubcategoryIds = Subcategories.map((Subcategory) => Subcategory.id);
    } else {
      newSelectedSubcategoryIds = [];
    }

    setSelectedSubcategoryIds(newSelectedSubcategoryIds);
  };

  const handleSelectOne = (event, id) => {
    const selectedIndex = selectedSubcategoryIds.indexOf(id);
    let newSelectedSubcategoryIds = [];

    if (selectedIndex === -1) {
      newSelectedSubcategoryIds = newSelectedSubcategoryIds.concat(selectedSubcategoryIds, id);
    } else if (selectedIndex === 0) {
      newSelectedSubcategoryIds = newSelectedSubcategoryIds.concat(selectedSubcategoryIds.slice(1));
    } else if (selectedIndex === selectedSubcategoryIds.length - 1) {
      newSelectedSubcategoryIds = newSelectedSubcategoryIds.concat(selectedSubcategoryIds.slice(0, -1));
    } else if (selectedIndex > 0) {
      newSelectedSubcategoryIds = newSelectedSubcategoryIds.concat(
        selectedSubcategoryIds.slice(0, selectedIndex),
        selectedSubcategoryIds.slice(selectedIndex + 1)
      );
    }

    setSelectedSubcategoryIds(newSelectedSubcategoryIds);
  };

  const handleLimitChange = (event) => {
    setLimit(event.target.value);
  };

  const handlePageChange = (event, newPage) => {
    setPage(newPage);
  };

  const handleEdit = (Subcategory_id) => {
    // console.log(Subcategory_id);
    router.push("/subcategories/" + Subcategory_id);
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
                <TableCell>Category</TableCell>
                <TableCell align="center">Edit</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {props.Subcategories.slice(0, limit).map((Subcategory) => (
                <TableRow hover key={Subcategory.id} selected={selectedSubcategoryIds.indexOf(Subcategory.id) !== -1}>
                
                  <TableCell>{Subcategory.name}</TableCell>
                  <TableCell>{Subcategory.category.name}</TableCell>
                  <TableCell align="center">
                    <Button
                      variant="outlined"
                      size="small"
                      sx={{ mr: 2 }}
                      onClick={() => handleEdit(Subcategory._id)}
                    >
                      <EditIcon sx={{ fontSize: 15 }}></EditIcon>
                    </Button>
                    <Button
                      variant="contained"
                      color="error"
                      size="small"
                      onClick={() => handleDeleteIcon(Subcategory._id)}
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
        count={Subcategories.length}
        onPageChange={handlePageChange}
        onRowsPerPageChange={handleLimitChange}
        page={page}
        rowsPerPage={limit}
        rowsPerPageOptions={[5, 10, 25]}
      />
    </Card>
  );
};

SubcategoryListResults.propTypes = {
  Subcategories: PropTypes.array.isRequired,
};
