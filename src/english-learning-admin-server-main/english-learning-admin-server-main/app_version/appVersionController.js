const appVersionService = require('./appVersionService');



const getappVersion = async (appVersionId) => {
    const app_version = await appVersionService.getappVersion();
    
    if(app_version === null){
        return await appVersionService.addappVersion({appVersion:0});
    }
    return app_version;
};



const updateappVersion = async ( data) => {
    return await appVersionService.updateappVersion( data);
};





module.exports = {
    updateappVersion,
    getappVersion
};
