import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvrg_app/common_widget/badge_image.dart';
import 'package:mvrg_app/common_widget/drawer/drawerC.dart';
import 'package:mvrg_app/model/badge.dart';
import 'package:mvrg_app/ui/create_and_update_badge/create_and_update_badge_page.dart';
import 'package:mvrg_app/ui/info_badge/info_badge_page.dart';
import 'package:mvrg_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream<QuerySnapshot> badgeStream =
      FirebaseFirestore.instance.collection("Badges").snapshots();

  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Rozetler",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      drawer: const DrawerC(),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: badgeStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wong"),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Text("Loading"),
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: buildColumn(snapshot),
            );
          },
        ),
      ),
    );
  }

  List<Widget> buildColumn(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    List<Badge> badges = snapshot.data!.docs.map((DocumentSnapshot document) {
      Badge badge = Badge.fromJson(document.data()! as Map<String, dynamic>);
      badge.id = document.id;
      return badge;
    }).toList();

    List<Widget> widgets = [];
    if (badges.isEmpty) {
      widgets.add(const Center(
          child: Text(
        "Daha hiçbir rozet eklenmemiştir",
        style: TextStyle(fontSize: 20),
      )));
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
                    BadgeImage(id: badge.id!, imageUrl: badge.imageUrl!),
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
