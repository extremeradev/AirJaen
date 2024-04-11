// ignore_for_file: file_names, prefer_initializing_formals

import 'Billete.dart';

class Usuario{
  
  late String email;
  late List billetes = [];

  Usuario(String email, List billetes){
    this.email = email;
    this.billetes = billetes;
  }

}