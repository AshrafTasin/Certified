const jwtStrategy = require('passport-jwt').Strategy;
const extractJwt = require('passport-jwt').ExtractJwt;
const helper = require('../app/helper')
// var username,orgname;

const opts = {}

opts.jwtFromRequest = extractJwt.fromAuthHeaderAsBearerToken();
opts.secretOrKey = "thisismysecret"



module.exports = passport =>  {
     passport.use(new jwtStrategy(opts,async (jwt_payload,done) => {
         

        let isUserRegistered = await helper.isUserRegistered(jwt_payload.username, jwt_payload.orgName);

        if(isUserRegistered){
            orgname = await helper.getUser(jwt_payload.username,jwt_payload.orgName);
             
         }else{
            orgname = "null"
         }
       
        console.log("Set HOise" +orgname);
        if(jwt_payload.orgName != orgname){
            console.log("Vullllllllll      "+ orgname + " " +jwt_payload.orgName)
            return done(null, null, {message : "Please Contact with Admin and Register First"})
        }
        console.log("XXXXXXXXXXXXXXX      "+ orgname + " " +jwt_payload.orgName)
        return done(null, jwt_payload.username)

    }))
}