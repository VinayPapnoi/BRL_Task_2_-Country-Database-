import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:brl_task_2/models/country_model.dart';

class ApiService {
  static Future<Country?> fetchCountry(String name) async {
    final url = Uri.parse('https://restcountries.com/v3.1/name/$name');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        return Country.fromJson(data[0]);
      }
    }
    return null; 
  }
  
  static Future<List<Country>> fetchCountrySuggestions(String query) async {
    if(query.isEmpty) return [];
    final url = Uri.parse('https://restcountries.com/v3.1/name/$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Country.fromJson(json)).toList();
    }
    return [];
  }
}
