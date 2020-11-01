import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pos_parking/bloc/kompaun_bloc.dart';
import 'package:pos_parking/model/kompaun_pelbagai_response_model.dart';
import 'package:pos_parking/model/kompaun_response_model.dart';
import 'package:pos_parking/repository/kompaun_repo.dart';
import 'package:pos_parking/views/pages/kompaun/kompaun.dart';
import 'package:pos_parking/views/pages/kompaun/kompaun_bayaran.dart';
import 'package:pos_parking/views/pages/kompaun/kompaun_detail.dart';
import 'package:pos_parking/views/pages/kompaun/kompaun_list_item.dart';
import 'package:pos_parking/views/pages/kompaun/kompaun_pelbagai_detail.dart';
import 'package:pos_parking/views/pages/kompaun/kompoun_receipt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../../../config/theme.dart' as Styles;

const CHANNEL = "com.posparking.channel";
const CETAK_NATIVE = "cetaknative";

class KompaunList extends StatefulWidget {
  final noPlate;
  final KompaunType type;

  KompaunList(this.noPlate, this.type);

  @override
  _KompaunListState createState() => _KompaunListState();
}

class _KompaunListState extends State<KompaunList> {
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
          "Senarai Kompaun",
          style: TextStyle(
            color: Styles.Colors.textDarkColor,
          ),
        ),
      ),
      body: BlocProvider<KompaunBloc>(
        create: (context) => KompaunBloc(KompaunRepository()),
        child: KompaunListData(widget.noPlate, widget.type),
      ),
    );
  }
}

class KompaunListData extends StatefulWidget {
  final noPlate;
  final KompaunType type;

  KompaunListData(this.noPlate, this.type);
  @override
  _KompaunListDataState createState() => _KompaunListDataState();
}

class _KompaunListDataState extends State<KompaunListData> {
  static const platform = const MethodChannel(CHANNEL);
  bool _isChecked = true;
  String name;

  KompaunBloc kompaunBloc;
  var totalamount = 0;
  String now;

  List<bool> checkValue = List<bool>();
  List<String> refNo = List<String>();
  List<String> priceList = List<String>();

  @override
  void initState() {
    super.initState();
    platform.setMethodCallHandler(_handleMethod);
    kompaunBloc = BlocProvider.of<KompaunBloc>(context);
    now = DateTime.now().toString();
    getKompaun();
  }

  Future<Null> printReceipt(total) async {
    await platform.invokeMethod(CETAK_NATIVE, [
      "Majlis Perbandaran Kuantan",
      widget.noPlate,
      "26300",
      formatDate(now),
      name.toString(),
      refNo.join(",").toString(),
      priceList.join(",").toString(),
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

  getKompaun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    name = prefs.getString("name");
    if (widget.type == KompaunType.vehicle) {
      kompaunBloc.add(FindKompaun(widget.noPlate, token));
    } else {
      kompaunBloc.add(FindPelbagai(widget.noPlate, token));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<KompaunBloc, KompaunState>(
      listener: (context, state) {
        if (state is KompaunIsSuccess) {
          for (var i = 0; i < state.getKompaun.data.length; i++) {
            checkValue.add(true);
            refNo.add(state.getKompaun.data[i].serviceReference1);
            priceList.add(
                (state.getKompaun.data[i].compoundAmount / 100).toString() +
                    "0");
            totalamount = 0;
            for (var i = 0; i < checkValue.length; i++) {
              if (checkValue[i]) {
                totalamount =
                    totalamount + state.getKompaun.data[i].compoundAmount;
              }
            }
          }
        } else if (state is KompaunPelbagaiIsSuccess) {
          for (var i = 0; i < state.getKompaun.data.length; i++) {
            checkValue.add(true);
            refNo.add(state.getKompaun.data[i].serviceReference1);
            priceList.add(
                (state.getKompaun.data[i].compoundAmount / 100).toString() +
                    "0");
            totalamount = 0;
            for (var i = 0; i < checkValue.length; i++) {
              if (checkValue[i]) {
                totalamount =
                    totalamount + state.getKompaun.data[i].compoundAmount;
              }
            }
          }
        } else if (state is KompaunIsNotSuccess) {
          return Center(child: Text("Error"));
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
      child: BlocBuilder<KompaunBloc, KompaunState>(builder: (context, state) {
        print(state.toString());
        if (state is KompaunIsLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is KompaunIsSuccess) {
          return state.getKompaun.data.length > 0
              ? _listKompaun(context, state.getKompaun)
              : Center(child: _noRecord(context));
        } else if (state is KompaunPelbagaiIsSuccess) {
          return state.getKompaun.data.length > 0
              ? _listKompaunPelbagai(context, state.getKompaun)
              : Center(child: _noRecord(context));
        } else if (state is KompaunIsNotSuccess) {
          return _noRecord(context);
        }
        return Container();
      }),
    );
  }

  Widget _noRecord(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Tiada rekod ditemui bagi",
              style: TextStyle(
                  color: Styles.Colors.textBlackColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500)),
          SizedBox(height: 10),
          Text(
            "${widget.noPlate}",
            style: TextStyle(
                color: Styles.Colors.primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10),
          Text(
            "Sila cuba menggunakan no. Mykad atau no. Syarikat untuk carian terperinci.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  formatDate(date) {
    DateTime newDate = DateTime.parse(date);
    // DateTime newDate = new DateTime(date).toUtc();
    return new DateFormat("dd-MM-yyyy hh:mm:ss").format(newDate);
  }

  Widget _listKompaun(BuildContext context, KompaunResponse kompaun) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            color: Color.fromRGBO(241, 156, 0, 0.1),
            padding: EdgeInsets.all(16),
            width: double.infinity,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.noPlate,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text("(${priceList.length}) RM${totalamount / 100}0",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      )),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.0),
                          color: _isChecked
                              ? Styles.Colors.primaryColor
                              : Styles.Colors.unselectedCheckbox,
                        ),
                        width: 24,
                        height: 24,
                        child: Theme(
                          data: ThemeData(
                              unselectedWidgetColor:
                                  Styles.Colors.unselectedCheckbox),
                          child: Checkbox(
                            activeColor: Styles.Colors.primaryColor,
                            value: _isChecked,
                            tristate: false,
                            onChanged: (bool isChecked) {
                              totalamount = 0;
                              for (var i = 0; i < checkValue.length; i++) {
                                checkValue[i] = isChecked;
                              }
                              if (!isChecked) {
                                refNo = List<String>();
                                priceList = List<String>();
                              } else {
                                refNo = List<String>();
                                priceList = List<String>();
                                for (var i = 0; i < kompaun.data.length; i++) {
                                  refNo.add(kompaun.data[i].serviceReference1);
                                  priceList.add(
                                      (kompaun.data[i].compoundAmount / 100)
                                              .toString() +
                                          "0");
                                  totalamount = totalamount +
                                      kompaun.data[i].compoundAmount;
                                }
                              }

                              setState(() {
                                _isChecked = isChecked;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Text("Pilih Semua",
                          style: TextStyle(
                            color: Styles.Colors.textGreyColor,
                            fontSize: 17,
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: kompaun.data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Container(
                      // padding: EdgeInsets.symmetric(
                      //     horizontal: 11.0, vertical: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Styles.Colors.unselectedCheckbox,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: CheckboxListTile(
                          activeColor: Styles.Colors.primaryColor,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => KompaunDetail(
                                            kompaun.data[index])));
                              },
                              child:
                                  Text(kompaun.data[index].serviceReference1)),
                          subtitle: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          KompaunDetail(kompaun.data[index])));
                            },
                            child: Text(
                                "Tarikh: ${formatDate(kompaun.data[index].violationTimestamp)}",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Styles.Colors.textBlackColor)),
                          ),
                          secondary: Text(
                              "RM${kompaun.data[index].compoundAmount / 100}0",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              )),
                          value: checkValue[index],
                          onChanged: (val) {
                            if (val) {
                              refNo.add(kompaun.data[index].serviceReference1);
                              priceList.add(
                                  (kompaun.data[index].compoundAmount / 100)
                                          .toString() +
                                      "0");
                              totalamount = totalamount +
                                  kompaun.data[index].compoundAmount;
                            } else {
                              refNo.remove(
                                  kompaun.data[index].serviceReference1);
                              priceList.remove(
                                  (kompaun.data[index].compoundAmount / 100)
                                          .toString() +
                                      "0");
                              totalamount = totalamount -
                                  kompaun.data[index].compoundAmount;
                            }
                            setState(() {
                              checkValue[index] = val;
                              _isChecked = false;
                            });
                          }),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
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
                    totalamount = 0;
                    for (var i = 0; i < checkValue.length; i++) {
                      if (checkValue[i]) {
                        totalamount =
                            totalamount + kompaun.data[i].compoundAmount;
                      }
                    }
                    var total = (totalamount / 100).toString() + "0";
                    printReceipt(total);
                  },
                  child: Text(
                    "CETAK",
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => KompounBayaran(
                                priceList.length,
                                totalamount,
                                widget.noPlate,
                                refNo,
                                priceList,
                                name)));
                    // _showDialog(kompaun);
                  },
                  child: Text(
                    "SETERUSNYA",
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
      ),
    );
  }

  Widget _listKompaunPelbagai(
      BuildContext context, KompaunPelbagaiResponse kompaun) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            color: Color.fromRGBO(241, 156, 0, 0.1),
            padding: EdgeInsets.all(16),
            width: double.infinity,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.noPlate,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text("(${priceList.length}) RM${totalamount / 100}0",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      )),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.0),
                          color: _isChecked
                              ? Styles.Colors.primaryColor
                              : Styles.Colors.unselectedCheckbox,
                        ),
                        width: 24,
                        height: 24,
                        child: Theme(
                          data: ThemeData(
                              unselectedWidgetColor:
                                  Styles.Colors.unselectedCheckbox),
                          child: Checkbox(
                            activeColor: Styles.Colors.primaryColor,
                            value: _isChecked,
                            tristate: false,
                            onChanged: (bool isChecked) {
                              totalamount = 0;
                              for (var i = 0; i < checkValue.length; i++) {
                                checkValue[i] = isChecked;
                              }
                              if (!isChecked) {
                                refNo = List<String>();
                                priceList = List<String>();
                              } else {
                                refNo = List<String>();
                                priceList = List<String>();
                                for (var i = 0; i < kompaun.data.length; i++) {
                                  refNo.add(kompaun.data[i].serviceReference1);
                                  priceList.add(
                                      (kompaun.data[i].compoundAmount / 100)
                                              .toString() +
                                          "0");
                                  totalamount = totalamount +
                                      kompaun.data[i].compoundAmount;
                                }
                              }

                              setState(() {
                                _isChecked = isChecked;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Text("Pilih Semua",
                          style: TextStyle(
                            color: Styles.Colors.textGreyColor,
                            fontSize: 17,
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: kompaun.data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Container(
                      // padding: EdgeInsets.symmetric(
                      //     horizontal: 11.0, vertical: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Styles.Colors.unselectedCheckbox,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: CheckboxListTile(
                          activeColor: Styles.Colors.primaryColor,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            KompaunPelbagaiDetail(
                                                kompaun.data[index])));
                              },
                              child:
                                  Text(kompaun.data[index].serviceReference1)),
                          subtitle: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          KompaunPelbagaiDetail(
                                              kompaun.data[index])));
                            },
                            child: Text(
                                "Tarikh: ${formatDate(kompaun.data[index].violationTimestamp)}",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Styles.Colors.textBlackColor)),
                          ),
                          secondary: Text(
                              "RM${kompaun.data[index].compoundAmount / 100}0",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              )),
                          value: checkValue[index],
                          onChanged: (val) {
                            if (val) {
                              refNo.add(kompaun.data[index].serviceReference1);
                              priceList.add(
                                  (kompaun.data[index].compoundAmount / 100)
                                          .toString() +
                                      "0");
                              totalamount = totalamount +
                                  kompaun.data[index].compoundAmount;
                            } else {
                              refNo.remove(
                                  kompaun.data[index].serviceReference1);
                              priceList.remove(
                                  (kompaun.data[index].compoundAmount / 100)
                                          .toString() +
                                      "0");
                              totalamount = totalamount -
                                  kompaun.data[index].compoundAmount;
                            }
                            setState(() {
                              checkValue[index] = val;
                              _isChecked = false;
                            });
                          }),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
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
                    totalamount = 0;
                    for (var i = 0; i < checkValue.length; i++) {
                      if (checkValue[i]) {
                        totalamount =
                            totalamount + kompaun.data[i].compoundAmount;
                      }
                    }
                    var total = (totalamount / 100).toString() + "0";
                    printReceipt(total);
                  },
                  child: Text(
                    "CETAK",
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => KompounBayaran(
                                priceList.length,
                                totalamount,
                                widget.noPlate,
                                refNo,
                                priceList,
                                name)));
                  },
                  child: Text(
                    "SETERUSNYA",
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
      ),
    );
  }
}
