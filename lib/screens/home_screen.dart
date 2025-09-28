import 'package:flutter/material.dart';
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
  List<Country> _suggestions = [];

  void _searchCountry(String name) async {
    if (name.isEmpty) {
      setState(() => _error = 'Please enter a country name');
      return;
    }

    setState(() {
      _error = '';
      _country = null;
      _suggestions = [];
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

  void _getSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }
    final results = await ApiService.fetchCountrySuggestions(query);
    setState(() {
      _suggestions = results;
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
<<<<<<< HEAD
              // Search bar at the top
              TypeAheadField<Country>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Enter country name',
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(fontSize: 20),
=======
              TextField(
                controller: _controller,
                style: const TextStyle(fontSize: 25),
                onChanged: _getSuggestions,
                decoration: const InputDecoration(
                  labelText: 'Enter country name',
                  labelStyle: TextStyle(fontSize: 20),
                  border: OutlineInputBorder(),
>>>>>>> fix-autocomplete
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
<<<<<<< HEAD
              const SizedBox(height: 20),
=======
              if (_suggestions.isNotEmpty)
                Container(
                  //neeche waali line recheck karni hai ek baar
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: _suggestions.map((country) {
                      return ListTile(
                        title: Text(
                          country.name,
                          style: const TextStyle(fontSize: 18),
                        ),
                        onTap: () {
                          _controller.text = country.name;
                          _searchCountry();
                        },
                      );
                    }).toList(),
                  ),
                ),

              const SizedBox(height: 10),
>>>>>>> fix-autocomplete
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
