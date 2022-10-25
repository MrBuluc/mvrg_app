import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvrg_app/common_widget/back_and_save.dart';
import 'package:mvrg_app/common_widget/form/form_c.dart';
import 'package:mvrg_app/common_widget/header/header.dart';
import 'package:mvrg_app/common_widget/image_file.dart';
import 'package:mvrg_app/common_widget/text_form_fieldC.dart';
import 'package:mvrg_app/services/validator.dart';
import 'package:mvrg_app/ui/const.dart';
import 'package:mvrg_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../app/exceptions.dart';
import '../../model/events/event.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({Key? key}) : super(key: key);

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  late Size size;

  List<String> titlesList = [];

  TextEditingController titleCnt = TextEditingController();
  TextEditingController locationCnt = TextEditingController();
  TextEditingController priceCnt = TextEditingController();

  bool award = false, isProgress = false;

  File? image;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getEventTitles();
  }

  Future getEventTitles() async {
    titlesList =
        await Provider.of<UserModel>(context, listen: false).getEventsTitles();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          buildHeaderAndTextForms(),
          BackAndSave(isProgress: isProgress, onTap: createEvent)
        ],
      ),
    );
  }

  Widget buildHeaderAndTextForms() => SizedBox(
        height: size.height * .8,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Header(
              containerColor: newBadgeAndEventColor,
              text: "Yeni Etkinlik Oluştur",
              columnBottomPadding: size.width * .1,
            ),
            FormC(
                top: size.height * .23,
                height: size.height * .7,
                width: size.width * .6,
                formKey: formKey,
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: size.width * .1, right: 25, left: 30),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormFieldC(
                              styleColor: Colors.grey,
                              controller: titleCnt,
                              iconData: Icons.title,
                              hintText: "Etkinlik Adı",
                              validator: (String? value) =>
                                  Validator.listContainsControl(
                                      value,
                                      titlesList,
                                      "Bu isimde bir etkinlik bulunmaktadır",
                                      "Bir etkinlik adı belirtmelisiniz")),
                          SizedBox(height: size.height * .03),
                          TextFormFieldC(
                              styleColor: Colors.grey,
                              controller: locationCnt,
                              iconData: Icons.location_on,
                              hintText: "Etkinliğin Konumu",
                              validator: (String? value) =>
                                  Validator.emptyControl(value,
                                      "Etkinliğin konumunu belirtmelisiniz")),
                          SizedBox(
                            height: size.height * .03,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  child: Text(
                                    "VIP etkinlik mi?",
                                    style: textFormFieldHintStyle.copyWith(
                                        fontSize: 15),
                                  ),
                                  onTap: () {
                                    AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.INFO,
                                            animType: AnimType.RIGHSLIDE,
                                            headerAnimationLoop: false,
                                            title: "VIP Etkinlik Nedir?",
                                            desc: "VIP Etkinliklerde etkinliğe "
                                                "katılanlardan aşağıda "
                                                "belirlediğiniz token miktarı "
                                                "kadar MvRG Token alınır. VIP "
                                                "Etkinlik olmayan etkinliklerde "
                                                "etkinliğe katılanlara "
                                                "belilediğiniz token miktarı "
                                                "kadar MvRG Token verilir.",
                                            btnOkOnPress: () {},
                                            btnOkText: "Tamam",
                                            btnOkColor: Colors.blue)
                                        .show();
                                  },
                                ),
                                Checkbox(
                                  value: award,
                                  onChanged: (bool? value) => setState(() {
                                    award = value!;
                                  }),
                                )
                              ],
                            ),
                          ),
                          TextFormFieldC(
                            styleColor: Colors.grey,
                            controller: priceCnt,
                            iconData: Icons.attach_money,
                            hintText: "Token Miktarı",
                            validator: Validator.checkPrice,
                            textInputType: TextInputType.number,
                          ),
                          SizedBox(
                            height: size.height * .03,
                          ),
                          ImageFile(
                              child: buildImageFileChild(),
                              onTap: galeriResimPick)
                        ],
                      ),
                    ),
                  ),
                ))
          ],
        ),
      );

  Widget buildImageFileChild() {
    if (image == null) {
      return Text(
        "Resim Yok",
        style:
            TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold),
      );
    } else {
      return Image.file(image!);
    }
  }

  Future galeriResimPick() async {
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

  Future createEvent() async {
    setState(() {
      isProgress = true;
    });

    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Lütfen etkinlik için bir resim seçiniz!!!"),
        duration: Duration(seconds: 2),
      ));

      setState(() {
        isProgress = false;
      });
    } else {
      if (formKey.currentState!.validate()) {
        UserModel userModel = Provider.of<UserModel>(context, listen: false);

        try {
          String imageUrl =
              await userModel.uploadFile("Events", image!, titleCnt.text);

          bool result = await userModel.setEvent(Event(
              title: titleCnt.text,
              location: locationCnt.text,
              imageUrl: imageUrl,
              award: !award,
              tokenPrice: int.parse(priceCnt.text),
              code: await getCode(),
              isDeleted: false));

          if (result) {
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.SUCCES,
                    animType: AnimType.RIGHSLIDE,
                    headerAnimationLoop: false,
                    title: "Yeni Etkinlik Oluşturulu 👍",
                    desc: "Yeni etkinlik başarılı bir şekilde oluşturuldu",
                    btnOkOnPress: () {},
                    btnOkText: "Tamam",
                    btnOkColor: Colors.blue)
                .show();

            setState(() {
              isProgress = false;
            });
          }
        } catch (e) {
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.WARNING,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: true,
                  title: "Etkinlik Oluşturma HATA",
                  desc: Exceptions.goster(e.toString()),
                  btnOkOnPress: () {},
                  btnOkText: "Tamam",
                  btnOkColor: Colors.blue)
              .show();

          setState(() {
            isProgress = false;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
                "Lütfen İstenilen Değerleri Doğru ve Tam Giriniz..."),
            duration: const Duration(seconds: 2),
            backgroundColor: colorTwo));

        setState(() {
          isProgress = false;
        });
      }
    }
  }

  Future<String> getCode() async {
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    Uuid uuid = const Uuid();
    String code = uuid.v4();
    bool flag = await userModel.isThereAnyEventWithCode(code);
    while (flag) {
      code = uuid.v4();
      flag = await userModel.isThereAnyEventWithCode(code);
    }
    return code;
  }
}
