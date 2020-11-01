import 'package:flutter/material.dart';
import '../../../config/theme.dart' as Styles;

class FilPage extends StatefulWidget {
  @override
  _FilPageState createState() => _FilPageState();
}

class _FilPageState extends State<FilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.Colors.primaryBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text("10,000",
                            style: TextStyle(
                              color: Styles.Colors.primaryColor,
                              fontSize: 17,
                            )),
                        SizedBox(width: 5),
                        Image.asset(
                          "assets/icons/fil.png",
                          width: 50,
                        )
                        // SizedBox(
                        //   width: 45,
                        //   child: Stack(children: <Widget>[
                        //     Positioned(
                        //       right: 0,
                        //       child: Opacity(
                        //         opacity: 0.5,
                        //         child: Container(
                        //             width: 28,
                        //             height: 28,
                        //             decoration: BoxDecoration(
                        //               color: Styles.Colors.primaryColor,
                        //               borderRadius: BorderRadius.circular(14),
                        //             )),
                        //       ),
                        //     ),
                        //     Container(
                        //         width: 28,
                        //         height: 28,
                        //         decoration: BoxDecoration(
                        //           color: Styles.Colors.primaryColor,
                        //           borderRadius: BorderRadius.circular(14),
                        //         )),
                        //   ]),
                        // )
                      ]),
                ),
                SizedBox(height: 21.0),
                Text(
                  "How much Fil?",
                  style: TextStyle(
                      color: Styles.Colors.textBlackColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 11.0),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  height: 52,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFE8ECEF),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter amount",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 21.0),
                Text(
                  "Sending to?",
                  style: TextStyle(
                      color: Styles.Colors.textBlackColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 11.0),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  height: 52,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFE8ECEF),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: <Widget>[
                      Text("+60 ", style: TextStyle(fontSize: 17)),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 21.0),
                Text(
                  "Payment Amount",
                  style: TextStyle(
                      color: Styles.Colors.textBlackColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 11.0),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  height: 52,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFE8ECEF),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: <Widget>[
                      Text("RM ", style: TextStyle(fontSize: 17)),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
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
            onPressed: () {},
            child: Text(
              "TRANSFER",
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
}
