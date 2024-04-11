// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, sort_child_properties_last, unused_field, prefer_final_fields, unused_import, must_call_super, no_logic_in_create_state, prefer_interpolation_to_compose_strings, avoid_print, use_build_context_synchronously, await_only_futures, unnecessary_new

import 'dart:math';

import 'package:airjaen/main.dart';
import 'package:airjaen/models/City.dart';
import 'package:airjaen/pages/home_page.dart';
import 'package:airjaen/services/firebase_service.dart';
import 'package:airjaen/services/send_email_service.dart';
import 'package:airjaen/services/weather_service.dart';
import 'package:airjaen/views/LoggedView.dart';
import 'package:airjaen/views/RegistroWindow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:airjaen/firebase/firebase_options.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';


class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();


}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailResetController = TextEditingController(text:"");
  String _emailReset = "";
  final _formReset = GlobalKey<FormState>();
  
  TextEditingController emailController = TextEditingController(text:"");
  TextEditingController pwController = TextEditingController(text:"");
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  bool _passwordVisible = false;
  bool _logged = false;
  bool loading = false;
  String? nombre;
  String? email;

  @override
  void initState(){
    _passwordVisible = false;
    comprobarUsuario();

  }


  Future<void> comprobarUsuario() async {
    print("COMPRUEBA EL USUARIO");
    if(firebaseAuth.currentUser != null){
      nombre = await firebaseAuth.currentUser!.displayName;
      email = await firebaseAuth.currentUser!.email;
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      await logInUser(emailController.text, pwController.text).then((value) {
        if(firebaseAuth.currentUser == null){
          showDialog(
            context: context, 
            builder: (BuildContext context){
              return AlertDialog(
                title: Text(
                  "Correo electrónico o contraseña incorrectos.",
                  style: TextStyle(fontWeight: FontWeight.bold)),
                icon: Icon(Icons.warning_amber_rounded, size: 36),
                iconColor: Colors.amber,
              );
            }
          );
        }
      });
      setState(() {
        
      });
      print("funxiona");
    }else{
      print("SI HAY ERRORES");
    }
  }


@override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: comprobarUsuario(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot){ 
        if(firebaseAuth.currentUser==null){
          return login(context);
        } else{
          return LoggedView();
        }
    }
    );

  }


  @override
  Widget login(BuildContext context) {
    BuildContext context2 = context;
    return 
      Container(
    
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                  Image.asset(
                    'assets/airjaen-logo-sinfondo.png',
                    fit: BoxFit.contain,
                    height: 230,
                  )
                ,
                Form(
                    key: _formKey,
        
                  
                  
                    child: Column(
        
                      children: [
        
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'E-mail'
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
                            onChanged: (text) => setState(() => _email = text,),
                          ),
                        ),
        
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            obscureText: !_passwordVisible,
                            controller: pwController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: (){
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                }
                              )
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
                            onChanged: (text) => setState(() => _password = text,),
                            
                          ),
                        ),
                        InkWell(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  child: Text(
                                    "¿Has olvidado tu contraseña?",
                                    style: TextStyle(color: Theme.of(context).primaryColorDark),
                                  
                                  ),
                                  onPressed: (){
                                    showDialog(
                                    context: context, 
                                    builder: (BuildContext context){
                                      return AlertDialog(
                                        title: Text("Introduzca su correo electrónico.")
                                        ,
                                        content: Form(
                                          key: _formReset,
                                          child: TextFormField(
                                            controller: emailResetController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'E-mail'
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
                                            onChanged: (text) => setState(() => _emailReset = text,),
                                          ),
                                        ),
                                        icon: Icon(Icons.question_mark, size: 36),
                                        iconColor: Colors.amber,
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              if (_formReset.currentState!.validate()) {
                                                print(emailResetController.text);
                                                FirebaseAuth.instance.sendPasswordResetEmail(email: emailResetController.text.trim());
                                              }else{

                                              }
                                            }, 
                                            child: Text("Enviar")
                                          ),
                                        ]
                                      );
                                    }
                                  );
                                    setState(() {
                                      
                                    });
                                  },
                                )
                                
                              ),
                              
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  child: Text(
                                    "¿No tienes cuenta? ¡Regístrate!",
                                    style: TextStyle(color: Theme.of(context).primaryColorDark),
                                  
                                  ),
                                  onPressed: (){
                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: RegistroWindow(),
                                      withNavBar: true, // OPTIONAL VALUE. True by default.
                                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                    ).then((value) {
                                      setState(() {
                                        
                                      });
                                    });
                                    setState(() {
                                      
                                    });
                                  },
                                )
                                
                              ),
                              
                            ],
                          )
                        ),
                          
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            child: Text("Enviar"),
                            onPressed: _email.isNotEmpty ? _submit : null,
                          )
                          
                        ),
    
                        SignInButton(
                          onPressed: () async {
                            loading = true;
                            
                            await signInWithGoogle().then((value) {
                                setState(() {
                                  
                                });
                            }
                            );
    
                            loading = false;
                          },//signInWithGoogle, 
                          Buttons.Google,
                        ),
                        loading ? CircularProgressIndicator() : Text(""),
                        
                      ],
    
                      
                    ),
                    
                    
                  
                
                ),
              ],
            ),
          ),
        )
      
      );
    

  }


  void _reset(){
    if (_formReset.currentState!.validate()) {
      Navigator.of(context).pop();
    }else{
      print("HAY ERRORE");
    }
  }
  
  
}