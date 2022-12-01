import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvrg_app/common_widget/center_text.dart';
import 'package:mvrg_app/model/lab_open/lab_open_duration.dart';
import 'package:mvrg_app/ui/const.dart';
import 'package:mvrg_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class LabOpenPage extends StatefulWidget {
  const LabOpenPage({Key? key}) : super(key: key);

  @override
  State<LabOpenPage> createState() => _LabOpenPageState();
}

class _LabOpenPageState extends State<LabOpenPage> {
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: buildAppBar("Bu Hafta Labı En Çok Açanlar"),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: Provider.of<UserModel>(context, listen: false)
              .labOpenDurationStream(),
          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const CenterText(text: "Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CenterText(text: "Loading");
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: buildColumn(snapshot),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> buildColumn(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    List<LabOpenDuration> labOpenDurationList = snapshot.data!.docs
        .map((DocumentSnapshot document) => document.data()! as LabOpenDuration)
        .toList();

    List<Widget> children = [];

    if (labOpenDurationList.isEmpty) {
      children.add(SizedBox(
        height: size.height * .4,
      ));
      children.add(const CenterText(
        text: "Bu hafta daha kimse labı açmamıştır",
        fontSize: 20,
      ));
      return children;
    }

    for (int i = 0; i < labOpenDurationList.length; i++) {
      LabOpenDuration labOpenDuration = labOpenDurationList.elementAt(i);
      List<String> hoursMinutes =
          calculateLabOpenHours(labOpenDuration.weeklyMinutes!);
      children.add(Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: Text(
            (i + 1).toString(),
            style: const TextStyle(fontSize: 20),
          ),
          title: Text(
            labOpenDuration.username! + hoursMinutesStr(hoursMinutes),
            style: const TextStyle(fontSize: 18),
          ),
          trailing: i == 0
              ? const Text(
                  "👑",
                  style: TextStyle(fontSize: 20),
                )
              : null,
        ),
      ));
    }

    return children;
  }

  String hoursMinutesStr(List<String> hoursMinutes) =>
      " => ${hoursMinutes[0]} sa ${hoursMinutes[1]} dk";
}
