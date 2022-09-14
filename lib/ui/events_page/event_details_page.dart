import 'package:flutter/material.dart';
import 'package:mvrg_app/common_widget/event_image.dart';
import 'package:mvrg_app/model/events/event.dart';
import 'package:mvrg_app/ui/const.dart';
import 'package:mvrg_app/ui/events_page/events_page.dart';
import 'package:mvrg_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class EventDetailsPage extends StatefulWidget {
  final Event event;
  const EventDetailsPage({Key? key, required this.event}) : super(key: key);

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(),
            SizedBox(
              height: size.height * .22,
            ),
            buildBody(),
            SizedBox(
              height: size.height * .03,
            ),
            buildButtons(),
            SizedBox(
              height: size.height * .03,
            ),
            buildBackAndQr()
          ],
        ),
      ),
    ));
  }

  Widget buildHeader() => Container(
        height: size.height * .25,
        decoration: BoxDecoration(
            color: detailsColor,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            boxShadow: const [
              BoxShadow(color: Colors.grey, spreadRadius: 2, blurRadius: 7)
            ]),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: size.width * .05),
              child: const Text(
                "Ayrıntılar",
                style: headerText,
              ),
            )
          ],
        ),
      );

  Widget buildBody() => Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: size.height * .25,
            width: size.width * .8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: detailsColor2),
            child: Column(
              children: [
                SizedBox(
                  height: size.width * .2,
                ),
                Text(
                  "Buluşma Yeri: " + widget.event.location!,
                  style: miniHeader2,
                )
              ],
            ),
          ),
          Positioned(
            top: -140,
            left: 35,
            child: SizedBox(
              height: size.height * .3,
              width: size.width * .6,
              child: EventImage(
                  borderRadius: 20,
                  heroTag: widget.event.title!,
                  image: widget.event.imageUrl!),
            ),
          )
        ],
      );

  Widget buildButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildTextButton("Katılacağım", () {}),
          buildTextButton("Kimler Katılacak?", () {})
        ],
      );

  Widget buildTextButton(String text, void Function() onTap) => Container(
        height: 50,
        width: 150,
        decoration: BoxDecoration(
            color: detailsColor, borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: GestureDetector(
            child: Text(
              text,
              style: miniHeader2,
            ),
            onTap: () {
              onTap();
            },
          ),
        ),
      );

  Widget buildBackAndQr() {
    bool admin = Provider.of<UserModel>(context, listen: false).user!.admin!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back,
                  color: detailsColor,
                ),
                Text(
                  "Geri",
                  style: TextStyle(color: detailsColor, fontSize: 20),
                )
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          buildIconButton(Icons.camera_alt, 30, const EventsPage()),
          if (admin) buildIconButton(Icons.qr_code, 35, const EventsPage())
        ],
      ),
    );
  }

  Widget buildIconButton(IconData iconData, double iconSize, Widget page) =>
      Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            gradient: indigoButton, borderRadius: BorderRadius.circular(10)),
        child: GestureDetector(
          child: Icon(
            iconData,
            color: Colors.white,
            size: iconSize,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
        ),
      );
}
