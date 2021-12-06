import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_view/gallery_view.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ims/LeadRegister/leadregister.dart';
import 'package:ims/Leaddetails/Leaddetails.dart';
import 'package:ims/Login/login.dart';
import 'package:ims/const/constant.dart';
import 'package:http/http.dart' as http;
import 'package:ims/leadedit/leadedit.dart';
import 'package:ims/onboardscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:intl/intl.dart';

class ProductimageScreen extends StatefulWidget {
  var id;
  @override
  ProductimageScreen({this.id});
  _ProductimageScreenState createState() => _ProductimageScreenState();
}

class _ProductimageScreenState extends State<ProductimageScreen> {
  var leadresponse = [];
  var lead_source = [];
  var lead_accountindustries = [];

  String msg = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map _product_image = {};

  final formKey = GlobalKey<FormState>();
  var accesstoken;

  SharedPreferences sharedPreferences;
  getproductsimages() async {
    print("inside getproductsimages" + widget.id.toString());
    sharedPreferences = await SharedPreferences.getInstance();
    accesstoken = sharedPreferences.getString("access_token") ?? "_";
    print("accesstoken" + accesstoken);
    if (accesstoken == "_") {
      print("insode if no access token ");
    } else {
      print("inside else" + accesstoken);

      Uri url = Uri.parse(siteurl + "api/products/${widget.id}");

      print("urlurlurlurl" + url.toString());
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accesstoken',
      });
      if (response.statusCode == 200) {
        setState(() {
          var resBody = json.decode(response.body);
          _product_image = json.decode(response.body);
          print("resBodyresBodyresBody" + resBody.toString());

          /*for (int i = 0; i < resBody.length; i++) {
            _product_image.add(resBody[i]);
          }*/
        });
        print("_product_image_product_image" + _product_image.toString());
//http://humbletree.in/lms/api/products/2
        return _product_image;
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

  Uint8List _bytesImage;

  Future a;
  initState() {
    a = getproductsimages();
    // getleadlist();

    super.initState();
  }

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
        title: Text("Product Gallery"),
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
                  
                      ? 
                      Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                             /* GridView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  scrollDirection: Axis.vertical,
                                  itemCount:
                                      _product_image["productimage"].length,
                                  //  itemCount: 1,
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
                                    //itemCount: _product_image["productimage"].length,
                                   // _bytesImage = Base64Decoder().convert(  "${_product_image["productimage"][index]["images"]}");
                                        //print("imgurlimgurlimgurl"+"https://humbletree.in/lms/storage/uploads/product/${_product_image["productimage"][index]["product_id"]}/${_product_image["productimage"][index]["images"]}".toString());
                              
                                    return new GestureDetector(
                                      onTap: () {},
                                      child: 
                                      SingleChildScrollView(
                                        child: new Container(
                                          color: Color(maincolor),
                                          height: 300.0,
                                          child: Column(children: [
                                            Expanded(
                                              child: GalleryView(
                                                crossAxisCount: 2,
                                                imageUrlList: [
                                                  "https://humbletree.in/lms/storage/uploads/product/${_product_image["productimage"][index]["product_id"]}/${_product_image["productimage"][index]["image"]}",
],
                                                key: null, //key: null,
                                              ),
                                            ),

                                            /*Container(
                                                  height: 300.0,
                                                  width: 200.0,
                                                  child: Image.memory(_bytesImage
                                                   
                                                    
                                      
                                                    /*  Container(
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
                                                                    "${_product_image[index]['status']}",
                                                                  ),
                                                                  // "${_product_image[index]['name']}",
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
                                                  */
                                                  )
                                                )
                                              */
                                          ]),
                                        ),
                                      ),
                                    );
                                  }),
                           */
                      Card(
                        elevation: 10.0,
                        child: new Container(
                          padding: EdgeInsets.all(10.0),
                          color: Color(maincolor),
                          height: 300.0,
                          child: Row(children: [
                            for(int i = 0;i<_product_image["productimage"].length;i++)
                            Expanded(
                              
                              child: GalleryView(
                            crossAxisCount: 1,
                                imageUrlList: [
                                  "https://humbletree.in/lms/storage/uploads/product/${_product_image["productimage"][i]["product_id"]}/${_product_image["productimage"][i]["image"]}",
                      ],
                                key: null, //key: null,
                              ),
                            ),
                      
                            /*Container(
                                  height: 300.0,
                                  width: 200.0,
                                  child: Image.memory(_bytesImage
                                   
                                    
                        
                                    /*  Container(
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
                                                    "${_product_image[index]['status']}",
                                                  ),
                                                  // "${_product_image[index]['name']}",
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
                                  */
                                  )
                                )
                              */
                          ]),
                        ),
                      ),
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
