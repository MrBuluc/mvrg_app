import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mvrg_app/common_widget/form/icon_button_with_progress.dart';
import 'package:mvrg_app/common_widget/header/header_with_row.dart';
import 'package:mvrg_app/common_widget/text_form_fieldC.dart';
import 'package:mvrg_app/services/validator.dart';
import 'package:mvrg_app/ui/const.dart';
import 'package:mvrg_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../app/exceptions.dart';
import '../../model/userC.dart';

class TokenTransferPage extends StatefulWidget {
  const TokenTransferPage({Key? key}) : super(key: key);

  @override
  State<TokenTransferPage> createState() => _TokenTransferPageState();
}

class _TokenTransferPageState extends State<TokenTransferPage> {
  late Size size;

  TextEditingController addressCnt = TextEditingController();
  TextEditingController valueCnt = TextEditingController(text: "0");

  bool isProgress = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int? token;

  String balanceStr = "0";

  @override
  void initState() {
    super.initState();
    getToken();
  }

  getToken() {
    setState(() {
      token = Provider.of<UserModel>(context, listen: false).user!.token!;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            HeaderWithRow(
                containerColor: tokenAppBarBgColor,
                text: "MvRG Token İşlemleri",
                fontSize: 22,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: size.height * .05),
                    child: Image.asset(
                      "assets/MvRG_Token.png",
                      height: 100,
                      width: 100,
                    ),
                  )
                ]),
            SizedBox(
              height: size.height * .03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildWalletWidget(token!.toString(), "Mevcut Token"),
                buildWalletWidget(balanceStr, "Cüzdanınızda Bulunan Token")
              ],
            ),
            SizedBox(
              height: size.height * .03,
            ),
            buildTextForms(),
            buildButtons()
          ],
        ),
      ),
    );
  }

  Widget buildWalletWidget(String countStr, String text) => SizedBox(
        height: 90,
        width: size.width / 2 - 10,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [
                      .2,
                      .4,
                      .6,
                      .8
                    ],
                    colors: [
                      Color.fromRGBO(47, 75, 110, 1),
                      Color.fromRGBO(43, 71, 105, 1),
                      Color.fromRGBO(39, 64, 97, 1),
                      Color.fromRGBO(34, 58, 90, 1)
                    ])),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80,
                  child: Center(
                    child: ListView(
                      children: [
                        Text(
                          countStr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Color.fromRGBO(253, 211, 4, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        Text(
                          text,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );

  Widget buildTextForms() => Container(
        height: size.height * .3,
        width: size.width * .8,
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
            padding:
                EdgeInsets.only(top: size.width * .05, right: 25, left: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormFieldC(
                    styleColor: Colors.grey,
                    controller: addressCnt,
                    iconData: Icons.account_balance_wallet,
                    hintText: "Cüzdan Adresiniz",
                    validator: checkAddress),
                SizedBox(
                  height: size.height * .03,
                ),
                TextFormFieldC(
                  styleColor: Colors.grey,
                  controller: valueCnt,
                  iconData: Icons.attach_money,
                  hintText: "Çekmek İstediğiniz Miktar",
                  validator: Validator.checkPrice,
                  textInputType: TextInputType.number,
                )
              ],
            ),
          ),
        ),
      );

  String? checkAddress(String? value) {
    RegExp regExp = RegExp("^0x[a-fA-F0-9]{40}\$");
    if (!regExp.hasMatch(value!)) {
      return "Lütfen geçerli bir Ethereum Cüzdan Adresi "
          "giriniz";
    }
    return null;
  }

  Widget buildButtons() => Padding(
        padding: EdgeInsets.only(
            left: size.width * .1,
            top: size.width * .08,
            right: size.width * .1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: newBadgeAndEventColor,
                    size: 30,
                  ),
                  Text(
                    "Geri",
                    style: TextStyle(
                        color: newBadgeAndEventColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            IconButtonWithProgress(
                isProgress: isProgress,
                onTap: checkBalance,
                iconData: Icons.generating_tokens),
            IconButtonWithProgress(
                isProgress: isProgress,
                onTap: transferToken,
                iconData: Icons.send)
          ],
        ),
      );

  Future checkBalance() async {
    valueCnt.text = "0";
    setState(() {
      isProgress = true;
    });

    if (formKey.currentState!.validate()) {
      try {
        String newBalance = await Provider.of<UserModel>(context, listen: false)
            .getTokenBalance(addressCnt.text);
        setState(() {
          balanceStr = newBalance;
          isProgress = false;
        });
      } catch (e) {
        AwesomeDialog(
                context: context,
                dialogType: DialogType.WARNING,
                animType: AnimType.RIGHSLIDE,
                headerAnimationLoop: true,
                title: "Token Miktarı Kontrol HATA",
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
          content:
              const Text("Lütfen İstenilen Değerleri Doğru ve Tam Giriniz..."),
          duration: const Duration(seconds: 2),
          backgroundColor: colorTwo));

      setState(() {
        isProgress = false;
      });
    }
  }

  Future transferToken() async {
    setState(() {
      isProgress = true;
    });

    if (formKey.currentState!.validate()) {
      try {
        if (valueCnt.text != "0") {
          int value = int.parse(valueCnt.text);
          if (value <= token!) {
            UserModel userModel =
                Provider.of<UserModel>(context, listen: false);
            UserC userC = userModel.user!;

            String transactionHash =
                    await userModel.sendToken(addressCnt.text, value),
                etherscanUrl =
                    "https://goerli.etherscan.io/tx/$transactionHash";

            userC.token = userC.token! - value;
            bool result = await userModel.updateUserStore(userC);
            if (result) {
              if (await canLaunchUrlString(etherscanUrl)) {
                AwesomeDialog(
                        context: context,
                        dialogType: DialogType.SUCCES,
                        animType: AnimType.RIGHSLIDE,
                        headerAnimationLoop: true,
                        title: "MvRG Token Transfer Edildi ✔",
                        desc: "$value MvRG Token başarıyla transfer edildi. "
                            "İsterseniz tamam butonuna basarak transactionın "
                            "etherscan adresine gidebilirsiniz.",
                        btnOkOnPress: () async {
                          await launchUrlString(etherscanUrl);
                        },
                        btnOkText: "Tamam",
                        btnOkColor: Colors.blue)
                    .show();
              } else {
                AwesomeDialog(
                        context: context,
                        dialogType: DialogType.SUCCES,
                        animType: AnimType.RIGHSLIDE,
                        headerAnimationLoop: true,
                        title: "MvRG Token Transfer Edildi ✔",
                        desc: "$value MvRG Token başarıyla transfer edildi.",
                        btnOkOnPress: () {},
                        btnOkText: "Tamam",
                        btnOkColor: Colors.blue)
                    .show();
              }

              await checkBalance();

              setState(() {
                isProgress = false;
                token = token! - value;
              });
            }
          } else {
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.WARNING,
                    animType: AnimType.RIGHSLIDE,
                    headerAnimationLoop: true,
                    title: "Transfer Etme HATA",
                    desc: "Transfer etmek istediğiniz $value MvRG Tokena sahip "
                        "değilsiniz. Lütfen sahip olduğunuz MvRG Token "
                        "miktarına eşit veya miktarından küçük bir değer "
                        "giriniz.",
                    btnOkOnPress: () {},
                    btnOkText: "Tamam",
                    btnOkColor: Colors.blue)
                .show();

            setState(() {
              isProgress = false;
            });
          }
        } else {
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.WARNING,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: true,
                  title: "Transfer Etme HATA",
                  desc: "Lütfen 0 dan büyük bir MvRG Token miktarı giriniz.",
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
                dialogType: DialogType.ERROR,
                animType: AnimType.RIGHSLIDE,
                headerAnimationLoop: true,
                title: "Transfer Etme HATA",
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
          content:
              const Text("Lütfen İstenilen Değerleri Doğru ve Tam Giriniz..."),
          duration: const Duration(seconds: 2),
          backgroundColor: colorTwo));

      setState(() {
        isProgress = false;
      });
    }
  }
}
