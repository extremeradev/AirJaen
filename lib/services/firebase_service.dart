// ignore_for_file: unnecessary_new, deprecated_member_use, avoid_returning_null_for_void, avoid_print, unused_local_variable, nullable_type_in_catch_clause, unnecessary_string_interpolations

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:airjaen/models/Airport.dart';
import 'package:airjaen/models/Billete.dart';
import 'package:airjaen/services/send_email_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = new GoogleSignIn();
final storage = FirebaseStorage.instance;

Future<void> createUser(String emailAddress, String password, String nombre) async {
  try {
    await firebaseAuth.createUserWithEmailAndPassword(email: emailAddress, password: password);
    await firebaseAuth.currentUser!.updateDisplayName(nombre);
  } catch(e) {
    print(e.toString());
    return null;
  }
  CollectionReference users = await FirebaseFirestore.instance.collection('users');
  users.add({
    'email': emailAddress,
  });
}

Future<void> updateUser(String emailAddress, String password, String nombre) async {
  try {
    await firebaseAuth.currentUser!.updateDisplayName(nombre);
    await firebaseAuth.currentUser!.updateEmail(emailAddress);
    await firebaseAuth.currentUser!.updatePassword(password);
  } catch(e) {
    print(e.toString());
    return null;
  }
}

Future <void> logInUser(String emailAddress, String password) async{
  String? user = firebaseAuth.currentUser?.toString();
  print(user);
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
}


bool checkLogin() {
  bool state = false;
 
  print(FirebaseAuth.instance.currentUser.toString());
  if(FirebaseAuth.instance.currentUser != null){
    return true;
  }else{
    return false;
  }

}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Future<void> signOutWithGoogle() async {
  // Sign out with firebase
  await firebaseAuth.signOut();
  // Sign out with google
  await googleSignIn.signOut();

}


Future <void> logOut() async {
  await FirebaseAuth.instance.signOut();
}


Future<List> getFlies(Airport? origen, Airport? destino, String? fecha, String? adultos) async{
  List flies = [];

  QuerySnapshot queryUsers = await db.collection("vuelos").get();
  
  for( var doc in queryUsers.docs){
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final vuelo = {
      "destino": data['destino'],
      "origen": data['origen'],
      "fecha": data['fecha'],
      "hora_llegada": data['hora_llegada'],
      "hora_salida": data['hora_salida'],
      "precio": data['precio'],
      
      };

    if(vuelo['origen'] == origen!.name && vuelo['destino'] == destino!.name && vuelo['fecha'] == fecha){
      flies.add(vuelo);
    }

  }
 return flies;
}

Future<void> addBillete(String? email, Billete billete) async{

  QuerySnapshot queryUsers = await db.collection("users").get();
  for( var doc in queryUsers.docs){
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    if(data['email'] == email){
      final bil = {
        "origen": billete.origen.name,
        "destino": billete.destino.name,
        "fecha": billete.fecha,
        "hora_salida": billete.hora_salida,
        "hora_llegada": billete.hora_llegada,
        "id": billete.id,
        "precio": billete.precio,
        "email": billete.email,

      };
      await db.collection("users").doc(doc.id).collection("billetes").add(bil).then((value) async {
        subirFoto(billete.qrCode, billete, value.id);

      });

    }


  }
}

void subirFoto(Uint8List data, Billete billete, String idBillete) async {
  final storageRef = FirebaseStorage.instance.ref();
  final mountainsRef = storageRef.child("${billete.email}/${idBillete}.jpg");

  
  await mountainsRef.putData(data);
   

}

Uint8List convertQrToImage(ByteData data){
  final buffer = data.buffer;
  var list = buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

  return list;   

}

Future<List> listarMisBilletes() async{
  List codigos = [];
  if(firebaseAuth.currentUser != null){
    final storageRef = FirebaseStorage.instance.ref().child("${firebaseAuth.currentUser!.email}/");
    QuerySnapshot queryUsers = await db.collection("users").get();
    final listResult = await storageRef.listAll();
    
    for (var item in listResult.items) {
      final islandRef = storageRef.child("${item.name}");

      for( var doc in queryUsers.docs){
          final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          
          await db.collection("users").doc(doc.id).collection("billetes").get().then((value) async {
            for(var dok in value.docs){
              if(dok.id+".jpg" == item.name){
                final Map<String, dynamic> data = dok.data() as Map<String, dynamic>;
                const oneMegabyte = 1024 * 1024;
                final Uint8List? qr = await islandRef.getData(oneMegabyte);
                Billete billete = new Billete(0, new Airport(name: data['destino'], city: " ", country: " "), new Airport(name: data['origen'], city: " ", country:" "), data['fecha'], data['hora_llegada'], data['hora_salida'],
                qr!, data['precio'], firebaseAuth.currentUser?.email);

                codigos.add(billete);
              }
            }
          });
    }
  
      
  }
  }
  return codigos;



}

