import 'package:flutter/material.dart';
import 'package:mvrg_app/ui/clipper.dart';
import 'package:mvrg_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

import '../../model/userC.dart';
import '../../ui/const.dart';

class DrawerC extends StatefulWidget {
  const DrawerC({Key? key}) : super(key: key);

  @override
  State<DrawerC> createState() => _DrawerCState();
}

class _DrawerCState extends State<DrawerC> {
  String name = " ", surname = " ", mail = "";

  late UserModel userModel;

  bool admin = false;

  @override
  Widget build(BuildContext context) {
    userModel = Provider.of<UserModel>(context, listen: false);
    currentUser();
    return Drawer(
      child: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Column(
            children: [
              ClipPath(
                clipper: WaveClipper(),
                child: Center(
                  child: SizedBox(
                    height: 230,
                    child: DrawerHeader(
                      decoration: gradient,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            CircleAvatar(
                              maxRadius: 40,
                              backgroundColor: Theme.of(context).platform ==
                                      TargetPlatform.iOS
                                  ? Colors.red
                                  : const Color.fromRGBO(117, 138, 230, 1),
                              child: Text(
                                name[0] + surname[0],
                                style: const TextStyle(
                                    fontSize: 35, color: Colors.black54),
                              ),
                            ),
                            Text(
                              mail,
                              style: const TextStyle(fontSize: 20),
                            ),
                            Text(
                              name + " " + surname,
                              style: const TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                    for (final map in drawerItems)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          children: [
                            TextButton.icon(
                              label: Text(
                                map["title"],
                                style: const TextStyle(
                                    color: Colors.white60,
                                    fontWeight: FontWeight.bold),
                              ),
                              icon: Icon(
                                map["icon"],
                                color: Colors.white60,
                                size: 24,
                              ),
                              onPressed: () {},
                            )
                          ],
                        ),
                      ),
                    //adminDrawerItems
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future currentUser() async {
    UserC? userC = userModel.user;
    if (userC != null) {
      setState(() {
        name = userC.name!;
        surname = userC.surname!;
        mail = userC.mail!;
        admin = userC.admin!;
      });
    }
  }
}
