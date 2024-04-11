// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, unnecessary_string_interpolations, use_build_context_synchronously

import 'package:airjaen/services/weather_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/City.dart';
import 'package:google_fonts/google_fonts.dart';

class BuscadorTiempo extends StatefulWidget {
  const BuscadorTiempo({super.key});

  @override
  State<BuscadorTiempo> createState() => _BuscadorTiempoState();
}

class _BuscadorTiempoState extends State<BuscadorTiempo> {
  late TextEditingController _controller = new TextEditingController();
  City? ciudad;
  WeatherService weatherService = new WeatherService();

  String fechaActual(){
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      final String formatted = formatter.format(now);
      return formatted;
  }

  

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              left: 8.0,
              right: 8.0
            ),
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: TextField(
              controller: _controller,
              onSubmitted: (String value) async {
                  ciudad = await weatherService.getWeatherByCity(value);
                  if(ciudad == null){
                    showDialog(
                    context: context, 
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Text(
                          "Ha habido un error, inténtelo más tarde.",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                        icon: Icon(Icons.warning_amber_rounded, size: 36),
                        iconColor: Color.fromARGB(255, 255, 0, 0),
                      );
                    }
                    );
                  }
                  setState(() {
                    
                  });
               
              },
              style: TextStyle(
                fontSize: 24,
              ),
              cursorColor: Color.fromARGB(175, 107, 28, 172),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  CupertinoIcons.search_circle,
                  size: 40,
                ),
                hintText: "¡Busca una ciudad!",
                hintStyle: TextStyle(
                  fontSize: 20,
                )
              ),
              
            ),
          )
    
          ,
          Container(
                child: ciudad!=null ? _result(context) : Text(""),
                height: 640.0,
                width: double.infinity,

                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff955cd1),
                      Color(0xff3fa2fa),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  )
                )
              ),
          
          
        ],
      ),
    );
  }

  Widget _result(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Container(
        child: Column(
          children: [
            
            Text(
              "${ciudad!.name}",
              style: GoogleFonts.hubballi(
                fontSize: 64,
                color: Colors.white
              ),
              textAlign: TextAlign.end,
            ),
            Text(fechaActual(), style: TextStyle(color: Colors.white)),
            Image.network(
              "https:${ciudad!.icon}",
              scale: 0.4,
            ),
                
            
            Text("${ciudad!.text}",
            style: GoogleFonts.hubballi(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.white

              ),
            ),
            
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "${ciudad!.temp}º",
                style: GoogleFonts.hubballi(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: Colors.white
                ),
              ),
            ),
      
          
            
            
            
          ],
        )
      ),
    );
  }
}