
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, await_only_futures, depend_on_referenced_packages

import 'package:airjaen/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: const FirebaseOptions(
    apiKey: 'AIzaSyAUcz8Xymi4UbeOejz_P19Bu3cpmwsU_Ko',
    appId: '1:770571023655:android:06068711155ec031dae502',
    messagingSenderId: '770571023655',
    projectId: 'airjaen',
    storageBucket: 'airjaen.appspot.com',
  )).then((value){
    runApp(MaterialApp(home: Main(), debugShowCheckedModeBanner: false,));
  });
  
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}
class _MainState extends State<Main> {

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: "Air Jaén",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color.fromARGB(255, 47, 0, 51),
          secondary: Colors.purple[800],

        )
        
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        
      }

    );
  }
}

class NavigationService { 
  static GlobalKey<NavigatorState> navigatorKey = 
  GlobalKey<NavigatorState>();
}