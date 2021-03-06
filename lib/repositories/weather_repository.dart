import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weatloc/api/response.dart';
import 'package:weatloc/api/weather_client.dart';
import 'package:weatloc/model/weather_model.dart';

class WeatherRepository {
  final String _apiKey = WeatherClient.apiKey;
  final String _host = WeatherClient.host;

  WeatherRepository();

  Future<List<WeatherModel>> fetchWeather(List<int> cityIds) async {
    String citiesId = "";
    cityIds.forEach((cityId) => citiesId = citiesId + cityId.toString() + ',');
    citiesId = citiesId.substring(0, citiesId.length - 1);

    String url = _host +
        'data/2.5/group' +
        '?id=$citiesId&appid=' +
        _apiKey +
        '&units=metric';

    final response = await http.get(url);

    List<WeatherModel> req = BaseResponse.fromJson(json.decode(response.body))
        .cities
        .map((city) => WeatherModel.fromResponse(city))
        .toList();

    return req;
  }
}
