import Head from 'next/head';
import { Box, Container } from '@mui/material';
import { LessonListResults } from '../components/Lesson/Lesson-list-results';
import { LessonListToolbar } from '../components/Lesson/Lesson-list-toolbar';
import { DashboardLayout } from '../components/dashboard-layout';
import { lessons } from '../_datas_/lessons';

const Lessons = () => (
  <>
    <Head>
      <title>
        Lessons | Material Kit
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
        <LessonListToolbar />
        <Box sx={{ mt: 3 }}>
          <LessonListResults Lessons={lessons} />
        </Box>
      </Container>
    </Box>
  </>
);
Lessons.getLayout = (page) => (
  <DashboardLayout>
    {page}
  </DashboardLayout>
);

export default Lessons;
