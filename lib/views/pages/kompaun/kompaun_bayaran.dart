import 'package:flutter/material.dart';
import 'package:pos_parking/views/pages/kompaun/kompoun_receipt.dart';
import '../../../config/theme.dart' as Styles;

class KompounBayaran extends StatefulWidget {
  final int kuantiti;
  final int amount;
  final String noPlate;
  final List<String> refNo;
  final List<String> priceList;
  final String name;

  KompounBayaran(this.kuantiti, this.amount, this.noPlate, this.refNo,
      this.priceList, this.name);
  @override
  _KompounBayaranState createState() => _KompounBayaranState();
}

class _KompounBayaranState extends State<KompounBayaran> {
  bool showDiskaun = false;
  bool showKupon = false;
  double newAmount;

  TextEditingController kuantitiController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController jumlahController = TextEditingController();
  TextEditingController penguranganController = TextEditingController();
  String diskaun = "Pilih Kupon";

  @override
  void initState() {
    super.initState();
    kuantitiController.text = widget.kuantiti.toString();
    amountController.text = "RM " + (widget.amount / 100).toString() + "0";
    jumlahController.text = "RM " + (widget.amount / 100).toString() + "0";
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
          "Bayaran Kompaun",
          style: TextStyle(
            color: Styles.Colors.textDarkColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Kuantiti Kompaun",
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
                color: Color(0xFFEEEEEE),
                border: Border.all(
                  color: Color(0xFFD4D4D4),
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                controller: kuantitiController,
                enabled: false,
                decoration: InputDecoration(
                  hintText: "Kuantiti",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 21.0),
            Text(
              "Jumlah Kompaun",
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
                color: Color(0xFFEEEEEE),
                border: Border.all(
                  color: Color(0xFFD4D4D4),
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                controller: jumlahController,
                decoration: InputDecoration(
                  hintText: "RM 0.00",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 21.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Kupon Diskaun",
                  style: TextStyle(
                      color: Styles.Colors.primaryColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w400),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      showKupon = !showKupon;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Styles.Colors.primaryColor)),
                    child: Icon(
                      showKupon ? Icons.remove : Icons.add,
                      size: 16,
                      color: Styles.Colors.primaryColor,
                    ),
                  ),
                )
              ],
            ),
            showKupon ? SizedBox(height: 11.0) : Container(),
            showKupon
                ? InkWell(
                    onTap: () {
                      _diskaunModal(context);
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 16, right: 16),
                      height: 52,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFFE8ECEF),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        diskaun,
                        style: TextStyle(
                          color: Styles.Colors.textBlackColor,
                        ),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(height: 21.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pengurangan",
                  style: TextStyle(
                      color: Styles.Colors.primaryColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w400),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      showDiskaun = !showDiskaun;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Styles.Colors.primaryColor)),
                    child: Icon(
                      showDiskaun ? Icons.remove : Icons.add,
                      size: 16,
                      color: Styles.Colors.primaryColor,
                    ),
                  ),
                )
              ],
            ),
            showDiskaun ? SizedBox(height: 11.0) : Container(),
            showDiskaun
                ? Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    height: 52,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFE8ECEF),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "RM ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: penguranganController,
                            onChanged: (value) {
                              print(value);
                              if (value != null || value != "") {
                                setState(() {
                                  amountController.text = "RM " +
                                      ((widget.amount / 100) -
                                              double.parse(value))
                                          .toString() +
                                      "0";
                                  newAmount = (((widget.amount / 100) -
                                          double.parse(value)) *
                                      100);
                                });
                              } else {
                                setState(() {
                                  amountController.text = "RM " +
                                      (widget.amount / 100).toString() +
                                      "0";
                                  newAmount = widget.amount.toDouble();
                                });
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "0.00",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            SizedBox(height: 21.0),
            Text(
              "Jumlah Bayaran",
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
                color: Color(0xFFEEEEEE),
                border: Border.all(
                  color: Color(0xFFD4D4D4),
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                controller: amountController,
                decoration: InputDecoration(
                  hintText: "RM 0.00",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
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
            onPressed: () {
              _showDialog();
            },
            child: Text(
              "BAYARAN DITERIMA",
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
              Text("Bayaran Diterima?",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  )),
              SizedBox(height: 20),
              Text(amountController.text,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 20),
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
                                  builder: (context) => KompaunReceipt(
                                      newAmount,
                                      widget.noPlate,
                                      widget.refNo,
                                      widget.priceList,
                                      widget.name,
                                      penguranganController.text)));
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

  _diskaunModal(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 200,
            child: new Wrap(
              children: <Widget>[
                _diskaunItem(context, "MDK50", "100"),
              ],
            ),
          );
        });
  }

  Widget _diskaunItem(context, code, val) {
    return InkWell(
      onTap: () {
        setState(() {
          showDiskaun = true;
          diskaun = code;
          penguranganController.text = val;
          amountController.text = "RM " +
              ((widget.amount / 100) - double.parse(val)).toString() +
              "0";
          newAmount = (((widget.amount / 100) - double.parse(val)) * 100);
        });
        Navigator.pop(context);
      },
      child: Container(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                Text("Kupon Diskaun",
                    style: TextStyle(
                        color: Styles.Colors.textBlackColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w400)),
                SizedBox(height: 16),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("$code ",
                          style: TextStyle(
                              color: Styles.Colors.textBlackColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w400)),
                      Text(
                        "(RM$val)",
                        style: TextStyle(
                            color: Styles.Colors.primaryColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w400),
                      ),
                    ]),
              ],
            ),
          )),
    );
  }
}
