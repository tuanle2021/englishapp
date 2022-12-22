import Head from 'next/head';
import { Box, Container } from '@mui/material';
import { AdminListResults } from '../../components/admin/admin-list-results';
import { AdminListToolbar } from '../../components/admin/admin-list-toolbar';
import { DashboardLayout } from '../../components/dashboard-layout';
import { useState, useEffect } from 'react';
import Cookie from "js-cookie";
import { useRouter } from 'next/router';

import axios from 'axios';
let access_token = Cookie.get("accesstoken");
const headers = { authorization: "Bearer " + access_token };

const axiosApiCall = (url, method, headers = {}, data) =>
    axios({
        method,
        url: `http://localhost:3001/${url}`,
        data: data,
        headers: headers,
        withCredentials: false,
    });
const AdminsList = () => {

    const [search, setSearch] = useState(null);
    const [Admins, setAdmins] = useState([]);
    const router = useRouter();

    const onChange_Search = (event) => {
        setSearch(event.target.value)
        console.log(search)
    }

    useEffect(() => {

        const user = JSON.parse(Cookie.get('user'));

        if (user.userType != "SYSTEM_ADMIN") {
            router.push("/")
        }

        axiosApiCall(`user/all?isDeleted=false`, "get", headers, "")
            .then((res) => {
                setAdmins(res.data);
            })
            .catch(function (error) {
                console.log("Bị lỗi tải");
            });



    }, [search])

    const handleDelete = (id) => {
        alert("You want to delete this user");
        axiosApiCall(`user/delete/${id}`, "get", headers, "")
            .then((res) => {
                axiosApiCall(`user/all?isDeleted=false`, "get", headers, "")
                    .then((res) => {
                        setAdmins(res.data);
                    })
                    .catch(function (error) {
                        console.log("Bị lỗi tải");
                    });
            })
            .catch(function (error) {
                console.log("Bị lỗi tải");
            });
    };
    return (
        <>
            <Head>
                <title>
                    Admins | Material Kit
                </title>
            </Head>
            <Box
                component="main"
                sx={{
                    flexGrow: 1,
                    py: 8
                }}
            >
                <Container maxWidth={false}>
                    <AdminListToolbar onChange={onChange_Search} />
                    <Box sx={{ mt: 3 }}>
                        <AdminListResults {...{ Admins: Admins,  handleDelete: handleDelete }} />
                    </Box>
                </Container>
            </Box>
        </>
    );
};
AdminsList.getLayout = (page) => (
    <DashboardLayout>
        {page}
    </DashboardLayout>
);

export default AdminsList;
