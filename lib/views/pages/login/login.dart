import 'package:flutter/material.dart';
import 'package:pos_parking/bloc/user_bloc.dart';
import 'package:pos_parking/model/user_response_model.dart';
import 'package:pos_parking/repository/user_repo.dart';
import 'package:pos_parking/views/pages/home/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/theme.dart' as Styles;
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List<String> majlis = ["MPK", "MDCH", "MPB"];
  String selectedMajlis = "MPK";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getmajlis();
  }

  Future<void> _getmajlis() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("majlis") != null) {
      setState(() {
        selectedMajlis = prefs.getString("majlis");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(38.0),
            child: Center(
              child: Column(children: <Widget>[
                SizedBox(height: 40),
                InkWell(
                  onLongPress: () {
                    selectMajlis();
                  },
                  child: Image.asset(
                    majlisSelected(selectedMajlis),
                    width: 120,
                  ),
                ),
                SizedBox(height: 150),
                BlocProvider<UserBloc>(
                    create: (context) => UserBloc(UserRepository()),
                    child: LoginForm())
              ]),
            ),
          ),
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

  void selectMajlis() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
              height: 195,
              color: Colors.transparent,
              child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: ListView.separated(
                  itemCount: majlis.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(majlis[index]),
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString("majlis", majlis[index]);
                        setState(() {
                          selectedMajlis = majlis[index];
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                  separatorBuilder: (context, index) => Divider(),
                ),
              ));
        });
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController emailControl = new TextEditingController();
  TextEditingController passwordControl = new TextEditingController();
  bool _showPassword = true;

  UserBloc userBloc;

  @override
  void initState() {
    super.initState();
    userBloc = BlocProvider.of<UserBloc>(context);
    emailControl.text = "pos.enforcer@pahanggo.com";
    passwordControl.text = "posEnforcer@Pgo!";
  }

  Widget _loginForm(context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Styles.Colors.unselectedCheckbox))),
          child: TextField(
            controller: emailControl,
            decoration: InputDecoration(
              hintText: "ID Penguatkuasa",
              border: InputBorder.none,
            ),
          ),
        ),
        SizedBox(height: 32),
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Styles.Colors.unselectedCheckbox))),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: passwordControl,
                  obscureText: _showPassword,
                  decoration: InputDecoration(
                    hintText: "Kata Laluan",
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                  icon: Icon(Icons.visibility_off, size: 20),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  })
            ],
          ),
        ),
        SizedBox(height: 70),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 54,
          child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              elevation: 0,
              color: Styles.Colors.primaryColor,
              onPressed: () {
                userBloc
                    .add(Authenticate(emailControl.text, passwordControl.text));
              },
              child: Text(
                "Log Masuk",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              )),
        ),
      ],
    );
  }

  _userLoginResult(bool status, String name, String token) async {
    if (status) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("name", name);
      prefs.setString("token", token);
      print(name);
      print(status);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      print("status false");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, LoginState>(listener: (context, state) {
      if (state is LoginIsSuccess) {
        _userLoginResult(state.getUser.success, state.getUser.data.name,
            state.getUser.data.authToken);
      } else if (state is LoginIsNotSuccess) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Wrong username or password",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    }, child: BlocBuilder<UserBloc, LoginState>(builder: (context, state) {
      if (state is LoginIsLoading)
        return Center(
          child: CircularProgressIndicator(),
        );
      return _loginForm(context);
    }));
  }
}
