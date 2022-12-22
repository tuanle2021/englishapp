import Head from "next/head";
import { useState, useEffect } from "react";
import { DashboardLayout } from "../../components/dashboard-layout";
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


export const ReadAndPick = ({ ...props }) => {


    const title = "Read And Pick";


    const formik = useFormikContext();

    const [sentences, setSentences] = useState([]);


    // use effect fetch data

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
                <Box >
                    {/* <TextField
                    fullWidth
                    label="Sentence"
                    margin="normal"
                    name="quizz_detail.sentence_id"
                    onBlur={formik.handleBlur}
                    onChange={formik.handleChange}
                    required
                    select
                    SelectProps={{ native: true }}
                    value={formik.values.quizz_detail.sentence_id}
                    variant="outlined"
                >
                    {sentences.map((sentence) => (
                        <option key={sentence.id} value={sentence.id}>
                            {sentence.name}
                        </option>
                    ))}
                </TextField> */}

                    <TextField
                        // error={Boolean(formik.touched.quizz_detail.word_id && formik.errors.quizz_detail.word_id)}
                        fullWidth
                        // helperText={formik.touched.quizz_detail.word_id && formik.errors.quizz_detail.word_id}
                        label="Word"
                        margin="normal"
                        name="quizz_detail.word_id"
                        onBlur={formik.handleBlur}
                        onChange={formik.handleChange}
                        type="string"
                        value={formik.values.quizz_detail.word_id}
                        variant="outlined"
                    />
                    {/* array phases */}
                    <FieldArray
                        name="quizz_detail.choices_word_id"
                        render={({ insert, remove, push }) => (
                            <>
                                <Grid sx={{ mt: 3 }}>
                                    <Grid item md={12} >
                                        <Button
                                            color="primary"
                                            variant="contained"
                                            onClick={() => { push(""), console.log(formik.values) }}
                                        >
                                            Add Choices Word
                                        </Button>
                                    </Grid>
                                    <Grid item md={12} sx={{ mt: 3 }} >
                                        <Grid container>
                                            {formik.values.quizz_detail.choices_word_id && formik.values.quizz_detail.choices_word_id.length > 0 ? (
                                                formik.values.quizz_detail.choices_word_id.map((phase, index) => (
                                                    <Grid key={index} xs={4} sx={{ mt: 3 }}  >

                                                        <TextField
                                                            name={`quizz_detail.choices_word_id.${index}`}
                                                            sx={{ mr: 3 }}
                                                            label={`choices_word_id-${index}`}
                                                            onChange={formik.handleChange}
                                                            value={formik.values.quizz_detail.choices_word_id[index]} />

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
