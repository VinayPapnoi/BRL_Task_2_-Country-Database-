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
  bool _isLoading = false;
  bool _pressed = false;

  void _searchCountry() async {
    String name = _controller.text.trim();

    if (name.isEmpty) {
      setState(() => _error = 'Please enter a country name');
      return;
    }

    setState(() {
      _error = '';
      _country = null;
      _suggestions = [];
      _isLoading = true;
    });

    Country? country = await ApiService.fetchCountry(name);

    setState(() {
      _isLoading = false;
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
    final filtered = results
        .where(
          (country) =>
              country.name.toLowerCase().startsWith(query.toLowerCase()),
        )
        .toList();

    setState(() {
      _suggestions = filtered.isEmpty ? [] : filtered;
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
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: _controller,
                style: const TextStyle(fontSize: 25),
                onChanged: _getSuggestions,
                decoration: const InputDecoration(
                  labelText: 'Enter country name',
                  labelStyle: TextStyle(fontSize: 20),
                  border: OutlineInputBorder(),
                ),
              ),
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
                  child: SizedBox(
                    height: 200,
                    child: ListView(
                      shrinkWrap: true,
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
                ),
              const SizedBox(height: 10),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _pressed ? 220 : 180,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _pressed = !_pressed;
                    });
                    _searchCountry();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(style: TextStyle(fontSize: 20), 'Search'),
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                Image.asset('assets/loading.gif', width: 300, height: 300),
              if (_error.isNotEmpty)
                Text(
                  _error,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 17, 0),
                    fontSize: 40,
                  ),
                ),
              if (_country != null) ...[
                if (_country!.flagUrl.isNotEmpty)
                  Image.network(_country!.flagUrl, height: 150),
                const SizedBox(height: 10),
                Text(style: TextStyle(fontSize: 22), 'Name: ${_country!.name}'),
                Text(
                  style: TextStyle(fontSize: 22),
                  'Capital: ${_country!.capital}',
                ),
                Text(
                  style: TextStyle(fontSize: 22),
                  'Continent: ${_country!.region}',
                ),
                Text(
                  style: TextStyle(fontSize: 22),
                  'Population: ${_country!.population}',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
