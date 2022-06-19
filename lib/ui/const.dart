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
