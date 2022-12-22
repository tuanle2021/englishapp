var randomstring = require("randomstring");
function makeid(length) {
   return randomstring.generate({
    length: length,
    charset: 'numeric'
  });
}

module.exports.makeId = makeid;