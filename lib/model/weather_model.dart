import 'package:weatloc/api/response.dart';

class WeatherModel {
  final String city;
  final double temperature;
  final double pressure;
  final int humidity;
  final double wind;
  final String condition;
  final String icon;
  final double lat;
  final double long;

  WeatherModel(
    this.city,
    this.temperature,
    this.pressure,
    this.humidity,
    this.condition,
    this.lat,
    this.long,
    this.wind,
    this.icon,
  );

  WeatherModel.fromResponse(City response)
      : city = response.name,
        // temperature = response.main.temp - 273.15,
        temperature = response.main.temp,
        pressure = response.main.pressure,
        humidity = response.main.humidity,
        condition = response.weather[0].main,
        icon = response.weather[0]?.icon,
        lat = response.coord.lat,
        long = response.coord.lon,
        wind = response.wind.speed;
}
