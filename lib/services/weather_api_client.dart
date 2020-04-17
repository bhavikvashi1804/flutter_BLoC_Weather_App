import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../app_Data.dart';
import '../models/models.dart' ;

class WeatherAPIClient{

  Future<Weather> fetchData(String cityName)async{
    
    
    final http.Client httpClient=http.Client();
    final String weatherUrl='$openWeatherMapUrl?q=$cityName&appid=$apiKey&units=metric';
    
    http.Response weatherResponse=await httpClient.get(weatherUrl);
    print(weatherResponse.body);
    
    if(weatherResponse.statusCode!=200){
      print(weatherResponse.body);
      throw Exception('error getting weather for location');

      
    }

    var weatherJSON=jsonDecode(weatherResponse.body);
    var weatherObject= Weather.fromJson(weatherJSON);
    print(weatherJSON);

    return weatherObject;
       

  }

}