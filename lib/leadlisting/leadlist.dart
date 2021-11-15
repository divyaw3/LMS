import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ims/LeadRegister/leadregister.dart';
import 'package:ims/Login/login.dart';
import 'package:ims/const/constant.dart';
import 'package:http/http.dart' as http;
import 'package:ims/leadedit/leadedit.dart';
import 'package:ims/onboardscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeadlistScreen extends StatefulWidget {
  @override
  _LeadlistScreenState createState() => _LeadlistScreenState();
}

class _LeadlistScreenState extends State<LeadlistScreen> {
  var leadresponse = [];
    var lead_source = [];
  var lead_accountindustries = [];
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

    print("url&accesstoekn"+url.toString() + '$accesstoken'.toString());
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

  String msg = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _leadlist = [];

  final formKey = GlobalKey<FormState>();
  var accesstoken;
  String location = 'Null, Press Button';
  String Address = 'search';

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
     // List<Placemark> placemarks = await placemarkFromCoordinates(9.925201, 78.119774);
  
    print("placeplacemarkkkk" + placemarks.toString());
    Placemark place = placemarks[0];
    print("place" + place.toString());
    setState(() {
      Address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country},${place.administrativeArea}';
    });
    print("address" + Address.toString());
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context) => new LeadRegisterscreen(
              street: '${place.street}',
              subLocality: '${place.subLocality}',
              locality: '${place.locality}',
              postalCode: '${place.postalCode}',
              country: '${place.country}',
              lati: position.latitude,
              lang: position.longitude,
              state : '${place.administrativeArea}',
            )));
  }

 Future<void> GetAddressFromLatLong1(Position position, _leadlist) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
     // List<Placemark> placemarks = await placemarkFromCoordinates(9.925201, 78.119774);
  
    print("placeplacemarkkkk" + placemarks.toString());
    Placemark place = placemarks[0];
    print("place" + place.toString());
    setState(() {
      Address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country},${place.administrativeArea}';
    });
    print("address" + Address.toString());
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context) => new LeadEditscreen(
  
    /*
               "lead_address": resBody[i]['lead_address'],
              "lead_city": resBody[i]['lead_city'],
              "lead_state": resBody[i]['lead_state'], 
              "lead_country": resBody[i]['lead_country'],
              "lead_postalcode": resBody[i]['lead_postalcode'],
           
              "opportunity_amount": resBody[i]['opportunity_amount'],
              
            
             leadaddress.text = widget.street.toString();
    leadcity.text = widget.locality.toString();

    leadstate.text = widget.state.toString();

    leadcountry.text = widget.country.toString();
    leadpostalcode.text = widget.postalCode.toString();
       "id": resBody[i]['id'],
                 "status": resBody[i]['status'],
    */

              
             street:_leadlist["lead_address"] ,
             id:_leadlist["id"] ,
status:_leadlist["status"] ,
              locality: _leadlist["lead_city"],
              postalCode: _leadlist["lead_postalcode"],
              country: _leadlist["lead_country"],
              
              lati: position.latitude,
              lang: position.longitude,
              state : _leadlist["lead_state"],
              name:  _leadlist["name"],
              email:  _leadlist["email"],
              phone: _leadlist["phone"],
              website:  _leadlist["title"],
              source:  _leadlist["source"],
              description:  _leadlist["description"],
              industry:  _leadlist["industry"],
              title:  _leadlist["title"],
                
            )));
  }

  SharedPreferences sharedPreferences;
  getleadlist() async {
    print("inside getleadlist");
    sharedPreferences = await SharedPreferences.getInstance();
    accesstoken = sharedPreferences.getString("access_token") ?? "_";
    print("accesstoken" + accesstoken);
    if (accesstoken == "_") {
      print("insode if no access token ");
          setState(() {
        loginname = "Login";
      });
    } else {
      setState(() {
        loginname = "Logout";
      });
      getleadaccountindustries();
getleadsource();
      print("inside else" + accesstoken);

      Uri url = Uri.parse(siteurl + "api/leads");

      print(url);
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accesstoken',
      });
      if (response.statusCode == 200) {
        setState(() {
          var resBody = json.decode(response.body);
          print(resBody.toString());
          for (int i = 0; i < resBody.length; i++) {
            _leadlist.add({
              //     resBody
              "name": resBody[i]['name'],
              "id": resBody[i]['id'],
              "email": resBody[i]['email'],
              "phone": resBody[i]['phone'],
              "title": resBody[i]['title'],
              "website": resBody[i]['website'],
               "lead_address": resBody[i]['lead_address'],
              "lead_city": resBody[i]['lead_city'],
              "lead_state": resBody[i]['lead_state'], 
              "lead_country": resBody[i]['lead_country'],
              "lead_postalcode": resBody[i]['lead_postalcode'],
              "status": resBody[i]['status'],
              "source": resBody[i]['source'],
              "opportunity_amount": resBody[i]['opportunity_amount'],
              "industry": resBody[i]['industry'],
              "description": resBody[i]['description'],
              "campaign_name": resBody[i]['campaign_name'],
               "created_by": resBody[i]['created_by'],
            "created_from": resBody[i]['created_from'],
   // "location_latitude": resBody[i]['location_latitude'],
    //"location_longitude": resBody[i]['location_longitude'],
   // "updated_at": resBody[i]['updated_at'],
  //  "created_at":resBody[i]['created_at'],

            });
          }
        });

        print("lead_accountindustries id is" + _leadlist.toString());
        print(_leadlist.toString());
        return _leadlist;
      }
      else if(response.statusCode == 401){
         sharedPreferences = await SharedPreferences.getInstance();
       accesstoken = sharedPreferences.setString("access_token",  "_");
  
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context) => new Loginscreen(
             
            )));
        }
       else {
        print(response.statusCode.toString());  
        print(json.decode(response.body).toString());
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    }
  }
Future a ;
  initState() {
   a= getleadlist();
  // getleadlist();

    super.initState();
  }

  _showDialog(BuildContext context, _leadlist) {
    print("_leadlist_leadlist" + _leadlist.toString()+_leadlist['name']);
       if(_leadlist['industry'] == '1'){

setState(() {
  _leadlist['industry'] = "Catering";
});
    }
    else if(_leadlist['industry'] == '2'){
setState(() {
  _leadlist['industry'] = "Events Management";
});
    }
    else if(_leadlist['industry'] == '3'){
setState(() {
  _leadlist['industry'] = "Information Technology";
});
    }
    if(_leadlist['source'] == '1'){
setState(() {
  _leadlist['source'] = "Referral";
});
    }
    else if(_leadlist['source'] == '2'){
setState(() {
  _leadlist['source'] = "Google 0r Yellow Pages";
});
    }
    else if(_leadlist['source'] == '3'){
setState(() {
  _leadlist['source'] = "Digital Marketting";
});
    }
    else if(_leadlist['source'] == '4'){
setState(() {
  _leadlist['source'] = "Zoho Lead";
});
    }
    BlurryDialog alert =
        BlurryDialog(
          _leadlist['name'],
        _leadlist['email'], 
        _leadlist['phone'],
         _leadlist['title'], 
         _leadlist['website'], 
         _leadlist['lead_address'],
          _leadlist['lead_city'],
           _leadlist['lead_state'],
            _leadlist['lead_country'],
 
         _leadlist['status'],
          _leadlist['source'].toString(),
           _leadlist['opportunity_amount'].toString(), 
           _leadlist['industry'], 
           _leadlist['description'],);
          



    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  String loginname = "";

  int dynamiccrosscount = 2;
  double dynamicchildAspectRatio = 1;

  Future<void> _signOut() async {
    print("hi insode signout");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //
    await preferences.remove('access_token');
     setState(() {
     
      loginname = "Login";
    });
    Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => OnBoardScreen(),
        ),
        (route) => false,//if you want to disable back feature set to false
);
    /*Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new OnBoardScreen()));*/
  }

  @override
  Widget build(BuildContext context) {
        final screenSize = MediaQuery.of(context).size;
    final screenWidth =
        screenSize.width / (2 / (screenSize.height / screenSize.width));
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(maincolor),
        icon: Icon(Icons.add),
        label: Text('Add Lead'),
        onPressed: () async {
          Position position = await _getGeoLocationPosition();
          location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
          GetAddressFromLatLong(position);
        },
        //9.925201
        //78.119774
        
      ),
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(maincolor),
        leading: IconButton(
          icon: const Icon(
            Icons.blur_on,
            size: 35.0,
            color: Colors.white,
          ),
          onPressed: () {
            //eventBus.fire('drawer');

            _scaffoldKey.currentState.openDrawer();
          },
        ),
      
      /*  leading: InkResponse(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),*/
        centerTitle: true,
        title: Text("Leads List"),
      ),
        drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            //  createDrawerHeader(),
            Container(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.network(
                logo,
                height: 100.0,
                width: 50.0,
              ),
            )),

            Divider(
              color: Colors.black,
            ),
            InkWell(
              onTap: () {
           Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new LeadlistScreen()));
            },
              child: ListTile(
                title: Text('Leads'),
                leading: Icon(FontAwesomeIcons.addressCard),
              ),
            ),


             InkWell(
              onTap: () {
                print(loginname);
                if (loginname == "Login") {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new Loginscreen()));
                } else {
                  _signOut();
                  setState(() {
                    loginname = "Login";
                  });
                }
              },
              child: ListTile(
                title: Text(loginname),
                leading: Icon(FontAwesomeIcons.user),
              ),
            ),

            /*  Divider(
              color: Colors.black,
            ),*/

       
          ],
        ),
      ),
    
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
               FutureBuilder(
                  //child: FutureBuilder(
                  future: a,
                  //  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);

                   
                    return snapshot.hasData == true
                        ? Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                /*Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                      onTap: () {
                                        /*    Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new Alleventsscreen()));*/
                                      },
                                      child: Container(
                                          child: Image.network(img,
                                              height: screenSize.height / 4,
                                              fit: BoxFit.cover,
                                              width: screenSize.width))),
                                ),*/
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                      Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: Text("Number of Leads".toString(),  style:
                                                                          new TextStyle(
                                                                        fontSize:
                                                                            18.0,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: Text(_leadlist.length.toString(),  style:
                                                                          new TextStyle(
                                                                        fontSize:
                                                                            18.0,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),),
                                      ),
                                    ),
                                  ],
                                ),
                                GridView.builder(
                                    shrinkWrap: true,
                                    primary: false,
                                    //  padding: const EdgeInsets.all(10.0),
                                    scrollDirection: Axis.vertical,
                                    itemCount: _leadlist.length,
                                    //  itemCount: data.length,
                                    gridDelegate:
                                        new SliverGridDelegateWithFixedCrossAxisCount(
                                    //  crossAxisCount: dynamiccrosscount,
                                    crossAxisCount: 2,
                                      childAspectRatio: MediaQuery.of(context)
                                              .size
                                              .width /
                                          (MediaQuery.of(context).size.height /
                                              1.25),
                                      mainAxisSpacing: 10.0,
                                
                                      crossAxisSpacing: 10.0,
                                      //childAspectRatio: (2/ 2.3),
                                      // childAspectRatio: dynamicchildAspectRatio,
                                      // childAspectRatio: MediaQuery.of(context).size.width /  (MediaQuery.of(context).size.height /2.0),
                                      //  mainAxisSpacing: 10.0,
                                      // crossAxisSpacing: 10.0,
                                    ), //itemBuilder: null
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                     
                                      //   Navigator.pop(context);
                                             if(_leadlist[index]['industry'] == '1'){

//setState(() {
  _leadlist[index]['industry'] = "Catering";
//});
    }
    else if(_leadlist[index]['industry'] == '2'){
//setState(() {
  _leadlist[index]['industry'] = "Events Management";
//});
    }
    else if(_leadlist[index]['industry'] == '3'){
//setState(() {
  _leadlist[index]['industry'] = "Information Technology";
//});
    }
    if(_leadlist[index]['source'] == '1'){
//setState(() {
  _leadlist[index]['source'] = "Referral";
//});
    }
    else if(_leadlist[index]['source'] == '2'){
//setState(() {
  _leadlist[index]['source'] = "Google 0r Yellow Pages";
//});
    }
    else if(_leadlist[index]['source'] == '3'){
//setState(() {
  _leadlist[index]['source'] = "Digital Marketting";
//});
    }
    else if(_leadlist[index]['source'] == '4'){
//setState(() {
  _leadlist[index]['source'] = "Zoho Lead";
//});
    }
                                      return new GestureDetector(
                                         onTap: () {
                                                  
                                                },
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Card(
                                            elevation: 4.0,
                                            child: GestureDetector(
                                             
                                            child: new Container(
                                             
                                            child: Column(
                                              
                                              children: <Widget>[
                                                Container(
                                                  
                                                  child: Row(
                                                     mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                              crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                    children: [
                                                   //   SizedBox(height: 45.0,),
                                                      Padding(
                                                      //  padding:  const EdgeInsets .all(  20.0),

                                                         padding: const EdgeInsets.fromLTRB(5.0, 20.0, 0.0, 10.0),
                                                        child: Center(
                                                          child: Container(
                                                            //  decoration: BoxDecoration(border: Border.all(color: Color(maincolor))),
                                                              child: CircleAvatar(
                                                                backgroundColor: Color(maincolor),
                                    child: Text( "${_leadlist[index]['name'][0]}".toUpperCase(),style: TextStyle(color: Colors.white),))),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                   padding:
                                                      const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                                                  child: Container(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                         Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(
                                      
                                      FontAwesomeIcons.user,
                                      color:Color(maincolor),
                                      size:15.0,
                                      ),
                                  ),
                                                        Expanded(
                                                          child:
                                                              Padding(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                    2.0),
                                                            child: Text(
                                                              //   "hai",
                                                           //  _leadlist[ij]['name'].toString(),
                                                              "${_leadlist[index]['name']}",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              // softWrap: false,
                                                              style:
                                                                  new TextStyle(
                                                                fontSize:
                                                                    15.0,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                                                  child: Container(

                                                    child:    Row(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(
                                      
                                      FontAwesomeIcons.envelopeSquare,
                                      color:Color(maincolor),
                                      size:15.0,
                                      ),
                                  ),
                                    SizedBox(width: 2.0,),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(   "${_leadlist[index]['email']}", 
                                                                      style:
                                                                  new TextStyle(
                                                                fontSize:
                                                                    15.0,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight.bold,
                                                              ),
                                                                       ),
                                        ),
                                      ),
                                ],),
                                
                                                    
                                                  /*   Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              Padding(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                    5.0),
                                                            child: Text(
                                                              
                                                                  " " +
                                                                  "${_leadlist[index]['email']}",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              // softWrap: false,
                                                              style:
                                                                  new TextStyle(
                                                                fontSize:
                                                                    13.0,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                */
                                                  ),
                                                ),
                                                 Padding(
                                                   padding:
                                                      const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                                                  child: Container(

                                                    child:    Row(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(
                                      
                                      FontAwesomeIcons.mobile,
                                      color:Color(maincolor),
                                      size:15.0,
                                      ),
                                  ),
                                    SizedBox(width: 2.0,),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(   "${_leadlist[index]['phone']}", 
                                                                       style:
                                                                  new TextStyle(
                                                                fontSize:
                                                                    15.0,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight.bold,
                                                              ),
                                                                       ),
                                        ),
                                      ),
                                ],),
                                
                                                    
                                                   
                                                  ),
                                                ),
                                             
                                            Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                                                  child: Container(

                                                    child:    Row(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(
                                      
                                      FontAwesomeIcons.industry,
                                      color:Color(maincolor),
                                      size:15.0,
                                      ),
                                  ),
                                    SizedBox(width: 2.0,),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(    _leadlist[index]['industry'], 
                                                                       style:
                                                                  new TextStyle(
                                                                fontSize:
                                                                    15.0,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight.bold,
                                                              ),
                                                                       ),
                                        ),
                                      ),
                                ],),
                                
                                                    
                                                   
                                                  ),
                                                ),
                                            Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                                                  child: Container(

                                                    child:    Row(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(
                                      
                                      FontAwesomeIcons.city,
                                      color:Color(maincolor),
                                      size:15.0,
                                      ),
                                  ),
                                    SizedBox(width: 2.0,),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(    _leadlist[index]['lead_city'], 
                                                                       style:
                                                                  new TextStyle(
                                                                fontSize:
                                                                    15.0,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight.bold,
                                                              ),
                                                                       ),
                                        ),
                                      ),
                                ],),
                                
                                                    
                                                   
                                                  ),
                                                ),
Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                                                  child: Container(

                                                    child:    Row(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: FlatButton(onPressed: 
                                    () async {
Position position = await _getGeoLocationPosition();
          location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
          GetAddressFromLatLong1(position, _leadlist[index]);
                                    }, child: Text("Edit"))
                                  ),
                                    SizedBox(width: 2.0,),
                                      Flexible(
                                        child:  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: FlatButton(onPressed: 
                                    (){
  _showDialog(context, _leadlist[index]);
                                    }, child: Text("View"))
                                  ),
                                      ),
                                ],),
                                
                                                    
                                                   
                                                  ),
                                                ),
                                                                                          
                                              ],
                                            ),
                                            ),
                                            ),
                                          ),
                                        ),
                                        
                                      );
                                    }),
                              ],
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 150.0,
                              ),
                              new Center(
                                child: new CircularProgressIndicator(),
                              ),
                            ],
                          );
                  },
                ),
         
              /*Row(
                children: [
                  Expanded(
                    child: DataTable(
                      sortColumnIndex: 1,
        
                      //    sortAscending: true,
                      // dataRowHeight: 50,
                      // dividerThickness: 5,
                      columns: <DataColumn>[
                        DataColumn(
                          tooltip: "This is Name",
                          label: Text(
                            'Name',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Color(maincolor)),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Email',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Color(maincolor)),
                          ),
                        ),
                      ],
                      rows: <DataRow>[
                        for (int ij = 0; ij < _leadlist.length; ij++)
                          DataRow(
                            cells: <DataCell>[
                              DataCell(
                                  Text(
                                    _leadlist[ij]['name'].toString(),
                                  ),
                                  //   showEditIcon: true,
                                  placeholder: false, onTap: () {
                                print('row 1 pressed');
                                _showDialog(context, _leadlist[ij]);
                              }),
                              DataCell(
                                  Text(_leadlist[ij]['email'].toString()
        
                                      //_leadlist[ij]['email']  null : _leadlist[ij]['email'] ? ''
        
                                      ), onTap: () {
                                print('row 2 pressed');
                                _showDialog(context, _leadlist[ij]);
                              }),
                              /* DataCell(Text(
                               _leadlist[ij]['phone'].toString() 
                            //  _leadlist[ij]['phone']
                              
                              )),*/
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              )
            */
            ],
          ),
        ),
      ),
    );
  }
}

class BlurryDialog extends StatelessWidget {
  // String title;
  String name,
      email,
      Phone,
      Title,
      Website,
      leadAddress,
      City,
      State,
      Country,
      Status,
      Source,
      OpportunityAmount,
      Campaign,
      Industry,description;
  //VoidCallback continueCallBack;

  BlurryDialog(
      // this.title,
      //this.content,
      this.name,
      this.email,
      this.Phone,
      this.Title,
      this.Website,
      this.leadAddress,
      this.City,
      this.State,
      this.Country,
      this.Status,
      this.Source,
      this.OpportunityAmount,
     // this.Campaign,
      this.Industry,
      this.description
      );
  TextStyle textStyle = TextStyle(color: Colors.black,fontSize: 15.0);

  TextStyle textStyle1 = TextStyle(color: Colors.white,fontSize: 15.0);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: SingleChildScrollView(
          child: AlertDialog(
            //contentPadding: EdgeInsets.zero,
        
            // content: new Text('Lead Details',style: textStyle,),
            title: Container(
              child: Column(
                children: [
                       Row(
                  children: [
                    Expanded(
                      child: DataTable(
                        sortColumnIndex: 1,
                    
                      columns: <DataColumn>[
                          DataColumn(
                            tooltip: "This is Name",
                            label: Text(
                              'Name',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Color(maincolor)),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              name,
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Color(maincolor)),
                            ),
                          ),
                          
                        ],
                        
                        rows: <DataRow>[
                     //     for (int ij = 0; ij < _leadlist.length; ij++)
                            DataRow(
                              cells: <DataCell>[
                                DataCell(
                                    Text(
                                     'Email'
                                    ),
                                    //   showEditIcon: true,
                                       ),
                                DataCell(
                                    Text(email.toString()
                    
                     
                                        ),  ),
                                
                              ],
                            ),
                               DataRow(
        
                              cells: <DataCell>[
                                DataCell(
                                    Text(
                                     'Phone'
                                    ),
                                    //   showEditIcon: true,
                                       ),
                                DataCell(
                                    Text(Phone.toString()
                    
                     
                                        ),  ),
        
                                
                              ],
                            ),
                              DataRow(
        
                              cells: <DataCell>[
                                DataCell(
                                    Text(
                                     'Title'
                                    ),
                                    //   showEditIcon: true,
                                       ),
                                DataCell(
                                    Text(Title.toString()
                    
                     
                                        ),  ),
                                        
                                
                              ],
                            ),
                              DataRow(
        
                              cells: <DataCell>[
                                DataCell(
                                    Text(
                                     'Website'
                                    ),
                                    //   showEditIcon: true,
                                       ),
                                DataCell(
                                    Text(Website.toString()
                    
                     
                                        ),  ),
                                        
                                
                              ],
                            ),
                              DataRow(
        
                              cells: <DataCell>[
                                DataCell(
                                    Text(
                                     'Lead Address'
                                    ),
                                    //   showEditIcon: true,
                                       ),
                                DataCell(
                                    Text(leadAddress.toString()
                    
                     
                                        ),  ),
                                        
                                
                              ],
                            ),
                              DataRow(
        
                              cells: <DataCell>[
                                DataCell(
                                    Text(
                                     'City'
                                    ),
                                    //   showEditIcon: true,
                                       ),
                                DataCell(
                                    Text(City.toString()
                    
                     
                                        ),  ),
                                        
                                
                              ],
                            ),
                              DataRow(
        
                              cells: <DataCell>[
                                DataCell(
                                    Text(
                                     'State'
                                    ),
                                    //   showEditIcon: true,
                                       ),
                                DataCell(
                                    Text(State.toString()
                    
                     
                                        ),  ),
                                        
                                
                              ],
                            ),
                              DataRow(
        
                              cells: <DataCell>[
                                DataCell(
                                    Text(
                                     'Country'
                                    ),
                                    //   showEditIcon: true,
                                       ),
                                DataCell(
                                    Text(Country.toString()
                    
                     
                                        ),  ),
                                        
                                
                              ],
                            ),
                              
                              /*DataRow(
        
                              cells: <DataCell>[
                                DataCell(
                                    Text(
                                     'Status'
                                    ),
                                    //   showEditIcon: true,
                                       ),
                                DataCell(
                                    Text(Status.toString()
                    
                     
                                        ),  ),
                                        
                                
                              ],
                            ),*/
                                
                              DataRow(
        
                              cells: <DataCell>[
                                DataCell(
                                    Text(
                                     'Source'
                                    ),
                                    //   showEditIcon: true,
                                       ),
                                DataCell(
                                    Text(Source.toString()
                    
                     
                                        ),  ),
                                        
                                
                              ],
                            ),
                              DataRow(
        
                              cells: <DataCell>[
                                DataCell(
                                    Text(
                                     'Opportunity Amount'
                                    ),
                                    //   showEditIcon: true,
                                       ),
                                DataCell(
                                    Text( defultcurrency +" "+OpportunityAmount.toString()
                    
                     
                                        ),  ),
                                        
                                
                              ],
                            ),
                              DataRow(
        
                              cells: <DataCell>[
                                DataCell(
                                    Text(
                                     'Industry'
                                    ),
                                    //   showEditIcon: true,
                                       ),
                                DataCell(
                                    Text(Industry.toString()
                    
                     
                                        ),  ),
                                        
                                
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                )
              
                ],
              ),
            ),
            // new Text(content, style: textStyle,),
            actions: <Widget>[
              new RaisedButton(
                color: Color(maincolor),
                child: new Text("Ok" ,style: textStyle1,),
                onPressed: () {
                  //  continueCallBack();
                  Navigator.of(context).pop();
                },
              ),
              new RaisedButton(
                 color: Color(maincolor),
                child: Text("Cancel",style: textStyle1,),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ));
  }
}
