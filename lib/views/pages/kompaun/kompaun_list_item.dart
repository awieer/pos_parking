import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_parking/model/kompaun_response_model.dart';
import 'package:pos_parking/views/pages/kompaun/kompaun_detail.dart';
import '../../../config/theme.dart' as Styles;

class KompaunListItem extends StatefulWidget {
  final KompaunData kompaun;
  bool _isChecked;

  final VoidCallback onCountSelected;

  KompaunListItem(this.kompaun, this._isChecked, this.onCountSelected);
  @override
  _KompaunListItemState createState() => _KompaunListItemState();
}

class _KompaunListItemState extends State<KompaunListItem> {
  bool _isChecked = false;

  formatDate(date) {
    DateTime newDate = DateTime.parse(date);
    // DateTime newDate = new DateTime(date).toUtc();
    return new DateFormat("dd-MM-yyyy hh:mm:ss").format(newDate);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => KompaunDetail(widget.kompaun)));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 11.0, vertical: 16.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Styles.Colors.unselectedCheckbox,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0),
                  color: widget._isChecked
                      ? Styles.Colors.primaryColor
                      : Styles.Colors.unselectedCheckbox,
                ),
                width: 24,
                height: 24,
                child: Theme(
                  data: ThemeData(
                      unselectedWidgetColor: Styles.Colors.unselectedCheckbox),
                  child: Checkbox(
                    activeColor: Styles.Colors.primaryColor,
                    value: widget._isChecked,
                    tristate: false,
                    onChanged: (bool isChecked) {
                      setState(() {
                        widget.onCountSelected();
                        widget._isChecked = isChecked;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(width: 11),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Text("${widget.kompaun.serviceReference1}",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ))),
                          Text("RM${widget.kompaun.compoundAmount / 100}0",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              )),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                          "Tarikh: ${formatDate(widget.kompaun.violationTimestamp)}",
                          style: TextStyle(
                              fontSize: 10,
                              color: Styles.Colors.textBlackColor)),
                      SizedBox(height: 3),
                      // Text("Seksyen: 30(A)",
                      //     style: TextStyle(
                      //         fontSize: 10,
                      //         color: Styles.Colors.textBlackColor)),
                      // SizedBox(height: 5),
                      // Row(
                      //   children: <Widget>[
                      //     Icon(
                      //       Icons.info,
                      //       size: 12,
                      //       color: Styles.Colors.primaryColor,
                      //     ),
                      //     SizedBox(width: 5),
                      //     Text("12 days left (12/12/12)",
                      //         style: TextStyle(
                      //             fontSize: 10,
                      //             fontWeight: FontWeight.bold,
                      //             color: Styles.Colors.textBlackColor)),
                      //   ],
                      // )
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
