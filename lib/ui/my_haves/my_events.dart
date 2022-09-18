import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvrg_app/ui/const.dart';
import 'package:mvrg_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({Key? key}) : super(key: key);

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  String? chosen;

  List<String> isParticipantEvents = [], isNotParticipantEvents = [];

  late Size size;

  @override
  void initState() {
    super.initState();
    getMyEvents();
  }

  Future getMyEvents() async {
    List<List<String>> myEvents =
        await Provider.of<UserModel>(context, listen: false).getMyEvents();
    setState(() {
      isParticipantEvents = myEvents.elementAt(0);
      isNotParticipantEvents = myEvents.elementAt(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        height: size.height,
        child: Column(
          children: [
            buildHeader(),
            SizedBox(
              height: size.height * .023,
            ),
            buildEventsDropdownButton(true),
            buildEventsDropdownButton(false)
          ],
        ),
      ),
    );
  }

  Widget buildHeader() => Container(
        height: 200,
        width: size.width,
        decoration: BoxDecoration(
            color: Colors.purple.shade100,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 25),
              child: Text(
                "Etkinliklerim",
                style: headerText,
              ),
            )
          ],
        ),
      );

  Widget buildEventsDropdownButton(bool isParticipant) => Padding(
        padding:
            const EdgeInsets.only(left: 30, right: 30, bottom: 24, top: 12),
        child: Container(
          height: 50,
          width: size.width,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              color: Colors.grey.shade300),
          child: Theme(
            data: Theme.of(context).copyWith(
                canvasColor: Colors.grey.shade300,
                buttonTheme:
                    ButtonTheme.of(context).copyWith(alignedDropdown: true)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                iconEnabledColor: Colors.grey.shade900,
                hint: Text(isParticipant ? "Katıldıklarım" : "Katılacaklarım"),
                onChanged: (String? value) {},
                value: chosen,
                items: isParticipant
                    ? isParticipantEvents
                        .map((String value) => buildDropdownMenuItem(value))
                        .toList()
                    : isNotParticipantEvents
                        .map((String value) => buildDropdownMenuItem(value))
                        .toList(),
              ),
            ),
          ),
        ),
      );

  DropdownMenuItem<String> buildDropdownMenuItem(String value) =>
      DropdownMenuItem<String>(
        value: value,
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: SizedBox(
            height: 50,
            width: size.width - 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: textStyle,
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      );
}
