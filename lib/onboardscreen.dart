import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ims/Login/login.dart';
import 'package:ims/LeadRegister/leadregister.dart';
import 'package:ims/const/constant.dart';
import 'package:ims/leadlisting/leadlist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class OnBoardScreen extends StatefulWidget {
  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  var accesstoken;
  SharedPreferences sharedPreferences;
  /* 

      checkaccesstoken()  async {
     sharedPreferences = await SharedPreferences.getInstance();
       accesstoken = sharedPreferences.getString("accesstoken") ?? "_";
    print("accesstoken"+accesstoken);
    if(accesstoken=="_"){
print("insode if no access token ");
  
  /* Navigator.of(context).push(new MaterialPageRoute(
      builder: (BuildContext context) => new OnBoardScreen(),
    ));*/

    }
    else{
      print("inside else"+accesstoken);
     /* Navigator.of(context).push(new MaterialPageRoute(
      builder: (BuildContext context) => new HomePage1(),
    ));*/
    }

  }
*/
  var buttonname = "";
  checkaccesstoken() async {
    //  GetAddressFromLatLong(position);
    sharedPreferences = await SharedPreferences.getInstance();
    accesstoken = sharedPreferences.getString("access_token") ?? "_";
    print("accesstoken" + accesstoken);

    if (accesstoken == "_") {
      print("insode if no access token ");
      setState(() {
        buttonname = "Sign In";
      });
    } else {
      print("inside else" + accesstoken);
      setState(() {
        buttonname = "Lead";
      });
      /*Navigator.of(context).pushReplacement(new MaterialPageRoute(
      builder: (BuildContext context) => new LeadlistScreen(),
    ));*/
    }
    approvegpsaccess();
  }

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
              state: '${place.administrativeArea}',
            )));
  }

  void initState() {
    checkaccesstoken();

    super.initState();
  }

  approvegpsaccess() async {
    Position position = await _getGeoLocationPosition();
          location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
     }
  Widget renderNextBtn() {
    return Text("Next");
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Colors.black,
    );
  }
  //static BlogNewsApi blogApi;

  Widget renderSkipBtn() {
    return Text("Skip");
  }

  void onDonePress() {
    Navigator.of(context).push(new MaterialPageRoute(
      builder: (BuildContext context) => new MyApp(),
      //HomePage1
      //LoginScreen(),
    ));
  }

  void onSkipPress() {
    Navigator.of(context).push(new MaterialPageRoute(
      builder: (BuildContext context) => new MyApp(),
    ));
  }

  final List<String> imgList = [
    //img1,
    img2,
    img3,
    img4,
    img5,
    img6
  ];

  final List<String> imgListtext = [
    //"obg.gif",
    "onb2.jpeg",
    "onb1.jpeg",
    "onb4.jpeg",
    "5.jpeg",
    "a6.jpeg",
  ];
  int _current = 0;
  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    //  final screenSize = MediaQuery.of(context).size;
    //  final screenWidth = screenSize.width / (2 / (screenSize.height / screenSize.width));

    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /* SizedBox(
          height: 30.0,
        ),*/
        CircleAvatar(
          radius: 180.0,
          backgroundColor: Colors.blueGrey[260],
          foregroundColor: Colors.black,
          child: CarouselSlider(
            // items: imageSliders,
            carouselController: _controller,

            options: CarouselOptions(
              aspectRatio: 1.3,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
              autoPlay: false,
              enlargeCenterPage: true,
            ),
            items: imgList
                .map((item) => Container(
                      //  color: Colors.white,
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // border: Border.all(color: Colors.black, width: 1.0),
                        //      borderRadius: BorderRadius.circular(70.0),
                        //  borderRadius: BorderRadius.all(Radius.circular(500)),

                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(item),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
        /* Container(
          height: 100.0,
          child: ListView.builder(
            itemCount: imgListtext.length,
            itemBuilder: (BuildContext context, int index) {
              return  Card(child: Text(imgListtext[index].toString()));}),
        ),*/
        SizedBox(
          height: 20.0,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //
            /*  Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                  width: 150.0,
                  height: 50.0,
                  color: Colors.lightBlue,
                  child: TextButton(
                    onPressed: () {
                           Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new LeadRegisterscreen(
                        
                          )));
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Container(
                        width: 200.0,
                        constraints:
                            BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                        alignment: Alignment.center,
                        child: Text(
                          "Sign Up",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 15),
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
        */
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                  width: 150.0,
                  height: 50.0,
                  color: Color(maincolor),
                  child: TextButton(
                    onPressed: () {
                      if (buttonname == "Sign In") {
                        print(buttonname.toString());
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new Loginscreen()));
                      } else if (buttonname == "Lead") {
                        print(buttonname.toString());
                        Navigator.of(context)
                            .pushReplacement(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new LeadlistScreen(),
                        ));
                      }
                    },
                    child: Container(
                      //decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0)),

                      // color: Color(maincolor),
                      width: 200.0,
                      constraints:
                          BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text(
                        buttonname,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 15),
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
      ],
    ));
  }
}
