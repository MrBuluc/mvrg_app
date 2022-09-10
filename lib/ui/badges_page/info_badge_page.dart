import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mvrg_app/common_widget/badge_image.dart';
import 'package:mvrg_app/common_widget/rank_dropown_button.dart';
import 'package:mvrg_app/model/badges/badge.dart';
import 'package:mvrg_app/model/badges/holder.dart';
import 'package:mvrg_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

import '../../model/badges/badgeHolder.dart';
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

  int? holderCount;

  List<Holder> holders = [];

  @override
  void initState() {
    super.initState();
    badge = widget.badge;
    getHolderCount();
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
      body: holderCount != null
          ? SafeArea(
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
                            "Bu rozet $holderCount kişi tarafınan "
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
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Future getHolderCount() async {
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    holderCount = await userModel.countBadgeHolderFromBadgeId(badge.id!);
    if (holderCount! > 0) {
      holders = await userModel.getHolders(badge.id!);
    }
    setState(() {});
  }

  List<Widget> buildPerson() {
    List<Widget> widgets = [];
    for (int i = 0; i < holders.length; i++) {
      Holder holder = holders.elementAt(i);
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
                        buildTextButton("Kaldır", Colors.red,
                            () => removeHolder(holder.badgeHolderId!, i)),
                        buildTextButton(
                            "Güncelle",
                            Colors.green,
                            () =>
                                updateRank(i, rankStr, holder.badgeHolderId!)),
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

  Future removeHolder(String badgeHolderId, int index) async {
    bool result = await Provider.of<UserModel>(context, listen: false)
        .deleteBadgeHolder(badgeHolderId);
    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${holders.elementAt(index).name} Kaldırıldı"),
        backgroundColor: colorTwo,
        duration: const Duration(seconds: 3),
      ));
      setState(() {
        holders.removeAt(index);
      });
      Navigator.pop(context);
    }
  }

  Future updateRank(int index, String newRank, String badgeHolderId) async {
    bool result = await Provider.of<UserModel>(context, listen: false)
        .updateBadgeHolder(
            BadgeHolder(id: badgeHolderId, rank: int.parse(newRank)));
    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${holders.elementAt(index).name} Seviyesi Güncellendi"),
        backgroundColor: colorTwo,
        duration: const Duration(seconds: 3),
      ));
      setState(() {
        holders.elementAt(index).rank = int.parse(newRank);
      });
      Navigator.pop(context);
    }
  }
}
