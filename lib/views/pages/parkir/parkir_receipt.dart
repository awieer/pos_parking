import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_parking/model/pay_parkir_response.dart';
import 'package:pos_parking/views/pages/home/homepage.dart';
import 'package:pos_parking/views/widget/dotted_seperator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../../../config/theme.dart' as Styles;

const CHANNEL = "com.posparking.channel";
const PARKIR_NATIVE = "parkirnative";

class ParkirReceipt extends StatefulWidget {
  final PayParkirResponse data;
  final name;

  ParkirReceipt(this.data, this.name);
  @override
  _ParkirReceiptState createState() => _ParkirReceiptState();
}

class _ParkirReceiptState extends State<ParkirReceipt> {
  static const platform = const MethodChannel(CHANNEL);
  String selectedMajlis = "MPK";
  bool selesaiBtn = false;

  @override
  void initState() {
    _getMajlis();
    super.initState();
    platform.setMethodCallHandler(_handleMethod);
  }

  _getMajlis() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedMajlis = prefs.getString("majlis");
    });
  }

  String majlisSelected(selectedMajlis) {
    String assetsImg;
    if (selectedMajlis == "MPK") {
      assetsImg = "assets/imgs/logo.png";
    } else if (selectedMajlis == "MDCH") {
      assetsImg = "assets/imgs/mdch.png";
    } else if (selectedMajlis == "MPB") {
      assetsImg = "assets/imgs/mpb.png";
    }

    return assetsImg;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.Colors.primaryBackgroundColor,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Styles.Colors.secondaryBackgroundColor,
        iconTheme: IconThemeData(
          color: Styles.Colors.textDarkColor, //change your color here
        ),
        centerTitle: true,
        title: Text(
          "Resit",
          style: TextStyle(
            color: Styles.Colors.textDarkColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
                border: Border.all(color: Styles.Colors.unselectedCheckbox)),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    majlisSelected(selectedMajlis),
                    width: 100,
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.data.data.pbt.name.toUpperCase(),
                    style: TextStyle(
                      color: Styles.Colors.textBlackColor,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "RESIT BELIAN KUPON",
                    style: TextStyle(
                      color: Styles.Colors.textBlackColor,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.data.data.plate.plateNumber,
                    style: TextStyle(
                        color: Styles.Colors.textBlackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("ID#: ${widget.data.data.id}"),
                            Text(widget.data.data.createdAt),
                          ]),
                      SizedBox(height: 8),
                      Text(
                        "Penguatkuasa: ${widget.name}",
                        style: TextStyle(
                          color: Styles.Colors.textBlackColor,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 16),
                      DottedSeparator(),
                      SizedBox(height: 16),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Jenis"),
                            Text("Jumlah"),
                          ]),
                      SizedBox(height: 16),
                      DottedSeparator(),
                      SizedBox(height: 16),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                                "Pas ${widget.data.data.parkingPassOption.name}"),
                            Text(
                                "RM${widget.data.data.parkingPassOption.price}"),
                          ]),
                      SizedBox(height: 40),
                      DottedSeparator(),
                      SizedBox(height: 16),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Jumlah Bayaran",
                              style: TextStyle(
                                  color: Styles.Colors.textBlackColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "RM${widget.data.data.parkingPassOption.price}",
                              style: TextStyle(
                                  color: Styles.Colors.textBlackColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                          ]),
                      SizedBox(height: 40),
                    ],
                  ),
                ],
              ),
            )),
      )),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: selesaiBtn
            ? Container(
                height: 54,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: Styles.Colors.primaryColor,
                  textColor: Colors.white,
                  elevation: 0,
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  child: Text(
                    "SELESAI",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            : Container(
                height: 54,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: Styles.Colors.primaryColor,
                  textColor: Colors.white,
                  elevation: 0,
                  onPressed: () {
                    printReceipt();
                  },
                  child: Text(
                    "CETAK",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Future<Null> printReceipt() async {
    await platform.invokeMethod(PARKIR_NATIVE, [
      widget.data.data.pbt.name.toUpperCase(),
      widget.data.data.plate.plateNumber,
      widget.data.data.id.toString(),
      widget.data.data.createdAt,
      widget.name.toString(),
      widget.data.data.parkingPassOption.name,
      widget.data.data.parkingPassOption.price.toString()
    ]);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    print("callback: ${call.arguments}");
    switch (call.method) {
      case "message":
        setState(() {
          selesaiBtn = true;
        });
        return new Future.value("");
    }
  }
}
