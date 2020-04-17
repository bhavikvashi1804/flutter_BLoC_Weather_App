import 'package:equatable/equatable.dart';


class Weather extends Equatable{
  
  final int id;
  final String locationName;
  final double minTemp;
  final double temp;
  final double maxTemp;
  final String iconString;
  

  const Weather({
    this.id,
    this.locationName,
    this.temp,
    this.minTemp,
    this.maxTemp,
    this.iconString,
    
  });

  
  @override
  List<Object> get props => [id,locationName,temp,minTemp,maxTemp,iconString];



  //convert the JSON to Weather Object
  static Weather fromJson(dynamic weatherDataJSON) {

    Weather weather=Weather(
      id : weatherDataJSON['weather'][0]['id'].toInt(),
      locationName: weatherDataJSON['name'],
      temp: weatherDataJSON['main']['temp'].toDouble(),
      minTemp: weatherDataJSON['main']['temp_min'].toDouble(),
      maxTemp: weatherDataJSON['main']['temp_max'].toDouble(),
      iconString: getWeatherIcon(weatherDataJSON['weather'][0]['id']),
    );
    return weather;
  }

  
  
  



  //get the icon according to the Condition 
  //Condition description is provided by API
  static String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

 



}