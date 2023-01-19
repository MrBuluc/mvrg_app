import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mvrg_app/model/lab/in_lab.dart';
import 'package:mvrg_app/model/lab/lab_open.dart';
import 'package:mvrg_app/ui/Profil/update_password_page.dart';
import 'package:mvrg_app/ui/badges_page/create_and_update_badge_page.dart';
import 'package:mvrg_app/ui/clipper.dart';
import 'package:mvrg_app/ui/lab_open_page/lab_open_page.dart';
import 'package:mvrg_app/ui/login/login_page.dart';
import 'package:mvrg_app/ui/my_haves/my_badges.dart';
import 'package:mvrg_app/ui/profil/user_detail_page.dart';
import 'package:mvrg_app/ui/token_transfer_page/token_transfer_page.dart';
import 'package:mvrg_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

import '../../app/exceptions.dart';
import '../../model/userC.dart';
import '../../ui/const.dart';
import '../../ui/my_haves/my_events.dart';

enum LabState { labAcikAyni, labAcikFarkli, labKapali, noAdmin, idle }

class DrawerC extends StatefulWidget {
  const DrawerC({Key? key}) : super(key: key);

  @override
  State<DrawerC> createState() => _DrawerCState();
}

class _DrawerCState extends State<DrawerC> {
  String name = "",
      surname = "",
      mail = "",
      token = "",
      weeklyLabOpenHours = "",
      weeklyLabOpenMinutesStr = "";

  bool admin = false, labAcik = false;

  Divider divider = const Divider(
    height: 1,
    color: Colors.grey,
  );

  late LabOpen labOpen;

  late UserC currentUserC;

  LabState labState = LabState.idle;

  InLab? inLab;

  @override
  void initState() {
    super.initState();
    currentUser();
    labAcikMi();
    getCurrentUserInLab();
  }

  Future currentUser() async {
    currentUserC = Provider.of<UserModel>(context, listen: false).user!;
    if (currentUserC.admin!) {
      assignWeeklyHoursMinutes();
    }
    name = currentUserC.name!;
    surname = currentUserC.surname!;
    mail = currentUserC.mail!;
    admin = currentUserC.admin!;
    token = currentUserC.token!.toString();
  }

  assignWeeklyHoursMinutes() {
    List<String> hoursMinutes =
        calculateLabOpenHours(currentUserC.weeklyLabOpenMinutes!);
    weeklyLabOpenHours = hoursMinutes.elementAt(0);
    weeklyLabOpenMinutesStr = hoursMinutes.elementAt(1);
  }

  Future labAcikMi() async {
    labOpen = await Provider.of<UserModel>(context, listen: false).labAcikMi();
    labAcik = labOpen.acikMi!;
    getLabState();
  }

  getLabState() {
    if (admin) {
      if (labAcik) {
        if (currentUserC.username == labOpen.userName!) {
          labState = LabState.labAcikAyni;
        } else {
          labState = LabState.labAcikFarkli;
        }
      } else {
        labState = LabState.labKapali;
      }
    } else {
      labState = LabState.noAdmin;
    }
  }

  Future getCurrentUserInLab() async {
    InLab? inLabLocal = await Provider.of<UserModel>(context, listen: false)
        .getInLab(currentUserC.id!);
    setState(() {
      inLab = inLabLocal;
    });
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
                    height: 250,
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
                            Text(
                              "$token MvRG Token",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.red),
                            ),
                            if (admin)
                              Text(
                                "Bu hafta labtaydın: "
                                "$weeklyLabOpenHours saat "
                                "$weeklyLabOpenMinutesStr dakika",
                                style: const TextStyle(fontSize: 15),
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
                        Icons.event,
                        "Etkinliklerim",
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyEvents()))),
                    buildListTileWithIcon(
                        Icons.badge,
                        "Rozetlerim",
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyBadges()))),
                    buildListTileWithIcon(
                        Icons.currency_exchange,
                        "MvRG Token İşlemleri",
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const TokenTransferPage()))),
                    buildListTileWithIcon(
                        labAcik ? Icons.lock_open : Icons.lock,
                        "Metaverse Lab Açık Mı?",
                        labAcikMiSnackBar),
                    buildListTileWithIcon(
                        Icons.star,
                        "Labı Açanlar Listesi",
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LabOpenPage()))),
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
                      buildListTileWithIcon(
                          Icons.badge_outlined,
                          "Yeni Rozet Ekle",
                          () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CreateAndUpdateBadgePage()))),
                    if (admin)
                      buildListTileWithIcon(
                          labState == LabState.labAcikAyni
                              ? Icons.door_back_door
                              : labState == LabState.labAcikFarkli
                                  ? Icons.lock
                                  : Icons.door_back_door,
                          labAcik ? "Labı Kapat" : "Labı Aç",
                          labiAcDialog),
                    if (labState == LabState.labAcikFarkli)
                      buildListTileWithIcon(
                          inLab == null ? Icons.input : Icons.output,
                          inLab == null ? "Labdayım" : "Labdan ayrıldım",
                          iamInLabOrLeaving),
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

  Widget buildListTileWithIcon(
          IconData iconData, String title, void Function()? onTap) =>
      ListTile(
        leading: Icon(iconData),
        title: Text(title),
        onTap: onTap,
      );

  labAcikMiSnackBar() {
    String mesaj = "Metaverse Laboratuvarı ";
    if (labAcik) {
      mesaj += "Açık ✅";
    } else {
      mesaj += "Kapalı ❌";
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mesaj), duration: const Duration(seconds: 2)));
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

  labiAcDialog() {
    if (labState == LabState.labAcikAyni) {
      labiAcVeyaKapat("-1");
    } else if (labState == LabState.labAcikFarkli) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Labı açan kişi labı kapatabilir"),
          duration: Duration(seconds: 2)));
    } else {
      String selectedHour = "1";
      List<String> hours = List.generate(24, (index) => "${++index}");
      hours.add("Belirsiz");
      AwesomeDialog(
          context: context,
          dialogType: DialogType.NO_HEADER,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: true,
          body: Column(
            children: [
              const Text(
                "Labı Kaç Saat Açık Tutacaksın?",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              StatefulBuilder(
                  builder: (context, hourDropdownButtonState) => Container(
                        alignment: Alignment.center,
                        child: DropdownButton<String>(
                          focusColor: Colors.white,
                          value: selectedHour,
                          style: const TextStyle(color: Colors.white),
                          iconEnabledColor: Colors.black,
                          onChanged: (String? newValue) =>
                              hourDropdownButtonState(() {
                            selectedHour = newValue!;
                          }),
                          items: hours
                              .map<DropdownMenuItem<String>>(
                                  (String itemsValue) =>
                                      DropdownMenuItem<String>(
                                        value: itemsValue,
                                        child: Text(
                                          itemsValue,
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ))
                              .toList(),
                        ),
                      )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: const Text(
                      "Labı Aç",
                      style: TextStyle(fontSize: 18),
                    ),
                    style: TextButton.styleFrom(foregroundColor: Colors.green),
                    onPressed: () {
                      labiAcVeyaKapat(selectedHour);
                      Navigator.pop(context);
                    },
                  )
                ],
              )
            ],
          )).show();
    }
  }

  Future labiAcVeyaKapat(String hour) async {
    late bool resultAddLabOpen;
    try {
      DateTime now = DateTime.now();
      //Labı kapatırken
      if (hour == "-1") {
        AwesomeDialog(
          context: context,
          animType: AnimType.LEFTSLIDE,
          headerAnimationLoop: false,
          dialogType: DialogType.INFO,
          showCloseIcon: true,
          title: "Lab Kapatılıyor...",
          desc: "Lab kapatılırken lütfen bekleyiniz",
          btnOkOnPress: () {},
          btnOkText: "Tamam",
        ).show();

        updateUserWeeklyMinutes(now, labOpen.time!.toDate());

        await Provider.of<UserModel>(context, listen: false)
            .setOrUpdateLabOpenDuration(
                currentUserC.weeklyLabOpenMinutes!, now);
      }
      labOpen = await addLabOpen(now);
      resultAddLabOpen = labOpen.acikMi!;
    } catch (e) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              animType: AnimType.RIGHSLIDE,
              headerAnimationLoop: true,
              title: "Lab Güncellenirken Hata",
              desc: Exceptions.goster(e.toString()),
              btnOkOnPress: () {},
              btnOkText: "Tamam",
              btnOkColor: Colors.blue)
          .show();
    }
    bool resultSendMessageToMvRG = await sendMessageToMvRG(hour);
    if (resultSendMessageToMvRG) {
      if (hour == "-1") {
        Navigator.pop(context);
      }
      AwesomeDialog(
              context: context,
              dialogType: DialogType.SUCCES,
              animType: AnimType.RIGHSLIDE,
              headerAnimationLoop: true,
              title: resultAddLabOpen ? "Lab Açıldı ✔" : "Lab Kapandı ❌",
              btnOkOnPress: () {},
              btnOkText: "Tamam",
              btnOkColor: Colors.blue)
          .show();

      setState(() {
        labAcik = resultAddLabOpen;
      });
      getLabState();
    }
  }

  updateUserWeeklyLabOpenMinutes(DateTime closeTime, DateTime openTime) {
    currentUserC.weeklyLabOpenMinutes = currentUserC.weeklyLabOpenMinutes! +
        closeTime.difference(openTime).inMinutes;
  }

  updateUserWeeklyMinutes(DateTime closeTime, DateTime openTime) {
    updateUserWeeklyLabOpenMinutes(closeTime, openTime);
    assignWeeklyHoursMinutes();
  }

  Future<LabOpen> addLabOpen(DateTime now) async {
    try {
      return await Provider.of<UserModel>(context, listen: false)
          .addLabOpen(!labAcik, now);
    } catch (e) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              animType: AnimType.RIGHSLIDE,
              headerAnimationLoop: true,
              title: "Lab Sorumlusu Eklenirken HATA",
              desc: Exceptions.goster(e.toString()),
              btnOkOnPress: () {},
              btnOkText: "Tamam",
              btnOkColor: Colors.blue)
          .show();
      rethrow;
    }
  }

  Future<bool> sendMessageToMvRG(String hour) async {
    try {
      return await Provider.of<UserModel>(context, listen: false)
          .sendMessageToMvRG(!labAcik, hour);
    } catch (e) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              animType: AnimType.RIGHSLIDE,
              headerAnimationLoop: true,
              title: "MvRG Discord'a Mesaj Gönderirken HATA",
              desc: Exceptions.goster(e.toString()),
              btnOkOnPress: () {},
              btnOkText: "Tamam",
              btnOkColor: Colors.blue)
          .show();
      return false;
    }
  }

  Future iamInLabOrLeaving() async {
    if (inLab == null) {
      try {
        inLab =
            InLab(userId: currentUserC.id!, username: currentUserC.username);
        bool result = await Provider.of<UserModel>(context, listen: false)
            .setInLab(inLab!);
        if (result) {
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.SUCCES,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: true,
                  title: "İşlem Tamamlandı ✔✔",
                  desc:
                      "Labda olanlar listesine başarılı bir şekilde eklendiniz ",
                  btnOkOnPress: () {},
                  btnOkText: "Tamam",
                  btnOkColor: Colors.blue)
              .show();
          setState(() {});
        }
      } catch (e) {
        showErrorAwesomeDialog("Lab Listesine Eklenirken Hata", e);
      }
    } else {
      try {
        DateTime now = DateTime.now(),
            arrivalTime = inLab!.arrivalTime!.toDate();
        int inLabDuration = (now.difference(arrivalTime)).inMinutes;
        await updateUserWeeklyMinutes(now, arrivalTime);

        bool result = await Provider.of<UserModel>(context, listen: false)
            .updateLabOpenDurationAndDeleteInLab(inLabDuration);
        if (result) {
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.SUCCES,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: true,
                  title: "İşlem Tamamlandı ✔✔",
                  desc: "Labdan başarılı bir şekilde ayrıldınız",
                  btnOkOnPress: () {},
                  btnOkText: "Tamam",
                  btnOkColor: Colors.blue)
              .show();

          setState(() {
            inLab = null;
          });
        }
      } catch (e) {
        showErrorAwesomeDialog("Labdan Ayrılırken Hata", e);
      }
    }
  }

  showErrorAwesomeDialog(String title, Object error) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.RIGHSLIDE,
            headerAnimationLoop: true,
            title: title,
            desc: Exceptions.goster(error.toString()),
            btnOkOnPress: () {},
            btnOkText: "Tamam",
            btnOkColor: Colors.blue)
        .show();
  }

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
