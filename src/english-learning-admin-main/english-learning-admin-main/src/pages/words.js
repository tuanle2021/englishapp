import Head from 'next/head';
import { Box, Container } from '@mui/material';
import { WordListResults } from '../components/word/Word-list-results';
import { WordListToolbar } from '../components/word/Word-list-toolbar';
import { DashboardLayout } from '../components/dashboard-layout';
import { words } from '../_datas_/words';


const Words = () => (
  <>
    <Head>
      <title>
        Words | Material Kit
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
        <WordListToolbar />
        <Box sx={{ mt: 3 }}>
          <WordListResults Words={words} />
        </Box>
      </Container>
    </Box>
  </>
);
Words.getLayout = (page) => (
  <DashboardLayout>
    {page}
  </DashboardLayout>
);

export default Words;
