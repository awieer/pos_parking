import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pos_parking/views/widget/dotted_seperator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../../../config/theme.dart' as Styles;

const CHANNEL = "com.posparking.channel";
const KOMPAUN_NATIVE = "kompaunnative";

class KompaunReceipt extends StatefulWidget {
  final double totalAmount;
  final noPlate;
  final List<String> refNo;
  final List<String> priceList;
  final name;
  final pengurangan;

  KompaunReceipt(this.totalAmount, this.noPlate, this.refNo, this.priceList,
      this.name, this.pengurangan);
  @override
  _KompaunReceiptState createState() => _KompaunReceiptState();
}

class _KompaunReceiptState extends State<KompaunReceipt> {
  static const platform = const MethodChannel(CHANNEL);
  String now;

  @override
  void initState() {
    super.initState();
    platform.setMethodCallHandler(_handleMethod);
    now = DateTime.now().toString();
  }

  formatDate(date) {
    DateTime newDate = DateTime.parse(date);
    // DateTime newDate = new DateTime(date).toUtc();
    return new DateFormat("dd-MM-yyyy hh:mm a").format(newDate);
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
                    "assets/imgs/logo.png",
                    width: 100,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Majlis Perbandaran Kuantan",
                    style: TextStyle(
                      color: Styles.Colors.textBlackColor,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "RESIT BAYARAN KOMPAUN",
                    style: TextStyle(
                      color: Styles.Colors.textBlackColor,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.noPlate,
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
                            Text("ID#: 26300"),
                            Text(formatDate(now)),
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
                            Text("No.Kompaun"),
                            Text("Jumlah"),
                          ]),
                      SizedBox(height: 16),
                      DottedSeparator(),
                      SizedBox(height: 16),
                      Container(
                        height: widget.refNo.length.toDouble() * 22,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.refNo.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("${widget.refNo[index]}"),
                                    Text("RM${widget.priceList[index]}"),
                                  ]),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      DottedSeparator(),
                      SizedBox(height: 16),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Pengurangan"),
                            Text("RM ${widget.pengurangan}.00"),
                          ]),
                      SizedBox(height: 16),
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
                              "RM${widget.totalAmount / 100}0",
                              style: TextStyle(
                                  color: Styles.Colors.textBlackColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                          ]),
                      SizedBox(height: 16),
                      DottedSeparator(),
                      SizedBox(height: 16),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Kuantiti"),
                            Text(widget.refNo.length.toString()),
                          ]),
                      SizedBox(height: 16),
                    ],
                  ),
                ],
              ),
            )),
      )),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
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
    var total = (widget.totalAmount / 100).toString() + "0";
    await platform.invokeMethod(KOMPAUN_NATIVE, [
      "Majlis Perbandaran Kuantan",
      widget.noPlate,
      "26300",
      formatDate(now),
      widget.name.toString(),
      widget.refNo.join(",").toString(),
      widget.priceList.join(",").toString(),
      total
    ]);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    print("callback: ${call.arguments}");
    switch (call.method) {
      case "message":
        _onSuccess(call);
        return new Future.value("");
    }
  }

  _onSuccess(MethodCall call) {
    if (call.arguments == "Success") {
      Toast.show("Printing receipt..", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }
}
