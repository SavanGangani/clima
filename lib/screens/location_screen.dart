import 'package:clima/screens/city_screen.dart';
import 'package:flutter/material.dart';
import 'package:clima/constants.dart';
import 'package:clima/weather.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationweather});

  final locationweather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  int temperature = 0;
  String weatherIcon = "";
  String name = "";
  String massage = "";

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationweather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherIcon = "Error!";
        massage = "Unable To Gate Location";
        name = "";
        return;
      }
      weatherIcon = weather.getWeatherIcon(weatherData['weather'][0]['id']);
      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      massage = weather.getMessage(temperature);
      name = weatherData['name'];
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/location_background.jpg"),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.white.withOpacity(0.85),
                        BlendMode.dstATop,
                      ))),
              constraints: BoxConstraints.expand(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                          onPressed: () async {
                            var weatherData =
                                await weather.getLocationWeather();
                            updateUI(weatherData);
                          },
                          child: Icon(
                            Icons.near_me,
                            size: 50,
                            color: Colors.white,
                          )),
                      FlatButton(
                          onPressed: () async {
                            var typedName = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CityScreen()));
                            if (typedName != null) {
                              var weatherData =
                                  await weather.getCityWeather(typedName);
                              updateUI(weatherData);
                            }
                          },
                          child: Icon(
                            Icons.location_city,
                            size: 50,
                            color: Colors.white,
                          )),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 110.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "$temperature°",
                          style: kTempTextStyle,
                        ),
                        Text(
                          weatherIcon,
                          style: kConditionTextStyle,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 15.0),
                    child: Text(
                      "$massage in $name",
                      textAlign: TextAlign.right,
                      style: kMessageTextStyle,
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
