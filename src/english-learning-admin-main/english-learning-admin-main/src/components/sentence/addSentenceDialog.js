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

import axios from "axios";

const axiosApiCall = (url, method, headers = {}) =>
  axios({
    method,
    url: `${process.env.NEXT_PUBLIC_API_BASE_URL}${url}`,
    data: {},
    headers: headers,
  });

export default function AddWordDialog({ handleAddSentence, listLessons, Word }) {
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
      <Button onClick={handleClickOpen}>Add Sentence</Button>
      <SimpleDialog
        selectedValue={selectedValue}
        open={open}
        onClose={handleClose}
        handleAddSentence={handleAddSentence}
        listLessons={listLessons}
        Word={Word}
        closePopUp={closePopUp}
        sx={"width: 500px"}
      />
    </div>
  );
}
function SimpleDialog(props) {
  const { onClose, selectedValue, open, handleAddSentence, listLessons, Word, closePopUp } = props;

  const handleClose = () => {
    onClose(selectedValue);
  };

  const handleListItemClick = (value) => {
    onClose(value);
  };

  return (
    <Dialog onClose={handleClose} open={open}>
      <DialogTitle>Add a new Sentence</DialogTitle>
      <AddSentenceForm
        handleAddSentence={handleAddSentence}
        listLessons={listLessons}
        Word={Word}
        closePopUp={closePopUp}
      ></AddSentenceForm>
    </Dialog>
  );
}

SimpleDialog.propTypes = {
  onClose: PropTypes.func.isRequired,
  open: PropTypes.bool.isRequired,
  selectedValue: PropTypes.string.isRequired,
};

export const AddSentenceForm = ({ handleAddSentence, listLessons, closePopUp, Word }) => {
  const formik = useFormik({
    initialValues: {
      lesson: listLessons[0] ? listLessons[0]._id : "",
      related_word_id: Word._id,
      related_word_name: Word.word,
      original: "",
      translated: "",
    },
    validationSchema: Yup.object({
      Sentence: Yup.string().max(255).required("Sentence is required"),
    }),
    onSubmit: (values) => {
      handleAddSentence(values);
    },
  });

  const handleAddCancel = () => {
    //setOpen(false);
    console.log(Word);
  };

  const handleAddSentencePopUp = () => {
    const values = formik.values;
    closePopUp();
    handleAddSentence(values);
  };

  return (
    <>
      <TextField
        error={Boolean(formik.touched.related_word_name && formik.errors.related_word_name)}
        fullWidth
        helperText={formik.touched.related_word_name && formik.errors.related_word_name}
        label="Word"
        margin="normal"
        name="related_word_name"
        onBlur={formik.handleBlur}
        onChange={formik.handleChange}
        type="string"
        value={formik.values.related_word_name}
        disabled
        variant="outlined"
      />
      <TextField
        error={Boolean(formik.touched.original && formik.errors.original)}
        fullWidth
        helperText={formik.touched.original && formik.errors.original}
        label="original"
        margin="normal"
        name="original"
        onBlur={formik.handleBlur}
        onChange={formik.handleChange}
        type="string"
        value={formik.values.original}
        variant="outlined"
      />
      <TextField
        error={Boolean(formik.touched.translated && formik.errors.translated)}
        fullWidth
        helperText={formik.touched.translated && formik.errors.translated}
        label="Translated"
        margin="normal"
        name="translated"
        onBlur={formik.handleBlur}
        onChange={formik.handleChange}
        type="string"
        value={formik.values.translated}
        variant="outlined"
      />
      <TextField
        error={Boolean(formik.touched.lesson && formik.errors.lesson)}
        fullWidth
        helperText={formik.touched.lesson && formik.errors.lesson}
        label="Lesson"
        margin="normal"
        name="lesson"
        onBlur={formik.handleBlur}
        onChange={formik.handleChange}
        required
        select
        SelectProps={{ native: true }}
        value={formik.values.lesson}
        variant="outlined"
      >
        {listLessons.map((option) => (
          <option key={option._id} value={option._id}>
            {option.name}
          </option>
        ))}
      </TextField>
      <button onClick={handleAddSentencePopUp}>Add Sentence</button>
      <button onClick={handleAddCancel}>Cancel</button>
    </>
  );
};
