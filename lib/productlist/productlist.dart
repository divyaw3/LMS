import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ims/LeadRegister/leadregister.dart';
import 'package:ims/Leaddetails/Leaddetails.dart';
import 'package:ims/Login/login.dart';
import 'package:ims/const/constant.dart';
import 'package:http/http.dart' as http;
import 'package:ims/leadedit/leadedit.dart';
import 'package:ims/onboardscreen.dart';
import 'package:ims/productlist/productimage.dart';
import 'package:ims/productlist/productview.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:intl/intl.dart';

class ProductlistScreen extends StatefulWidget {
  @override
  _ProductlistScreenState createState() => _ProductlistScreenState();
}

class _ProductlistScreenState extends State<ProductlistScreen> {
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

  String msg = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _productlist = [];

  final formKey = GlobalKey<FormState>();
  var accesstoken;

  SharedPreferences sharedPreferences;
  getproductslist() async {
    print("inside getproductslist");
    sharedPreferences = await SharedPreferences.getInstance();
    accesstoken = sharedPreferences.getString("access_token") ?? "_";
    print("accesstoken" + accesstoken);
    if (accesstoken == "_") {
      print("insode if no access token ");
    } else {
      getleadaccountindustries();
      getleadsource();
      print("inside else" + accesstoken);

      Uri url = Uri.parse(siteurl + "api/products");

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
            // {
            //     resBody
            /*"name": resBody[i]['name'],
              "user_id": resBody[i]['user_id'],
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
              "created_from": resBody[i]['created_from'],*/
            // "location_latitude": resBody[i]['location_latitude'],
            //"location_longitude": resBody[i]['location_longitude'],
            // "updated_at": resBody[i]['updated_at'],
            //  "created_at":resBody[i]['created_at'],
            //}
            //  );
            _productlist.add(resBody[i]);

            setState(() {
              if (_productlist[i]['status'] == "0") {
                setState(() {
                  _productlist[i]['status'] = "Available";
                  contcolor = Colors.blue;
                });
              } else if (_productlist[i]['status'] == "1") {
                setState(() {
                  _productlist[i]['status'] = "Unavailable";
                  //  contcolor = Colors.teal;
                });
              }
            });
          }
        });

        print("lead_accountindustries id is" + _productlist.toString());
        print(_productlist.toString());
        setState(() {});
        return _productlist;
      } else if (response.statusCode == 401) {
        sharedPreferences = await SharedPreferences.getInstance();
        accesstoken = sharedPreferences.setString("access_token", "_");

        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) => new Loginscreen()));
      } else {
        print(response.statusCode.toString());
        print(json.decode(response.body).toString());
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    }
  }

  allWordsCapitilize(String str) {
    return str.toLowerCase().split(' ').map((word) {
      String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
      return word[0].toUpperCase() + leftText;
    }).join(' ');
  }

  Future a;
  initState() {
    a = getproductslist();
    // getleadlist();

    super.initState();
  }

  /*_showDialog(BuildContext context, _productlist) {
    print("_productlist_productlist" +
        _productlist.toString() +
        _productlist['name']);

 
    if (_productlist['industry'] == '1') {
      setState(() {
        _productlist['industry'] = "Catering";
      });
    } else if (_productlist['industry'] == '2') {
      setState(() {
        _productlist['industry'] = "Events Management";
      });
    } else if (_productlist['industry'] == '3') {
      setState(() {
        _productlist['industry'] = "Information Technology";
      });
    }
    if (_productlist['source'] == '1') {
      setState(() {
        _productlist['source'] = "Referral";
      });
    } else if (_productlist['source'] == '2') {
      setState(() {
        _productlist['source'] = "Google 0r Yellow Pages";
      });
    } else if (_productlist['source'] == '3') {
      setState(() {
        _productlist['source'] = "Digital Marketting";
      });
    } else if (_productlist['source'] == '4') {
      setState(() {
        _productlist['source'] = "Zoho Lead";
      });
    }

    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new LeaddetailsScreen(
              _productlist['name'],
              _productlist['email'],
              _productlist['phone'],
              _productlist['title'],
              _productlist['website'],
              _productlist['lead_address'],
              _productlist['lead_city'],
              _productlist['lead_state'],
              _productlist['lead_country'],
              _productlist['status'],
              _productlist['source'].toString(),
              _productlist['opportunity_amount'].toString(),
              _productlist['industry'],
              _productlist['description'],
            )));
  }

 

 */
  int dynamiccrosscount = 1;

  var contcolor = Colors.white;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth =
        screenSize.width / (2 / (screenSize.height / screenSize.width));
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
        title: Text("Products List"),
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
                                  /*  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Text(
                                        "Number of Leads".toString(),
                                        style: new TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),*/
                                  /* Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Text(
                                        _productlist.length.toString(),
                                        style: new TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),*/
                                ],
                              ),
                              GridView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  //  padding: const EdgeInsets.all(10.0),
                                  scrollDirection: Axis.vertical,
                                  itemCount: _productlist.length,
                                  //  itemCount: data.length,
                                  gridDelegate:
                                      new SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: dynamiccrosscount,
                                    //  crossAxisCount: 2,
                                    childAspectRatio: MediaQuery.of(context)
                                            .size
                                            .width /
                                        (MediaQuery.of(context).size.height /
                                            2.2),
                                    mainAxisSpacing: 10.0,

                                    crossAxisSpacing: 10.0,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    //   Navigator.pop(context);
                                    // "${_productlist[index]['brand']}",
                                    if (_productlist[index]['tax'] == "1") {
                                      _productlist[index]['tax'] = "GST (18%)";
                                    }
                                    if (_productlist[index]['tax'] == "2") {
                                      _productlist[index]['tax'] =
                                          "CGST 9% (9%)";
                                    }
                                    if (_productlist[index]['tax'] == "3") {
                                      _productlist[index]['tax'] =
                                          "SGST 9% (9%)";
                                    }
                                    if (_productlist[index]['tax'] == "1,2,3") {
                                      _productlist[index]['tax'] =
                                          "GST (18%) CGST 9% (9%) SGST 9% (9%)";
                                    }
                                    if (_productlist[index]['tax'] == 3) {}
                                    if (_productlist[index]['brand'] == 1) {
                                      _productlist[index]['brand'] = "ZOHO";
                                    }

                                    //         print("_productlist[index]['category']_productlist[index]['category']"+_productlist[index]['category'].toString());
                                    if (_productlist[index]['category'] == 1) {
                                      _productlist[index]['category'] =
                                          "Zoho Workplace";
                                    }

                                    if (_productlist[index]['status'] == 0) {
                                      contcolor = Colors.green;
                                      _productlist[index]['status'] =
                                          "Available";
                                    }
                                    if (_productlist[index]['status'] == 1) {
                                      contcolor = Colors.red;
                                      _productlist[index]['status'] =
                                          "Unavailable";
                                    }
                                    if (_productlist[index]['status'] ==
                                        "Available") {
                                      contcolor = Colors.green;
//                                         _productlist[index]['status'] = "Available";

                                    }
                                    if (_productlist[index]['status'] ==
                                        "Unavailable") {
                                      //    _productlist[index]['status'] = "Unavailable";
                                      contcolor = Colors.red;
                                    }

                                    return Center(
                                      child: new GestureDetector(
                                        onTap: () {},
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Card(
                                            //  color: Color(crd_color),
                                            elevation: 6.0,
                                            child: GestureDetector(
                                              child: new Container(
                                                child: Column(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          8.0, 0.0, 0.0, 0.0),
                                                      child: Container(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        5.0,
                                                                        20.0,
                                                                        0.0,
                                                                        10.0),
                                                                //  const EdgeInsets .all(  5.0),
                                                                child: Text(
                                                                  //toBeginningOfSentenceCase('this is a string'),
                                                                  allWordsCapitilize(
                                                                    "${_productlist[index]['name']}",
                                                                  ),
                                                                  // "${_productlist[index]['name']}",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  // softWrap: false,
                                                                  style:
                                                                      new TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            // _productlist['status']

                                                            Column(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          1.0),

                                                                  //  const EdgeInsets .all(  5.0),
                                                                  child: Text(
                                                                    "Status",
                                                                    style:
                                                                        new TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          15.0,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                    child:
                                                                        Container(
                                                                      // width: 30.0,
                                                                      // height: 20.0,
                                                                      color:
                                                                          contcolor,
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(4.0),
                                                                          child:
                                                                              Text(
                                                                            allWordsCapitilize(
                                                                              "${_productlist[index]['status']}",
                                                                            ),
                                                                            // "${_productlist[index]['name']}",
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            // softWrap: false,
                                                                            style:
                                                                                new TextStyle(
                                                                              fontSize: 15.0,
                                                                              //  color:contcolor,
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          8.0, 0.0, 0.0, 0.0),
                                                      child: Container(
                                                        child: Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 13.0,
                                                                backgroundColor:
                                                                    Colors.grey[
                                                                        350],
                                                                child: Icon(
                                                                  FontAwesomeIcons
                                                                      .list,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 15.0,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 2.0,
                                                            ),
                                                            Flexible(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Text(
                                                                  //Zoho Workplace

                                                                  "${_productlist[index]['category']}",
                                                                  style:
                                                                      new TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                    //  color: Color(text_color),
                                                                    color: Colors
                                                                        .grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),

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
                                                                    "${_productlist[index]['email']}",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                // softWrap: false,
                                                                style:
                                                                    new TextStyle(
                                                                  fontSize:
                                                                      18.0,
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
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          8.0, 0.0, 0.0, 0.0),
                                                      child: Container(
                                                        child: Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 13.0,
                                                                backgroundColor:
                                                                    Colors.grey[
                                                                        350],
                                                                child: Icon(
                                                                  FontAwesomeIcons
                                                                      .building,
                                                                  //color:Color(maincolor),
                                                                  //  color: Color(text_color),
                                                                  color: Colors
                                                                      .black,
                                                                  size: 15.0,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 2.0,
                                                            ),
                                                            Flexible(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Text(
                                                                  //brand
                                                                  "${_productlist[index]['brand']}",
                                                                  style:
                                                                      new TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                    color: Colors
                                                                        .grey,
                                                                    //  color: Color(text_color),
                                                                    //  color: Colors .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          8.0, 0.0, 0.0, 0.0),
                                                      child: Container(
                                                        child: Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 13.0,
                                                                backgroundColor:
                                                                    Colors.grey[
                                                                        350],
                                                                child: Icon(
                                                                  FontAwesomeIcons
                                                                      .coins,
                                                                  //  color:Color(maincolor),
                                                                  color: Colors
                                                                      .black,
                                                                  size: 15.0,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 2.0,
                                                            ),
                                                            Flexible(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Text(
                                                                  defultcurrency +
                                                                      " " +
                                                                      _productlist[index]
                                                                              [
                                                                              'price']
                                                                          .toString(),
                                                                  style:
                                                                      new TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          8.0, 0.0, 0.0, 0.0),
                                                      child: Container(
                                                        child: Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 13.0,
                                                                backgroundColor:
                                                                    Colors.grey[
                                                                        350],
                                                                child: Icon(
                                                                  FontAwesomeIcons
                                                                      .percentage,
                                                                  color: Colors
                                                                      .black,
                                                                  // color:Color(maincolor),
                                                                  size: 14.0,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 2.0,
                                                            ),
                                                            Flexible(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Text(
                                                                  _productlist[
                                                                          index]
                                                                      ['tax'],
                                                                  style:
                                                                      new TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                    color: Colors
                                                                        .grey,
                                                                    //  color: Colors .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          8.0, 0.0, 0.0, 0.0),
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
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),

                                                              child: Container(
                                                                height: 40.0,
                                                                width: 100.0,
                                                                child: ElevatedButton(
                                                                    style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Color(maincolor))))),
                                                                    onPressed: () async {
                                                                      Navigator.of(context).push(new MaterialPageRoute(
                                                                          builder: (BuildContext context) => new ProductimageScreen(
                                                                                id: _productlist[index]['id'],
                                                                              )));
                                                                    },
                                                                    child: Text(
                                                                      "Image",
                                                                      style: TextStyle(
                                                                          // fontStyle: FontStyle.italic,
                                                                          color: Colors.white),
                                                                    )),
                                                              ),
                                                              // )
                                                            ),
                                                            // SizedBox(width: 2.0,),
                                                            Flexible(
                                                              child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        40.0,
                                                                    width:
                                                                        100.0,
                                                                    //   color: Color(lightcolor),
                                                                    child: ElevatedButton(
                                                                        style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Color(maincolor))))),
                                                                        onPressed: () async {
                                                                          /* Navigator.of(
                                                                              context)
                                                                          .push(
                                                                              new MaterialPageRoute(builder: (BuildContext context) => new 
                                                                               ProductdetailsScreen(
                                                                                  name:'';
                                                                                    status:"",
                                                                                     category:"",
                                                                                     brand:"",
                                                                                     price:"",
                                                                                     tax:"",
                                                                                     partNumber:"",weight:"",
url:"",
description:""

                                                                                   
       
                                                                               
                                                                              )));*/

                                                                          Navigator.of(context).push(new MaterialPageRoute(
                                                                              builder: (BuildContext context) => new ProductdetailsScreen(
                                                                                    _productlist[index]['name'],
                                                                                    _productlist[index]['status'],
                                                                                    _productlist[index]['category'],
                                                                                    _productlist[index]['brand'],
                                                                                    _productlist[index]['price'].toString(),
                                                                                    _productlist[index]['tax'].toString(),
                                                                                    _productlist[index]['part_number'].toString(),
                                                                                    _productlist[index]['weight'].toString(),
                                                                                    _productlist[index]['URL'].toString(),
                                                                                    _productlist[index]['description'],
                                                                                  )));
                                                                        },
                                                                        /*  name:'';
                                                                                    status:"",
                                                                                     status:"",
                                                                                     brand:"",
                                                                                     price:"",
                                                                                     tax:"",
                                                                                     partNumber:"",weight:"",
url:"",
description:""
 */
                                                                        child: Text(
                                                                          "View",
                                                                          style: TextStyle(
                                                                              // fontStyle: FontStyle.italic,
                                                                              color: Colors.white),
                                                                        )),
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
            ],
          ),
        ),
      ),
    );
  }
}
