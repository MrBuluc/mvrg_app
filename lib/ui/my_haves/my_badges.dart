import 'package:flutter/material.dart';
import 'package:mvrg_app/common_widget/center_text.dart';
import 'package:mvrg_app/model/badges/holder.dart';
import 'package:mvrg_app/ui/const.dart';
import 'package:mvrg_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class MyBadges extends StatefulWidget {
  const MyBadges({Key? key}) : super(key: key);

  @override
  State<MyBadges> createState() => _MyBadgesState();
}

class _MyBadgesState extends State<MyBadges> {
  List<Holder> holders = [];

  late Size size;

  @override
  void initState() {
    super.initState();
    getMyBadges();
  }

  Future getMyBadges() async {
    holders =
        await Provider.of<UserModel>(context, listen: false).getMyBadges();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: buildAppBar("Rozetlerim"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: size.height * .01),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: buildColumnChildren(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildColumnChildren() {
    List<Widget> widgets = [];
    if (holders.isEmpty) {
      widgets.add(const CenterText(
        text: "Daha hiçbir rozet kazanılmamıştır",
        fontSize: 20,
      ));
      return widgets;
    }
    int length = holders.length;
    for (int i = 0; i < length; i++) {
      int remainder = i % 3;
      List<Holder> holders1 = [];
      switch (remainder) {
        case 0:
          holders1 = [holders[i]];
          break;
        case 1:
          if (i + 1 == length) {
            holders1 = [holders[i]];
          } else {
            holders1 = [holders[i], holders[i + 1]];
          }
          break;
        default:
          continue;
      }
      widgets.add(buildBadgeWidget(holders1));
    }
    return widgets;
  }

  Widget buildBadgeWidget(List<Holder> holders) => Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: holders
            .map((holder) => Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Stack(
                      children: [
                        Image.network(
                          holder.badgeImageUrl!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          loadingBuilder: imageLoadingBuilder,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 70),
                          child: Row(
                            children: buildStars(holder),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      holder.name!,
                      style: const TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: size.height * .01,
                    )
                  ],
                ))
            .toList(),
      );

  List<Widget> buildStars(Holder holder) {
    List<Widget> stars = [];
    for (int i = 0; i < holder.rank!; i++) {
      stars.add(const Icon(
        Icons.star,
        color: Colors.yellow,
        size: 30,
      ));
    }
    return stars;
  }
}
