// ignore_for_file: prefer_const_constructors, prefer_is_empty, unnecessary_new, unnecessary_this


import 'package:airjaen/services/airport_service.dart';
import 'package:flutter/material.dart';

import '../models/Airport.dart';

class CitySearchDelegate extends SearchDelegate<Airport>{
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => this.query = "" ,
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    Airport nulo = new Airport(city: "", name: "", country: "");
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, nulo)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if(query.trim().length == 0){
      return Text("No hay valor en la búsuqeda");
    }
    final cityAirport = new AirportService();
    return FutureBuilder(
      future: cityAirport.getAirportByCity(query),
      builder: ( _ , AsyncSnapshot snapshot) {
        if(snapshot.hasData){
          
          return _showAirports(snapshot.data);

        }else{
          return Center(child: CircularProgressIndicator());
        }
      },
    );

    //print(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListTile(title: Text("Escribe a qué ciudad quieres ir.") );
  }

  Widget _showAirports(List<dynamic> airports){

    return ListView.builder(
      itemCount: airports.length,
      itemBuilder: (context , i){
        Airport airport = new Airport(name: airports[i]['name'], country: airports[i]['country'], city: airports[i]['city']);
        return ListTile(
          title: Text(airport.name, style: TextStyle(fontSize: 20)),
          //trailing: Text(airport['iata']),
          subtitle: Text(airport.city),
          leading: Text(airport.country),
          onTap: (){
            this.close(context, airport);
            
          }
        );
      }
    );
  }

}