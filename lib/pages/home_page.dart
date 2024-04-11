// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, unused_local_variable, no_leading_underscores_for_local_identifiers, unused_element

import 'package:airjaen/views/LoggedView.dart';
import 'package:airjaen/views/LoginView.dart';
import 'package:airjaen/views/InicioView.dart';
import 'package:airjaen/views/BuscadorTiempoView.dart';
import 'package:airjaen/views/MisViajesView.dart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final int selectedIndex = 0;
  late final ValueChanged<int> onItemSelected;

  List<Widget> screens = [
        InicioView(),
        BuscadorTiempo(),
        MisViajes(),
        LoginView(),
  ];

  _updateTabs(){
      screens = [
        InicioView(),
        BuscadorTiempo(),
        MisViajes(),
        LoginView(),

      ];
  }

  @override
    void initState() {
      _updateTabs();
      super.initState();
  }


  @override
  Widget build(BuildContext context) {  

    PersistentTabController _controller =PersistentTabController(initialIndex: 0);

    List<PersistentBottomNavBarItem>  _navBarsItems(){
      return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        inactiveIcon: const Icon(Icons.home_outlined),
        title: "Inicio",
        activeColorPrimary: Color.fromARGB(175, 107, 28, 172),
        activeColorSecondary: CupertinoColors.white,
      ),
      PersistentBottomNavBarItem(
        inactiveIcon: const Icon(Icons.search),
        icon: const Icon(Icons.search),
        title: "Buscar",
        activeColorPrimary: Color.fromARGB(175, 107, 28, 172),
        activeColorSecondary: CupertinoColors.white
      ),
      PersistentBottomNavBarItem(
        inactiveIcon: const Icon(Icons.airplane_ticket_outlined),
        icon: const Icon(Icons.airplane_ticket),
        title: "Mis viajes",
        activeColorPrimary: Color.fromARGB(175, 107, 28, 172),
        activeColorSecondary: CupertinoColors.white,
      ),
      PersistentBottomNavBarItem(
        inactiveIcon: const Icon(Icons.person_outline),
        icon: const Icon(Icons.person),
        title: "Mi cuenta",
        activeColorPrimary: Color.fromARGB(175, 107, 28, 172),
        activeColorSecondary: CupertinoColors.white

      ),
      ];
    }

    

    return Scaffold(
      
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/airjaen-logo-sinfondo.png',
              fit: BoxFit.contain,
              height: 60,
            )
          ]
        ),
      ),
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: screens,
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          
        ),
        popAllScreensOnTapOfSelectedTab: true,
        navBarStyle: NavBarStyle.style7,
        stateManagement: false,
        onItemSelected: (index) {
          setState(() {
            _updateTabs();
          });
        },
      ),
    
    );
      


    
  }
}

