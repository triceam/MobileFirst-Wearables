var express = require('express');
var passport = require('passport');

var ImfBackendStrategy = require('passport-imf-token-validation').ImfBackendStrategy;
var imf = require('imf-oauth-user-sdk');

try {
    passport.use(new ImfBackendStrategy());
} catch ( e ) {
    console.log(e);
}

var app = express();
app.use(passport.initialize());

app.set('view engine', 'jade');

var credentials = {};

if (process.env.hasOwnProperty("VCAP_SERVICES")) {
    // Running on Bluemix. Parse out the port and host that we've been assigned.
    var env = JSON.parse(process.env.VCAP_SERVICES);
    var host = process.env.VCAP_APP_HOST; 
    var port = process.env.VCAP_APP_PORT;
   
    credentials = env['cloudantNoSQLDB'][0].credentials;  
}
else {
    
    //enter Cloudant credentials for local node.js server instance
    credentials.username = "";
    credentials.password = "";
    credentials.url = ""
}

var database = "heartmonitor";
var Cloudant = require('cloudant');
var heartmonitor;

Cloudant({account:credentials.username, password:credentials.password}, function(err, cloudant) {
    console.log('Connected to Cloudant');
    heartmonitor = cloudant.use(database);
})

var prepareData = function(res, template) {
    
    var results = [];
    
    //create the index if it doesn't already exist
    var sort_index = {name:'sort', type:'json', index:{fields:['sort']}};
    heartmonitor.index(sort_index, function(er, response) {
        if (er) {
            throw er;
        }

        console.log('Index creation result: %s', response.result);
    
        //perform the search
        var selector = {sort:{"$gt":0}};
        heartmonitor.find({selector:selector, sort:["sort"]}, function(er, result) {
            if (er) {
                throw er;
            }

            console.log('Found %d documents with type com.heartmonitor.entry', result.docs.length)

            for (var x=0; x<result.docs.length; x++) {
                var obj = result.docs[x];
                
                var transformedData = [];
                for (var y=0; y<obj.data.length; y++) {
                    transformedData.push(obj.data[y].heartRate);
                }
                obj.transformedData = transformedData;
                
                results.push( obj ); 
            }
            res.render(template, { results:results});
        });
    });
};

app.get('/', function(req, res){
    prepareData(res, 'list');
});

/*
app.get('/list', function(req, res){
    prepareData(res, 'list');
});
*/






// create a public static content service
app.use("/public", express.static(__dirname + '/public'));

// create another static content service, and protect it with imf-backend-strategy
app.use("/protected", passport.authenticate('imf-backend-strategy', {session: false }));
app.use("/protected", express.static(__dirname + '/protected'));

// create a backend service endpoint
app.get('/publicServices/generateToken', function(req, res){
		// use imf-oauth-user-sdk to get the authorization header, which can be used to access the protected resource/endpoint by imf-backend-strategy
		imf.getAuthorizationHeader().then(function(token) {
			res.send(200, token);
		}, function(err) {
			console.log(err);
		});
	}
);

//create another backend service endpoint, and protect it with imf-backend-strategy
app.get('/protectedServices/test', passport.authenticate('imf-backend-strategy', {session: false }),
		function(req, res){
			res.send(200, "Successfully access to protected backend endpoint.");
		}
);

var port = (process.env.VCAP_APP_PORT || 3000);
app.listen(port);
console.log("mobile backend app is listening at " + port);