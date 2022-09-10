import 'package:flutter/material.dart';
import 'package:mvrg_app/common_widget/drawer/drawerC.dart';
import 'package:mvrg_app/ui/badges_page/badges_page.dart';
import 'package:mvrg_app/ui/const.dart';
import 'package:mvrg_app/ui/events_page/events_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: buildAppBar("Ana Sayfa"),
      drawer: const DrawerC(),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: size.height * .03,
            ),
            buildNavigators(Icons.verified_outlined, "Rozetleri İncele",
                "Rozetler Sayfasına Git", const BadgesPage()),
            SizedBox(
              height: size.height * .05,
            ),
            buildNavigators(Icons.event, "Varolan Etkinlikleri İncele",
                "Etkinlikler Sayfasına Git", const EventsPage())
          ],
        ),
      ),
    );
  }

  Widget buildNavigators(
          IconData iconData, String text, String buttonText, Widget page) =>
      Expanded(
          child: Container(
        margin: const EdgeInsets.only(right: 10, left: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.bottomRight,
                colors: [colorOne, colorTwo])),
        child: Row(
          children: [
            Icon(
              iconData,
              size: size.height * .3,
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 25),
                    ),
                    Expanded(
                        child: Align(
                      child: ElevatedButton(
                        child: Text(
                          buttonText,
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => page));
                        },
                      ),
                    ))
                  ],
                ),
              ),
            )
          ],
        ),
      ));
}
