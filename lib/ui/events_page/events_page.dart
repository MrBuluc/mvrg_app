import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvrg_app/common_widget/center_text.dart';
import 'package:mvrg_app/common_widget/event_image.dart';
import 'package:mvrg_app/model/events/event.dart';
import 'package:mvrg_app/ui/const.dart';
import 'package:mvrg_app/ui/events_page/create_event_page.dart';
import 'package:mvrg_app/ui/events_page/event_details_page.dart';
import 'package:mvrg_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  late Size size;

  Stream<QuerySnapshot> eventsStream =
      FirebaseFirestore.instance.collection("Events").snapshots();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: homePageBg),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size.height * .05,
                ),
                buildHeader(),
                SizedBox(
                  height: size.height * .05,
                ),
                buildCevreText(),
                SizedBox(
                  height: size.height * .05,
                ),
                buildEventsStreamBuilder()
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget buildHeader() {
    bool admin = Provider.of<UserModel>(context, listen: false).user!.admin!;
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: admin ? size.width * .15 : size.width * .25),
          child: const Text(
            "MvRG App",
            style: headerText,
          ),
        ),
        if (admin)
          Padding(
            padding: EdgeInsets.only(left: size.width * .05),
            child: FloatingActionButton(
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 50,
              ),
              backgroundColor: Colors.green,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateEventPage()));
              },
            ),
          )
      ],
    );
  }

  Widget buildCevreText() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Etkinlikler",
            style: headerText2,
          )
        ],
      );

  Widget buildEventsStreamBuilder() => StreamBuilder<QuerySnapshot>(
      stream: eventsStream,
      builder: (context, snapshot) {
        int length = snapshot.data?.docs.length ?? 0;

        if (snapshot.hasError) {
          return const CenterText(text: "Something went wrong");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CenterText(text: "Loading");
        } else if (length == 0) {
          return const CenterText(
              text: "Daha hiçbir etkinlik eklenmemiştir", fontSize: 20);
        }
        {
          return SizedBox(
            height: length * 350,
            width: 320,
            child: Column(
              children: buildColumnsChildren(snapshot),
            ),
          );
        }
      });

  List<Widget> buildColumnsChildren(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    List<Event> events = snapshot.data!.docs
        .map((doc) => Event.fromFirestore(doc.data()! as Map<String, dynamic>))
        .toList();

    List<Widget> widgets = [];
    for (Event event in events) {
      widgets.add(buildEventWidget(event));
    }
    widgets.add(const SizedBox(
      height: 10,
    ));
    return widgets;
  }

  Widget buildEventWidget(Event event) => Column(
        children: [
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade700,
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3))
              ]),
              child: EventImage(
                borderRadius: 10,
                heroTag: event.title!,
                imageUrl: event.imageUrl!,
                height: 320,
                width: 320,
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EventDetailsPage(event: event)));
            },
          ),
          const SizedBox(
            height: 20,
          )
        ],
      );
}
