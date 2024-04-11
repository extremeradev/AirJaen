import 'package:dio/dio.dart';

import '../models/City.dart';

class WeatherService{
  final _dio = new Dio();
  

  Future<City?> getWeatherByCity(String city) async{
    String _apiKey = "9ddc995b8d2646e5943100643231705";

    try{

      final url = 'http://api.weatherapi.com/v1/current.json?key=${_apiKey}&q=${city}';


      final resp = await _dio.get(url);
      final ciudad = City.fromJson(resp.data);

      return ciudad;

    } catch (e) {
      
      return null;
    }
  }

}