import PropTypes from "prop-types";
import Button from "@mui/material/Button";
import Paper from "@mui/material/Paper";
import Avatar from "@mui/material/Avatar";
import List from "@mui/material/List";
import ListItem from "@mui/material/ListItem";
import ListItemAvatar from "@mui/material/ListItemAvatar";
import ListItemText from "@mui/material/ListItemText";
import DialogTitle from "@mui/material/DialogTitle";
import Dialog from "@mui/material/Dialog";
import PersonIcon from "@mui/icons-material/Person";
import AddIcon from "@mui/icons-material/Add";
import Typography from "@mui/material/Typography";
import { blue } from "@mui/material/colors";
import TextField from "@mui/material/TextField";
import { useFormik } from "formik";
import * as Yup from "yup";
import React, { useState } from "react";

import addWordDialogStyle from "./addWordDialog.module.css";

import axios from "axios";

const axiosApiCall = (url, method, headers = {}) =>
  axios({
    method,
    url: `${process.env.NEXT_PUBLIC_API_BASE_URL}${url}`,
    data: {},
    headers: headers,
  });

export default function EditWordDialog({ handleEditWord, listCategories, Word }) {
  const [open, setOpen] = React.useState(false);
  const [selectedValue, setSelectedValue] = React.useState("emails[1]");

  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = (value) => {
    setOpen(false);
    setSelectedValue(value);
  };

  const closePopUp = () => {
    setOpen(false);
  };

  return (
    <div>
      <Button onClick={handleClickOpen}>Edit Word</Button>
      <SimpleDialog
        selectedValue={selectedValue}
        open={open}
        onClose={handleClose}
        handleEditWord={handleEditWord}
        listCategories={listCategories}
        Word={Word}
        closePopUp={closePopUp}
        sx={"width: 500px"}
      />
    </div>
  );
}
function SimpleDialog(props) {
  const { onClose, selectedValue, open, handleEditWord, listCategories, Word, closePopUp } = props;

  const handleClose = () => {
    onClose(selectedValue);
  };

  const handleListItemClick = (value) => {
    onClose(value);
  };

  return (
    <Dialog onClose={handleClose} open={open}>
      <DialogTitle>Add a new word</DialogTitle>
      <AddWordForm
        handleEditWord={handleEditWord}
        listCategories={listCategories}
        Word={Word}
        closePopUp={closePopUp}
      ></AddWordForm>
    </Dialog>
  );
}

SimpleDialog.propTypes = {
  onClose: PropTypes.func.isRequired,
  open: PropTypes.bool.isRequired,
  selectedValue: PropTypes.string.isRequired,
};

export const AddWordForm = ({ handleEditWord, listCategories, Word, closePopUp }) => {
  const formik = useFormik({
    initialValues: {
      _id: Word._id,
      word_id: Word.word_id,
      word: Word.word,
      lexicalCategory: Word.lexicalCategory,
      type: Word.type,
      ori_lang: Word.ori_lang,
      tra_lang: Word.tra_lang,
      definitions: Word.definitions,
      shortDefinitions: Word.shortDefinitions,
      examples: Word.examples,
      phoneticNotation: Word.phoneticNotation,
      phoneticSpelling: Word.phoneticSpelling,
      audioFile: Word.audioFile,
      synonyms: Word.synonyms,
      pharses: Word.pharses,
      mean: Word.mean,
      category: Word.category ? Word.category._id : "",
      image: Word.image,
      image_url: Word.image_url,
    },
    validationSchema: Yup.object({
      word: Yup.string().max(255).required("Word is required"),
    }),
    onSubmit: (values) => {
      handleEditWord(values);
    },
  });

  const handleEditCancel = () => {
    //setOpen(false);
  };

  const handleEditWordPopUp = () => {
    const values = formik.values;
    closePopUp();
    handleEditWord(values);
  };

  return (
    <>
      <TextField
        error={Boolean(formik.touched.word && formik.errors.word)}
        fullWidth
        helperText={formik.touched.word && formik.errors.word}
        label="Word"
        margin="normal"
        name="word"
        onBlur={formik.handleBlur}
        onChange={formik.handleChange}
        type="string"
        value={formik.values.word}
        variant="outlined"
      />
      <TextField
        error={Boolean(formik.touched.definition && formik.errors.definition)}
        fullWidth
        helperText={formik.touched.definition && formik.errors.definition}
        label="Definitions"
        margin="normal"
        name="definition"
        onBlur={formik.handleBlur}
        onChange={formik.handleChange}
        type="string"
        value={formik.values.definitions}
        variant="outlined"
      />
      <TextField
        error={Boolean(formik.touched.synonyms && formik.errors.synonyms)}
        fullWidth
        helperText={formik.touched.synonyms && formik.errors.synonyms}
        label="Synonyms"
        margin="normal"
        name="synonyms"
        onBlur={formik.handleBlur}
        onChange={formik.handleChange}
        type="string"
        value={formik.values.synonyms}
        variant="outlined"
      />
      <TextField
        error={Boolean(formik.touched.pharses && formik.errors.pharses)}
        fullWidth
        helperText={formik.touched.pharses && formik.errors.pharses}
        label="Pharses"
        margin="normal"
        name="pharses"
        onBlur={formik.handleBlur}
        onChange={formik.handleChange}
        type="string"
        value={formik.values.pharses}
        variant="outlined"
      />
      <TextField
        error={Boolean(formik.touched.mean && formik.errors.mean)}
        fullWidth
        helperText={formik.touched.mean && formik.errors.mean}
        label="Mean"
        margin="normal"
        name="mean"
        onBlur={formik.handleBlur}
        onChange={formik.handleChange}
        type="string"
        value={formik.values.mean}
        variant="outlined"
      />

      <TextField
        error={Boolean(formik.touched.category && formik.errors.category)}
        fullWidth
        helperText={formik.touched.category && formik.errors.category}
        label="Category"
        margin="normal"
        name="category"
        onBlur={formik.handleBlur}
        onChange={formik.handleChange}
        required
        select
        SelectProps={{ native: true }}
        value={formik.values.category}
        variant="outlined"
      >
        {listCategories.map((option) => (
          <option key={option._id} value={option._id}>
            {option.name}
          </option>
        ))}
      </TextField>
      <button onClick={handleEditWordPopUp}>Edit Word</button>
      <button onClick={handleEditCancel}>Cancel</button>
    </>
  );
};
