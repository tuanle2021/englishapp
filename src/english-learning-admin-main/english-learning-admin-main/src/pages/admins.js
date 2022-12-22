import Head from 'next/head';
import { Box, Container } from '@mui/material';
import { AdminListResults } from '../components/Admin/Admin-list-results';
import { AdminListToolbar } from '../components/Admin/Admin-list-toolbar';
import { DashboardLayout } from '../components/dashboard-layout';
import { admins } from '../_datas_/admins';

const Admins = () => (
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
        <AdminListToolbar />
        <Box sx={{ mt: 3 }}>
          <AdminListResults Admins={admins} />
        </Box>
      </Container>
    </Box>
  </>
);
Admins.getLayout = (page) => (
  <DashboardLayout>
    {page}
  </DashboardLayout>
);

export default Admins;
