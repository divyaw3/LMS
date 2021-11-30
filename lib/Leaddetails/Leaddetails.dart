import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ims/LeadRegister/leadregister.dart';
import 'package:ims/Login/login.dart';
import 'package:ims/const/constant.dart';
import 'package:http/http.dart' as http;
import 'package:ims/leadedit/leadedit.dart';
import 'package:ims/onboardscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:intl/intl.dart';

class LeaddetailsScreen extends StatefulWidget {
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
      Industry,
      description;
      
  @override
   LeaddetailsScreen(
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
      this.description);
  _LeaddetailsScreenState createState() => _LeaddetailsScreenState();
}
 
class _LeaddetailsScreenState extends State<LeaddetailsScreen> {
   
  final formKey = GlobalKey<FormState>();
  var accesstoken;
  
  initState() {
 

    super.initState();
  }

   TextStyle textStyle = TextStyle(color: Colors.black, fontSize: 15.0);

  TextStyle textStyle1 = TextStyle(color: Colors.white, fontSize: 15.0);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth =
        screenSize.width / (2 / (screenSize.height / screenSize.width));
    return Scaffold(
     
       
      appBar: AppBar(
        backgroundColor: Color(maincolor),
       
        centerTitle: true,
        title: Text("Leads Details"),

      ),
        body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                child: Card(
                elevation: 5.0,
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
                                    widget.name,
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
                                      Text('Email'),
                                      //   showEditIcon: true,
                                    ),
                                    DataCell(
                                      Text(widget.email.toString()),
                                    ),
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Text('Phone'),
                                      //   showEditIcon: true,
                                    ),
                                    DataCell(
                                      Text(widget.Phone.toString()),
                                    ),
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Text('Title'),
                                      //   showEditIcon: true,
                                    ),
                                    DataCell(
                                      Text(widget.Title.toString()),
                                    ),
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Text('Website'),
                                      //   showEditIcon: true,
                                    ),
                                    DataCell(
                                      Text(widget.Website.toString()),
                                    ),
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Text('Lead Address'),
                                      //   showEditIcon: true,
                                    ),
                                    DataCell(
                                      Text(widget.leadAddress.toString()),
                                    ),
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Text('City'),
                                      //   showEditIcon: true,
                                    ),
                                    DataCell(
                                      Text(widget.City.toString()),
                                    ),
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Text('State'),
                                      //   showEditIcon: true,
                                    ),
                                    DataCell(
                                      Text(widget.State.toString()),
                                    ),
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Text('Country'),
                                      //   showEditIcon: true,
                                    ),
                                    DataCell(
                                      Text(widget.Country.toString()),
                                    ),
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
                                      Text('Source'),
                                      //   showEditIcon: true,
                                    ),
                                    DataCell(
                                      Text(widget.Source.toString()),
                                    ),
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Text('Opportunity Amount'),
                                      //   showEditIcon: true,
                                    ),
                                    DataCell(
                                      Text(defultcurrency +
                                          " " +
                                          widget.OpportunityAmount.toString()),
                                    ),
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Text('Industry'),
                                      //   showEditIcon: true,
                                    ),
                                    DataCell(
                                      Text(widget.Industry.toString()),
                                    ),
                
                                    //_leadlist['status']
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Text('status'),
                                      //   showEditIcon: true,
                                    ),
                                    DataCell(
                                      Text(widget.Status.toString()),
                                    ),
                
                                    //_leadlist['status']
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
              children: [
Padding(
  padding: const EdgeInsets.all(8.0),
  child:   Container(
          height: 40.0,
                                                                  width: 100.0,
    child:   ElevatedButton(
      
      style: ButtonStyle(
        //  foregroundColor: color:Color(maincolor),
    
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Color(maincolor))
        )
      )
    ),
                 //   color: Color(maincolor),
                    child: new Text(
                      "Ok",
                      style: textStyle1,
                    ),
                    onPressed: () {
                      //  continueCallBack();
                      Navigator.of(context).pop();
                    },
                  ),
  ),
),
            ],)
        
              ],
          ),
        ),
      ),
    );
  }
}

 