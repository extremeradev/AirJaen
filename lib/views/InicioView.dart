// ignore_for_file: prefer_const_constructors, unused_field, prefer_final_fields, sort_child_properties_last, prefer_const_literals_to_create_immutables, unused_local_variable, unrelated_type_equality_checks, prefer_interpolation_to_compose_strings

import 'package:airjaen/models/Airport.dart';
import 'package:airjaen/search/CitySearchDelegate.dart';
import 'package:airjaen/services/firebase_service.dart';
import 'package:airjaen/views/BusquedaVuelosView.dart';
import 'package:airjaen/views/LoggedView.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

const List<String> list = <String>['Un adulto', 'Dos adultos', 'Tres adultos', 'Cuatro adultos', 'Cinco adultos',
'Seis adultos', 'Siete adultos', 'Ocho adultos', 'Nueve adultos'];
String? selectedValue;


class InicioView extends StatefulWidget {
  const InicioView({super.key, this.restorationId});

  final String? restorationId;

  @override
  State<InicioView> createState() => _InicioViewState();
}

class _InicioViewState extends State<InicioView> with RestorationMixin{

  List<bool> _selectedOption = <bool>[true, false];
  List<Widget> opciones = <Widget>[
    Text('Ida'),
    Text('Ida y Vuelta')
  ];
  Airport? origenSeleccionado = new Airport(city: "", country: "", name: "");
  Airport? destinoSeleccionado = new Airport(city: "", country: "", name: "");
  String? _selectedAdultos = "null";

  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate =
      RestorableDateTime(DateTime(2021, 7, 25));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  final RestorableDateTime _selectedDateVuelta =
      RestorableDateTime(DateTime(2021, 7, 25));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFutureVuelta =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDateVuelta,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDateVuelta.value.millisecondsSinceEpoch,
      );
    },
  );

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2021),
          lastDate: DateTime(2022),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(_selectedDateVuelta, 'selected_date_vuelta');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
        registerForRestoration(
        _restorableDatePickerRouteFutureVuelta, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));
      });
    }
  }

  void _selectDateVuelta(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDateVuelta.value = newSelectedDate;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));
      });
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          child: Center(
            child: Column(
              children: [
                Image.asset(
                    'assets/fondo_avion.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 160,
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: ToggleButtons(
                    children: opciones, 
                    isSelected: _selectedOption,
                    direction: Axis.horizontal,
                    onPressed: (int index){
                      setState(() {
                        for (int i = 0; i< _selectedOption.length; i++){
                          _selectedOption[i] = i == index;
                        }
                      });
                    },
                    fillColor: Color.fromARGB(175, 107, 28, 172),
                    selectedColor: Colors.white,
                    selectedBorderColor: Color.fromARGB(255, 156, 156, 156),
                    constraints: const BoxConstraints(
                        minHeight: 40.0,
                        minWidth: 120.0,
                        
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    textStyle: TextStyle(
                      fontSize: 17,
                    ),
                    
                
                  ),
                ),
                Container(
                  width: 300,
                  height: 370,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(175, 107, 28, 172)
    
                    
                    
                  ),
                  child: _selectedOption[0] ? 
    
                    Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                  
                                  child:
                                  Container(
                                    width: 150,
                                    //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 20),
                                            child: TextButton.icon(
                                              icon: Icon(Icons.home_outlined, color: Color.fromARGB(255, 0, 0, 0)),
                                              label: Text("Origen", 
                                                style: TextStyle(
                                                  height: 1.5,
                                                  shadows: [
                                                    Shadow(
                                                        color: Color.fromARGB(255, 255, 255, 255),
                                                        offset: Offset(0, -5))
                                                  ],
                                                  fontSize: 20,
                                                  color: Colors.transparent,
                                                  decoration: TextDecoration.underline,
                                                  decorationColor: Colors.white,
                                                  
                                                ), 
                                              ),
                                              onPressed: () async {
                                                
                                                Airport? origen = await showSearch(
                                                  context: context, 
                                                  delegate: CitySearchDelegate()
                                                );
                                  
                                                setState(() {
                                                  origenSeleccionado = origen;
                                                });
                                                
                                              },
                                              
                                            ),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            if(origenSeleccionado?.city != "")
                                              Container(
                                                child: Stack(
                                                  children: [
                                                    
                                                    Align(
                                                      alignment: Alignment.center,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                                                        child: Text(origenSeleccionado!.country+" - " +origenSeleccionado!.city, style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white
                                                        ),
                                                        textAlign: TextAlign.center,),
                                                      ),
                                                    ),
                                                    
                                                    Align(
                                                      alignment: Alignment.bottomRight,
                                                      
                                                        
                                                      child: Icon(
                                                        Icons.flight_takeoff,
                                                        color: Color.fromARGB(255, 255, 255, 255)
                                                      ),
                                                        
                                                      
                                                  )
                                                  ],
                                                ),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    gradient: LinearGradient(
                                                  colors: <Color>[
                                                    Color.fromARGB(122, 177, 177, 177),
                                                    Color.fromARGB(122, 177, 177, 177),
                                                  ],
                                                  ),
                                                  ),
                                                width: 150.0,
                                                 
                                              ),
                                            
                                              
                                            
                                            
                                          ],
                                        ),
    
                                        
                                      ],
                                    ),
                                  ),
                                  
                                  
                                  
    
    
                                
                              
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
    
                              child: Container(
                                width: 150,
                                //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                                child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.topCenter,
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom: 20),
                                              child: TextButton.icon(
                                                icon: Icon(Icons.airplanemode_active, color: Color.fromARGB(255, 0, 0, 0)),
                                                label: Text("Destino", 
                                                  style: TextStyle(
                                                    height: 1.5,
                                                    shadows: [
                                                      Shadow(
                                                          color: Color.fromARGB(255, 255, 255, 255),
                                                          offset: Offset(0, -5))
                                                    ],
                                                    fontSize: 20,
                                                    color: Colors.transparent,
                                                    decoration: TextDecoration.underline,
                                                    decorationColor: Colors.white,
                                                    
                                                  ), 
                                                ),
                                                onPressed: () async {
                                                      
                                                      Airport? destino = await showSearch(
                                                        context: context, 
                                                        delegate: CitySearchDelegate()
                                                      );
                                                    
                                                      setState(() {
                                                        destinoSeleccionado = destino;
                                                      });
                                                      
                                                    },
                                                
                                              ),
                                            ),
                                          ),
                                                    
                                          Column(
                                            children: [
                                              if(destinoSeleccionado?.city != "")
                                                Container(
                                                  child: Stack(
                                                    children: [
                                                      Align(
                                                        alignment: Alignment.bottomLeft,
                                                        child: Icon(
                                                            Icons.flight_land,
                                                            color: Color.fromARGB(255, 255, 255, 255)
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment.center,
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                                                          child: Text(destinoSeleccionado!.country+" - " +destinoSeleccionado!.city, style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white
                                                            
                                                          ),
                                                          ),
                                                        ),
                                                      ),
                                                      
                                                    ],
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    gradient: LinearGradient(
                                                  colors: <Color>[
                                                    Color.fromARGB(130, 177, 177, 177),
                                                    Color.fromARGB(130, 177, 177, 177),
                                                  ],
                                                  ),
                                                  ),
                                                  width: 150.0,
                                                ),
                                              
                                              
                                            ],
                                          ),
                                          
                                        ],
                                      ),
                                      
                              ),
                            ),
    
    
                              
                          ],
                        ),
    
                        Center(
                          child: OutlinedButton(onPressed: () {
                            _restorableDatePickerRouteFuture.present();
                          },
                          child: Text("FECHA IDA", style: TextStyle(
                            fontSize: 18,
                            color: Colors.white
                          ))),
                          
                        ),
    
                        Text(_selectedDate.value.day.toString()+"/"+_selectedDate.value.month.toString()+
                        "/"+_selectedDate.value.year.toString(), style: TextStyle(
                          fontSize: 18,
                          color: Colors.white
                        ),),
    
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              
                              hint: Text("Adultos", style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              )), items: list
                                    .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white
                                      ),
                                    ),
                                  ))
                                          .toList(),
                                  value: selectedValue,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue = value as String;
                                      _selectedAdultos = selectedValue;
                                    });
                                  },
                                  buttonStyleData: const ButtonStyleData(
                                    height: 50,
                                    width: 170,
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    decoration: BoxDecoration(
                                      color: Colors.black
                                    )
                                  ),
                                ),
                                
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 28.0),
                          child: ElevatedButton(onPressed: (){
                            if(origenSeleccionado!.name == "" || destinoSeleccionado!.name == ""){
                              showDialog(
                                context: context, 
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    title: Text(
                                      "No has seleccionado destino u origen.",
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                    icon: Icon(Icons.warning_amber_rounded, size: 36),
                                    iconColor: Colors.amber,
                                  );
                                }
                              );
                            
                            }
                            else if(_selectedAdultos == "null"){
                            showDialog(
                                context: context, 
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    title: Text(
                                      "No has seleccionado número de adultos.",
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                    icon: Icon(Icons.warning_amber_rounded, size: 36),
                                    iconColor: Colors.amber,
                                  );
                                }
                              );
                            }
                            else{
                              String ida = _selectedDate.value.day.toString()+"/"+_selectedDate.value.month.toString()+
                                "/"+_selectedDate.value.year.toString();
    
                              PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen: BusquedaVuelos(origen: origenSeleccionado, destino: destinoSeleccionado, ida: ida, vuelta: "null", adultos: _selectedAdultos),
                                    withNavBar: true,
                                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                              );
                            }
    
                            
                          }, child: Text("Buscar vuelos")),
                        )
                      ],
                    )
    
                  
                  
                  
                  
                  
                  
                  
                   : getIdaYVuelta(),
      
                ),
                Padding(
                          padding: const EdgeInsets.only(left: 60, top: 30.0, right: 1, bottom: 20),
                          child: Row(
                              children: [
                                Container(
                                  
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                
                                      Text("Alejandro López Extremera", style: GoogleFonts.ubuntu(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontWeight: FontWeight.bold
                                      )),
                                      Text("IES Virgen del Carmen", style: GoogleFonts.ubuntu(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold
                                      )),
                                      Text("Desarrollo de aplicaciones multiplataforma", style: GoogleFonts.ubuntu(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold
                                      )),
                                    
                                    ]
                                  ),
                                )
                              ],
                              
                            ),
                          
                        ),
              ],
              
      
            
          ),)
        ),
      ),
    );
  }


Widget getIdaYVuelta(){
  return Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                
                                child:
                                Container(
                                  width: 150,
                                  //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 20),
                                          child: TextButton.icon(
                                            icon: Icon(Icons.home_outlined, color: Color.fromARGB(255, 0, 0, 0)),
                                            label: Text("Origen", 
                                              style: TextStyle(
                                                height: 1.5,
                                                shadows: [
                                                  Shadow(
                                                      color: Color.fromARGB(255, 255, 255, 255),
                                                      offset: Offset(0, -5))
                                                ],
                                                fontSize: 20,
                                                color: Colors.transparent,
                                                decoration: TextDecoration.underline,
                                                decorationColor: Colors.white,
                                                
                                              ), 
                                            ),
                                            onPressed: () async {
                                              
                                              Airport? origen = await showSearch(
                                                context: context, 
                                                delegate: CitySearchDelegate()
                                              );
                                
                                              setState(() {
                                                origenSeleccionado = origen;
                                              });
                                              
                                            },
                                            
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          if(origenSeleccionado?.city != "")
                                            Container(
                                              child: Stack(
                                                children: [
                                                  
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                                                      child: Text(origenSeleccionado!.country+" - " +origenSeleccionado!.city, style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white
                                                      ),
                                                      textAlign: TextAlign.center,),
                                                    ),
                                                  ),
                                                  
                                                  Align(
                                                    alignment: Alignment.bottomRight,
                                                    
                                                      
                                                    child: Icon(
                                                      Icons.flight_takeoff,
                                                      color: Color.fromARGB(255, 255, 255, 255)
                                                    ),
                                                      
                                                    
                                                )
                                                ],
                                              ),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  gradient: LinearGradient(
                                                colors: <Color>[
                                                  Color.fromARGB(122, 177, 177, 177),
                                                  Color.fromARGB(122, 177, 177, 177),
                                                ],
                                                ),
                                                ),
                                              width: 150.0,
                                               
                                            ),
                                          
                                            
                                          
                                          
                                        ],
                                      ),

                                      
                                    ],
                                  ),
                                ),
                                
                                
                                


                              
                            
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),

                            child: Container(
                              width: 150,
                              //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                              child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 20),
                                            child: TextButton.icon(
                                              icon: Icon(Icons.airplanemode_active, color: Color.fromARGB(255, 0, 0, 0)),
                                              label: Text("Destino", 
                                                style: TextStyle(
                                                  height: 1.5,
                                                  shadows: [
                                                    Shadow(
                                                        color: Color.fromARGB(255, 255, 255, 255),
                                                        offset: Offset(0, -5))
                                                  ],
                                                  fontSize: 20,
                                                  color: Colors.transparent,
                                                  decoration: TextDecoration.underline,
                                                  decorationColor: Colors.white,
                                                  
                                                ), 
                                              ),
                                              onPressed: () async {
                                                    
                                                    Airport? destino = await showSearch(
                                                      context: context, 
                                                      delegate: CitySearchDelegate()
                                                    );
                                                  
                                                    setState(() {
                                                      destinoSeleccionado = destino;
                                                    });
                                                    
                                                  },
                                              
                                            ),
                                          ),
                                        ),
                                                  
                                        Column(
                                          children: [
                                            if(destinoSeleccionado?.city != "")
                                              Container(
                                                child: Stack(
                                                  children: [
                                                    Align(
                                                      alignment: Alignment.bottomLeft,
                                                      child: Icon(
                                                          Icons.flight_land,
                                                          color: Color.fromARGB(255, 255, 255, 255)
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.center,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                                                        child: Text(destinoSeleccionado!.country+" - " +destinoSeleccionado!.city, style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white
                                                          
                                                        ),
                                                        ),
                                                      ),
                                                    ),
                                                    
                                                  ],
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  gradient: LinearGradient(
                                                colors: <Color>[
                                                  Color.fromARGB(130, 177, 177, 177),
                                                  Color.fromARGB(130, 177, 177, 177),
                                                ],
                                                ),
                                                ),
                                                width: 150.0,
                                              ),
                                            
                                            
                                          ],
                                        ),
                                        
                                      ],
                                    ),
                                    
                            ),
                          ),


                            
                        ],
                      ),

                      Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 150,
                                child: Center(
                                  child: OutlinedButton(onPressed: () {
                                    _restorableDatePickerRouteFuture.present();
                                  },
                                  child: Text("FECHA IDA", style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white
                                  ))),
                                  
                                ),
                              ),
                              Text(_selectedDate.value.day.toString()+"/"+_selectedDate.value.month.toString()+
                                "/"+_selectedDate.value.year.toString(), style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                                ),),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: 130,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: OutlinedButton(onPressed: () {
                                      _restorableDatePickerRouteFutureVuelta.present();
                                    },
                                    child: Text("FECHA VUELTA", style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white
                                    ))),
                                ),
                              ),
                                
                              
                              Text(_selectedDateVuelta.value.day.toString()+"/"+_selectedDateVuelta.value.month.toString()+
                                "/"+_selectedDateVuelta.value.year.toString(), style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                                ),),
                            ],
                          ),

                        ],
                      ),

                      

                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            
                            hint: Text("Adultos", style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            )), items: list
                                  .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white
                                    ),
                                  ),
                                ))
                                        .toList(),
                                value: selectedValue,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value as String;
                                    _selectedAdultos = selectedValue;
                                  });
                                },
                                buttonStyleData: const ButtonStyleData(
                                  height: 50,
                                  width: 170,
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                    color: Colors.black
                                  )
                                ),
                              ),
                              
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 28.0),
                        child: ElevatedButton(onPressed: (){
                          String ida = _selectedDate.value.day.toString()+"/"+_selectedDate.value.month.toString()+
                            "/"+_selectedDate.value.year.toString();
                            String vuelta = _selectedDateVuelta.value.day.toString()+"/"+_selectedDateVuelta.value.month.toString()+
                              "/"+_selectedDateVuelta.value.year.toString();
                          if(origenSeleccionado!.name == "" || destinoSeleccionado!.name == ""){
                            showDialog(
                              context: context, 
                              builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text(
                                    "No has seleccionado destino u origen.",
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                  icon: Icon(Icons.warning_amber_rounded, size: 36),
                                  iconColor: Colors.amber,
                                );
                              }
                            );
                          }
                          else if(vuelta.compareTo(ida) < 0 ){
                            showDialog(
                                context: context, 
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    title: Text(
                                      "La VUELTA no puede ser antes que la IDA.",
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                    icon: Icon(Icons.warning_amber_rounded, size: 36),
                                    iconColor: Colors.amber,
                                  );
                                }
                              );
                          }
                          else if(_selectedAdultos == "null"){
                            showDialog(
                                context: context, 
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    title: Text(
                                      "No has seleccionado número de adultos.",
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                    icon: Icon(Icons.warning_amber_rounded, size: 36),
                                    iconColor: Colors.amber,
                                  );
                                }
                              );
                          }
                          else{
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: BusquedaVuelos(origen: origenSeleccionado, destino: destinoSeleccionado, ida: ida, vuelta: vuelta, adultos: _selectedAdultos),
                              withNavBar: true,
                              pageTransitionAnimation: PageTransitionAnimation.cupertino,
                            );
                          }
                          

                        }, child: Text("Buscar vuelos")),
                      ),
                    
                    ],
                  );
}

}



Future<DateTime?> showDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  DateTime? currentDate,
  DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
  SelectableDayPredicate? selectableDayPredicate,
  String? helpText,
  String? cancelText,
  String? confirmText,
  Locale? locale,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  TextDirection? textDirection,
  TransitionBuilder? builder,
  DatePickerMode initialDatePickerMode = DatePickerMode.day,
  String? errorFormatText,
  String? errorInvalidText,
  String? fieldHintText,
  String? fieldLabelText,
  TextInputType? keyboardType,
  Offset? anchorPoint,
}) async {
  assert(context != null);
  assert(initialDate != null);
  assert(firstDate != null);
  assert(lastDate != null);
  initialDate = DateUtils.dateOnly(initialDate);
  firstDate = DateUtils.dateOnly(firstDate);
  lastDate = DateUtils.dateOnly(lastDate);
  assert(
    !lastDate.isBefore(firstDate),
    'lastDate $lastDate must be on or after firstDate $firstDate.',
  );
  assert(
    !initialDate.isBefore(firstDate),
    'initialDate $initialDate must be on or after firstDate $firstDate.',
  );
  assert(
    !initialDate.isAfter(lastDate),
    'initialDate $initialDate must be on or before lastDate $lastDate.',
  );
  assert(
    selectableDayPredicate == null || selectableDayPredicate(initialDate),
    'Provided initialDate $initialDate must satisfy provided selectableDayPredicate.',
  );
  assert(initialEntryMode != null);
  assert(useRootNavigator != null);
  assert(initialDatePickerMode != null);
  assert(debugCheckHasMaterialLocalizations(context));

  Widget dialog = DatePickerDialog(
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    currentDate: currentDate,
    initialEntryMode: initialEntryMode,
    selectableDayPredicate: selectableDayPredicate,
    helpText: helpText,
    cancelText: cancelText,
    confirmText: confirmText,
    initialCalendarMode: initialDatePickerMode,
    errorFormatText: errorFormatText,
    errorInvalidText: errorInvalidText,
    fieldHintText: fieldHintText,
    fieldLabelText: fieldLabelText,
    keyboardType: keyboardType,
  );

  if (textDirection != null) {
    dialog = Directionality(
      textDirection: textDirection,
      child: dialog,
    );
  }

  if (locale != null) {
    dialog = Localizations.override(
      context: context,
      locale: locale,
      child: dialog,
    );
  }

  return showDialog<DateTime>(
    context: context,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
    anchorPoint: anchorPoint,
  );
}

