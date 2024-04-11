// ignore_for_file: unused_field, unnecessary_new, empty_catches, unused_local_variable, avoid_print, empty_constructor_bodies
import 'package:dio/dio.dart';

import '../models/Airport.dart';

class AirportService {
  final _dio = new Dio();

  

  Future getAirportByCity(String city) async {
    try{

      final url = 'https://airports-by-api-ninjas.p.rapidapi.com/v1/airports?city=$city';
      _dio.options.headers['X-RapidAPI-Key'] = '3ba23ee3b8msh33def26a25db2f7p147a44jsne8142f9572bc';
      _dio.options.headers['X-RapidAPI-Host'] = 'airports-by-api-ninjas.p.rapidapi.com';


      final resp = await _dio.get(url);

      final List<dynamic> airportList = resp.data;

      airportList.map(
        (obj) => Airport.fromJson(obj)
      ).toList();


      return airportList;

    } catch (e) {
      return [];
    }
  }
}