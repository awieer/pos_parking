import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:pos_parking/views/pages/parkir/parkir_pay.dart';
import 'package:pos_parking/views/widget/uppercase_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/theme.dart' as Styles;

class Parkir extends StatefulWidget {
  @override
  _ParkirState createState() => _ParkirState();
}

class _ParkirState extends State<Parkir> {
  double _scaleFactor = 1.0;
  String _selectedType = "pas";
  String jamSelected = "Pilih";
  String passSelected = "Pilih";
  String pass;
  String price;
  TextEditingController noplateController = new TextEditingController();
  String name;
  int passId;

  @override
  void initState() {
    super.initState();
    _getName();
  }

  @override
  void dispose() {
    super.dispose();
    noplateController.dispose();
  }

  _getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString("name");
    print(name);
  }

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
              // Row(
              //   children: <Widget>[
              //     Expanded(
              //       child: BouncingWidget(
              //         scaleFactor: _scaleFactor,
              //         onPressed: () {
              //           setState(() {
              //             _selectedType = "pas";
              //           });
              //         },
              //         child: Container(
              //           height: 134,
              //           child: Column(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: <Widget>[
              //                 Opacity(
              //                   opacity: _selectedType == "pas" ? 1 : 0.3,
              //                   child: Image.asset("assets/icons/pass.png",
              //                       width: 48),
              //                 ),
              //                 SizedBox(height: 10),
              //                 Text(
              //                   "Pas",
              //                   style: TextStyle(
              //                       color: Styles.Colors.textBlackColor,
              //                       fontSize: 17,
              //                       fontWeight: FontWeight.w400),
              //                 ),
              //               ]),
              //         ),
              //       ),
              //     ),
              //     SizedBox(width: 10),
              //     Expanded(
              //       child: BouncingWidget(
              //         scaleFactor: _scaleFactor,
              //         onPressed: () {
              //           setState(() {
              //             _selectedType = "jam";
              //           });
              //         },
              //         child: Container(
              //           height: 134,
              //           child: Column(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: <Widget>[
              //                 Opacity(
              //                     opacity: _selectedType == "jam" ? 1 : 0.3,
              //                     child: Image.asset("assets/icons/hour.png",
              //                         width: 48)),
              //                 SizedBox(height: 10),
              //                 Text(
              //                   "Jam",
              //                   style: TextStyle(
              //                       color: Styles.Colors.textBlackColor,
              //                       fontSize: 17,
              //                       fontWeight: FontWeight.w400),
              //                 ),
              //               ]),
              //         ),
              //       ),
              //     )
              //   ],
              // ),
              SizedBox(height: 30),
              // _selectedType == "pas" ? _formPas(context) : _formJam(context),
              _formPas(context),
              SizedBox(height: 21.0),
            ],
          ),
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
            onPressed: () {
              //  =================================================
              _showDialog();
            },
            child: Text(
              "BELI",
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

  Widget _formPas(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Jenis Pas",
          style: TextStyle(
              color: Styles.Colors.textBlackColor,
              fontSize: 17,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 11.0),
        InkWell(
          onTap: () {
            _pasListModal(context);
          },
          child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFFE8ECEF),
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                passSelected,
                style: TextStyle(
                    color: passSelected == "Pilih"
                        ? Colors.grey
                        : Styles.Colors.textPrimaryColor,
                    fontSize: 16),
              )),
        ),
        SizedBox(height: 21.0),
        Text(
          "No. Plat Kenderaan",
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
            controller: noplateController,
            inputFormatters: [
              UpperCaseTextFormatter(),
            ],
            decoration: InputDecoration(
              hintText: "No. Plat Kenderaan",
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _formJam(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Tempoh",
          style: TextStyle(
              color: Styles.Colors.textBlackColor,
              fontSize: 17,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 11.0),
        InkWell(
          onTap: () {
            _hourListModal(context);
          },
          child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFFE8ECEF),
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                jamSelected,
                style: TextStyle(
                    color: jamSelected == "Pilih"
                        ? Colors.grey
                        : Styles.Colors.textPrimaryColor,
                    fontSize: 16),
              )),
        ),
        SizedBox(height: 21.0),
        Text(
          "No. Plat Kenderaan",
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
            controller: noplateController,
            inputFormatters: [
              UpperCaseTextFormatter(),
            ],
            decoration: InputDecoration(
              hintText: "No. Plat Kenderaan",
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  void _pasListModal(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                _parkirItem(context, "One(1) month", "55.65", "pas", 1),
                _parkirItem(context, "Three(3) months", "159.00", "pas", 2),
                _parkirItem(context, "One(1) year", "604.20", "pas", 4),
              ],
            ),
          );
        });
  }

  void _hourListModal(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                _parkirItem(context, "1 jam", "0.60", "jam", ""),
                _parkirItem(context, "2 jam", "1.20", "jam", ""),
                _parkirItem(context, "3 jam", "1.80", "jam", ""),
                _parkirItem(context, "4 jam", "2.40", "jam", ""),
                _parkirItem(context, "5 jam", "3.00", "jam", ""),
              ],
            ),
          );
        });
  }

  Widget _parkirItem(context, jam, harga, type, id) {
    return InkWell(
      onTap: () {
        pass = jam.toString();
        price = harga;
        setState(() {
          if (type == "jam") {
            jamSelected = "$jam (RM$harga)";
          } else {
            passSelected = "$jam (RM$harga)";
            passId = id;
          }
        });
        Navigator.pop(context);
      },
      child: Container(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("$jam ",
                      style: TextStyle(
                          color: Styles.Colors.textBlackColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w400)),
                  Text(
                    "(RM$harga)",
                    style: TextStyle(
                        color: Styles.Colors.primaryColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w400),
                  ),
                ]),
          )),
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(content: Builder(builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Text("Sahkan Pembelian?",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  )),
              SizedBox(height: 20),
              Text(noplateController.text,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  )),
              SizedBox(height: 10),
              Text(passSelected),
              SizedBox(height: 25),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 54,
                      decoration: BoxDecoration(
                        // border: Border.all(
                        //   color: Styles.Colors.primaryColor,
                        //   width: 2.0,
                        // ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        color: Styles.Colors.unselectedCheckbox,
                        textColor: Colors.white,
                        elevation: 0,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "BATAL",
                          style: TextStyle(
                            color: Styles.Colors.textDarkColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
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
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ParkirPay(
                                      passId, noplateController.text)));
                        },
                        child: Text(
                          "YA",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          );
        }));
      },
    );
  }
}
