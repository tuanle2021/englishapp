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

export const FillWord = ({ ...props }) => {

    const formik = useFormikContext();

    const title = "Fill Word";


    const [phases, setPhases] = useState([]);

    const [sentences, setSentences] = useState([]);


    useEffect(() => {
        // get list of sentence
        axiosApiCall(`sentence/all`, "get", "", "").then((res) => {
            console.log("sentences", res.data);

            let data_sentences = []

            res.data.forEach(sentence => {
                data_sentences.push({ id: sentence._id, name: sentence.original[0].content })
            })

            setSentences(data_sentences);

            console.log("sentence_state", data_sentences);
        }).catch((error) => {
            console.log("Bị lỗi tải", error);
        });


    }, []);





    return (
        <>
            <Container maxWidth={false}>
                <Typography sx={{ m: 1 }} variant="h5">
                    {title}
                </Typography>
                < Box >
                    {/* Left of Word */}
                    <TextField
                        error={Boolean(formik.touched.name && formik.errors.name)}
                        fullWidth
                        helperText={formik.touched.name && formik.errors.name}
                        label="Left of Word"
                        margin="normal"
                        name="quizz_detail.leftOfWord"
                        onBlur={formik.handleBlur}
                        onChange={formik.handleChange}
                        type="string"
                        value={formik.values.quizz_detail.leftOfWord}
                        variant="outlined"
                    />
                    {/* Right of Word */}
                    <TextField
                        error={Boolean(formik.touched.name && formik.errors.name)}
                        fullWidth
                        helperText={formik.touched.name && formik.errors.name}
                        label="Right of Word"
                        margin="normal"
                        name="quizz_detail.rightOfWord"
                        onBlur={formik.handleBlur}
                        onChange={formik.handleChange}
                        type="string"
                        value={formik.values.quizz_detail.rightOfWord}
                        variant="outlined"
                    />

                    {/* Vietnamese Sentence */}
                    <TextField
                        error={Boolean(formik.touched.name && formik.errors.name)}
                        fullWidth
                        helperText={formik.touched.name && formik.errors.name}
                        label="Vietnamese Sentence"
                        margin="normal"
                        name="quizz_detail.viSentence"
                        onBlur={formik.handleBlur}
                        onChange={formik.handleChange}
                        type="string"
                        value={formik.values.quizz_detail.viSentence}
                        variant="outlined"
                    />

                   
                    {/* answer */}
                    <Grid container>
                        {/* correct choice */}
                        <Grid xs={3}>
                            <TextField
                                error={Boolean(formik.touched.name && formik.errors.name)}
                                fullWidth
                                xs={4}
                                helperText={formik.touched.name && formik.errors.name}
                                label="Correct Choice"
                                margin="normal"
                                name="quizz_detail.correctChoice"
                                onBlur={formik.handleBlur}
                                onChange={formik.handleChange}
                                type="string"
                                value={formik.values.quizz_detail.correctChoice}
                                variant="outlined"
                            />
                        </Grid>
                        {/* correct choice */}

                        {/* first choice */}
                        <Grid xs={3}>
                            <TextField
                                error={Boolean(formik.touched.name && formik.errors.name)}
                                fullWidth
                                xs={4}
                                helperText={formik.touched.name && formik.errors.name}
                                label="First Choice"
                                margin="normal"
                                name="quizz_detail.firstChoice"
                                onBlur={formik.handleBlur}
                                onChange={formik.handleChange}
                                type="string"
                                value={formik.values.quizz_detail.firstChoice}
                                variant="outlined"
                            />
                        </Grid>
                        {/* first choice */}

                        {/* second choice */}
                        <Grid xs={3}>
                            <TextField
                                error={Boolean(formik.touched.name && formik.errors.name)}
                                fullWidth
                                xs={4}
                                helperText={formik.touched.name && formik.errors.name}
                                label="Second Choice"
                                margin="normal"
                                name="quizz_detail.secondChoice"
                                onBlur={formik.handleBlur}
                                onChange={formik.handleChange}
                                type="string"
                                value={formik.values.quizz_detail.secondChoice}
                                variant="outlined"
                            />
                        </Grid>
                        {/* second choice */}

                        {/* third choice */}
                        <Grid xs={3}>
                            <TextField
                                error={Boolean(formik.touched.name && formik.errors.name)}
                                fullWidth
                                xs={4}
                                helperText={formik.touched.name && formik.errors.name}
                                label="Third Choice"
                                margin="normal"
                                name="quizz_detail.thirdChoice"
                                onBlur={formik.handleBlur}
                                onChange={formik.handleChange}
                                type="string"
                                value={formik.values.quizz_detail.thirdChoice}
                                variant="outlined"
                            />
                        </Grid>
                        {/* third choice */}

                    </Grid>
                    {/* answer */}
                </Box>
            </Container>
        </>
    );
};
