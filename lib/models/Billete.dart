// ignore_for_file: prefer_initializing_formals, non_constant_identifier_names
import 'dart:typed_data';

import 'package:airjaen/models/Airport.dart';

class Billete{
  late int id;
  late int precio;
  late Airport destino;
  late Airport origen;
  late String fecha;
  late String hora_llegada;
  late String hora_salida;
  late String? email;
  late Uint8List qrCode;

  Billete(int id, Airport destino, Airport origen, String fecha, String hora_llegada, String hora_salida, Uint8List qrCode, int precio, String? email){
    this.id = id;
    this.origen = origen;
    this.destino = destino;
    this.fecha = fecha;
    this.hora_llegada = hora_llegada;
    this.hora_salida = hora_salida;
    this.qrCode = qrCode;
    this.precio = precio;
    this.email = email;
  }

  

}