import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mvrg_app/common_widget/badge_image.dart';
import 'package:mvrg_app/common_widget/rank_dropown_button.dart';
import 'package:mvrg_app/model/badge.dart';
import 'package:mvrg_app/model/holder.dart';
import 'package:mvrg_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

import '../const.dart';

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
                  BadgeImage(
                    badge: badge,
                  ),
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
    for (int i = 0; i < badge.holders!.length; i++) {
      Holder holder = Holder.fromMap(badge.holders!.elementAt(i));
      int rank = holder.rank!;
      String rankStr = rank.toString();

      Row row = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.done,
            color: Colors.grey,
          ),
          Text(
            holder.name!,
            style: const TextStyle(fontSize: 16),
          )
        ],
      );

      for (int j = 0; j < rank; j++) {
        row.children.add(const Icon(
          Icons.star,
          color: Colors.yellow,
        ));
      }

      GestureDetector gestureDetector = GestureDetector(
        child: Padding(
          padding: EdgeInsets.only(top: size.height * .01),
          child: row,
        ),
        onTap: () {
          bool admin =
              Provider.of<UserModel>(context, listen: false).user!.admin!;
          if (admin) {
            AwesomeDialog(
                context: context,
                dialogType: DialogType.NO_HEADER,
                animType: AnimType.RIGHSLIDE,
                headerAnimationLoop: true,
                body: Column(
                  children: [
                    Text(
                      "${holder.name} Seviyesini Güncelle",
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    StatefulBuilder(
                        builder: (context, rankDropdownButtonState) =>
                            RankDropdownButton(
                                value: rankStr,
                                onChanged: (String? value) =>
                                    rankDropdownButtonState(() {
                                      rankStr = value!;
                                    }))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        buildTextButton(
                            "Kaldır", Colors.red, () => removeHolder(i)),
                        buildTextButton("Güncelle", Colors.green,
                            () => updateRank(i, rankStr)),
                      ],
                    )
                  ],
                )).show();
          }
        },
      );
      widgets.add(gestureDetector);
    }
    return widgets;
  }

  Widget buildTextButton(
      String text, Color buttonColor, void Function()? onPressed) {
    return TextButton(
      child: Text(
        text,
        style: const TextStyle(fontSize: 18),
      ),
      style: TextButton.styleFrom(primary: buttonColor),
      onPressed: onPressed,
    );
  }

  Future removeHolder(int index) async {
    Map<String, dynamic> holdersMap = badge.holders!.elementAt(index);
    bool result = await Provider.of<UserModel>(context, listen: false)
        .removeHolderFromBadge(badge.id!, holdersMap);
    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${holdersMap["name"]} Kaldırıldı"),
        backgroundColor: colorTwo,
        duration: const Duration(seconds: 3),
      ));
      setState(() {
        badge.holders!.removeAt(index);
      });
      Navigator.pop(context);
    }
  }

  Future updateRank(int index, String newRank) async {
    Map<String, dynamic> holdersMap = badge.holders!.elementAt(index);
    holdersMap["rank"] = int.parse(newRank);
    badge.holders!.elementAt(index)["rank"] = holdersMap["rank"];
    bool result = await Provider.of<UserModel>(context, listen: false)
        .updateBadge(Badge(id: badge.id!, holders: badge.holders!));
    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${holdersMap["name"]} Seviyesi Güncellendi"),
        backgroundColor: colorTwo,
        duration: const Duration(seconds: 3),
      ));
      setState(() {});
      Navigator.pop(context);
    }
  }
}
