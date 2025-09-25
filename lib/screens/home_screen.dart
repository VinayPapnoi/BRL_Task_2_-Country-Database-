import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:brl_task_2/models/country_model.dart';
import 'package:brl_task_2/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  Country? _country;
  String _error = '';

  void _searchCountry(String name) async {
    if (name.isEmpty) {
      setState(() => _error = 'Please enter a country name');
      return;
    }

    setState(() {
      _error = '';
      _country = null;
    });

    Country? country = await ApiService.fetchCountry(name);

    setState(() {
      if (country != null) {
        _country = country;
      } else {
        _error = 'Country not found';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries Database', style: TextStyle(fontSize: 25)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // stretch to full width
            children: [
              // Search bar at the top
              TypeAheadField<Country>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Enter country name',
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(fontSize: 20),
                ),
                suggestionsCallback: (pattern) async {
                  if (pattern.isEmpty) return [];
                  return await ApiService.fetchCountrySuggestions(pattern);
                },
                itemBuilder: (context, Country suggestion) {
                  return ListTile(
                    leading: suggestion.flagUrl.isNotEmpty
                        ? Image.network(suggestion.flagUrl, width: 30)
                        : null,
                    title: Text(suggestion.name),
                    subtitle: Text(suggestion.capital),
                  );
                },
                onSuggestionSelected: (Country suggestion) {
                  setState(() {
                    _country = suggestion;
                    _error = '';
                    _controller.text = suggestion.name;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _searchCountry(_controller.text.trim()),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 10,
                  ),
                ),
                child: const Text('Search', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 20),
              if (_error.isNotEmpty)
                Text(
                  _error,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 17, 0),
                    fontSize: 30,
                  ),
                ),
              if (_country != null) ...[
                if (_country!.flagUrl.isNotEmpty)
                  Image.network(_country!.flagUrl, height: 150),
                const SizedBox(height: 10),
                Text(
                  'Name: ${_country!.name}',
                  style: const TextStyle(fontSize: 22),
                ),
                Text(
                  'Capital: ${_country!.capital}',
                  style: const TextStyle(fontSize: 22),
                ),
                Text(
                  'Continent: ${_country!.region}',
                  style: const TextStyle(fontSize: 22),
                ),
                Text(
                  'Population: ${_country!.population}',
                  style: const TextStyle(fontSize: 22),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
