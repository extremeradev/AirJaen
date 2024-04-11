// ignore_for_file: prefer_const_constructors

import 'package:airjaen/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MisViajes extends StatefulWidget {
  const MisViajes({super.key});

  @override
  State<MisViajes> createState() => _MisViajesState();
}

class _MisViajesState extends State<MisViajes> {
  List images = [];
  bool isLoading = true;

  Future<void> obtenerBilletes() async {
    if(firebaseAuth.currentUser != null){
      images = await listarMisBilletes().then((value) {
        isLoading = false;
        return value;
      });
      

    }
    
  }

  @override
  Widget build(BuildContext context) {
    isLoading = true;

    return FutureBuilder<void>(
        future: obtenerBilletes(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot){

          if(firebaseAuth.currentUser != null){
            return SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(175, 107, 28, 172),
                    shape: BoxShape.rectangle,
                  ),
                  child: Text("MIS VIAJES", style: GoogleFonts.ubuntu(
                    fontSize: 34,
                    

                  ),
                  textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  child: isLoading == false ? ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: images.length, 
                        itemBuilder: _itemBuilder,
                      ) : Padding(
                        padding: const EdgeInsets.only(top: 38.0),
                        child: Center(child: Container(width: 30, height: 30, child: CircularProgressIndicator())),
                      )
                )
                
              ],
            )
            );
          }
          else{
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text("NO HAS INICIADO SESION", style: GoogleFonts.ubuntu(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(175, 107, 28, 172),
                )),
              ),
            );

          }
          
        }    
    );
    
  }


   Widget _itemBuilder(BuildContext context, int index) {

    return InkWell(
      onTap: () async {

      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: 300,
              height: 500,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                color: Color.fromARGB(175, 107, 28, 172),
                
                elevation: 20,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topLeft, 
                          child: Text(images[index].fecha, style: GoogleFonts.ubuntu(
                            fontSize: 30,
                            color: Colors.white,
                          ))
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Image.memory(
                              images[index].qrCode, width: 150, alignment: Alignment.bottomCenter,
                            ),
                            
                        ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Text(images[index].origen.name, style: GoogleFonts.ubuntu(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                                child: Divider(thickness: 2, color: Colors.black),
                              ),
                              Text(images[index].hora_salida, style: GoogleFonts.ubuntu(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                              ),
                            ],
                          ),

                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Transform.rotate(
                            angle: 3.14,
                            
                            child: Icon(Icons.flight, size: 40)),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Text(images[index].hora_llegada, style: GoogleFonts.ubuntu(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                                child: Divider(thickness: 2, color: Colors.black),
                              ),
                              Text(images[index].destino.name, style: GoogleFonts.ubuntu(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,),
                            ],
                          ),
                        ),
                    ],
                  ),
              
            ),
          ),
          ),
        ],
      )
    );
  }

}