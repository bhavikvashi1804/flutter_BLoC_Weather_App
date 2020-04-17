import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './simple_bloc_delegate.dart';
import './blocs/blocs.dart';
import './services/services.dart';
import './widgets/widgets.dart';
import './models/models.dart';


void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  final WeatherAPIClient weatherAPIClient=WeatherAPIClient();
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => WeatherBloc(weatherAPIClient: weatherAPIClient),
        child: WeatherPage()
      ),
    );
  }
}


class WeatherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weathe App'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final city = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CitySelection(),
                ),
              );
              if (city != null) {
                BlocProvider.of<WeatherBloc>(context).add(FetchWeather(city: city));
              }
            },
          )
        ],
      ),

      body: Center(
        child: BlocBuilder<WeatherBloc,WeatherState>(
          builder: (context, state){

            if(state is WeatherEmpty ){
              return Center(child: Text('Please Select a Location'));
            }
            if (state is WeatherLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is WeatherError) {
              return Center(
                child: Text(
                  'Something went wrong!',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }
            if(state is WeatherLoaded){
              final Weather weather=state.weather;
              return Center(
                child:Text(
                  weather.temp.toString(),
                )
              );
            }

          },
        ),
      ),
      
      
    );
  }
}

class MyHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(child: Text('This Weather App using BLoC'),),
    );
  }
}