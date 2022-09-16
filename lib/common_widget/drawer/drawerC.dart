import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mvrg_app/ui/Profil/update_password_page.dart';
import 'package:mvrg_app/ui/badges_page/create_and_update_badge_page.dart';
import 'package:mvrg_app/ui/clipper.dart';
import 'package:mvrg_app/ui/login/login_page.dart';
import 'package:mvrg_app/ui/my_events/my_events.dart';
import 'package:mvrg_app/ui/profil/user_detail_page.dart';
import 'package:mvrg_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

import '../../app/exceptions.dart';
import '../../model/userC.dart';
import '../../ui/const.dart';

class DrawerC extends StatefulWidget {
  const DrawerC({Key? key}) : super(key: key);

  @override
  State<DrawerC> createState() => _DrawerCState();
}

class _DrawerCState extends State<DrawerC> {
  String name = " ", surname = " ", mail = "";

  bool admin = false;

  Divider divider = const Divider(
    height: 1,
    color: Colors.grey,
  );

  @override
  void initState() {
    super.initState();
    currentUser();
  }

  @override
  Widget build(BuildContext context) {
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
                            ),
                            GestureDetector(
                              child: const Text(
                                "100 MvRG Token    🔄",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.red),
                              ),
                              onTap: () {},
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
                    buildListTileWithIcon(
                        Icons.event, "Etkinliklerim", const MyEvents()),
                    divider,
                    ExpansionTile(
                      leading: const Icon(Icons.account_box),
                      title: const Text("Hesap Bilgilerim"),
                      trailing: const Icon(Icons.arrow_drop_down),
                      children: [
                        buildListTile("Kullanıcı Bilgilerimi Güncelle",
                            const UserDetailPage()),
                        buildListTile(
                            "Şifre Değişikliği", const UpdatePasswordPage())
                      ],
                    ),
                    if (admin)
                      buildListTileWithIcon(Icons.badge, "Yeni Rozet Ekle",
                          const CreateAndUpdateBadgePage()),
                    divider,
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            areYouSureForSignOut();
                          },
                        ),
                        TextButton(
                          child: const Text(
                            "Çıkış Yap",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          onPressed: () {
                            areYouSureForSignOut();
                          },
                        )
                      ],
                    )
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
    UserC? userC = Provider.of<UserModel>(context, listen: false).user;
    if (userC != null) {
      setState(() {
        name = userC.name!;
        surname = userC.surname!;
        mail = userC.mail!;
        admin = userC.admin!;
      });
    }
  }

  Widget buildListTile(String title, Widget page) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_right),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }

  Widget buildListTileWithIcon(IconData iconData, String title, Widget page) =>
      ListTile(
        leading: Icon(iconData),
        title: Text(title),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        },
      );

  Future areYouSureForSignOut() async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      borderSide: const BorderSide(color: Colors.green, width: 2),
      headerAnimationLoop: false,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Emin Misin?',
      desc: 'Oturumunu kapatmak istediğine emin misin?',
      btnCancelText: "Vazgeç",
      btnCancelOnPress: () {},
      btnOkText: "Evet",
      btnOkOnPress: () {
        signOut();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      },
    ).show();
  }

  Future signOut() async {
    try {
      await (Provider.of<UserModel>(context, listen: false).signOut());
    } catch (e) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.WARNING,
              animType: AnimType.RIGHSLIDE,
              headerAnimationLoop: true,
              title: 'Oturum Kapatılırken HATA',
              desc: Exceptions.goster(e.toString()),
              btnOkOnPress: () {},
              btnOkText: "Tamam",
              btnOkColor: Colors.blue)
          .show();
    }
  }
}
