// ignore_for_file: prefer_const_constructors, unused_local_variable, sized_box_for_whitespace, must_call_super, use_build_context_synchronously

import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:airjaen/models/Airport.dart';
import 'package:airjaen/models/Billete.dart';
import 'package:airjaen/services/firebase_service.dart';
import 'package:airjaen/views/CompraView.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:qr_flutter/qr_flutter.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';


class BusquedaVuelos extends StatefulWidget {
  const BusquedaVuelos({super.key, this.origen, this.destino, this.ida, this.vuelta, this.adultos});

  final Airport? origen;
  final Airport? destino;
  final String? ida;
  final String? vuelta;
  final String? adultos;



  @override
  State<BusquedaVuelos> createState() => _BusquedaVuelosState();
}

class _BusquedaVuelosState extends State<BusquedaVuelos> {
  late List vuelos = [];
  late int size;
  bool compra = false;
  String placeholder = "";
  bool isLoading = false;
  Billete? ida;
  Billete? vuelta;


  @override
  void initState() {
    placeholder = "Ida";
    setState(() {
      getVuelos(widget.origen, widget.destino, widget.ida, widget.adultos);
    });

  }

  Future getVuelos(Airport? origen, Airport? destino, String? fecha, String? adultos) async{
    setState(() {
      isLoading = true;
    });
    await getFlies(origen, destino, fecha, widget.adultos).then((value) => {
      setState(() {
            vuelos = value;
            isLoading = false;
        })
    });
    
  }



  @override
  Widget build(BuildContext context) {
    


    return Scaffold(
      appBar: AppBar(title: Text(placeholder)),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),

        child: vuelos.length == 0 ? 
        
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Text("No existen vuelos", style: GoogleFonts.ubuntu(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(175, 107, 28, 172)
            ))
            
          ),
        ) 
        
        
        
        : Column(
          
          children: [
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 22.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("${widget.origen!.name} (${widget.origen!.city})", style: TextStyle(
                        fontSize: 22
                      ),
                      textAlign: TextAlign.center,),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                    child: Divider(thickness: 2, color: Colors.black),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("${widget.destino!.name} (${widget.destino!.city})", style: TextStyle(
                        fontSize: 22),
                        textAlign: TextAlign.center
                              ),
                    ),
                  ),
                ],
              ),
            )
            ,
            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 8.0, right: 8.0,),
              child: 
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: vuelos.length,
                  itemBuilder: _itemBuilder,
                  ),
              
            ),
            Visibility(visible: isLoading, child: CircularProgressIndicator())
              
            
            
          ],
        ),
      ),
    );
  }

   Widget _itemBuilder(BuildContext context, int index) {


    return InkWell(
      onTap: () async {
        print("LA VUELTA ES: "+widget.vuelta!);
        if(firebaseAuth.currentUser == null){
          showDialog(
            context: context, 
            builder: (BuildContext context){
              return AlertDialog(
                title: Text(
                  "No has iniciado sesión",
                  style: TextStyle(fontWeight: FontWeight.bold)),
                icon: Icon(Icons.warning_amber_rounded, size: 36),
                iconColor: Colors.amber,
              );
            }
          );
        }
        else{
          if(ida == null && compra == false){
            final int id = Random().nextInt(10000 - 1)+1;

            final qrValidationResult = QrValidator.validate(
            data: "id: ${id}\n origen: ${widget.origen!.name}\n destino: ${widget.destino!.name}\n fecha: ${vuelos[index]['fecha']}\n hora_salida: ${vuelos[index]['hora_salida']}\n hora_llegada: ${vuelos[index]['hora_llegada']}\n precio: ${vuelos[index]['precio']}\n email: ${firebaseAuth.currentUser!.email}",
            version: QrVersions.auto,
            errorCorrectionLevel: QrErrorCorrectLevel.L,
            );

            final qrCode = qrValidationResult.qrCode;
            final painter = QrPainter.withQr(
              qr: qrCode!,
              color: const Color(0xFF000000),
              gapless: true,
              embeddedImageStyle: null,
              embeddedImage: null,
            );

            final picData = await painter.toImageData(2048, format: ui.ImageByteFormat.png);
            Uint8List codigoQr = convertQrToImage(picData!);

            ida = Billete(id, widget.destino!, widget.origen!, vuelos[index]['fecha'],
            vuelos[index]['hora_llegada'], vuelos[index]['hora_salida'], codigoQr, vuelos[index]['precio'], firebaseAuth.currentUser!.email);
            
            placeholder = "Vuelta";
            setState(() {
              getVuelos(widget.destino, widget.origen, widget.vuelta, widget.adultos);
            });
            

            if(widget.vuelta == "null"){
                compra = true;
                vuelta = ida;
                PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: CompraView(ida!, vuelta!),
                withNavBar: true, 
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            }

          }
          else if(widget.vuelta != "null" && vuelta == null && compra == false){
            print("ENTRA EN LA VUELTA");
            final int id = Random().nextInt(10000 - 1)+1;

              final qrValidationResult = QrValidator.validate(
              data: "id: ${id}\n origen: ${widget.destino!.name}\n destino: ${widget.origen!.name}\n fecha: ${vuelos[index]['fecha']}\n hora_salida: ${vuelos[index]['hora_salida']}\n hora_llegada: ${vuelos[index]['hora_llegada']}\n precio: ${vuelos[index]['precio']}\n email: ${firebaseAuth.currentUser!.email}",
              version: QrVersions.auto,
              errorCorrectionLevel: QrErrorCorrectLevel.L,
              );

              final qrCode = qrValidationResult.qrCode;
              final painter = QrPainter.withQr(
                qr: qrCode!,
                color: const Color(0xFF000000),
                gapless: true,
                embeddedImageStyle: null,
                embeddedImage: null,
              );

              final picData = await painter.toImageData(2048, format: ui.ImageByteFormat.png);
              Uint8List codigoQr = convertQrToImage(picData!);

              vuelta = Billete(id, widget.origen!, widget.destino!, vuelos[index]['fecha'],
              vuelos[index]['hora_llegada'], vuelos[index]['hora_salida'], codigoQr, vuelos[index]['precio'], firebaseAuth.currentUser!.email);

              
              compra = true;
              
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: CompraView(ida!, vuelta!),
                withNavBar: true, 
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
          }
          
        }

        
      },
      child: Container(
        height: 150,
        child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
            color: Color.fromARGB(175, 107, 28, 172),
            elevation: 20,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        vuelos[index]['hora_salida'],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 20
                          
                        ),
                        textAlign: TextAlign.left
                    ),
                    Expanded(child: Divider(thickness: 2, color: Colors.black), flex: 30),
                    Icon(
                      Icons.airplane_ticket,
                      size: 40 
                    ),
                    Expanded(child: Divider(thickness: 2, color: Colors.black), flex: 30),
                    Text(
                      vuelos[index]['hora_llegada'],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 20
            
                        
                      ),
                      textAlign: TextAlign.left
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 80.0, right: 10.0),
                      child: Text(
                        "${vuelos[index]['precio'].toString()}€",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 26
                                
                          
                        ),
                        textAlign: TextAlign.left
                      ),
                    ),
                  ],
                ),
            ),
            
        ),
      ),
    );
  }
}



