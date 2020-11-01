import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_parking/model/kompaun_pelbagai_response_model.dart';
import '../../../config/theme.dart' as Styles;

class KompaunPelbagaiDetail extends StatefulWidget {
  final KompaunPelbagaiData kompaun;

  KompaunPelbagaiDetail(this.kompaun);
  @override
  _KompaunPelabagiDetailState createState() => _KompaunPelabagiDetailState();
}

class _KompaunPelabagiDetailState extends State<KompaunPelbagaiDetail> {
  formatDate(date) {
    DateTime newDate = DateTime.parse(date);
    // DateTime newDate = new DateTime(date).toUtc();
    return new DateFormat("dd-MM-yyyy hh:mm:ss").format(newDate);
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
            "Butiran",
            style: TextStyle(
              color: Styles.Colors.textDarkColor,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(26),
            child: Container(
              child: Column(children: <Widget>[
                Row(children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width * 40 / 100,
                      child: Text(
                        "Compaund No.",
                        style: TextStyle(fontSize: 17),
                      )),
                  Text(":"),
                  SizedBox(width: 5),
                  Text(
                    widget.kompaun.serviceReference1,
                    style: TextStyle(fontSize: 17),
                  ),
                ]),
                SizedBox(height: 16),
                // Row(children: <Widget>[
                //   Container(
                //       width: MediaQuery.of(context).size.width * 40 / 100,
                //       child: Text(
                //         "Kod Hasil",
                //         style: TextStyle(fontSize: 17),
                //       )),
                //   Text(":"),
                //   SizedBox(width: 5),
                //   Text(
                //     widget.kompaun.serviceReference2,
                //     style: TextStyle(fontSize: 17),
                //   ),
                // ]),
                // SizedBox(height: 16),
                Row(children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width * 40 / 100,
                      child: Text(
                        "Tarikh",
                        style: TextStyle(fontSize: 17),
                      )),
                  Text(":"),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      formatDate(widget.kompaun.violationTimestamp),
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ]),
                SizedBox(height: 16),
                // Row(children: <Widget>[
                //   Container(
                //       width: MediaQuery.of(context).size.width * 40 / 100,
                //       child: Text(
                //         "Nama/Syarikat",
                //         style: TextStyle(fontSize: 17),
                //       )),
                //   Text(":"),
                //   SizedBox(width: 5),
                //   Text(
                //     "Marco Alvensintrovich",
                //     style: TextStyle(fontSize: 17),
                //   ),
                // ]),
                // SizedBox(height: 16),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width * 40 / 100,
                          child: Text(
                            "Offender Name",
                            style: TextStyle(fontSize: 17),
                          )),
                      Text(":"),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          widget.kompaun.offenderName,
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ]),
                SizedBox(height: 16),
                Row(children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width * 40 / 100,
                      child: Text(
                        "Offender ID",
                        style: TextStyle(fontSize: 17),
                      )),
                  Text(":"),
                  SizedBox(width: 5),
                  Text(
                    widget.kompaun.offenderId,
                    style: TextStyle(fontSize: 17),
                  ),
                ]),
                SizedBox(height: 16),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width * 40 / 100,
                          child: Text(
                            "Alamat/Lokasi",
                            style: TextStyle(fontSize: 17),
                          )),
                      Text(":"),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          widget.kompaun.violationLocation,
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ]),
                SizedBox(height: 16),
                // Row(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: <Widget>[
                //       Container(
                //           width: MediaQuery.of(context).size.width * 40 / 100,
                //           child: Text(
                //             "Butiran",
                //             style: TextStyle(fontSize: 17),
                //           )),
                //       Text(":"),
                //       SizedBox(width: 5),
                //       Expanded(
                //           child: Text(
                //         "Kawasan hadapan permis menghalang laluan",
                //         style: TextStyle(fontSize: 17),
                //       )),
                //     ]),
                // SizedBox(height: 16),
                // // Row(children: <Widget>[
                // //   Container(
                // //       width: MediaQuery.of(context).size.width * 40 / 100,
                // //       child: Text(
                // //         "Seksyen",
                // //         style: TextStyle(fontSize: 17),
                // //       )),
                // //   Text(":"),
                // //   SizedBox(width: 5),
                // //   Text(
                // //     "30(a)",
                // //     style: TextStyle(fontSize: 17),
                // //   ),
                // // ]),
                // // SizedBox(height: 16),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width * 40 / 100,
                          child: Text(
                            "Keterangan",
                            style: TextStyle(fontSize: 17),
                          )),
                      Text(":"),
                      SizedBox(width: 5),
                      Expanded(
                          child: Text(
                        widget.kompaun.violationType,
                        style: TextStyle(fontSize: 17),
                      )),
                    ]),
                SizedBox(height: 16),
                // Row(children: <Widget>[
                //   Container(
                //       width: MediaQuery.of(context).size.width * 40 / 100,
                //       child: Text(
                //         "ID Penguatkuasa",
                //         style: TextStyle(fontSize: 17),
                //       )),
                //   Text(":"),
                //   SizedBox(width: 5),
                //   Text(
                //     "123411",
                //     style: TextStyle(fontSize: 17),
                //   ),
                // ]),
                // SizedBox(height: 16),
                // Row(children: <Widget>[
                //   Container(
                //       width: MediaQuery.of(context).size.width * 40 / 100,
                //       child: Text(
                //         "ID Saksi",
                //         style: TextStyle(fontSize: 17),
                //       )),
                //   Text(":"),
                //   SizedBox(width: 5),
                //   Text(
                //     "223309",
                //     style: TextStyle(fontSize: 17),
                //   ),
                // ]),
                // SizedBox(height: 16),
                Row(children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width * 40 / 100,
                      child: Text(
                        "Kadar Bayaran",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      )),
                  Text(":"),
                  SizedBox(width: 5),
                  Text(
                    "RM${widget.kompaun.compoundAmount / 100}0",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ]),
                SizedBox(height: 16),
              ]),
            ),
          ),
        ));
  }
}
