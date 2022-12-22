const express = require("express");
const router = express.Router();
const userService = require("./userService");
const { VERSION, ROUTES } = require("../routes/constant");
const { verifyUser } = require("../authenticate/authenticate");
const mailService = require("../services/mailService");
const handleError = require("../shares/handleError");
router.get(
  `/${VERSION}${ROUTES.USER.FORGOT_PASSWORD}`,
  handleError((req, res) => {
    res.render("forgotPassword", { API_URL: process.env.API_URL });
  })
);

router.get(
  `/${VERSION}${ROUTES.USER.GEN_RESET_LINK}/:email`,
  handleError(async (req, res) => {
    const { email } = req.params;
    const { valid } = await userService.checkExistEmail(email);
    if (valid == true) {
      const subject = "[Your RESET PASSWORD link]";
      const text = `Click this to reset your password: ${process.env.API_URL}/user/v1/reset-password/${email}`;
      const result = await mailService.sendMail(subject, text, email);
      res.statusCode = 200;
      res.send({ validEmail: true });
    } else {
      res.send({ validEmail: false });
    }
  })
);

router.get(
  `/${VERSION}${ROUTES.USER.RESET_PASSWORD}/:email`,
  handleError((req, res) => {
    const { email } = req.params;
    res.render("resetPassword", { API_URL: process.env.API_URL, email: email });
  })
);

router.post(
  `/${VERSION}${ROUTES.USER.UPDATE_PASSWORD}`,
  handleError(async (req, res) => {
    const { email, newPassword } = req.body;
    const { statusCode, result } = await userService.updatePassword(
      email,
      newPassword
    );
    res.statusCode = statusCode;
    res.send(result);
    return;
  })
);

router.all("*", verifyUser);

router.get(`/${VERSION}${ROUTES.USER.FETCH_USER_DATA}`, handleError(async (req,res)=> {
  if (req.user) {
    const result = await userService.fetchUserData(req.user._id)
    res.send({success:true,result})
  }
 else {
   res.send({success: false})
 }
}))

router.get(
  `/${VERSION}${ROUTES.USER.PROFILE}`,
  handleError(async (req, res) => {
    console.log(req.user);
    const { statusCode, result } = await userService.profile(req);
    res.statusCode = statusCode;
    res.send({ user: result });
    return;
  })
);

router.post(
  `/${VERSION}${ROUTES.USER.UPDATE_PROFILE}`,
  handleError(async (req, res) => {
    console.log(req.body);
    const { success,userProfile} = await userService.updateProfile(
      req.body.id,
      req.body.firstName,
      req.body.lastName,
      req.body.photoUrl,
      req.body.facebookId,
      req.body.googleId,
      req.body.authStrategy,
      req.body.isSharedData,
    );
    if (success == true) {
      res.statusCode = 200;
      res.send({ success: success,userProfile:userProfile });
    } else {
      res.statusCode = 500;
      res.send({success: success});
    }

    return;
  })
);

// router.get("/v1/profile", (req, res, next) => {
//   res.send({ user: req.user });
// });

// router.post("/v1/updateProfile", async (req, res, next) => {
//   var user = await User.findOne({ _id: mongoose.Types.ObjectId(req.body.id) });
//   if (user) {
//     user.firstName = req.body.firstName;
//     user.lastName = req.body.lastName;
//     user.photoUrl = req.body.photoUrl;
//     user.save((err, user) => {
//       if (err) {
//         res.statusCode = 500;
//         res.send({ error: err });
//       } else {
//         res.statusCode = 200;
//         res.send({ success: true });
//       }
//     });
//   }
// });
module.exports = router;
