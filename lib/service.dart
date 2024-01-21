import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DataService {
  Future<WeatherResponse> getWeather(String city, String language) async {
    try {
      final queryParameters = {
        'q': city,
        'appid': 'e1e449e9d0b314c7bac1681d070366a5',
        'units': 'metric',
        'lang': language,
      };

      final uri = Uri.https('api.openweathermap.org', '/data/2.5/weather', queryParameters);
      final response = await http.get(uri);

      if (response.statusCode == 200) { //если статус равен 200 то всё ок(чтоб не запарсилось при 400 или 500:))
        final json = jsonDecode(response.body);

        final cityName = json['name'];

        final tempInfoJson = json['main'];
        final tempInfo = TemperatureInfo.fromJson(tempInfoJson);

        final weatherInfoJson = json['weather'][0];
        final weatherInfo = WeatherInfo.fromJson(weatherInfoJson);

        return WeatherResponse(cityName: cityName, tempInfo: tempInfo, weatherInfo: weatherInfo);
      } else { // обработка ошибок сети
        throw Exception('failed to load weather data');// генерирует исключение
      }
    } catch (e) { // другие ошикби
      print('Error: $e'); //e - сама ошибка
      throw Exception('failed to load weather data');
    }
  }
}