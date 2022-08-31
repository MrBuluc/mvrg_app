import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvrg_app/model/badge.dart';
import 'package:mvrg_app/ui/const.dart';
import 'package:mvrg_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

import '../../app/exceptions.dart';

class CreateBadgePage extends StatefulWidget {
  const CreateBadgePage({Key? key}) : super(key: key);

  @override
  State<CreateBadgePage> createState() => _CreateBadgePageState();
}

class _CreateBadgePageState extends State<CreateBadgePage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late Size size;

  List<String> names = [];

  TextEditingController nameCnt = TextEditingController();
  TextEditingController infoCnt = TextEditingController();
  TextEditingController imageUrlCnt = TextEditingController();

  File? image;

  bool badgeInProgress = false;

  @override
  void initState() {
    super.initState();
    getBadgeNames();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Theme(
              data: ThemeData(primaryColor: newBadgeColor),
              child: buildHeaderandTextForm()),
          buildBack()
        ],
      ),
    );
  }

  Future getBadgeNames() async {
    names =
        await Provider.of<UserModel>(context, listen: false).getBadgeNames();
  }

  Widget buildHeaderandTextForm() {
    return SizedBox(
      height: size.height * .8,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size.width,
            height: size.height * .3,
            decoration: BoxDecoration(
                color: newBadgeColor,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Padding(
              padding: EdgeInsets.only(
                  left: size.width * .1, bottom: size.width * .1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Yeni Rozet Oluştur",
                    style: headerText,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: size.height * .23,
            right: size.width * .1,
            left: size.width * .1,
            child: Container(
              height: size.height * .7,
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
                      top: size.width * .1, right: 30, left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTextFormField(Colors.grey, nameCnt,
                          Icons.verified_outlined, "Rozet Adı", nameControl),
                      SizedBox(
                        height: size.height * .03,
                      ),
                      buildTextFormField(Colors.indigo.shade200, infoCnt,
                          Icons.info_outline, "Rozetin Infosu", infoControl),
                      SizedBox(
                        height: size.height * .03,
                      ),
                      buildTextFormField(Colors.indigo.shade200, imageUrlCnt,
                          Icons.link, "Rozetin Resim Linki", urlControl),
                      SizedBox(
                        height: size.height * .03,
                      ),
                      Center(
                        child: Container(
                          height: size.height * .15,
                          width: size.width * .4,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: newBadgeColor)),
                          child: GestureDetector(
                            child: Center(
                              child: image == null
                                  ? Text(
                                      "Resim Yok",
                                      style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Image.file(image!),
                            ),
                            onTap: galeriResimUpload,
                          ),
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
    );
  }

  Widget buildTextFormField(
      Color styleColor,
      TextEditingController controller,
      IconData iconData,
      String hintText,
      String? Function(String?)? validator) {
    return TextFormField(
      style: TextStyle(color: styleColor),
      controller: controller,
      decoration: InputDecoration(
          prefixIcon: Icon(
            iconData,
            color: newBadgeColor,
          ),
          hintStyle: const TextStyle(
              fontFamily: "Catamaran",
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 17),
          hintText: hintText),
      validator: validator,
    );
  }

  String? nameControl(String? value) {
    if (names.contains(value)) {
      return "Bu rozet bulunmaktadır";
    } else if (value!.isEmpty) {
      return "Bir rozet adı belirtmelisiniz";
    } else {
      return null;
    }
  }

  String? infoControl(String? value) {
    if (value!.isEmpty) {
      return "Rozetin Infosunu belirtmelisiniz";
    }
    return null;
  }

  String? urlControl(String? value) {
    if (value != null && value.isNotEmpty) {
      RegExp regex = RegExp("(http(s?):)([/|.|\\w|\\s|%|-])*\\.(?:jpg|png)");
      if (!regex.hasMatch(value)) {
        return "Sonu .jpg veya .png ile biten geçerli bir url belirtmelisiniz";
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future galeriResimUpload() async {
    try {
      XFile? pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      setState(() {
        image = File(pickedFile!.path);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Resim Seçilmedi 😕"),
        duration: Duration(seconds: 2),
      ));
    }
  }

  Widget buildBack() {
    return Padding(
      padding: EdgeInsets.only(left: size.width * .1, top: size.width * .08),
      child: Row(
        children: [
          GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              color: newBadgeColor,
              size: 30,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          GestureDetector(
            child: Text(
              "Geri",
              style: TextStyle(
                  color: newBadgeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(
            height: size.height * .15,
            width: size.width * .45,
          ),
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: butonBorder,
                  gradient: const LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.bottomRight,
                      stops: [
                        .1,
                        .8
                      ],
                      colors: [
                        Color.fromRGBO(30, 227, 167, 1),
                        Color.fromRGBO(220, 247, 239, 1)
                      ])),
              height: size.height * .08,
              width: size.width * .15,
              child: Icon(
                badgeInProgress ? Icons.lock : Icons.save,
                color: Colors.white,
                size: 40,
              ),
            ),
            onTap: () {
              if (!badgeInProgress) {
                createBadge();
              }
            },
          )
        ],
      ),
    );
  }

  Future createBadge() async {
    setState(() {
      badgeInProgress = true;
    });

    if (image == null && imageUrlCnt.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "Lütfen rozet için bir resim seçiniz veya resim linki giriniz!!!"),
        duration: Duration(seconds: 2),
      ));

      setState(() {
        badgeInProgress = false;
      });
    } else {
      if (formKey.currentState!.validate()) {
        UserModel userModel = Provider.of<UserModel>(context, listen: false);

        try {
          late String imageUrl;
          if (imageUrlCnt.text.isEmpty) {
            imageUrl =
                await userModel.uploadFile("Badges", image!, nameCnt.text);
          } else {
            imageUrl = imageUrlCnt.text;
          }

          bool sonuc = await userModel.setBadge(Badge(
              imageUrl: imageUrl,
              name: nameCnt.text,
              info: infoCnt.text,
              holders: []));

          if (sonuc) {
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.SUCCES,
                    animType: AnimType.RIGHSLIDE,
                    headerAnimationLoop: true,
                    title: 'Yeni Rozet Oluşturuldu 👍',
                    desc: 'Yeni rozet başarılı bir şekilde oluşturuldu',
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Lütfen İstenilen Değerleri Doğru Giriniz..."),
          backgroundColor: colorTwo,
          duration: const Duration(seconds: 3),
        ));
        setState(() {
          badgeInProgress = false;
        });
      }
    }
  }
}
