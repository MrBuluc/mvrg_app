import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mvrg_app/services/validator.dart';
import 'package:mvrg_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

import '../../app/exceptions.dart';
import '../../model/userC.dart';
import '../const.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late Size size;

  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(gradient: registerpageBg),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildHeader(),
                Theme(
                    data: ThemeData(primaryColor: textFieldPrimaryColor),
                    child: buildTextField(context)),
                buildBackButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return SizedBox(
      height: size.height * 0.25,
      width: size.width * 0.85,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Hesap\nOluştur",
            style: headerText,
          )
        ],
      ),
    );
  }

  Widget buildTextField(BuildContext context) {
    return Container(
      height: size.height * 0.6,
      width: size.width * 0.85,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                offset: const Offset(1, 2),
                blurRadius: 4,
                color: Colors.grey.shade600)
          ]),
      child: Form(
        key: formKey,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 15, right: 30, left: 30, bottom: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              getTextFormField(Icons.mail, "E-posta Adresi", mailController,
                  Validator.emailControl),
              getTextFormField(Icons.person, "Adınız", nameController,
                  Validator.nameControl),
              getTextFormField(Icons.person, "Soyadınız", surnameController,
                  Validator.surnameControl),
              getTextFormField(Icons.lock, "Şifre", passwordController,
                  Validator.passwordControl,
                  obscureText: true),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                          gradient: orangeButton,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      _generateNewUser(context);
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getTextFormField(IconData icon, String hintText,
      TextEditingController controller, String? Function(String?)? validator,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.grey.shade400),
      decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.yellow.shade500,
            size: 30,
          ),
          hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade400,
              fontSize: 17),
          hintText: hintText),
      validator: validator,
    );
  }

  Widget buildBackButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: size.width * 0.1, top: size.width * 0.1),
      child: Row(
        children: [
          GestureDetector(
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
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
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  Future _generateNewUser(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.INFO,
        showCloseIcon: true,
        title: "Üye Kayıt Ediliyor...",
        desc: "Üye kayıt edilirken lütfen bekleyiniz",
        btnOkOnPress: () {},
        btnOkText: "Tamam",
      ).show();

      UserModel userModel = Provider.of<UserModel>(context, listen: false);
      try {
        UserC? userC = await userModel.createUserWithEmailandPassword(
            nameController.text,
            surnameController.text,
            mailController.text,
            passwordController.text);
        if (userC != null) {
          Navigator.pop(context);
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.SUCCES,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: true,
                  title: "Kaydınız Başarıyla Gerçekleştirildi 👍",
                  desc:
                      "Giriş ekranına dönerek e-posta adresiniz ve şifreniz ile "
                      "giriş yapabilirsiniz",
                  btnOkOnPress: () {
                    Navigator.pop(context);
                  },
                  btnOkText: "Tamam",
                  btnOkColor: Colors.green)
              .show();
        } else {
          Navigator.pop(context);
          AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            animType: AnimType.LEFTSLIDE,
            headerAnimationLoop: false,
            showCloseIcon: true,
            title: "Üye Kayıt Edilirken HATA 😕",
            desc: "Üye kayıt edilirken bir sorun oluştu.\n"
                "Lütfen internet bağlantınızı kontrol edin",
            btnOkOnPress: () {},
            btnOkText: "Tamam",
          ).show();
        }
      } on FirebaseAuthException {
        Navigator.pop(context);
        AwesomeDialog(
                context: context,
                dialogType: DialogType.WARNING,
                animType: AnimType.RIGHSLIDE,
                headerAnimationLoop: true,
                title: "Bu hesap kullanımda",
                desc: "Bu e-posta ile ilişkili bir hesap bulunmaktadır",
                btnOkOnPress: () {},
                btnOkText: "Tamam",
                btnOkIcon: Icons.cancel,
                btnOkColor: Colors.red)
            .show();
      } catch (e) {
        Navigator.pop(context);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.WARNING,
          animType: AnimType.LEFTSLIDE,
          headerAnimationLoop: false,
          showCloseIcon: true,
          title: "",
          desc: Exceptions.goster(e.toString()),
          btnOkOnPress: () {},
          btnOkText: "Tamam",
        ).show();
      }
    } else {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              animType: AnimType.RIGHSLIDE,
              headerAnimationLoop: true,
              title: "Değerleri Doğru Giriniz",
              desc: "Lütfen istenilen değerleri tam ve doğru giriniz",
              btnOkOnPress: () {},
              btnOkText: "Tamam",
              btnOkColor: Colors.blue)
          .show();
    }
  }
}
