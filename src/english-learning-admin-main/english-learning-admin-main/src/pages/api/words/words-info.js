// Next.js API route support: https://nextjs.org/docs/api-routes/introduction
import { words } from '../../../_datas_/words';

export default function handler(req, res) {

    const { pid } = req.query ; 
    if(pid == "faewrlqo123"){
        
    }
    res.status(200).json(words[0]);
}
  