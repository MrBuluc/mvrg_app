import 'package:flutter/material.dart';
import 'package:mvrg_app/model/badge.dart';

class InfoBadgePage extends StatefulWidget {
  final Badge badge;
  const InfoBadgePage({Key? key, required this.badge}) : super(key: key);

  @override
  State<InfoBadgePage> createState() => _InfoBadgePageState();
}

class _InfoBadgePageState extends State<InfoBadgePage> {
  late Badge badge;

  late Size size;

  late double infoPaddingVertical;

  @override
  void initState() {
    super.initState();
    badge = widget.badge;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    infoPaddingVertical = size.height * .01;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Rozet Bilgisi"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(top: size.height * .03),
              child: Text(
                badge.name!,
                style: const TextStyle(
                    fontSize: 23,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height * .1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                      tag: badge.id!,
                      child: Image.network(
                        badge.imageUrl!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )),
                  Padding(
                    padding: EdgeInsets.only(
                        top: size.height * .03,
                        left: infoPaddingVertical,
                        right: infoPaddingVertical),
                    child: Text(
                      badge.info!,
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: size.height * .03),
                    child: Text(
                      "Bu rozet ${badge.holders!.length} kişi tarafınan "
                      "kazanıldı:",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Column(
                    children: buildPerson(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> buildPerson() {
    List<Widget> widgets = [];
    for (dynamic dynamicLocal in badge.holders!) {
      Map<String, dynamic> map = dynamicLocal;
      Row row = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.done,
            color: Colors.grey,
          ),
          Text(
            map["name"],
            style: const TextStyle(fontSize: 16),
          )
        ],
      );
      int rank = map["rank"];
      for (int i = 0; i < rank; i++) {
        row.children.add(const Icon(
          Icons.star,
          color: Colors.yellow,
        ));
      }
      Padding padding = Padding(
        padding: EdgeInsets.only(top: size.height * .01),
        child: row,
      );
      widgets.add(padding);
    }
    return widgets;
  }
}
