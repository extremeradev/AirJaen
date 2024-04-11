// ignore_for_file: prefer_const_constructors, prefer_if_null_operators, use_build_context_synchronously

import 'package:airjaen/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'LoggedView.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({super.key});

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  bool terminos = false;
  TextEditingController emailController = TextEditingController(text:"");
  TextEditingController pwController = TextEditingController(text:"");
  TextEditingController nombreController = TextEditingController(text:"");
  TextEditingController confirmPwController = TextEditingController(text:"");
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Perfil')),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
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
              Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                      child: TextFormField(
                        controller: nombreController,
                          readOnly: firebaseAuth.currentUser!.emailVerified,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: firebaseAuth.currentUser!.displayName != null ? firebaseAuth.currentUser!.displayName : "Nombre de usuario"
                            
                          ),
                          validator: (text){
                            if( text == null || text.isEmpty){
                              return 'El campo no puede estar vacío';
                            }
                            else if( text.length < 3 ){
                              return 'El campo mínimo requiere 3 caracteres';
                            }
                            return null;
                          },
                      
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15),
                child: TextFormField(
                  readOnly: firebaseAuth.currentUser!.emailVerified,
                  controller: emailController,
                  
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: firebaseAuth.currentUser!.email,
                      
                  ),
                  validator: (text){
                      if( text == null || text.isEmpty){
                        return 'El campo no puede estar vacío';
                      }
                      else if( text.length < 8 ){
                        return 'El campo mínimo requiere 8 caracteres';
                      }
                      else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(text)){
                        return "El correo no es válido";
                      }
                      return null;
                    },
                
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0,top: 15),
                child: TextFormField(
                readOnly: firebaseAuth.currentUser!.emailVerified,
                obscureText: true,
                  controller: pwController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Contraseña"
                  ),
                  validator: (text){
                      if( text == null || text.isEmpty){
                        return 'El campo no puede estar vacío';
                      }
                      else if( text.length < 8 ){
                        return 'El campo mínimo requiere 8 caracteres';
                      }
                      return null;
                    },
                
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15, ),
                child: TextFormField(
                  readOnly: firebaseAuth.currentUser!.emailVerified,
                  obscureText: true,
                  controller: confirmPwController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Repita la contraseña"
                  ),
                  validator: (text){
                      if( text == null || text.isEmpty){
                        return 'El campo no puede estar vacío';
                      }
                      else if( text.length < 8 ){
                        return 'El campo mínimo requiere 8 caracteres';
                      }
                      else if( pwController.text !=  text){
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                
                ),
              ),
              firebaseAuth.currentUser!.emailVerified == true ? Text("Las cuentas registradas con Google no se pueden actualizar.", style: TextStyle(color: Colors.redAccent)) : Text(""),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  onPressed: () async {
                    
                    await updateUser(emailController.text, pwController.text, nombreController.text);
                    setState(() {
                      Navigator.pop(context);
                      
                  
                    });
                    
                    
                  },
                  child: Text("Actualizar")
                ),
              )
            ]
            ),
          ),
        ),
      )
    );
  }
}