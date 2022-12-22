import { useState } from 'react';
import PerfectScrollbar from 'react-perfect-scrollbar';
import PropTypes from 'prop-types';
import { format } from 'date-fns';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import { useRouter } from 'next/router';

import {
  Button,
  Avatar,
  Box,
  Card,
  Checkbox,
  Table,
  TableBody,
  TableCell,
  TableHead,
  TablePagination,
  TableRow,
  Typography
} from '@mui/material';
import { getInitials } from '../../utils/get-initials';

export const AdminListResults = ({ ...props }) => {
  const router = useRouter();


  const [selectedAdminIds, setSelectedAdminIds] = useState([]);
  const [Admins, setAdmins] = useState(props.Admins);

  const [limit, setLimit] = useState(10);
  const [page, setPage] = useState(0);


  const handleLimitChange = (event) => {
    setLimit(event.target.value);
  };

  const handlePageChange = (event, newPage) => {
    setPage(newPage);
  };

  const handleEdit = (admin_id) => {
    // console.log(word_id);
    router.push('/admins/' + admin_id);
  };
  const handleDelete = (id) => {
    props.handleDelete(id);
  };


  return (
    <Card {...props}>
      <PerfectScrollbar>
        <Box sx={{ minWidth: 1050 }}>
          <Table>
            <TableHead>
              <TableRow>
                <TableCell>
                  Name
                </TableCell>
                <TableCell>
                  Type
                </TableCell>
                <TableCell>
                  Edit
                </TableCell>

              </TableRow>
            </TableHead>
            <TableBody>
              {props.Admins.slice(0, limit).map((Admin) => (
                <TableRow
                  hover
                  key={Admin.id}
                  selected={selectedAdminIds.indexOf(Admin.id) !== -1}
                >

                  <TableCell>
                    <Box
                      sx={{
                        alignItems: 'center',
                        display: 'flex'
                      }}
                    >
                      <Avatar
                        src={Admin.avatarUrl}
                        sx={{ mr: 2 }}
                      >
                        {getInitials(Admin.name)}
                      </Avatar>
                      <Typography
                        color="textPrimary"
                        variant="body1"
                      >
                        {Admin.username}
                      </Typography>
                    </Box>
                  </TableCell>
                  <TableCell>
                    {Admin.userType}
                  </TableCell>


                  <TableCell>
                    <Button variant="outlined" size="small" sx={{ mr: 2 }} onClick={() => handleEdit(Admin._id)} ><EditIcon sx={{ fontSize: 15 }}></EditIcon></Button>
                    <Button variant="contained" color="error" size="small"  onClick={() =>handleDelete(Admin._id)}><DeleteIcon sx={{ fontSize: 15 }}></DeleteIcon></Button>
                  </TableCell>

                </TableRow>
              ))}
            </TableBody>
          </Table>
        </Box>
      </PerfectScrollbar>
      <TablePagination
        component="div"
        count={Admins.length}
        onPageChange={handlePageChange}
        onRowsPerPageChange={handleLimitChange}
        page={page}
        rowsPerPage={limit}
        rowsPerPageOptions={[5, 10, 25]}
      />
    </Card>
  );
};

AdminListResults.propTypes = {
  Admins: PropTypes.array.isRequired
};
