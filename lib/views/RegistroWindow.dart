// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, avoid_print, unused_field, prefer_final_fields, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:airjaen/services/firebase_service.dart';
import 'package:airjaen/services/send_email_service.dart';
import 'package:airjaen/views/LoggedView.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class RegistroWindow extends StatefulWidget {
  const RegistroWindow({super.key});

  @override
  State<RegistroWindow> createState() => _RegistroWindowState();
}

class _RegistroWindowState extends State<RegistroWindow> {

  bool terminos = false;
  TextEditingController emailController = TextEditingController(text:"");
  TextEditingController pwController = TextEditingController(text:"");
  TextEditingController nombreController = TextEditingController(text:"");
  TextEditingController confirmPwController = TextEditingController(text:"");
  final _formKey = GlobalKey<FormState>();
  String _email = "";

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      await createUser(emailController.text, pwController.text, nombreController.text).then((value) async {
        String message = "te has registrado correctamente en AirJaén.";
        Navigator.pop(context);
        await enviarEmail(firebaseAuth.currentUser!.displayName, firebaseAuth.currentUser!.email, "Registro en AirJaén.", message);
      });
      

     
    }else{
      print("SI HAY ERRORES");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(
                    'assets/airjaen-logo-sinfondo.png',
                    fit: BoxFit.contain,
                    height: 150,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: nombreController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Nombre de usuario"
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
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "E-mail"
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
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
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
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
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
                  CheckboxFormField(
                    title: Text("Acepto los términos y condiciones."),
                    //checkColor: Colors.white,
                    initialValue: terminos,
                    validator:(value){
                      if(value == false){
                        return 'Debes aceptar las condiciones y términos';
                      }
                      return null;
                    },
                    /*onChanged: (bool? value) {
                      setState(() {
                        terminos = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,*/
                  ),
                  
                  ElevatedButton(
                    
                    child: Text("Registrarse"),
                    onPressed: (){
                      
                      
                      setState(() {
                        _submit();
                      });
                      
                    },
                    ),
                  
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}


class CheckboxFormField extends FormField<bool> {
  CheckboxFormField(
      {Widget? title,
      FormFieldSetter<bool>? onSaved,
      FormFieldValidator<bool>? validator,
      bool initialValue = false,
      bool autovalidate = false})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<bool> state) {
              return CheckboxListTile(
                dense: state.hasError,
                title: title,
                value: state.value,
                onChanged: state.didChange,
                subtitle: state.hasError
                    ? Builder(
                        builder: (BuildContext context) => Text(
                          state.errorText ?? "",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                        ),
                      )
                    : null,
                controlAffinity: ListTileControlAffinity.leading,
              );
            });
}