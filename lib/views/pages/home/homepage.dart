import 'package:flutter/material.dart';
import 'package:pos_parking/views/pages/fil/fil.dart';
import 'package:pos_parking/views/pages/kompaun/kompaun.dart';
import 'package:pos_parking/views/pages/parkir/parkir.dart';
import '../../../config/theme.dart' as Styles;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Styles.Colors.primaryBackgroundColor,
        appBar: AppBar(
          elevation: 1,
          excludeHeaderSemantics: true,
          backgroundColor: Styles.Colors.secondaryBackgroundColor,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.power_settings_new,
                color: Colors.black38,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
          bottom: TabBar(
            indicator: UnderlineTabIndicator(
              borderSide:
                  BorderSide(color: Styles.Colors.primaryColor, width: 3.0),
            ),
            labelColor: Styles.Colors.primaryColor,
            unselectedLabelColor: Styles.Colors.textDarkColor,
            tabs: <Widget>[
              Tab(text: "PARKIR"),
              Tab(text: "KOMPAUN"),
              // Tab(text: "FIL"),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Parkir(),
            Kompaun(),
            // FilPage(),
          ],
        ),
      ),
    );
  }
}
