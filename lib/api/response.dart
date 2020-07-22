import 'package:json_annotation/json_annotation.dart';
part 'response.g.dart';

@JsonSerializable()
class BaseResponse extends Object {
  @JsonKey(name: "cnt")
  final int count;

  @JsonKey(name: "list")
  final List<City> cities;

  BaseResponse(this.count, this.cities);

  factory BaseResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseFromJson(json);
}

@JsonSerializable()
class City extends Object {
  final int id;
  final String name;
  final int dt;
  final Coord coord;
  final Main main;

  @JsonKey(nullable: true)
  final Wind wind;

  final Clouds clouds;
  final List<Weather> weather;

  City(
    this.id,
    this.name,
    this.dt,
    this.coord,
    this.main,
    this.wind,
    this.clouds,
    this.weather,
  );

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}

@JsonSerializable()
class Coord extends Object {
  final double lat;
  final double lon;

  Coord(
    this.lat,
    this.lon,
  );

  factory Coord.fromJson(Map<String, dynamic> json) => _$CoordFromJson(json);
}

@JsonSerializable()
class Weather extends Object {
  final int id;
  final String main;
  final String description;
  final String icon;

  Weather(
    this.id,
    this.main,
    this.description,
    this.icon,
  );

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
}

@JsonSerializable()
class Main extends Object {
  final double temp;
  @JsonKey(name: "feels_like")
  final double feelsLike;
  final double pressure;
  final int humidity;
  @JsonKey(name: "temp_max")
  final double tempMax;
  @JsonKey(name: "temp_min")
  final double tempMin;

  Main(
    this.temp,
    this.pressure,
    this.humidity,
    this.tempMax,
    this.tempMin,
    this.feelsLike,
  );

  factory Main.fromJson(Map<String, dynamic> json) => _$MainFromJson(json);
}

@JsonSerializable()
class Wind extends Object {
  final double speed;
  final double deg;

  Wind(
    this.speed,
    this.deg,
  );

  factory Wind.fromJson(Map<String, dynamic> json) => _$WindFromJson(json);
}

@JsonSerializable()
class Clouds extends Object {
  final int all;

  Clouds(
    this.all,
  );

  factory Clouds.fromJson(Map<String, dynamic> json) => _$CloudsFromJson(json);
}
