import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mvrg_app/model/userC.dart';
import 'package:mvrg_app/services/validator.dart';
import 'package:mvrg_app/ui/const.dart';
import 'package:mvrg_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

import '../../app/exceptions.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({Key? key}) : super(key: key);

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameCnt = TextEditingController();
  TextEditingController surnameCnt = TextEditingController();
  TextEditingController mailCnt = TextEditingController();

  bool changed = false;

  UserC? userC;

  @override
  void initState() {
    super.initState();
    currentUser();
  }

  @override
  void dispose() {
    nameCnt.dispose();
    surnameCnt.dispose();
    mailCnt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: gradient,
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: gradient,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(left: 15, bottom: 15),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Kullanıcı Bilgilerimi Güncelle",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    )),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        buildTextFormField(
                          nameCnt,
                          "Ad",
                          Icons.perm_identity,
                          Validator.nameControl,
                          top: 15,
                        ),
                        buildTextFormField(surnameCnt, "Soyad",
                            Icons.perm_identity, Validator.surnameControl),
                        buildTextFormField(mailCnt, "E-mail", Icons.email,
                            Validator.emailControl,
                            keyboardType: TextInputType.emailAddress),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: OutlinedButton(
                            child: const Text(
                              "Kaydet",
                              style: TextStyle(
                                  color: Color.fromRGBO(172, 182, 229, 1),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () =>
                                changed ? showPasswordDialog(context) : null,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void currentUser() {
    userC = Provider.of<UserModel>(context, listen: false).user;
    setState(() {
      nameCnt.text = userC!.name!;
      surnameCnt.text = userC!.surname!;
      mailCnt.text = userC!.mail!;
    });
  }

  Widget buildTextFormField(TextEditingController controller, String labelText,
      IconData icon, String? Function(String?)? validator,
      {double top = 0, TextInputType? keyboardType}) {
    return Container(
      padding: EdgeInsets.only(top: top, left: 15, right: 30),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            labelText: labelText,
            prefixIcon: Icon(
              icon,
              size: 22,
            )),
        validator: validator,
        onChanged: (String value) => changed = true,
      ),
    );
  }

  showPasswordDialog(BuildContext context) {
    String oldMail = userC!.mail!;
    if (oldMail != mailCnt.text) {
      if (userC!.password == null) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context1) {
              return SimpleDialog(
                title: const Text("Email Güncellemek İçin Şifrenizi Giriniz"),
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 10, 10, 0),
                        child: TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.vpn_key,
                                size: 22,
                              ),
                              labelText: "Şifre"),
                          validator: Validator.passwordControl,
                          onFieldSubmitted: (String? value) {
                            Navigator.pop(context);
                            save(context, password: value!);
                          },
                        ),
                      )
                    ],
                  )
                ],
              );
            });
      } else {
        save(context, password: userC!.password!);
      }
    } else {
      save(context);
    }
  }

  Future save(BuildContext context, {String password = ""}) async {
    if (formKey.currentState!.validate()) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.INFO,
              animType: AnimType.RIGHSLIDE,
              headerAnimationLoop: true,
              title: 'Kullanıcı Bilgileri Güncelleniyor...',
              desc: 'Kullanıcı bilgileri güncellenirken lütfen bekleyiniz',
              btnOkOnPress: () {},
              btnOkText: "Tamam",
              btnOkColor: Colors.blue)
          .show();

      try {
        bool sonuc = await Provider.of<UserModel>(context, listen: false)
            .updateUserAuth(userC!.id!, nameCnt.text, surnameCnt.text,
                mailCnt.text, password, userC!.admin!);
        if (sonuc) {
          Navigator.pop(context);
          AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Güncelleme Başarıyla Gerçekleştirildi 👍',
            desc: 'MvRG App\'ı tercih ettiğiniz için teşekkür ederiz 🤟',
            btnOkText: "Tamam",
            btnOkColor: Colors.blue,
            btnOkOnPress: () {},
          ).show();
        } else {
          Navigator.pop(context);
          AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Kullanıcı Güncellenirken HATA 😕',
            desc: 'Kullanıcı güncellenirken bir sorun oluştu. \n' +
                'Lütfen internet bağlantınızı kontrol edin',
            btnOkText: "Tamam",
            btnOkColor: Colors.blue,
            btnOkOnPress: () {},
          ).show();
        }
      } catch (e) {
        Navigator.pop(context);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.WARNING,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Kullanıcı Güncelleme HATA 😕',
          desc: Exceptions.goster(e.toString()),
          btnOkText: "Tamam",
          btnOkColor: Colors.blue,
          btnOkOnPress: () {},
        ).show();
      }
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.WARNING,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Değerleri Doğru Giriniz',
        desc: 'Lütfen istenilen değerleri tam ve doğru giriniz',
        btnOkText: "Tamam",
        btnOkColor: Colors.blue,
        btnOkOnPress: () {},
      ).show();
    }
  }
}
