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

  void _searchCountry() async {
    String name = _controller.text.trim();

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
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: _controller,
                style: const TextStyle(fontSize: 25),
                decoration: const InputDecoration(
                  labelText: 'Enter country name',
                  labelStyle: TextStyle(fontSize: 20),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _searchCountry,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 10,
                  ),
                ),
                child: const Text(style: TextStyle(fontSize: 20), 'Search'),
              ),
              const SizedBox(height: 20),
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
                  'Region: ${_country!.region}',
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
