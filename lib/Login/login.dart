import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ims/const/constant.dart';

import 'package:http/http.dart' as http;
import 'package:ims/leadlisting/leadlist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginscreen extends StatefulWidget {
  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  var leadresponse = [];
  String msg = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
 
//https://humbletree.in/lms/api/accountindustries

  SharedPreferences sharedPreferences;

  login(email, password) async {
    var url = Uri.parse(siteurl + "api/auth/login");
    print("url" +
        url.toString() +
        "emailpass" +
        email.toString() +
        password.toString());
    var response = await http.post(url, headers: {
      //'Content-type': 'application/json',
      'Accept': 'application/json',
    },
        //  headers: {"Accept": "application/json"},
        body: {
          "email": email.toString(),
          "password": password.toString(),
        });
    print("responseeee");
    print(response.body.toString());
    print(response.statusCode);

    if (response.statusCode == 200) {
      print('response.body:' + response.body.toString());

      var res = json.decode(response.body);
      print(res['access_token']);
      sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString(
          "access_token", res['access_token'].toString());

      setState(() {
        //   leadresponse = json.decode(response.body);

        _scaffoldKey.currentState.showSnackBar(SnackBar(
           backgroundColor: Color(maincolor),
          content: Text("Successfully logged in"),
        ));
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) => new LeadlistScreen()));
      });
    } else {
      print(response.statusCode);

      setState(() {
        // leadresponse = json.decode(response.body);
        print("errresponse" + response.body.toString());
        var errres = json.decode(response.body);
        print("errrres" + errres['error'].toString());
        msg = errres['error'].toString();
        setState(() {
          //   leadresponse = json.decode(response.body);
          _scaffoldKey.currentState.showSnackBar(SnackBar(
             backgroundColor: Color(maincolor),
            content: Text(msg.toString()),
          ));
        });
      });
    }
  }
   var accesstoken;

      checkaccesstoken()  async {
     sharedPreferences = await SharedPreferences.getInstance();
       accesstoken = sharedPreferences.getString("access_token") ?? "_";
    print("accesstoken"+accesstoken);
    if(accesstoken=="_"){
print("insode if no access token ");


    }
    else{
      print("inside else"+accesstoken);
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
      builder: (BuildContext context) => new LeadlistScreen(),
    ));
    }

  }


  bool _isObscure = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final formKey = GlobalKey<FormState>();
  void initState() {
    checkaccesstoken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
        final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(maincolor),
        leading: InkResponse(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text("Login"),
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
               /* Text(
                  "Login",
                  style: TextStyle(
                      color: Color(maincolor),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
                */
                      Column(
                          children: <Widget>[
                            Row(
                             // mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                  child: Container(
                                   //   height: 40.0,
                                      width:  screenSize.width,
                                      child: Image.network(
                                        logo,
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.grey[200],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter email";
                              }
                            },
                            //  validator: validateEmail,
                            controller: email,
                            //  autofocus:true,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              //   labelText: "Email",
                              hintText: "Email",
                              border: InputBorder.none,
                              fillColor: Colors.white,
                            )),
                      ),
                    ),
                  ),
                ),
                /*  SizedBox(
                  height: 5.0,
                ),*/
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.grey[200],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please Enter Password";
                            }
                          },
                          //     validator: validateMobile,
                          controller: password,
                          //  autofocus:true,
                          obscureText: _isObscure,
                          // keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            hintText: "Password",
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                print("xsdsdsds" + _isObscure.toString());
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                                print("xsdsdsds1" + _isObscure.toString());
                              },
                            ),
                            labelText: "Password",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Container(
                      width: 150.0,
                      height: 50.0,
                      color: Color(maincolor),
                      child: TextButton(
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            login(
                              email.text,
                              password.text,
                            );
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              backgroundColor: Color(maincolor),
                              content: Text("Validate your credentials"),
                            ));
                          } else {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                               backgroundColor: Color(maincolor),
                              content: Text("One or more fields are empty"),
                            ));
                          }
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Container(
                            width: 200.0,
                            constraints: BoxConstraints(
                                maxWidth: 250.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Login",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        /*  Text("Sign in",
                 style: TextStyle(
                   color: Colors.black,
                   fontSize: 20.0,
                   fontWeight: FontWeight.bold,
                 ),
               ),*/
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Enter Valid Email';
  else
    return null;
}

String validateMobile(String value) {
  String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return 'Please enter mobile number';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter valid mobile number';
  }
  return null;
}
