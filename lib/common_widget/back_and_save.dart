import 'package:flutter/material.dart';
import 'package:mvrg_app/common_widget/form/icon_button_with_progress.dart';
import 'package:mvrg_app/ui/const.dart';

class BackAndSave extends StatefulWidget {
  final bool isProgress;
  final Future Function() onTap;
  const BackAndSave({Key? key, required this.isProgress, required this.onTap})
      : super(key: key);

  @override
  State<BackAndSave> createState() => _BackAndSaveState();
}

class _BackAndSaveState extends State<BackAndSave> {
  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(left: size.width * .1, top: size.width * .08),
      child: Row(
        children: [
          GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              color: newBadgeAndEventColor,
              size: 30,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          GestureDetector(
            child: Text(
              "Geri",
              style: TextStyle(
                  color: newBadgeAndEventColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(
            height: size.height * .15,
            width: size.width * .45,
          ),
          IconButtonWithProgress(
              isProgress: widget.isProgress,
              onTap: widget.onTap,
              iconData: Icons.save)
        ],
      ),
    );
  }
}
