import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

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
  final WeatherAPIClient weatherAPIClient = WeatherAPIClient();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeBloc>(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeData>(
        builder: (context, theme) => MaterialApp(
          title: 'Weather App',
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: BlocProvider<WeatherBloc>(
              create: (context) =>
                  WeatherBloc(weatherAPIClient: weatherAPIClient),
              child: WeatherPage()),
        ),
      ),
    );
  }
}

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    _refreshCompleter = Completer<void>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
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
                BlocProvider.of<WeatherBloc>(context)
                    .add(FetchWeather(city: city));
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.wb_sunny),
            onPressed: () => context.bloc<ThemeBloc>().add(ThemeEvent.toggle),
          )
        ],
      ),
      body: BlocConsumer<WeatherBloc, WeatherState>(
        listener: (context, state) {
          if (state is WeatherLoaded) {
            _refreshCompleter?.complete();
          }
        },
        builder: (context, state) {
          if (state is WeatherEmpty) {
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
          if (state is WeatherLoaded) {
            final Weather weather = state.weather;

            return RefreshIndicator(
              onRefresh: () {
                if (_refreshCompleter.isCompleted) {
                  _refreshCompleter = Completer();
                }
                BlocProvider.of<WeatherBloc>(context).add(
                  RefreshWeather(city: weather.locationName),
                );
                return _refreshCompleter.future;
              },
              child: ListView(
                children: [
                  Column(
                    children: [
                      Text(
                        weather.locationName,
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Temperature: ${weather.temp} °C  ${weather.iconString}',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Min Temp: ${weather.minTemp} °C'),
                          SizedBox(
                            width: 30,
                          ),
                          Text('Max Temp: ${weather.maxTemp} °C')
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Last Updated at: ${weather.time}")
                    ],
                  ),
                ],
              ),
            );
          }
          return Container();
        },
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
      body: Center(
        child: Text('This Weather App using BLoC'),
      ),
    );
  }
}
