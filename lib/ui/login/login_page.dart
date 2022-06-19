import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mvrg_app/app/exceptions.dart';
import 'package:mvrg_app/services/validator.dart';
import 'package:mvrg_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

import '../const.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late Size size;

  String? mail, password;

  late UserModel userModel;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    userModel = Provider.of<UserModel>(context, listen: false);
    return Container(
      decoration: BoxDecoration(gradient: loginPageBg),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildHeader(),
                Theme(
                    data: ThemeData(primaryColor: Colors.indigo.shade200),
                    child: buildFormField(context))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: SizedBox(
        height: size.height * 0.29,
        width: size.width * 0.86,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Center(
              child: Text(
                "MvRG App",
                style: headerText,
              ),
            ),
            Text(
              "Devam etmek için giriş yapın",
              style: miniHeader,
            )
          ],
        ),
      ),
    );
  }

  Widget buildFormField(BuildContext context) {
    return Container(
      height: size.height * 0.45,
      width: size.width * 0.86,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 30, left: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                style: TextStyle(color: Colors.indigo.shade200),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.mail,
                    color: Colors.indigo.shade200,
                  ),
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade200,
                      fontSize: 17),
                  hintText: "E-posta Adresi",
                ),
                validator: Validator.emailControl,
                onSaved: (String? value) => mail = value,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: true,
                style: TextStyle(color: Colors.indigo.shade200),
                decoration: InputDecoration(
                    hintText: "Şifre",
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.indigo.shade200,
                    ),
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade200,
                        fontSize: 17)),
                validator: Validator.passwordControl,
                onSaved: (String? value) => password = value,
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: Text(
                      "Şifreni mi unuttun?",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade200),
                    ),
                    onTap: () {
                      _forgetPassword(context);
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      height: size.height * 0.07,
                      width: size.width * 0.2,
                      decoration: BoxDecoration(
                          gradient: indigoButton,
                          borderRadius: BorderRadius.circular(5)),
                      child: const Icon(
                        Icons.forward,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {},
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _forgetPassword(BuildContext context) async {
    formKey.currentState!.save();
    String? sonuc = Validator.emailControl(mail);
    if (sonuc == "Geçersiz email") {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.WARNING,
              headerAnimationLoop: false,
              animType: AnimType.TOPSLIDE,
              showCloseIcon: true,
              closeIcon: const Icon(Icons.close_fullscreen_outlined),
              title: 'E-posta Adresini Kontrol Et',
              desc:
                  'E-posta alanını boş bırakamazsın ve doğru formatta e-posta '
                  'girmen gerekiyor',
              btnOkOnPress: () {})
          .show();
    } else {
      try {
        bool sonuc1 = await userModel.sendPasswordResetEmail(mail!);
        if (sonuc1) {
          AwesomeDialog(
            context: context,
            animType: AnimType.LEFTSLIDE,
            headerAnimationLoop: false,
            dialogType: DialogType.SUCCES,
            showCloseIcon: true,
            title: 'E posta Kutunu Kontrol Et',
            desc: 'Şifreni sıfırlamak için ihtiyacın olan bağlantı linki $mail '
                'adresine gönderildi',
            btnOkOnPress: () {},
            btnOkIcon: Icons.check_circle,
          ).show();
        } else {
          AwesomeDialog(
            context: context,
            animType: AnimType.LEFTSLIDE,
            headerAnimationLoop: false,
            dialogType: DialogType.WARNING,
            showCloseIcon: true,
            title: 'Şifre Sıfırlama Mailı Gönderilemedi 😕',
            desc: 'Şifre sıfırlama mailı gönderilirken bir sorun oluştu.\n'
                'İnternet bağlantınızı kontrol edin',
            btnOkOnPress: () {},
            btnOkText: "Tamam",
            btnOkIcon: Icons.check_circle,
          ).show();
        }
      } catch (e) {
        AwesomeDialog(
          context: context,
          animType: AnimType.LEFTSLIDE,
          headerAnimationLoop: false,
          dialogType: DialogType.WARNING,
          showCloseIcon: true,
          title: 'Şifre Sıfırlama Maili HATA',
          desc: Exceptions.goster(e.toString()),
          btnOkOnPress: () {},
          btnOkText: "Tamam",
          btnOkIcon: Icons.check_circle,
        ).show();
      }
    }
  }
}
