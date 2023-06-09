import 'package:api_creator/src/common/enums/enums.dart';

import '../../../../models/server_auth_model.dart';

String middlewareTemplate(
    {required ServerAuthentication serverAuthentication}) {
  String authentication =
      serverAuthentication.authenticationLevel == AuthenticationLevel.TOKEN.name
          ? '''
const {authenticationCredentials } = require("../config/config.js")

exports.bearerAuthentication = (req, res, next) => {
    const authorizationHeader = req.headers.authorization;
    if (!authorizationHeader) {
      return res.status(403).json({ error: 'No credentials sent!' });
    } else {
      let token = authorizationHeader.split(" ")[1];
      if(token == authenticationCredentials.token){
        next();
      } else {
        res.status(401).send("Please enter a valid token to access");
      }
    }
  }
'''
          : serverAuthentication.authenticationLevel ==
                  AuthenticationLevel.BASIC.name
              ? '''
const {authenticationCredentials } = require("../config/config.js")

  exports.basicAuthentication = (req, res, next) => {
    var authheader = req.headers.authorization; 
    if (!authheader) {
          return res.status(403).json({ error: 'No credentials sent!' });
    } else {
 
    var auth = new Buffer.from(authheader.split(' ')[1],
    'base64').toString().split(':');
    var user = auth[0];
    var pass = auth[1];
 
    if (user == authenticationCredentials.userName && pass == authenticationCredentials.password) {
        next();
    } else {
      res.status(401).send();
    }
    }
  }
'''
              : '';
  return authentication;
}
