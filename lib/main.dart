import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:tempapp/appManager/firebase_manager.dart';
import 'package:tempapp/splash_screen.dart';
import 'appManager/firebase_option.dart';
import 'appManager/view_manager.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  ///การ set firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ///การ set timezone
  tzdata.initializeTimeZones();
  final location = tz.getLocation('Asia/Bangkok');
  tz.setLocalLocation(location);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Temp Application',
      debugShowCheckedModeBanner: false,
      locale: Locale('th', 'TH'),
      home: MyHomePage(title: 'TempApp'),
      navigatorKey: GlobalVariable.navState,
      theme: ThemeData(
        fontFamily: "Prompt",
        primaryColor: ColorManager().primaryColor,
        colorScheme: ThemeData()
            .colorScheme
            .copyWith(primary: ColorManager().primaryColor),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}

class GlobalVariable {
  static final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
}
