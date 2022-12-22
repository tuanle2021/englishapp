import Head from "next/head";
import { useState, useEffect } from "react";
import { DashboardLayout } from "../dashboard-layout";
import { Box, Button, Container, Grid, Link, TextField, Typography } from "@mui/material";
import IconButton from '@mui/material/IconButton';
import DeleteIcon from "@mui/icons-material/Delete";
import { useRouter } from "next/router";
import { useFormik, Form, FieldArray, useFormikContext } from "formik";
import * as Yup from "yup";
import { styled } from "@mui/material/styles";
import axios from "axios";

const axiosApiCall = (url, method, headers = {}, data) =>
    axios({
        method,
        url: `http://localhost:3001/${url}`,
        data: data,
        headers: headers,
    });


// @refresh reset
const Input = styled("input")({
    display: "none",
});

const quizzes_type = [
    {
        value: "TRANSLATE_AND_ARRANGE",
        label: "TRANSLATE_AND_ARRANGE",
    },
    {
        value: "FILL_IN_BLANKS_SENTENCE",
        label: "FILL_IN_BLANKS_SENTENCE",
    },
    {
        value: "LISTEN_AND_PICK",
        label: "LISTEN_AND_PICK",
    },
    {
        value: "READ_AND_PICK",
        label: "READ_AND_PICK",
    },
    {
        value: "PICTURE_AND_PICK",
        label: "PICTURE_AND_PICK",
    },
];

export const TranslateAndArrange = ({ ...props }) => {

    const formik = useFormikContext();

    const title = "Tranlate and arrange";


    const [phases, setPhases] = useState([]);

    const [sentences, setSentences] = useState([]);


    useEffect(() => {
        

    }, []);





    return (
        <>
            <Container maxWidth={false}>
                <Typography sx={{ m: 1 }} variant="h5">
                    {title}
                </Typography>
                <Box >
                    
                    <TextField
                        // error={Boolean(formik.touched.quizz_detail.originSentence && formik.errors.quizz_detail.originSentence)}
                        fullWidth
                        // helperText={formik.touched.quizz_detail.originSentence && formik.errors.quizz_detail.originSentence}
                        label="Origin Sentence"
                        margin="normal"
                        name="quizz_detail.originSentence"
                        onBlur={formik.handleBlur}
                        onChange={formik.handleChange}
                        type="string"
                        value={formik.values.quizz_detail.originSentence}
                        variant="outlined"
                      />
                     <TextField
                        // error={Boolean(formik.touched.quizz_detail.viSentence && formik.errors.quizz_detail.viSentence)}
                        fullWidth
                        // helperText={formik.touched.quizz_detail.viSentence && formik.errors.quizz_detail.viSentence}
                        label="Vietnames Sentence"
                        margin="normal"
                        name="quizz_detail.viSentence"
                        onBlur={formik.handleBlur}
                        onChange={formik.handleChange}
                        type="string"
                        value={formik.values.quizz_detail.viSentence}
                        variant="outlined"
                      />
                      <TextField
                        // error={Boolean(formik.touched.quizz_detail.viSentence && formik.errors.quizz_detail.viSentence)}
                        fullWidth
                        // helperText={formik.touched.quizz_detail.viSentence && formik.errors.quizz_detail.viSentence}
                        label="Number of right word"
                        margin="normal"
                        name="quizz_detail.numRightPhrase"
                        onBlur={formik.handleBlur}
                        onChange={formik.handleChange}
                        type="number"
                        value={formik.values.quizz_detail.numRightPhrase}
                        variant="outlined"
                      />

                    {/* array phases */}
                    <FieldArray
                        name="quizz_detail.viPharse"
                        render={({ insert, remove, push }) => (
                            <>
                                <Grid sx={{ mt: 3 }}>
                                    <Grid item md={12} >
                                        <Button
                                            color="primary"
                                            variant="contained"
                                            onClick={() => { push(""), console.log(formik.values) }}
                                        >
                                            Add Phases
                                        </Button>
                                    </Grid>
                                    <Grid item md={12} sx={{ mt: 3 }} >
                                        <Grid container>
                                            {formik.values.quizz_detail.viPharse && formik.values.quizz_detail.viPharse.length > 0 ? (
                                                formik.values.quizz_detail.viPharse.map((phase, index) => (
                                                    <Grid key={index} xs={4} sx={{ mt: 3 }}  >

                                                        <TextField
                                                            name={`quizz_detail.viPharse.${index}`}
                                                            sx={{ mr: 3 }}
                                                            label={`viPhrase-${index}`}
                                                            onChange={formik.handleChange}
                                                            value={formik.values.quizz_detail.viPharse[index]} />
                                                        <IconButton variant="contained" color="error" component="span" onClick={() => { remove(index), console.log(formik.values) }}>
                                                            <DeleteIcon />
                                                        </IconButton>

                                                    </Grid>
                                                ))
                                            ) : <></>}
                                        </Grid>
                                    </Grid>
                                </Grid>
                            </>
                        )}
                    />
                </Box>
            </Container>
        </>
    );
};
