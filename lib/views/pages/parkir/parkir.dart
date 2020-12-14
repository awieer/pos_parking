import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_parking/bloc/parking_pass_bloc.dart';
import 'package:pos_parking/model/parking_pass_monthly_model.dart';
import 'package:pos_parking/repository/parking_pass_repo.dart';
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
  String selectedMajlis = "MPK";

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
    setState(() {
      selectedMajlis = prefs.getString("majlis");
    });
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
              Row(
                children: <Widget>[
                  Expanded(
                    child: BouncingWidget(
                      scaleFactor: _scaleFactor,
                      onPressed: () {
                        setState(() {
                          jamSelected = "Pilih";
                          _selectedType = "pas";
                        });
                      },
                      child: Container(
                        height: 134,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Opacity(
                                opacity: _selectedType == "pas" ? 1 : 0.3,
                                child: Image.asset("assets/icons/pass.png",
                                    width: 48),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Pas",
                                style: TextStyle(
                                    color: Styles.Colors.textBlackColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400),
                              ),
                            ]),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: BouncingWidget(
                      scaleFactor: _scaleFactor,
                      onPressed: () {
                        setState(() {
                          passSelected = "Pilih";
                          _selectedType = "jam";
                        });
                      },
                      child: Container(
                        height: 134,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Opacity(
                                  opacity: _selectedType == "jam" ? 1 : 0.3,
                                  child: Image.asset("assets/icons/hour.png",
                                      width: 48)),
                              SizedBox(height: 10),
                              Text(
                                "Jam",
                                style: TextStyle(
                                    color: Styles.Colors.textBlackColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400),
                              ),
                            ]),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 30),
              _selectedType == "pas" ? _formPas(context) : _formJam(context),
              // _formPas(context),
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
            color: passSelected != "Pilih" || jamSelected != "Pilih"
                ? Styles.Colors.primaryColor
                : Styles.Colors.primaryColor.withOpacity(0.5),
            textColor: Colors.white,
            elevation: 0,
            onPressed: () {
              //  =================================================
              if (passSelected != "Pilih" || jamSelected != "Pilih") {
                _showDialog();
              }
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
    var parkingpassSelect = showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return BlocProvider<ParkingPassBloc>(
            create: (context) => ParkingPassBloc(ParkingPassRepository()),
            child: ParkingListUI(),
          );
        });
    parkingpassSelect.then((value) {
      Pass selectedData = value;
      print(selectedData.name);
      setState(() {
        passSelected = "${selectedData.name} (RM${selectedData.price})";
        passId = selectedData.id;
      });
    });
  }

  void _hourListModal(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          var price = 0.0;
          var dayPrice = 0.0;
          if (selectedMajlis == "MPK") {
            price = 0.6;
            dayPrice = 2.50;
          } else if (selectedMajlis == "MPB") {
            price = 0.3;
            dayPrice = 2.60;
          }
          return Container(
            child: new ListView(
              children: <Widget>[
                _parkirItemDaily(context, "1 jam",
                    (1 * price).toStringAsFixed(2), "jam", ""),
                _parkirItemDaily(context, "2 jam",
                    (2 * price).toStringAsFixed(2), "jam", ""),
                _parkirItemDaily(context, "3 jam",
                    (3 * price).toStringAsFixed(2), "jam", ""),
                _parkirItemDaily(context, "4 jam",
                    (4 * price).toStringAsFixed(2), "jam", ""),
                _parkirItemDaily(context, "5 jam",
                    (5 * price).toStringAsFixed(2), "jam", ""),
                _parkirItemDaily(context, "6 jam",
                    (6 * price).toStringAsFixed(2), "jam", ""),
                _parkirItemDaily(context, "7 jam",
                    (7 * price).toStringAsFixed(2), "jam", ""),
                _parkirItemDaily(context, "8 jam",
                    (8 * price).toStringAsFixed(2), "jam", ""),
                _parkirItemDaily(context, "9 jam",
                    (9 * price).toStringAsFixed(2), "jam", ""),
                _parkirItemDaily(context, "10 jam",
                    (10 * price).toStringAsFixed(2), "jam", ""),
                _parkirItemDaily(context, "11 jam",
                    (11 * price).toStringAsFixed(2), "jam", ""),
                _parkirItemDaily(context, "12 jam",
                    (12 * price).toStringAsFixed(2), "jam", ""),
                _parkirItemDaily(context, "13 jam",
                    (13 * price).toStringAsFixed(2), "jam", ""),
                _parkirItemDaily(context, "14 jam",
                    (14 * price).toStringAsFixed(2), "jam", ""),
                _parkirItemDaily(context, "15 jam",
                    (15 * price).toStringAsFixed(2), "jam", ""),
                _parkirItemDaily(context, "16 jam",
                    (16 * price).toStringAsFixed(2), "jam", ""),
                _parkirItemDaily(context, "17 jam",
                    (17 * price).toStringAsFixed(2), "jam", ""),
                _parkirItemDaily(context, "18 jam",
                    (18 * price).toStringAsFixed(2), "jam", ""),
                _parkirItemDaily(context, "19 jam",
                    (19 * price).toStringAsFixed(2), "jam", ""),
                _parkirItemDaily(context, "Daily Pass",
                    dayPrice.toStringAsFixed(2), "jam", ""),
              ],
            ),
          );
        });
  }

  Widget _parkirItemDaily(context, jam, harga, type, id) {
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
                  )
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
              Text(passSelected == 'Pilih' ? jamSelected : passSelected),
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

class ParkingListUI extends StatefulWidget {
  @override
  _ParkingListUIState createState() => _ParkingListUIState();
}

class _ParkingListUIState extends State<ParkingListUI> {
  ParkingPassBloc parkingPassBloc;

  @override
  void initState() {
    parkingPassBloc = BlocProvider.of<ParkingPassBloc>(context);
    getPass();
    super.initState();
  }

  getPass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    parkingPassBloc.add(GetParkingPassMonthly(token));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParkingPassBloc, ParkingPassState>(
      builder: (context, state) {
        if (state is ParkingPassLoaded) {
          return _parkingPassList(context, state.getParkingPass);
        } else if (state is ParkingPassFailed) {
          return Center(child: Text(state.errorMsg));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _parkingPassList(context, ParkingPassMonthly data) {
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      height: ((60 * data.data.length) + 32).toDouble(),
      child: ListView.builder(
        itemCount: data.data.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.pop(context, data.data[index]);
            },
            child: Container(
                height: 60,
                child: Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(data.data[index].name,
                            style: TextStyle(
                                color: Styles.Colors.textBlackColor,
                                fontSize: 17,
                                fontWeight: FontWeight.w400)),
                        Text(
                          " (RM${data.data[index].price.toString()})",
                          style: TextStyle(
                              color: Styles.Colors.primaryColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w400),
                        )
                      ]),
                )),
          );
        },
      ),
    );
  }
}
