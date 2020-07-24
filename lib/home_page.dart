import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_icons/weather_icons.dart';
import 'package:weatloc/api/response.dart';
import 'package:weatloc/api/weather_client.dart';
import 'package:weatloc/model/weather_model.dart';
import 'package:weatloc/repositories/weather_repository.dart';

class HomePage extends StatefulWidget {
  final String title;
  HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherRepository weatherRepository;
  List<WeatherModel> weatherList = List();
  // default text style
  TextStyle textStyle = new TextStyle(
    fontFamily: 'Raleway',
    color: Colors.white,
  );

  String capitalize(String string) {
    if (string == null) {
      throw ArgumentError("string: $string");
    }

    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
  }

  @override
  void initState() {
    this.getWeatherList([160263, 160196, 149606]);
    super.initState();
  }

  /// Fetch all weathers by id
  ///
  /// @param List<int> cityIds
  ///
  /// @return String
  Future<String> getWeatherList(List<int> cityIds) async {
    String citiesId = '';
    cityIds.forEach((cityId) => citiesId = citiesId + cityId.toString() + ',');
    citiesId = citiesId.substring(0, citiesId.length - 1);
    final String _apiKey = WeatherClient.apiKey;
    final String _host = WeatherClient.host;
    String url = _host +
        'data/2.5/group' +
        '?id=$citiesId&appid=' +
        _apiKey +
        '&units=metric';
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    List<WeatherModel> req = BaseResponse.fromJson(json.decode(response.body))
        .cities
        .map((city) => WeatherModel.fromResponse(city))
        .toList();

    setState(() {
      weatherList = req;
    });

    return 'Success';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF39273E),
      body: SafeArea(
        child: weatherList.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.yellow,
                ),
              )
            : buildWeatherSlider(),
      ),
    );
  }

  ///
  /// Build weather slider
  ///
  buildWeatherSlider() {
    final double height = MediaQuery.of(context).size.height;
    return CarouselSlider(
      options: CarouselOptions(
        height: height,
        autoPlay: false,
        viewportFraction: 1.0,
        enlargeCenterPage: false,
        enableInfiniteScroll: false,
      ),
      items: weatherList.map((weather) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(color: Color(0xff65456e)),
              child: Column(
                children: <Widget>[
                  buildWeatherTemp(weather),
                  SizedBox(height: MediaQuery.of(context).size.height / 2.3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      buildWeatherUtilCard(weather, "wind"),
                      buildWeatherUtilCard(weather, "humidity"),
                      buildWeatherUtilCard(weather, "pressure"),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }

  /// Render top row with temperate info
  ///
  /// @param WeatherModel weather
  /// @return Row
  buildWeatherTemp(WeatherModel weather) {
    String iconUrl = "http://openweathermap.org/img/w/" + weather.icon + ".png";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 48.0, 16.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  weather.temperature.toInt().toString() +
                      String.fromCharCode(0x00B0),
                  style: textStyle.copyWith(
                    fontSize: 48.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                child: Text(
                  weather.condition.toLowerCase(),
                  style: textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                child: Text(
                  weather.city,
                  style: textStyle.copyWith(
                    fontWeight: FontWeight.w300,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 24.0),
          child: Column(
            children: <Widget>[
              Image.network(
                iconUrl,
                width: 60,
                height: 60,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Create single card for weather util card
  ///
  /// @param WeatherModel weatherModel
  /// @param String util
  ///
  /// @return Card
  buildWeatherUtilCard(WeatherModel weatherModel, String util) {
    return Card(
      elevation: 24.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      color: util == 'wind' ? Color(0xFFAB4459) : Color(0xFF9D5070),
      child: Container(
        width: MediaQuery.of(context).size.width / 3.3,
        height: MediaQuery.of(context).size.height / 5,
        child: Column(
          children: <Widget>[
            iconSelector(util),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 29,
                horizontal: 6.0,
              ),
              child: textSelector(weatherModel, util),
            ),
            Container(
              color: util == 'wind' ? Color(0xFF9A3545) : Color(0xFF893E5D),
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    util == 'pressure'
                        ? "Air ${capitalize(util)}"
                        : capitalize(util),
                    style: textStyle.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Icon selection based on passed weather util
  ///
  /// @param String selector
  /// @return Icon
  Icon iconSelector(String selector) {
    switch (selector) {
      case 'wind':
        return Icon(
          WeatherIcons.wind_beaufort_0,
          size: 40,
          color: Colors.white,
        );
        break;

      case 'humidity':
        return Icon(
          WeatherIcons.humidity,
          size: 40,
          color: Colors.white,
        );
        break;

      case 'pressure':
        return Icon(
          WeatherIcons.barometer,
          size: 40,
          color: Colors.white,
        );
        break;
      default:
        return Icon(
          Icons.queue_play_next,
          size: 40,
          color: Colors.white,
        );
        break;
    }
  }

  /// Text selection based on weather util
  ///
  /// @param WeatherModel weatherModel
  /// @param String util
  ///
  /// @return RichText
  RichText textSelector(WeatherModel weatherModel, String util) {
    switch (util) {
      case 'wind':
        return RichText(
          text: TextSpan(
            text: weatherModel.wind.toString(),
            style: textStyle.copyWith(fontSize: 24.0),
            children: <TextSpan>[
              TextSpan(
                text: ' Km/h',
                style: textStyle.copyWith(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
        break;

      case 'humidity':
        return RichText(
          text: TextSpan(
            text: weatherModel.humidity.toString(),
            style: textStyle.copyWith(fontSize: 24.0),
            children: <TextSpan>[
              TextSpan(
                text: " " + String.fromCharCode(0x25),
                style: textStyle.copyWith(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
        break;

      case 'pressure':
        return RichText(
          text: TextSpan(
            text: weatherModel.pressure.toString(),
            style: textStyle.copyWith(fontSize: 20.0),
            children: <TextSpan>[
              TextSpan(
                text: " hpa",
                style: textStyle.copyWith(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
        break;
      default:
        return RichText(
          text: TextSpan(
            text: 'No data',
            style: textStyle.copyWith(fontSize: 24.0),
            children: <TextSpan>[
              TextSpan(
                text: ' ---',
                style: textStyle.copyWith(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
        break;
    }
  }
}
