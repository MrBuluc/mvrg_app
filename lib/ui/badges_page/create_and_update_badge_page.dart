import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvrg_app/common_widget/badge_image.dart';
import 'package:mvrg_app/common_widget/image_file.dart';
import 'package:mvrg_app/common_widget/rank_dropown_button.dart';
import 'package:mvrg_app/common_widget/text_form_fieldC.dart';
import 'package:mvrg_app/model/badges/badge.dart';
import 'package:mvrg_app/model/userC.dart';
import 'package:mvrg_app/services/validator.dart';
import 'package:mvrg_app/ui/const.dart';
import 'package:mvrg_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

import '../../app/exceptions.dart';
import '../../model/badges/badgeHolder.dart';

class CreateAndUpdateBadgePage extends StatefulWidget {
  final Badge? badge;
  const CreateAndUpdateBadgePage({Key? key, this.badge}) : super(key: key);

  @override
  State<CreateAndUpdateBadgePage> createState() =>
      _CreateAndUpdateBadgePageState();
}

class _CreateAndUpdateBadgePageState extends State<CreateAndUpdateBadgePage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late Size size;

  List<String> badgeNames = [];
  List<UserC> users = [];

  TextEditingController nameCnt = TextEditingController();
  TextEditingController infoCnt = TextEditingController();
  TextEditingController imageUrlCnt = TextEditingController();

  File? image;

  bool badgeInProgress = false, imageUrlEnable = true;

  Badge? badge;

  String? chosenUserId;
  String chosenRank = "0";

  @override
  void initState() {
    super.initState();
    getBadgeNames();
    badge = widget.badge;
    if (badge != null) {
      prepareCnts();
      getUserNames();
      chosenUserId = "-1";
    }
  }

  void prepareCnts() {
    nameCnt.text = badge!.name!;
    infoCnt.text = badge!.info!;
    imageUrlCnt.text = badge!.imageUrl!;
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
              data: ThemeData(primaryColor: newBadgeAndEventColor),
              child: buildHeaderandTextForm()),
          buildBack()
        ],
      ),
    );
  }

  Future getBadgeNames() async {
    badgeNames =
        await Provider.of<UserModel>(context, listen: false).getBadgeNames();
    if (badge != null) {
      badgeNames.remove(badge!.name);
    }
  }

  Future getUserNames() async {
    users = await Provider.of<UserModel>(context, listen: false).getUsers();
    setState(() {
      users.add(UserC(id: "-1", name: "Seçilmedi", surname: ""));
    });
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
                color: newBadgeAndEventColor,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Padding(
              padding: EdgeInsets.only(
                  left: size.width * .1, bottom: size.width * .1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    badge == null ? "Yeni Rozet Oluştur" : "Rozet Güncelle",
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
              height: size.height * .64,
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
                        top: size.width * .05, right: 30, left: 30),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormFieldC(
                                styleColor: Colors.grey,
                                controller: nameCnt,
                                iconData: Icons.verified_outlined,
                                hintText: "Rozet Adı",
                                validator: (String? value) =>
                                    Validator.listContainsControl(
                                        value,
                                        badgeNames,
                                        "Bu rozet bulunmaktadır",
                                        "Bir rozet adı belirtmelisiniz")),
                            SizedBox(
                              height: size.height * .03,
                            ),
                            TextFormFieldC(
                                styleColor: Colors.grey,
                                controller: infoCnt,
                                iconData: Icons.info_outline,
                                hintText: "Rozetin Infosu",
                                validator: (String? value) =>
                                    Validator.emptyControl(value,
                                        "Rozetin Infosunu belirtmelisiniz")),
                            SizedBox(
                              height: size.height * .03,
                            ),
                            TextFormFieldC(
                                styleColor: Colors.grey,
                                controller: imageUrlCnt,
                                iconData: Icons.link,
                                hintText: "Rozetin Resim Linki",
                                validator: urlControl,
                                enable: imageUrlEnable),
                            SizedBox(
                              height: size.height * .03,
                            ),
                            if (badge != null)
                              buildHoldersRow("Rozete atanacak kişi:", true),
                            if (badge != null)
                              buildHoldersRow("Kişinin seviyesi:", false),
                            ImageFile(
                                child: buildImage(), onTap: galeriResimUpload)
                          ],
                        ),
                        if (image != null)
                          GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: size.width * .491,
                                  top: badge != null
                                      ? size.height * .436
                                      : size.height * .281),
                              child: const Icon(
                                Icons.clear,
                                color: Colors.red,
                                size: 28,
                              ),
                            ),
                            onTap: () {
                              removeImage();
                            },
                          ),
                      ],
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }

  String? urlControl(String? value) {
    if (value != null && value.isNotEmpty) {
      RegExp regex = RegExp("(http(s?):)([/|.|\\w|\\s|%|-])*\\.(?:jpg|png)");
      if (!regex.hasMatch(value)) {
        return "Sonu .jpg veya .png ile biten bir url belirtmelisiniz";
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Widget buildHoldersRow(String text, bool isUserName) {
    return Padding(
      padding: EdgeInsets.only(bottom: isUserName ? 0 : size.height * .015),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text),
          if (isUserName) buildDropdownButton(),
          if (!isUserName)
            RankDropdownButton(
                value: chosenRank,
                onChanged: (String? value) => setState(() {
                      chosenRank = value!;
                    }))
        ],
      ),
    );
  }

  Widget buildDropdownButton() {
    return Container(
      alignment: Alignment.center,
      child: DropdownButton<String>(
        focusColor: Colors.white,
        value: chosenUserId,
        style: const TextStyle(color: Colors.white),
        iconEnabledColor: Colors.black,
        onChanged: (String? value) => setState(() {
          chosenUserId = value;
        }),
        items: users
            .map<DropdownMenuItem<String>>(
                (UserC userC) => DropdownMenuItem<String>(
                      value: userC.id,
                      child: Text(
                        userC.name! + " " + userC.surname!,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ))
            .toList(),
      ),
    );
  }

  Widget buildImage() {
    if (image == null) {
      if (badge == null) {
        return Text(
          "Resim Yok",
          style: TextStyle(
              color: Colors.grey.shade600, fontWeight: FontWeight.bold),
        );
      } else {
        return BadgeImage(
          badge: badge!,
        );
      }
    } else {
      return Image.file(image!);
    }
  }

  Future galeriResimUpload() async {
    try {
      XFile? pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      setState(() {
        image = File(pickedFile!.path);
        imageUrlEnable = false;
      });

      imageUrlCnt.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Resim Seçilmedi 😕"),
        duration: Duration(seconds: 2),
      ));
    }
  }

  removeImage() {
    setState(() {
      image = null;
      imageUrlEnable = true;
    });
  }

  Widget buildBack() {
    return Padding(
      padding: EdgeInsets.only(left: size.width * .1, top: size.width * .08),
      child: Row(
        children: [
          GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              color: newBadgeAndEventColor,
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
                  color: newBadgeAndEventColor,
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
                createAndUpdateBadge();
              }
            },
          )
        ],
      ),
    );
  }

  Future createAndUpdateBadge() async {
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
          if (image != null) {
            imageUrl =
                await userModel.uploadFile("Badges", image!, nameCnt.text);
          } else {
            imageUrl = imageUrlCnt.text;
            bool response = await checkImageUrl(imageUrl);
            if (!response) {
              setState(() {
                badgeInProgress = false;
              });
              return;
            }
          }

          late bool result;
          Badge newBadge =
              Badge(imageUrl: imageUrl, name: nameCnt.text, info: infoCnt.text);
          if (badge == null) {
            result = await userModel.setBadge(newBadge);
          } else {
            newBadge.id = badge!.id;
            if (chosenUserId != "-1") {
              await userModel.addBadgeHolder(BadgeHolder(
                  badgeId: newBadge.id!,
                  userId: chosenUserId,
                  rank: int.parse(chosenRank)));
            }
            result = await userModel.updateBadge(newBadge);
          }

          if (result) {
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.SUCCES,
                    animType: AnimType.RIGHSLIDE,
                    headerAnimationLoop: true,
                    title: badge == null
                        ? 'Yeni Rozet Oluşturuldu 👍'
                        : "Rozet Güncellendi 👍",
                    desc: badge == null
                        ? 'Yeni rozet başarılı bir şekilde oluşturuldu'
                        : "Rozet başarılı bir şekilde güncellendi",
                    btnOkOnPress: () {},
                    btnOkText: "Tamam",
                    btnOkColor: Colors.blue)
                .show();

            setState(() {
              badgeInProgress = false;
            });
          }
        } catch (e) {
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.WARNING,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: true,
                  title: badge == null
                      ? 'Rozet Ekleme HATA'
                      : "Rozet Güncelleme HATA",
                  desc: Exceptions.goster(e.toString()),
                  btnOkOnPress: () {},
                  btnOkText: "Tamam",
                  btnOkColor: Colors.blue)
              .show();
          setState(() {
            badgeInProgress = false;
          });
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

  Future<bool> checkImageUrl(String url) async {
    bool response =
        await Provider.of<UserModel>(context, listen: false).checkResponse(url);
    if (!response) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.WARNING,
              animType: AnimType.RIGHSLIDE,
              headerAnimationLoop: true,
              title: 'Rozet Ekleme HATA',
              desc:
                  "Girdiğiniz resim linki geçerli değil. Lütfen geçerli bir resim "
                  "linki giriniz.",
              btnOkOnPress: () {},
              btnOkText: "Tamam",
              btnOkColor: Colors.blue)
          .show();
    }
    return response;
  }
}
