// Next.js API route support: https://nextjs.org/docs/api-routes/introduction
import { words } from '../../../_datas_/words';

export default function handler(req, res) {
    const { search } = req.query ; 
    let result = words;
    if(search){
       result = words.filter(word => word.name.includes(search));
    }
    res.status(200).json({words:result});
  }
  