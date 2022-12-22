// Next.js API route support: https://nextjs.org/docs/api-routes/introduction
import { admins } from '../../../_datas_/admins';

export default function handler(req, res) {

    const { pid } = req.query ; 
    if(pid == "faewrlqo123"){
        
    }
    res.status(200).json(admins[0]);
}
  