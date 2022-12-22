// Next.js API route support: https://nextjs.org/docs/api-routes/introduction

export default function handler(req, res) {

    const { username,password } = req.query ; 

    if(username == "administrator@gmail.com" && password =="administrator"){
        res.status(200).json({success:1,username:"administrator"});
    }else{
        res.status(200).json({falied:1,error:"username or password not match"});
    }
}
  