import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvrg_app/common_widget/badge_image.dart';
import 'package:mvrg_app/common_widget/center_text.dart';
import 'package:mvrg_app/model/badges/badge.dart';
import 'package:mvrg_app/ui/badges_page/create_and_update_badge_page.dart';
import 'package:mvrg_app/ui/badges_page/info_badge_page.dart';
import 'package:mvrg_app/ui/const.dart';
import 'package:mvrg_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class BadgesPage extends StatefulWidget {
  const BadgesPage({Key? key}) : super(key: key);

  @override
  State<BadgesPage> createState() => _BadgesPageState();
}

class _BadgesPageState extends State<BadgesPage> {
  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: buildAppBar("Rozetler"),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: Provider.of<UserModel>(context, listen: false).badgeStream(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const CenterText(text: "Something went wong");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CenterText(text: "Loading");
            }

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: buildColumn(snapshot),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> buildColumn(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    List<Badge> badges = snapshot.data!.docs.map((DocumentSnapshot document) {
      Badge badge = document.data()! as Badge;
      badge.id = document.id;
      return badge;
    }).toList();

    List<Widget> widgets = [];
    if (badges.isEmpty) {
      widgets.add(const CenterText(
          text: "Daha hiçbir rozet eklenmemiştir", fontSize: 20));
      return widgets;
    }
    int length = badges.length;
    for (int i = 0; i < length; i++) {
      int remainder = i % 3;
      List<Badge> badges1 = [];
      switch (remainder) {
        case 0:
          badges1 = [badges[i]];
          break;
        case 1:
          if (i + 1 == length) {
            badges1 = [badges[i]];
          } else {
            badges1 = [badges[i], badges[i + 1]];
          }
          break;
        default:
          continue;
      }
      widgets.add(buildBadgeWidget(badges1));
    }
    return widgets;
  }

  Widget buildBadgeWidget(List<Badge> badges) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: badges
          .map((Badge badge) => GestureDetector(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    BadgeImage(
                      badge: badge,
                    ),
                    Text(
                      badge.name!,
                      style: const TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: size.height * .01,
                    )
                  ],
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InfoBadgePage(badge: badge)));
                },
                onLongPress: () {
                  bool admin = Provider.of<UserModel>(context, listen: false)
                      .user!
                      .admin!;
                  if (admin) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateAndUpdateBadgePage(
                                  badge: badge,
                                )));
                  }
                },
              ))
          .toList(),
    );
  }
}
