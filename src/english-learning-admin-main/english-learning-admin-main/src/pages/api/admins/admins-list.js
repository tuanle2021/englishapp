// Next.js API route support: https://nextjs.org/docs/api-routes/introduction
import { admins } from '../../../_datas_/admins';

export default function handler(req, res) {
    const { search } = req.query ; 
    let result = admins;
    if(search){
       result = admins.filter(admin => admin.name.includes(search));
    }
    res.status(200).json({admins:result});
  }
  