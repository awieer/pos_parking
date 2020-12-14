import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_parking/bloc/parkir_bloc.dart';
import 'package:pos_parking/model/pay_parkir_response.dart';
import 'package:pos_parking/repository/parkir_repo.dart';
import 'package:pos_parking/views/pages/parkir/parkir_receipt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/theme.dart' as Styles;

class ParkirPay extends StatefulWidget {
  final pass;
  final noPlate;

  ParkirPay(this.pass, this.noPlate);

  @override
  _ParkirPayState createState() => _ParkirPayState();
}

class _ParkirPayState extends State<ParkirPay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ParkirBloc>(
          create: (context) => ParkirBloc(ParkirRepo()),
          child: ParkirProcess(
            widget.pass,
            widget.noPlate,
          )),
    );
  }
}

class ParkirProcess extends StatefulWidget {
  final pass;
  final noPlate;

  ParkirProcess(this.pass, this.noPlate);

  @override
  _ParkirProcessState createState() => _ParkirProcessState();
}

class _ParkirProcessState extends State<ParkirProcess> {
  ParkirBloc parkirBloc;
  var name;

  @override
  void initState() {
    super.initState();
    parkirBloc = BlocProvider.of<ParkirBloc>(context);
    _runParkirPay();
  }

  _runParkirPay() async {
    print("==========================");
    print(widget.noPlate);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    name = prefs.getString("name");
    parkirBloc.add(PayParkir(widget.noPlate, token, widget.pass));
  }

  void _finishPayment(PayParkirResponse data) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ParkirReceipt(data, name)));
  }

  void _parkingNotSuccess(noPlate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(content: Builder(builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Text("Kupon Parking Sah",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  )),
              SizedBox(height: 20),
              Text(
                "Kenderaan $noPlate sudah mempunyai kupon parking yang sah.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
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
                          int count = 0;
                          Navigator.of(context).popUntil((_) => count++ >= 2);
                        },
                        child: Text(
                          "OKAY",
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

  void _parkingFailed(msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(content: Builder(builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Text("Error",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  )),
              SizedBox(height: 20),
              Text(
                "$msg",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
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
                          int count = 0;
                          Navigator.of(context).popUntil((_) => count++ >= 2);
                        },
                        child: Text(
                          "OKAY",
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<ParkirBloc, ParkirState>(
      listener: (context, state) {
        if (state is ParkirIsSuccess) {
          _finishPayment(state.getResponse);
        } else if (state is ParkirIsNotSuccess) {
          // _parkingNotSuccess(widget.noPlate);
          _parkingFailed(state.message);
        }
        return Container();
      },
      child: BlocBuilder<ParkirBloc, ParkirState>(
        builder: (context, state) {
          if (state is ParkirIsInit) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ParkirIsLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ParkirIsNotSuccess) {
            return Center(
              child: Container(),
            );
          } else if (state is ParkirIsSuccess) {
            return Center(
              child: Text("payment successful"),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
