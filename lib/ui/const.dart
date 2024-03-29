import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

LinearGradient loginPageBg = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [
      0.1,
      0.6,
      0.9
    ],
    colors: [
      Color.fromRGBO(0, 5, 161, 1),
      Color.fromRGBO(138, 149, 243, 1),
      Color.fromRGBO(201, 206, 251, 1)
    ]);

LinearGradient indigoButton = const LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [
      0.1,
      0.5,
      0.9
    ],
    colors: [
      Color.fromRGBO(206, 210, 242, 1),
      Color.fromRGBO(138, 149, 243, 1),
      Color.fromRGBO(124, 127, 225, 1)
    ]);

LinearGradient registerpageBg = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: const [
      0.1,
      0.5,
      0.9
    ],
    colors: [
      Colors.blue.shade100,
      const Color.fromRGBO(255, 241, 151, 1),
      const Color.fromRGBO(250, 164, 26, 1)
    ]);

LinearGradient orangeButton = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: const [
      0.3,
      0.9
    ],
    colors: [
      Colors.blue.shade100,
      const Color.fromRGBO(255, 241, 151, 1),
    ]);

LinearGradient homePageBg = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: const [.1, .6, .9],
    colors: [Colors.grey.shade900, Colors.grey, Colors.white]);

const TextStyle headerText = TextStyle(
    color: Colors.white,
    fontSize: 42,
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(
        offset: Offset(3, 3),
        blurRadius: 8,
        color: Color.fromARGB(43, 43, 43, 0),
      )
    ]);

const TextStyle headerText2 = TextStyle(
    fontFamily: "Ubuntu",
    color: Colors.white,
    fontSize: 25,
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(
          offset: Offset(3, 3),
          blurRadius: 8,
          color: Color.fromARGB(43, 43, 43, 0))
    ]);

const TextStyle miniHeader = TextStyle(
    color: Colors.white,
    fontSize: 15,
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(
        offset: Offset(5, 5),
        blurRadius: 10,
        color: Color.fromARGB(43, 43, 43, 0),
      )
    ]);

const TextStyle miniHeader2 = TextStyle(
    fontFamily: "Catamaran",
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(
          offset: Offset(5, 5),
          blurRadius: 10,
          color: Color.fromRGBO(43, 43, 43, 0))
    ]);

const TextStyle textFormFieldHintStyle = TextStyle(
    fontFamily: "Catamaran",
    fontWeight: FontWeight.bold,
    color: Colors.grey,
    fontSize: 17);

TextStyle textStyle = TextStyle(
    color: Colors.grey.shade700, fontFamily: "Catamaran", fontSize: 16);

Color textFieldPrimaryColor = const Color.fromRGBO(30, 227, 167, 1);
Color colorOne = const Color.fromRGBO(116, 235, 213, 1);
Color colorTwo = const Color.fromRGBO(172, 182, 229, 1);
Color newBadgeAndEventColor = const Color.fromRGBO(30, 227, 167, 1);
Color detailsColor = const Color.fromRGBO(151, 175, 255, 1);
Color detailsColor2 = const Color.fromRGBO(213, 217, 255, 1);
Color qrColor = const Color.fromRGBO(242, 210, 242, 1);
Color tokenAppBarBgColor = const Color.fromRGBO(225, 158, 152, 1);

Decoration gradient = const BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
      Color.fromRGBO(116, 235, 213, 1),
      Color.fromRGBO(172, 182, 229, 1)
    ]));

BorderRadius butonBorder = BorderRadius.circular(10);

AppBar buildAppBar(String text) => AppBar(
      title: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 22),
      ),
      centerTitle: true,
      elevation: 2,
    );

Widget imageLoadingBuilder(
    BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
  if (loadingProgress == null) return child;
  return CircularProgressIndicator(
    value: loadingProgress.expectedTotalBytes != null
        ? loadingProgress.cumulativeBytesLoaded /
            loadingProgress.expectedTotalBytes!
        : null,
  );
}

List<String> calculateLabOpenHours(int minutes) {
  return [(minutes / 60).floor().toString(), (minutes % 60).toString()];
}
