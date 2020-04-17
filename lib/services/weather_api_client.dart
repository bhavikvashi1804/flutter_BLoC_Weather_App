import 'dart:convert';

import 'package:http/http.dart' as http;

import '../app_Data.dart';
import '../models/models.dart' ;

class WeatherAPIClient{

  Future<Weather> fetchData(String cityName)async{
    
    
    final String weatherUrl='$openWeatherMapUrl?q=$cityName&appid=$apiKey&units=metric';
    
    http.Response weatherResponse=await http.get(weatherUrl);
    
    if(weatherResponse.statusCode!=200){
      throw Exception('error getting weather for location');
    }

    var weatherJSON=jsonDecode(weatherResponse.body);
    var weatherObject= Weather.fromJson(weatherJSON);

    return weatherObject;
       

  }

}