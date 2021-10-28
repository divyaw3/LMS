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
import 'package:ims/onboardscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeadlistScreen extends StatefulWidget {
  @override
  _LeadlistScreenState createState() => _LeadlistScreenState();
}

class _LeadlistScreenState extends State<LeadlistScreen> {
  var leadresponse = [];
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
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print("placeplacemarkkkk" + placemarks.toString());
    Placemark place = placemarks[0];
    print("place" + place.toString());
    setState(() {
      Address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
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

  initState() {
    getleadlist();

    super.initState();
  }

  _showDialog(BuildContext context, _leadlist) {
    print("_leadlist_leadlist" + _leadlist.toString()+_leadlist['name']);
    BlurryDialog alert =
        BlurryDialog(_leadlist['name'],_leadlist['email'], _leadlist['phone'], _leadlist['title'], _leadlist['website'], _leadlist['lead_address'], _leadlist['lead_city'], _leadlist['lead_state'], _leadlist['lead_country'], _leadlist['lead_postalcode'], _leadlist['status'], _leadlist['source'].toString(), _leadlist['opportunity_amount'].toString(), _leadlist['industry'], _leadlist['description'],);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  String loginname = "";

  Future<void> _signOut() async {
    print("hi insode signout");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //
    await preferences.remove('access_token');
     setState(() {
     
      loginname = "Login";
    });
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new OnBoardScreen()));
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text("Lead List"),
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

       /*     Visibility(
              visible: dispfacebook,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebView(
                        initialUrl: local_link['Facebook'],
                        //  title: "Facebook",
                      ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text('Facebook'),
                  leading: Icon(
                    FontAwesomeIcons.facebook,
                  ),
                ),
              ),
            ),

            Visibility(
              visible: dispinsta,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebView(
                        initialUrl: local_link['Instagram'],
                        //  title: "Facebook",
                      ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text('Instagram'),
                  leading: Icon(FontAwesomeIcons.instagram),
                ),
              ),
            ),
            Visibility(
              visible: dispyoutube,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebView(
                        initialUrl: local_link['Youtube'],
                        //  title: "Facebook",
                      ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text('Youtube'),
                  leading: Icon(FontAwesomeIcons.youtube),
                ),
              ),
            ),
            Visibility(
              visible: disptwitter,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebView(
                        initialUrl: local_link['Twitter'],
                        //  title: "Facebook",
                      ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text('Twitter'),
                  leading: Icon(FontAwesomeIcons.twitter),
                ),
              ),
            ),

//Orderdetails
            Divider(
              color: Colors.black,
            ),

            InkWell(
              onTap: () {
                whatsAppOpen();
              },
              child: ListTile(
                title: Text('How Can I Help You'),
                leading: Icon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.green,
                ),
              ),
            ),
*/
        
          ],
        ),
      ),
    
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /*Text(
                "Lead List",
                style: TextStyle(
                    color: Color(maincolor),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),*/
              Row(
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
      this.Campaign,
      this.Industry,
      this.description
      );
  TextStyle textStyle = TextStyle(color: Colors.black,fontSize: 15.0);

  TextStyle textStyle1 = TextStyle(color: Colors.white,fontSize: 15.0);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          //contentPadding: EdgeInsets.zero,

          // content: new Text('Lead Details',style: textStyle,),
          title: Container(
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(child: Row(
                      children: [
                        Text("Name  :  ",style: textStyle,),
                          
                        Text( name,style: textStyle,),
                          
                      ],
                    )),
                  ),
                ),
                 Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(child: Row(
                    children: [
                      Text("Email  :  ",style: textStyle,),
          
                      Text( email,style: textStyle,),
          
                    ],
                  )),
                ), Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(child: Row(
                    children: [
                      Text("Phone  :  ",style: textStyle,),
          
                      Text( Phone.toString(),style: textStyle,),
          
                    ],
                  )),
                ), Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(child: Row(
                    children: [
                      Text("Title  :  ",style: textStyle,),
          
                      Text( Title,style: textStyle,),
          
                    ],
                  )),
                ), Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(child: Row(
                    children: [
                      Text("Website  :  ",style: textStyle,),
          
                      Text( Website,style: textStyle,),
          
                    ],
                  )),
                ), Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(child: Row(
                    children: [
                      Text("Address  :  ",style: textStyle,),
          
                      Flexible
                      (child: Text( leadAddress,style: textStyle,)),
          
                    ],
                  )),
                ), Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(child: Row(
                    children: [
                      Text("City  :  ",style: textStyle,),
          
                      Text( City,style: textStyle,),
          
                    ],
                  )),
                ), Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(child: Row(
                    children: [
                      Text("State  :  ",style: textStyle,),
          
                      Text( State,style: textStyle,),
          
                    ],
                  )),
                ), Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(child: Row(
                    children: [
                      Text("Country  :  ",style: textStyle,),
          
                      Text( Country,style: textStyle,),
          
                    ],
                  )),
                ), Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(child: Row(
                    children: [
                      Text("Status  :  ",style: textStyle,),
          
                      Text(Status,style: textStyle, ),
          
                    ],
                  )),
                ), Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(child: Row(
                    children: [
                      Text("Source  :  ",style: textStyle,),
          
                      Text( Source,style: textStyle,),
          
                    ],
                  )),
                ), Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(child: Row(
                    children: [
                      Text("Opportunity_amount  :  ",style: textStyle,),
          
                      Text( OpportunityAmount,style: textStyle,),
          
                    ],
                  )),
                ), Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(child: Row(
                    children: [
                      Text("Industry  : ",style: textStyle,),
          
                      Text( Industry,style: textStyle,),
          
                    ],
                  )),
                ), Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(child: Row(
                    children: [
                      Text("Description  : ",style: textStyle,),
          
                      Text( description,style: textStyle,),
          
                    ],
                  )),
                ),
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
        ));
  }
}
