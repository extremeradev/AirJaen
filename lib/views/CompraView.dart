// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new, no_leading_underscores_for_local_identifiers, unused_element, empty_catches

import 'dart:convert';
import 'dart:ui';
import 'package:airjaen/models/Billete.dart';
import 'package:airjaen/services/firebase_service.dart';
import 'package:airjaen/views/MisViajesView.dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';

import 'package:qr_flutter/qr_flutter.dart';

import '../models/Airport.dart';
import '../services/send_email_service.dart';

class CompraView extends StatefulWidget {
  final Billete ida;
  final Billete vuelta;


  const CompraView(this.ida, this.vuelta, {super.key});

  

  @override
  State<CompraView> createState() => _CompraViewState();
}

class _CompraViewState extends State<CompraView> {

  TextEditingController cardNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future<Image>? image;

  @override
  Widget build(BuildContext context) {
    

    void _submit() async {
      if (_formKey.currentState!.validate()) {
        
        
        if(widget.vuelta.fecha == widget.ida.fecha ){
          String message = "has realizado la compra satisfactoriamente de billetes en AirJaén, consulta en nuestra app tu reciente compra.";
          addBillete(firebaseAuth.currentUser!.email, widget.ida);
          await enviarEmail(firebaseAuth.currentUser!.displayName, firebaseAuth.currentUser!.email, "Compra de billetes en AirJaén.", message);

        }else{
          String message = "has realizado la compra satisfactoriamente de billetes en AirJaén, consulta en nuestra app tu reciente compra.";
          addBillete(firebaseAuth.currentUser!.email, widget.ida);
          addBillete(firebaseAuth.currentUser!.email, widget.vuelta);
          await enviarEmail(firebaseAuth.currentUser!.displayName, firebaseAuth.currentUser!.email, "Compra de billetes en AirJaén.", message);

        }

        showDialog(
          context: context, 
          builder: (BuildContext context){
            return AlertDialog(
              title: Text(
                "Has realizado la compra con éxito.",
                style: TextStyle(fontWeight: FontWeight.bold)),
              icon: Icon(Icons.check_box, size: 36),
              iconColor: Color.fromARGB(255, 0, 172, 51),
            );
          }
        );
        Navigator.pop(context);
        Navigator.pushNamed(context, '/');
        
        

      
      }else{
        print("SI HAY ERRORES");
      }
    }

    


    return Scaffold(
      appBar: AppBar(title: Text("Datos bancarios")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.asset(
                'assets/pngegg.png',
                fit: BoxFit.cover,
                width: 240,
                height: 240,
              ),
              
              
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Nombre del titular",
                          prefixIcon: Icon(Icons.person)
                        ),
                        validator: (text) {
                          if(text!.isEmpty){
                            return "El campo no puede estar vacío";
                          }
                          else if(text.length <= 3){
                            return "El campo requiere mínimo 4 caracteres";
                          }
                        },
                      ),
                    )
                    ,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(19),
                          CardNumberInputFormatter(),
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Número de tarjeta",
                          prefixIcon: Icon(Icons.credit_card)
                        ),
                        validator: (text) {
                          if(text!.isEmpty){
                            return "El campo no puede estar vacío";
                          }
                          else if(text.length < 23){
                            return "El campo requiere 19 caracteres";
                          }
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "CVV",
                                prefixIcon: Icon(Icons.credit_score_outlined),
                              ),
                              validator: (text) {
                              if(text!.isEmpty){
                                return "El campo no puede estar vacío";
                              }
                              else if(text.length < 3){
                                return "El campo requiere 3 caracteres";
                              }
                            },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                                CardMonthInputFormatter(),
                              ],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "MM/YY",
                                prefixIcon: Icon(Icons.calendar_month_outlined),
                              ),
                              validator: (text) {
                              if(text!.isEmpty){
                                return "El campo no puede estar vacío";
                              }
                              
                            },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 28.0),
                      child: ElevatedButton(
                        onPressed: (){
                          _submit();
                        }, 
                        child: Text("Aceptar compra")
                      ),
                    ),
                    
                  ]
                ),
              )
            ],
            ),
        ),
      )
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter{
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, TextEditingValue newValue){
      if(newValue.selection.baseOffset == 0){
        return newValue;
      }
      
      String inputData = newValue.text;
      StringBuffer buffer = StringBuffer();

      for(var i = 0; i<inputData.length; i++){
        buffer.write(inputData[i]);
        int index = i+1;

        if (index % 4 == 0 && inputData.length != index){
          buffer.write(" ");
        }
      }

      return TextEditingValue(
        text: buffer.toString(),
        selection: TextSelection.collapsed(
          offset: buffer.toString().length,
        )
        );

    }
}

class CardMonthInputFormatter extends TextInputFormatter{
  @override 
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, TextEditingValue newValue){
      var newText = newValue.text;

    if(newValue.selection.baseOffset == 0){
      return newValue;
    }

    var buffer = StringBuffer();
    for(int i = 0; i<newText.length; i++){
      buffer.write(newText[i]);
      var nonZeroIndex = i + 1;
      if(nonZeroIndex % 2 == 0 && nonZeroIndex != newText.length){
        buffer.write('/');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length)
    );



    
    }
  
  
}