import 'package:flutter/material.dart';
import 'package:mvrg_app/model/userC.dart';
import 'package:mvrg_app/services/validator.dart';
import 'package:mvrg_app/ui/const.dart';
import 'package:mvrg_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
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
                  "Kullanıcı Bilgilerim",
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
                            onPressed: () {},
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
}
