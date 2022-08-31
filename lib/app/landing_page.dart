import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mvrg_app/ui/homepage/home_page.dart';
import 'package:mvrg_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

import '../ui/login/login_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool connection = true;

  @override
  void initState() {
    super.initState();
    checkIntConnection().then((value) {
      setState(() {
        connection = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: true);
    if (connection) {
      if (_userModel.state == ViewState.idle) {
        if (_userModel.user == null) {
          return LoginPage();
        } else {
          return const HomePage();
        }
      } else {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    } else {
      return const Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "İnternet bağlantın olmadan uygulamayı kullanamazsın. "
              "İnternet bağlantını kontrol et.",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      );
    }
  }

  Future<bool> checkIntConnection() async {
    return await (Connectivity().checkConnectivity()) !=
        ConnectivityResult.none;
  }
}
