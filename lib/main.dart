import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mvrg_app/locator.dart';
import 'package:provider/provider.dart';

import 'app/landing_page.dart';
import 'viewmodel/user_model.dart';

Future main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: "assets/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserModel(),
      child: MaterialApp(
        title: 'MvRG App',
        debugShowCheckedModeBanner: true,
        theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFFFFFFFF),
            primaryColor: Colors.grey.shade100,
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(secondary: Colors.grey.shade200)),
        home: const LandingPage(),
      ),
    );
  }
}
