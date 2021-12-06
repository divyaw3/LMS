import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ims/const/constant.dart';
import 'package:http/http.dart' as http;
//import 'package:intl/intl.dart';

class ProductdetailsScreen extends StatefulWidget {
  String  name,   status,
                                                                                     category,
                                                                                     brand,
                                                                                     price,
                                                                                     tax,
                                                                                     partNumber,
weight,
url,
description;
      
  @override
   ProductdetailsScreen(
      // this.title,
      //this.content,
      this.name,
      this.status,
      this.category,
      this.brand,
      this.price,
      this.tax,
      this.partNumber,
      this.weight,
      this.url,
      this.description,
     
      );
  _ProductdetailsScreenState createState() => _ProductdetailsScreenState();
}
 
class _ProductdetailsScreenState extends State<ProductdetailsScreen> {
   
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
        title: Text("Product Details"),

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
                                      Text('Status'),
                                      //   showEditIcon: true,
                                    ),
                                    DataCell(
                                      Text(widget.status.toString()),
                                    ),
                                  ],
                                ),
                              DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Text('Category'),
                                      //   showEditIcon: true,
                                    ),
                                    DataCell(
                                      Text(widget.category.toString()),
                                    ),
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Text('Brand'),
                                      //   showEditIcon: true,
                                    ),
                                    DataCell(
                                      Text(widget.brand.toString()),
                                    ),
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Text('Price'),
                                      //   showEditIcon: true,
                                    ),
                                    DataCell(
                                      Text(
                                    defultcurrency+ " "+widget.price.toString()
                                      ),
                                    ),
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Text('Tax'),
                                      //   showEditIcon: true,
                                    ),
                                    DataCell(
                                      Text(widget.tax.toString()),
                                    ),
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Text('Part number'),
                                      //   showEditIcon: true,
                                    ),
                                    DataCell(
                                      Text(widget.partNumber.toString()),
                                    ),
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Text('Weight'),
                                      //   showEditIcon: true,
                                    ),
                                    DataCell(
                                      Text(widget.weight.toString()),
                                    ),
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Text('URL'),
                                      //   showEditIcon: true,
                                    ),
                                    DataCell(
                                      Text(widget.url.toString()),
                                    ),
                                  ],
                                ),
                
                                        DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Text('Description'),
                                      //   showEditIcon: true,
                                    ),
                                    DataCell(
                                      Text(widget.description.toString()),
                                    ),
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

 