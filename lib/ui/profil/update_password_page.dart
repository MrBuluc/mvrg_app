import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mvrg_app/common_widget/header/header.dart';
import 'package:mvrg_app/services/validator.dart';
import 'package:mvrg_app/ui/const.dart';
import 'package:mvrg_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

import '../../app/exceptions.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({Key? key}) : super(key: key);

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController oldPassCnt = TextEditingController();
  TextEditingController newPassCnt = TextEditingController();
  TextEditingController newPassAgainCnt = TextEditingController();

  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: [buildHeaderAndTextForm(), buildBack()],
      ),
    );
  }

  Widget buildHeaderAndTextForm() {
    return SizedBox(
      height: size.height * 0.8,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Header(
              containerColor: Color.fromRGBO(57, 28, 178, 1),
              text: "Şifremi\nGüncelle"),
          Positioned(
            top: size.height * 0.26,
            right: size.width * 0.1,
            left: size.width * 0.1,
            child: Container(
              height: size.height * .55,
              width: size.width * .6,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3))
                  ]),
              child: Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: size.width * .15, right: 30, left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTextFormField(
                          "Eski Şifren", Icons.lock_open, oldPassCnt),
                      const SizedBox(
                        height: 30,
                      ),
                      buildTextFormField("Yeni Şifre", Icons.lock, newPassCnt),
                      const SizedBox(
                        height: 30,
                      ),
                      buildTextFormField(
                          "Yeni Şifre Tekrar", Icons.lock, newPassAgainCnt)
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildTextFormField(
      String hintText, IconData iconData, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      style: TextStyle(color: Colors.indigo.shade200),
      decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(
            iconData,
            color: Colors.indigo.shade200,
          ),
          hintStyle: TextStyle(
              fontFamily: "Catamaran",
              fontWeight: FontWeight.bold,
              color: Colors.indigo.shade200,
              fontSize: 17)),
      validator: Validator.passwordControl,
    );
  }

  Widget buildBack() {
    return Padding(
      padding: EdgeInsets.only(left: size.width * .1, top: size.width * .08),
      child: Row(
        children: [
          GestureDetector(
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.indigo,
              size: 30,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          GestureDetector(
            child: const Text(
              "Geri",
              style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(
            width: size.width * .4,
          ),
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: butonBorder, gradient: indigoButton),
              height: size.height * .1,
              width: size.width * .2,
              child: const Icon(
                Icons.save,
                color: Colors.white,
                size: 50,
              ),
            ),
            onTap: () {
              updatePassword(context);
            },
          )
        ],
      ),
    );
  }

  Future updatePassword(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      if (newPassCnt.text == newPassAgainCnt.text) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Şifreniz Güncelleniyor..."),
          duration: Duration(seconds: 3),
        ));

        try {
          bool sonuc = await Provider.of<UserModel>(context, listen: false)
              .updatePassword(oldPassCnt.text, newPassCnt.text);
          if (sonuc) {
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.SUCCES,
                    animType: AnimType.RIGHSLIDE,
                    headerAnimationLoop: true,
                    title: 'Şifreniz Güncellendi 👍',
                    desc: 'Şifreniz başarılı bir şekilde güncellendi',
                    btnOkOnPress: () {},
                    btnOkText: "Tamam",
                    btnOkColor: Colors.blue)
                .show();
          } else {
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.WARNING,
                    animType: AnimType.RIGHSLIDE,
                    headerAnimationLoop: true,
                    title: 'Şifreniz Güncellenemedi 😕',
                    desc: 'Şifreniz güncellenirken bir sorun oluştu.\n' +
                        'Lütfen internet bağlantınızı kontrol edin.',
                    btnOkOnPress: () {},
                    btnOkText: "Tamam",
                    btnOkColor: Colors.blue)
                .show();
          }
        } catch (e) {
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.WARNING,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: true,
                  title: 'Şifre Güncelleme HATA',
                  desc: Exceptions.goster(e.toString()),
                  btnOkOnPress: () {},
                  btnOkText: "Tamam",
                  btnOkColor: Colors.blue)
              .show();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Yeni Şifreler Uyuşmuyor"),
          duration: Duration(seconds: 3),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Lütfen İstenilen Değerleri Doğru Giriniz..."),
        backgroundColor: colorTwo,
        duration: const Duration(seconds: 3),
      ));
    }
  }
}
