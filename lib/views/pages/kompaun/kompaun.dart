import 'package:flutter/material.dart';
import 'package:pos_parking/views/pages/kompaun/kompaun_list.dart';
import 'package:pos_parking/views/widget/uppercase_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/theme.dart' as Styles;

enum KompaunType { vehicle, other }

class Kompaun extends StatefulWidget {
  @override
  _KompaunState createState() => _KompaunState();
}

class _KompaunState extends State<Kompaun> {
  TextEditingController noplateController = new TextEditingController();
  KompaunType _type = KompaunType.vehicle;

  bool isDisabled = true;
  String selectedMajlis = "MPK";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getmajlis();
  }

  Future<void> _getmajlis() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedMajlis = prefs.getString("majlis");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40),
            Image.asset(
              majlisSelected(selectedMajlis),
              width: 100,
            ),
            SizedBox(height: 40),
            Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      children: [
                        Radio(
                          activeColor: Styles.Colors.primaryColor,
                          value: KompaunType.vehicle,
                          groupValue: _type,
                          onChanged: (KompaunType selected) {
                            setState(() {
                              _type = selected;
                            });
                          },
                        ),
                        Text("Kenderaan"),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          activeColor: Styles.Colors.primaryColor,
                          value: KompaunType.other,
                          groupValue: _type,
                          onChanged: (KompaunType selected) {
                            setState(() {
                              _type = selected;
                            });
                          },
                        ),
                        Text("Pelbagai"),
                      ],
                    ),
                  ]),
            ),
            SizedBox(height: 11.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFE8ECEF),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  onChanged: (value) {
                    if (value != null || value != '') {
                      setState(() {});
                    }
                  },
                  controller: noplateController,
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: _type == KompaunType.vehicle
                        ? "No Plat Kenderaan"
                        : "No Mykad / Syarikat",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 21.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 54,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    elevation: 0,
                    color: noplateController.text == ''
                        ? Styles.Colors.primaryColor.withOpacity(0.5)
                        : Styles.Colors.primaryColor,
                    onPressed: () {
                      print(noplateController.text);
                      if (noplateController.text != '') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => KompaunList(
                                    noplateController.text, _type)));
                      }
                    },
                    child: Text(
                      "CARI",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
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
}
