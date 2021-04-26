// echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
// sudo fuser -k Port_Number/tcp

'use strict';
const log4js = require('log4js');
const logger = log4js.getLogger('BasicNetwork');
const http = require('http')
const util = require('util');
const express = require('express')
const app = express();
const jwt = require('jsonwebtoken');
const bearerToken = require('express-bearer-token');
const cors = require('cors');
const constants = require('./config/constants.json')
const path = require('path')
const passport = require('passport');
const cookieParser = require('cookie-parser');

const host = process.env.HOST || constants.host;
const port = process.env.PORT || constants.port;


const helper = require('./app/helper')
const invoke = require('./app/invoke')
const query = require('./app/query')
const initPassport = require('./config/passport.js')

app.options('*', cors());
app.use(cors());
app.use(cookieParser());
app.use(express.json({limit:"100mb", extended: true }));
app.use(express.urlencoded({limit:"100mb", extended: true }));



// set secret variable
app.set('secret', 'thisismysecret');
app.use(express.static(path.join(__dirname, 'public')));
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

app.use('/css',express.static(path.join(__dirname, 'public/css')));
app.use('/js',express.static(path.join(__dirname, 'public/js')));
app.use('/img',express.static(path.join(__dirname, 'public/img')));



app.use(bearerToken());


initPassport(passport);


logger.level = 'debug';


var server = http.createServer(app).listen(port, function () { console.log(`Server started on ${port}`) });
logger.info('****************** SERVER STARTED ************************');
logger.info('***************  http://%s:%s  ******************', host, port);
server.timeout = 240000;

function getErrorMessage(field) {
    var response = {
        success: false,
        message: field + ' field is missing or Invalid in the request'
    };
    return response;
}

function checkUser(req,res,next){

    const token = req.cookies.jwt;

    // check json web token exists & is verified
    if (token) {
      jwt.verify(token, 'thisismysecret', (err, decodedToken) => {
        if (err) {
          console.log(err.message);
          res.redirect('/login');
        } else {
          console.log(decodedToken);
          next();
        }
      });
    } else {
      res.redirect('/login');
    }
}


app.get('/register',(req,res) => {

    res.render('register.ejs');

})

app.get('/login', (req,res) => {

    res.render('login.ejs')
})

app.get('/index',checkUser, (req,res) => {
    console.log("Dhukse");
    res.render('index')
})

app.get('/query', async function (req, res) {
    try {
        logger.debug('==================== QUERY BY CHAINCODE ==================');

        var channelName = req.query.channelName;
        var chaincodeName = req.query.chaincodeName;
        console.log(`chaincode name is :${chaincodeName}`)
        let args = req.query.args;
        let fcn = req.query.fcn;

        logger.debug('channelName : ' + channelName);
        logger.debug('chaincodeName : ' + chaincodeName);
        logger.debug('fcn : ' + fcn);
        logger.debug('args : ' + args);

        if (!chaincodeName) {
            res.json(getErrorMessage('\'chaincodeName\''));
            return;
        }
        if (!channelName) {
            res.json(getErrorMessage('\'channelName\''));
            return;
        }
        if (!fcn) {
            res.json(getErrorMessage('\'fcn\''));
            return;
        }
        if (!args) {
            res.json(getErrorMessage('\'args\''));
            return;
        }
        console.log('args==========', args);
        args = args.replace(/'/g, '"');
        args = JSON.parse(args);
        logger.debug(args);

        let message = await query.query(channelName, chaincodeName, args, fcn, req.query.username, req.query.orgname);

        const response_payload = {
            result: message,
            error: null,
            errorData: null
        }

        res.send(response_payload);
    } catch (error) {
        const response_payload = {
            result: null,
            error: error.name,
            errorData: error.message
        }
        res.send(response_payload)
    }
});

app.get('/logout', (req,res) => {
    
    res.cookie('jwt', '', { maxAge: 1 });
    res.redirect('/login');

})

app.get('/info',checkUser,(req,res) => {
    res.render('info')
})



app.post('/register', async function (req, res) {
    
    var username = req.body.username;
    var orgName = req.body.orgName;
    
    logger.debug('End point : /users');
    logger.debug('User name : ' + username);
    logger.debug('Org name  : ' + orgName);
   
    if (!username) {
        res.json(getErrorMessage('\'username\''));
        return;
    }
    if (!orgName) {
        res.json(getErrorMessage('\'orgName\''));
        return;
    }

    let response = await helper.registerUser(username, orgName);

    logger.debug('-- returned from registering the username %s for organization %s', username, orgName);
    if (response && typeof response !== 'string') {
        logger.debug('Successfully registered the username %s for organization %s', username, orgName);
        res.render('login.ejs')
    } else {
        logger.debug('Failed to register the username %s for organization %s with::%s', username, orgName, response);
        res.json({ success: false, message: response });
    }

});

app.post('/login', async function (req, res) {
    
    var username = req.body.userName;
    var orgName = req.body.orgName;
    
    logger.debug('End point : /users');
    logger.debug('User name : ' + username);
    logger.debug('Org name  : ' + orgName);
    
    if (!username) {
        res.json(getErrorMessage('\'username\''));
        return;
    }
    if (!orgName) {
        res.json(getErrorMessage('\'orgName\''));
        return;
    }

    var token = jwt.sign({
        exp: Math.floor(Date.now() / 1000) + parseInt(constants.jwt_expiretime),
        username: username,
        orgName: orgName
    }, app.get('secret'));

    let isUserRegistered = await helper.isUserRegistered(username, orgName);

    if (isUserRegistered) {

        const maxAge = 1 * 24 * 60 * 60;
        res.cookie('jwt', token, { httpOnly: true, maxAge: maxAge * 1000 });
        res.json({ success: true, message: { token: token } });

    } else {
        res.json({ success: false, message: `User with username ${username} is not registered with ${orgName}, Please register first.` });
    }
});

app.post('/invoke',passport.authenticate('jwt',{session : false }),async function (req, res) {
    try {
        logger.debug('==================== INVOKE ON CHAINCODE ==================');

        var fcn = "addStudent";
        var args = req.body.args;
        var transient = req.body.transient;
        const authHeader = req.headers['authorization']
        const token = authHeader && authHeader.split(' ')[1]
        
        logger.debug('args  : ' + args);
        

        if (!args) {
            res.json(getErrorMessage('\'args\''));
            return;
        }

        var decoded = jwt.decode(token,{complete : true});
        
        // let message = await invoke.invokeTransaction(channelName, chaincodeName, fcn, args, req.username, req.orgname, transient);
        console.log("Eita hoitase ....." + req.username)

        let message = await invoke.invokeTransaction(fcn, args,decoded.payload.username, decoded.payload.orgName, transient);
        console.log(`message result is : ${message}`)

        const response_payload = {
            result: message,
            error: null,
            errorData: null
        }
        res.send(response_payload);

    } catch (error) {
        const response_payload = {
            result: null,
            error: error.name,
            errorData: error.message
        }
        res.send(response_payload)
    }
});



app.get('/data', (req, res) => {
    res.render('query.ejs')
})

app.get('/home', (req, res) => res.render('home'));


