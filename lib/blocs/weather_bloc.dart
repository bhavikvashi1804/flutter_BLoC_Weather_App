import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../models/models.dart';
import '../services/services.dart';


/*
There are two weather Event
1. Fetch Weather  loads new weather data
2. Refresh Weather update the existing weather data 
*/
abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
}

class FetchWeather extends WeatherEvent {
  final String city;

  const FetchWeather({@required this.city}) : assert(city != null);
  //assert make sure that city must not be null

  @override
  List<Object> get props => [city];
}

class RefreshWeather extends WeatherEvent {
  final String city;

  const RefreshWeather({@required this.city}) : assert(city != null);

  @override
  List<Object> get props => [city];
}


/*
We have four state for Weather App
1. Empty : There is no weather data
2. Loading : App is loading the weather data currently doing the networking stuff
3. Loaded:  We have loaded Weather data now pass it the scree
4. Error : We have error while loading the data
*/



abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherEmpty extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Weather weather;

  const WeatherLoaded({@required this.weather}) : assert(weather != null);

  @override
  List<Object> get props => [weather];
}

class WeatherError extends WeatherState {}



// Here is our BLoC


class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  
  
  final WeatherAPIClient weatherAPIClient;

  WeatherBloc({@required this.weatherAPIClient}):assert(weatherAPIClient != null);

  //our initial state is empty
  @override
  WeatherState get initialState => WeatherEmpty();

  //Event to State
  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is FetchWeather) {
      yield* _mapFetchWeatherToState(event);
    } else if (event is RefreshWeather) {
      yield* _mapRefreshWeatherToState(event);
    }
  }

  //if event is FetchEvent
  Stream<WeatherState> _mapFetchWeatherToState(FetchWeather event) async* {
    //set the state to loading the data
    yield WeatherLoading();
    
    //load the data
    try {
      final Weather weather = await weatherAPIClient.fetchData(event.city);
      //data loading completed
      //set the state to loading completed
      yield WeatherLoaded(weather: weather);
    } catch (error) {
      print(error);
      //if error occured then set the state to WeatherError
      yield WeatherError();
    }
  }

  //refresh Event
  Stream<WeatherState> _mapRefreshWeatherToState(RefreshWeather event) async* {
    try {
      //fetch data
      final Weather weather = await weatherAPIClient.fetchData(event.city);
      //data is loaded so update the UI by WeatherLoaded State with new weather data 
      yield WeatherLoaded(weather: weather);
    } catch (_) {
      //if error occurs then simple returns the current state 
      //we do not want to change state
      yield state;
    }
  }
}
