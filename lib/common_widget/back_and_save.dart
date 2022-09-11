import 'package:flutter/material.dart';
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
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: butonBorder,
                  gradient: const LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.bottomRight,
                      stops: [
                        .1,
                        .8
                      ],
                      colors: [
                        Color.fromRGBO(30, 227, 167, 1),
                        Color.fromRGBO(220, 247, 239, 1)
                      ])),
              height: size.height * .08,
              width: size.width * .15,
              child: Icon(
                widget.isProgress ? Icons.lock : Icons.save,
                color: Colors.white,
                size: 40,
              ),
            ),
            onTap: () {
              if (!widget.isProgress) {
                widget.onTap();
              }
            },
          )
        ],
      ),
    );
  }
}
