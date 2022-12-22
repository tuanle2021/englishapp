const nodemailer = require("nodemailer");

const sendMail = async (subject, text, email) => {
  const gmail = process.env.Mail;
  const password = process.env.passwordMail;

  const smtpTransport = nodemailer.createTransport({
    service: "gmail",
    host: "smtp.gmail.com",
    auth: {
      user: gmail,
      pass: password,
    },
  });
  const mailOptions = {
    from: gmail,
    to: email,
    subject: subject,
    text: text,
  };
  const result = await smtpTransport.sendMail(mailOptions);
  smtpTransport.close();
  return result;
};

module.exports = {
  sendMail: sendMail,
};
