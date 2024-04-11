// ignore_for_file: sort_child_properties_last, prefer_const_constructors, avoid_print

import 'package:airjaen/services/firebase_service.dart';
import 'package:airjaen/views/EditarPerfilView.dart';
import 'package:airjaen/views/LoginView.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../services/send_email_service.dart';

class LoggedView extends StatefulWidget {
  LoggedView({super.key});

  @override
  State<LoggedView> createState() => _LoggedViewState();
}

class _LoggedViewState extends State<LoggedView> {
  String? nombre;
  String? email;
  void cerrarSesion() async {
    
    await logOut();
    setState(() {
    });

  }

  /*@override
  void initState(){
    getInfo();
  }*/

  Future<void> getInfo() async {
    if(firebaseAuth.currentUser != null){
      nombre = await firebaseAuth.currentUser!.displayName;
      email = await firebaseAuth.currentUser!.email;
      print("GET INFOOOO: "+nombre!+" --- "+ email!);
    }
      
    
  }

  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
      future: getInfo(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot){ 
        if(firebaseAuth.currentUser==null){
          return LoginView();
        } else{
          return logged(context);
        }
    }
    );
  }

  @override
  Widget logged(BuildContext context) {
        return Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: SizedBox(
                width: 90,
                height: 90,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(180),
                  child: firebaseAuth.currentUser!.photoURL != null ? Image.network(
                              firebaseAuth.currentUser!.photoURL.toString(),
                              
                            )
                          
                          :
                          Text("")
                    ,
                ),
              ),
            ),
            const SizedBox(
              height: 10
            ),
            
            Text(nombre != null ? nombre! : "" , style: GoogleFonts.ubuntu(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
            const SizedBox(
              height: 5
            ),
            Text(
              email != null ? email! : "", style: GoogleFonts.ubuntu(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            )),
            const SizedBox(
              height: 20
            ),
            SizedBox(
              width: 200,
              height: 45,
              child: ElevatedButton(child: Text("Editar Perfil", style: GoogleFonts.ubuntu(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )), 
              onPressed: (){
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: EditarPerfil(),
                  withNavBar: true, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                ).then((value) {
                  setState(() {
                    
                  });
                });
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                side: BorderSide.none,
                shape: const StadiumBorder(),
              )),
            ),
            const SizedBox(
              height: 30
            ),
            const Divider(),
            const SizedBox(
              height: 10
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 25.0),
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color.fromARGB(31, 107, 28, 172),
                  ),
                  child: Icon(Icons.info_outline, color: Color.fromARGB(175, 107, 28, 172),)
                ),
                title: Text("Acerca de mi", style: GoogleFonts.ubuntu(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                )),
                trailing: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color.fromARGB(255, 236, 236, 236)
                  ),
                  child: const Icon(Icons.arrow_forward_ios)
                ),
                onTap: ()async {
                  showDialog(
                      context: context, 
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: Text(
                            "Proyecto de Desarrollo de Aplicaciones Multiplataforma, realizado por Alejandro López Extremera",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                          icon: Icon(Icons.question_mark, size: 36),
                          iconColor: Color.fromARGB(255, 72, 0, 255),
                        );
                      }
                  );
                          
                  
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 25.0),
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color.fromARGB(31, 107, 28, 172),
                  ),
                  child: Icon(Icons.logout, color: Color.fromARGB(175, 107, 28, 172),)
                ),
                title: Text("Cerrar Sesión", style: GoogleFonts.ubuntu(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Colors.redAccent,
                )),
                trailing: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color.fromARGB(255, 236, 236, 236)
                  ),
                  child: const Icon(Icons.arrow_forward_ios)
                ),
                onTap: cerrarSesion,
              ),
            )
          ],
        ),
      );
      
    
  }
}