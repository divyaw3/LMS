import 'dart:convert';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ims/const/constant.dart';
import 'package:ims/leadlisting/leadlist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LeadRegisterscreen extends StatefulWidget {
  var street, subLocality, locality, postalCode, country, lati, lang, state;
  @override
  //Address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

  //
  LeadRegisterscreen(
      {this.country,
      this.locality,
      this.postalCode,
      this.street,
      this.lang,
      this.lati,
      this.subLocality,
      this.state});
  @override
  _LeadRegisterscreenState createState() => _LeadRegisterscreenState();
}

class _LeadRegisterscreenState extends State<LeadRegisterscreen> {
  //address
  var leadresponse = [];
  String msg = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var lead_source = [];

  var lead_status = [];
  var lead_accountindustries = [];
  //var lead_setting =[];
  Map lead_setting = {};
  bool displaynotes = false;
  Future getsettingdetails() async {
    print("inside getsetting details");
    Uri url = Uri.parse(siteurl + "api/lead/setting");

    print("getsetting details" + url.toString());
    print("accesstokenaccesstokensetting" + accesstoken.toString());
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accesstoken',
    });
    if (response.statusCode == 200) {
      setState(() {
        lead_setting = json.decode(response.body);
        //  print("lead_settinglead_setting"+lead_setting.toString());
if(lead_setting["notesactive"] == 0 ){
setState(() {
  displaynotes = false;
});
}
else if (lead_setting["notesactive"] == 1) {
setState(() {
    displaynotes = true;

});
}
        print("lead_settinglead_setting" + lead_setting['name'].toString());
      });
      print("respo.se.scode" + response.statusCode.toString());

      return lead_setting;
    } else {
      print(json.decode(response.body).toString());
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future getleadstatus() async {
    Uri url = Uri.parse(siteurl + "api/leadstatus");

    print(url);
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accesstoken',
    });
    if (response.statusCode == 200) {
      setState(() {
        var resBody = json.decode(response.body);

        lead_status = json.decode(response.body);
      });

      print("lead_status id is" + lead_status.toString());
      print(lead_status.toString());
      return lead_status;
    } else {
      print(json.decode(response.body).toString());
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future getleadsource() async {
    //http://humbletree.in/lms/api/leadsources

    Uri url = Uri.parse(siteurl + "api/leadsources");

    print(url);
    print("http://humbletree.in/lms/api/leadsources");
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accesstoken',
    });
    if (response.statusCode == 200) {
      setState(() {
        var resBody = json.decode(response.body);
        for (int i = 0; i < resBody.length; i++) {
          lead_source.add(
              //resBody[i]['name']
              {
                "name": resBody[i]['name'],
                "id": resBody[i]['id'],
              });
        }
      });

      print("lead_source id is" + lead_source.toString());
      print(lead_source.toString());
      return lead_source;
    } else {
      print(json.decode(response.body).toString());
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future getleadaccountindustries() async {
    //http://humbletree.in/lms/api/leadsources

    Uri url = Uri.parse(siteurl + "api/accountindustries");

    print("url&accesstoekn" + url.toString() + '$accesstoken'.toString());
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accesstoken',
    });
    if (response.statusCode == 200) {
      setState(() {
        var resBody = json.decode(response.body);
        for (int i = 0; i < resBody.length; i++) {
          lead_accountindustries.add({
            "name": resBody[i]['name'],
            "id": resBody[i]['id'],
          });
        }
      });

      print("lead_accountindustries id is" + lead_accountindustries.toString());
      print(lead_accountindustries.toString());
      return lead_accountindustries;
    } else {
      print(json.decode(response.body).toString());
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  createlead(
      fname,
      femail,
      fphone,
      ftitle,
      fwebsite,
      fleadaddress,
      fleadcity,
      fleadstate,
      fleadcountry,
      fleadpostalcode,
      fopportunityamount,
      fsource,
      fstatus,
      findustry,
      fdescription,fnotes
      
      ) async {
    print(
        "fname,femail,fphone,ftitle,fwebsite,fleadaddress,fleadcity,fleadstate,fleadcountry,fleadpostalcode,fopportunityamount,fsource,findustry,fdescription" +
            fname.toString() +
            femail.toString() +
            fphone.toString() +
            ftitle.toString() +
            fwebsite.toString() +
            fleadaddress.toString() +
            fleadcity.toString() +
            fleadstate.toString() +
            fleadcountry.toString() +
            fleadpostalcode.toString() +
            fopportunityamount.toString() +
            fsource.toString() +
            fstatus.toString() +
            findustry.toString() +
            fdescription.toString()+fnotes.toString());
    var url = Uri.parse(siteurl + "api/leads/create");

    var response = await http.post(url, headers: {
      //  'Content-type': 'application/json',
      //   'Accept': 'application/json',
      'Authorization': 'Bearer $accesstoken',
    },
        //  headers: {"Accept": "application/json"},
        body: {
          "name": fname.toString(),
          "email": femail.toString(),
          "phone": fphone.toString(),
          "title": ftitle.toString(),
          "website": fwebsite.toString(),
          "lead_address": fleadaddress.toString(),
          "lead_city": fleadcity.toString(),
          "lead_state": fleadstate.toString(),
          "lead_country": fleadcountry.toString(),
          "lead_postalcode": fleadpostalcode.toString(),
          "opportunity_amount": fopportunityamount.toString(),
          //opportunityamount
          "source": fsource.toString(),
          "status": fstatus.toString(),
          "industry": findustry.toString(),
          "description": fdescription.toString(),
          "notes":fnotes.toString(),
          "location_longitude": widget.lang.toString(),
          "location_latitude": widget.lati.toString()
        });
    print("responseeee");
    print(response.body.toString());
    print(response.statusCode);

    if (response.statusCode == 201) {
      print('response.body:' + response.body.toString());
      setState(() {
        //   leadresponse = json.decode(response.body);
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Lead created successfully"),
          backgroundColor: Color(maincolor),
        ));
        Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new LeadlistScreen(),
        ));
      });

      print("create sucessfully");
    } else {
      print(response.statusCode);

      setState(() {
        // leadresponse = json.decode(response.body);
        print("leadresponse" + response.body.toString());
        var leadresponse1 = json.decode(response.body);
        print("leadresponse1" + leadresponse1['message'].toString());
        msg = leadresponse1['message'].toString();
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

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController website = TextEditingController();
  TextEditingController leadaddress = TextEditingController();
  TextEditingController leadcity = TextEditingController();

  TextEditingController leadstate = TextEditingController();

  TextEditingController leadcountry = TextEditingController();
  TextEditingController leadpostalcode = TextEditingController();

  TextEditingController opportunityamount = TextEditingController();

  TextEditingController source = TextEditingController();

  TextEditingController status = TextEditingController();
  //status
  TextEditingController industry = TextEditingController();

  TextEditingController description = TextEditingController();

  TextEditingController notes = TextEditingController();

  final formKey = GlobalKey<FormState>();
  SharedPreferences sharedPreferences;
  var accesstoken;
  checkaccesstoken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    accesstoken = sharedPreferences.getString("access_token") ?? "_";
    print("accesstoken" + accesstoken);
    if (accesstoken == "_") {
      print("insode if no access token ");
    } else {
      print("inside else" + accesstoken);
      getleadsource();
      getleadaccountindustries();
      getsettingdetails();
      getleadstatus();
      /*  Navigator.of(context).push(new MaterialPageRoute(
      builder: (BuildContext context) => new LeadlistScreen(),
    ));*/
    }
  }

/*  if (_leadlist[i]['status'] == "0") {
                setState(() {
                  _leadlist[i]['status'] = "New";
                  contcolor = Colors.blue;
                });
              } else if (_leadlist[i]['status'] == "1") {
                setState(() {
                  _leadlist[i]['status'] = "Assigned";
                  //  contcolor = Colors.teal;
                });
              } else if (_leadlist[i]['status'] == "2") {
                setState(() {
                  _leadlist[i]['status'] = "In Process";
                  // contcolor = Colors.orange;
                });
              } else if (_leadlist[i]['status'] == "3") {
                setState(() {
                  _leadlist[i]['status'] = "Converted";
                  //  contcolor = Colors.red;
                });
              } else if (_leadlist[i]['status'] == "4") {
                setState(() {
                  _leadlist[i]['status'] = "Recycled";
                  //   contcolor = Colors.red;
                });
              } else if (_leadlist[i]['status'] == "5") {
                setState(() {
                  _leadlist[i]['status'] = "Dead";
                  //   contcolor = Colors.red;
                });
              } */
  void initState() {
    checkaccesstoken();
    //getsettingdetails();

    print("widget.country.locality.subLocality.postalCode.street " +
        widget.country.toString() +
        widget.locality +
        widget.subLocality +
        widget.postalCode +
        widget.street);
    super.initState();
    leadaddress.text = widget.street.toString();
    leadcity.text = widget.locality.toString();

    leadstate.text = widget.state.toString();

    leadcountry.text = widget.country.toString();
    leadpostalcode.text = widget.postalCode.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        backgroundColor: Color(maincolor),
        leading: InkResponse(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new LeadlistScreen(),
            ));
            //     Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text("Create New Lead"),
      ),
      body: Form(
        key: formKey,
        child: WillPopScope(
          //   onWillPop: () async => false,
          onWillPop: () {
            Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new LeadlistScreen(),
            ));
          },
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  /* Text(
                    "Create New Lead",
                    style: TextStyle(
                        color: Color(maincolor),
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
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
                                if (lead_setting['name'] == 1) {
                                  if (value.isEmpty) {
                                    return "Please enter name";
                                  }
                                } else if (lead_setting['name'] == 0) {}
                              },
                              //  validator: validateEmail,
                              controller: name,
                              //  autofocus:true,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                //   labelText: "Email",
                                hintText: "Name",
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
                              /* validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter email";
                                }
                              },*/
                              validator: (value) {
                                if (lead_setting['email'] == 1) {
                                  Pattern pattern =
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                  RegExp regex = new RegExp(pattern);
                                  if (!regex.hasMatch(value)) {
                                    return 'Enter Valid Email';
                                  } else {
                                    return null;
                                  }

                                  //  ValidateEmail();
                                } else if (lead_setting['email'] == 0) {
                                  if (value.isEmpty) {
                                    return "";
                                  }
                                }
                              },
                              // validator: validateEmail,
                              controller: email,
                              //  autofocus:true,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                //   labelText: "Email",
                                hintText: "Email",
                                border: InputBorder.none,
                                fillColor: Colors.white,
                              )),
                        ),
                      ),
                    ),
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
                              /*  validator: (value) {
                                if (value.isEmpty) {
                                  return "Please Enter Phone";
                                }
                              },*/
                              //alidator: validateMobile,
                              validator: (value) {
                                if (lead_setting['phone'] == 1) {
                                  String patttern = r'(^[0-9]*$)';
                                  RegExp regExp = new RegExp(patttern);
                                  if (value.length == 0) {
                                    return "Please enter the Mobile Number";
                                  } else if (value.length != 10) {
                                    return "Mobile number must 10 digits";
                                  } else if (!regExp.hasMatch(value)) {
                                    return "Mobile Number must be digits";
                                  }
                                  return null;

                                  //  ValidateEmail();
                                } else if (lead_setting['phone'] == 0) {
                                  if (value.isEmpty) {
                                    return "";
                                  }
                                }
                              },
                              controller: phone,
//                              minLines: 10,
                              maxLength: 10,
                              //  autofocus:true,
                              //  keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                //   labelText: "Email",
                                labelText: 'Phone',
                                hintText: "Phone",
                                border: InputBorder.none,
                                fillColor: Colors.white,
                              )),
                        ),
                      ),
                    ),
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
                              /*    validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter title";
                                }
                              },*/
                              validator: (value) {
                                if (lead_setting['title'] == 1) {
                                  if (value.isEmpty) {
                                    return "Please enter title";
                                  }
                                } else if (lead_setting['title'] == 0) {}
                              },
                              controller: title,
                              //  autofocus:true,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: 'Title',
                                hintText: "Title",
                                border: InputBorder.none,
                                fillColor: Colors.white,
                              )),
                        ),
                      ),
                    ),
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
                              /*validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter website";
                                }
                              },*/
                              validator: (value) {
                                if (lead_setting['website'] == 1) {
                                  if (value.isEmpty) {
                                    return "Please enter website";
                                  }
                                } else if (lead_setting['website'] == 0) {}
                              },
                              controller: website,
                              //  autofocus:true,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: 'Website',
                                hintText: "Website",
                                border: InputBorder.none,
                                fillColor: Colors.white,
                              )),
                        ),
                      ),
                    ),
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
                              /*  validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter lead address";
                                }
                              },*/
                              validator: (value) {
                                if (lead_setting['lead_address'] == 1) {
                                  if (value.isEmpty) {
                                    return "Please enter lead address";
                                  }
                                } else if (lead_setting['lead_address'] == 0) {}
                              },
                              controller: leadaddress,
                              //  autofocus:true,
                              keyboardType: TextInputType.streetAddress,
                              decoration: InputDecoration(
                                labelText: 'Lead Address',
                                hintText: "Lead Address",
                                border: InputBorder.none,
                                fillColor: Colors.white,
                              )),
                        ),
                      ),
                    ),
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
                                if (lead_setting['lead_city'] == 1) {
                                  if (value.isEmpty) {
                                    return "Please enter city";
                                  }
                                } else if (lead_setting['lead_city'] == 0) {}
                              },
                              controller: leadcity,
                              //  autofocus:true,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: 'City',
                                hintText: "City",
                                border: InputBorder.none,
                                fillColor: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ),
                  /*
        
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
                                  return "Please enter state";
                                }
                              },
                              controller: leadstate,
                              //  autofocus:true,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                hintText: "Enter state",
                                border: InputBorder.none,
                                fillColor: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ),*/
                  /*Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.grey[200],
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                ///Adding CSC Picker Widget in app
                                CSCPicker(
                                  ///Enable disable state dropdown [OPTIONAL PARAMETER]
                                  showStates: true,
        
                                  /// Enable disable city drop down [OPTIONAL PARAMETER]
                                  showCities: false,
        
                                  ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                                  flagState: CountryFlag.DISABLE,
        
                                  ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                                  dropdownDecoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey.shade300, width: 1)),
        
                                  ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                                  disabledDropdownDecoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: Colors.grey.shade300,
                                      border: Border.all(
                                          color: Colors.grey.shade300, width: 1)),
        
                                  ///placeholders for dropdown search field
                                  countrySearchPlaceholder: "Country",
                                  stateSearchPlaceholder: "State",
                                  citySearchPlaceholder: "City",
        
                                  ///labels for dropdown
                                  countryDropdownLabel: "Country",
                                  stateDropdownLabel: "State",
                                  cityDropdownLabel: "City",
        
                                //defaultCountry :DefaultCountry.India,
                                                              defaultCountry :DefaultCountry.India,
                              //  leadcountry.text;
                                //  defaultCountry: DefaultCountry.India,
        
         // defaultCountry: leadcountry.text.toString(),
                                  ///Disable country dropdown (Note: use it with default country)
                                  //disableCountry: true,
        
                                  ///selected item style [OPTIONAL PARAMETER]
                                  selectedItemStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
        
                                  ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                                  dropdownHeadingStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
        
                                  ///DropdownDialog Item style [OPTIONAL PARAMETER]
                                  dropdownItemStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
        
                                  ///Dialog box radius [OPTIONAL PARAMETER]
                                  dropdownDialogRadius: 10.0,
        
                                  ///Search bar radius [OPTIONAL PARAMETER]
                                  searchBarRadius: 10.0,
        
                                  ///triggers once country selected in dropdown
                                  onCountryChanged: (value) {
                                    setState(() {
                                      ///store value in country variable
                                      leadcountry.text = value;
                                    });
                                  },
        
                                  ///triggers once state selected in dropdown
                                  onStateChanged: (value) {
                                    setState(() {
                                      ///store value in state variable
                                      leadstate.text = value;
                                    });
                                  },
        
                                  ///triggers once city selected in dropdown
                                  onCityChanged: (value) {
                                    setState(() {
                                      ///store value in city variable
                                      leadcity.text = value;
                                    });
                                  },
                                ),
                              ],
                            )),
        
                        /* TextFormField(
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "Please enter country";
                                              }
                                            },
                                            controller: leadcountry,
                                            //  autofocus:true,
                                            keyboardType: TextInputType.name,
                                 
                                            decoration: InputDecoration(
                                               suffix: InkWell(
                                                 onTap: (){
                                                        showCountryPicker(
                              context: context,
                              //Optional.  Cans be used to exclude(remove) one ore more country from the countries list (optional).
                            //  exclude: <String>['KN', 'MF'],
                              //Optional. Shows phone code before the country name.
                              showPhoneCode: false,
                              onSelect: (Country country) {
                                print('Select country: ${country.name}');
                                setState(() {
                                  leadcountry.text = '${country.name}';
                                });
                              
                              },
                              // Optional. Sets the theme for the country list picker.
                              countryListTheme: CountryListThemeData(
                                // Optional. Sets the border radius for the bottomsheet.
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40.0),
                                  topRight: Radius.circular(40.0),
                                ),
                                // Optional. Styles the search field.
                                inputDecoration: InputDecoration(
                                  labelText: 'Search',
                                  hintText: 'Start typing to search',
                                  prefixIcon: const Icon(Icons.search),
                                  /*border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: const Color(0xFF8C98A8).withOpacity(0.2),
                                    ),
                                  ),*/
                                ),
                              ),
                            );
              
                                                 },
                                                 
                                                 child: new Icon(Icons.arrow_drop_down, color: Colors.grey)),
                           // hintText: 'Search...',
           //   suffixText: '${.length}',
                                              hintText: "Enter Country",
                                              border: InputBorder.none,
                                              fillColor: Colors.white,
                                            )),
                          
                          */ /* TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter country";
                                }
                              },
                              controller: leadcountry,
                              //  autofocus:true,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                hintText: "Enter Country",
                                border: InputBorder.none,
                                fillColor: Colors.white,
                              )),*/
                      ),
                    ),
                  ),
                */

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
                                if (lead_setting['lead_state'] == 1) {
                                  if (value.isEmpty) {
                                    return "Please enter state";
                                  }
                                } else if (lead_setting['lead_state'] == 0) {}
                              },
                              controller: leadstate,
                              //  autofocus:true,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: 'State',
                                hintText: "State",
                                border: InputBorder.none,
                                fillColor: Colors.white,
                              )),
                        ),
                      ),
                    ),
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
                                if (lead_setting['lead_country'] == 1) {
                                  if (value.isEmpty) {
                                    return "Please enter country";
                                  }
                                } else if (lead_setting['lead_country'] == 0) {}
                              },
                              controller: leadcountry,
                              //  autofocus:true,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: 'Country',
                                hintText: "Country",
                                border: InputBorder.none,
                                fillColor: Colors.white,
                              )),
                        ),
                      ),
                    ),
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
                              /* validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter postal code";
                                }
                              },*/

                              controller: leadpostalcode,
                              //  autofocus:true,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Postal code',
                                hintText: "Postal code",
                                border: InputBorder.none,
                                fillColor: Colors.white,
                              )),
                        ),
                      ),
                    ),
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
                              controller: opportunityamount,
                              //  autofocus:true,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Opportunity Amount',
                                hintText: "Opportunity Amount",
                                border: InputBorder.none,
                                fillColor: Colors.white,
                              )),
                        ),
                      ),
                    ),
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
                          child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                  //   labelText: 'Choose source ',
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey[200]))),
                              hint: Text(
                                  'Choose Status'), // Not necessary for Option 1
                              //    value: _selecteditem,
                              items: lead_status
                                  .map<DropdownMenuItem<String>>((value) {
                                //    print("newMap of onchanged" + newMap .toString());
                                return DropdownMenuItem<String>(
                                  child: Text(
                                    value.toString(),
                                    style: TextStyle(
                                        fontSize: 15.0, color: Colors.black
                                        //[
                                        //700]
                                        ),
                                  ),
                                  value: value.toString(),
                                  //
                                  //  value: value['slug'].toString()
                                );

                                // }
                              }).toList(),
                              validator: (value) => value == null
                                  ? 'Kindly Choose a Status'
                                  : null,
                              onChanged: (newValue) {
                                status.text = newValue.toString();
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              }),
                        ),
                      ),
                    ),
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
                          child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                  //   labelText: 'Choose source ',
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey[200]))),
                              hint: Text(
                                  'Choose source'), // Not necessary for Option 1
                              //    value: _selecteditem,
                              items: lead_source
                                  .map<DropdownMenuItem<String>>((value) {
                                //    print("newMap of onchanged" + newMap .toString());
                                return DropdownMenuItem<String>(
                                  child: Text(
                                    value['name'].toString(),
                                    style: TextStyle(
                                        fontSize: 15.0, color: Colors.black
                                        //[
                                        //700]
                                        ),
                                  ),
                                  value: value['id'].toString(),
                                  //
                                  //  value: value['slug'].toString()
                                );

                                // }
                              }).toList(),
                              validator: (value) => value == null
                                  ? 'Kindly Choose a source'
                                  : null,
                              onChanged: (newValue) {
                                if (newValue == "New") {
                                  status.text = "0";
                                } else if (newValue == "Assigned") {
                                  status.text = "1";
                                } else if (status.text == "In Process") {
                                  status.text = "2";
                                } else if (status.text == "Converted") {
                                  status.text = "3";
                                } else if (status.text == "Recycled") {
                                  setState(() {
                                    status.text = "4";
                                  });
                                } else if (status.text == "Dead") {
                                  status.text = "5";
                                }
                                source.text = newValue.toString();
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              }),

                          /*TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter source";
                                }
                              },
                              controller: source,
                              //  autofocus:true,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Enter source",
                                border: InputBorder.none,
                                fillColor: Colors.white,
                              )),*/
                        ),
                      ),
                    ),
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
                          child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                  // labelText: 'Choose Industries',
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey[200]))),
                              hint: Text(
                                  'Choose Industries'), // Not necessary for Option 1
                              //    value: _selecteditem,
                              items: lead_accountindustries
                                  .map<DropdownMenuItem<String>>((value) {
                                //    print("newMap of onchanged" + newMap .toString());
                                return DropdownMenuItem<String>(
                                  child: Text(
                                    value['name'].toString(),
                                    // FocusScope.of(context).requestFocus(new FocusNode());

                                    style: TextStyle(
                                        fontSize: 15.0, color: Colors.black
                                        //[
                                        //700]
                                        ),
                                  ),
                                  value: value['id'].toString(),
                                  //
                                  //  value: value['slug'].toString()
                                );

                                // }
                              }).toList(),
                              validator: (value) => value == null
                                  ? 'Kindly Choose an Industries'
                                  : null,
                              onChanged: (newValue) {
                                industry.text = newValue.toString();
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              }),

                          /* TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter industry";
                                }
                              },
                              controller: industry,
                              //  autofocus:true,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Enter industry",
                                border: InputBorder.none,
                                fillColor: Colors.white,
                              )),
                      
                      */
                        ),
                      ),
                    ),
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
                                if (lead_setting['description'] == 1) {
                                  if (value.isEmpty) {
                                    return "Please enter description";
                                  }
                                } else if (lead_setting['description'] == 0) {}
                              },
                              maxLines: 5,
                              controller: description,
                              //  autofocus:true,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: 'Description',
                                hintText: "Description",
                                border: InputBorder.none,
                                fillColor: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ),
                  
                   Visibility(
                     visible: displaynotes,
                     child: Padding(
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
                                  if (lead_setting['notes'] == 1) {
                                    if (value.isEmpty) {
                                      return "Please enter notes";
                                    }
                                  } else if (lead_setting['notes'] == 0) {}
                                },
                                maxLines: 5,
                                controller: notes,
                                //  autofocus:true,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  labelText: 'Notes',
                                  hintText: "Notes",
                                  border: InputBorder.none,
                                  fillColor: Colors.white,
                                )),
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
                            if (formKey.currentState.validate() &&
                                leadcity.text.isNotEmpty &&
                                leadcountry.text.isNotEmpty &&
                                leadstate.text.isNotEmpty) {
                              createlead(
                                  name.text,
                                  email.text,
                                  phone.text,
                                  title.text,
                                  website.text,
                                  leadaddress.text,
                                  leadcity.text,
                                  leadstate.text,
                                  leadcountry.text,
                                  leadpostalcode.text,
                                  opportunityamount.text,
                                  source.text,
                                  status.text,
                                  industry.text,
                                  description.text
                                  ,
                                  notes.text);
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                backgroundColor: Color(maincolor),
                                content: Text("Lead creation in progress"),
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
                                "Submit",
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
  String patttern = r'(^[0-9]*$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return "Please enter the Mobile Number";
  } else if (value.length != 10) {
    return "Mobile number must 10 digits";
  } else if (!regExp.hasMatch(value)) {
    return "Mobile Number must be digits";
  }
  return null;
}
