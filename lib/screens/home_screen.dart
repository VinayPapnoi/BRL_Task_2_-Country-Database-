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
      appBar: AppBar(title: const Text('Countries Database')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter country name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _searchCountry,
              child: const Text('Search'),
            ),
            const SizedBox(height: 20),
            if (_error.isNotEmpty)
              Text(_error, style: const TextStyle(color: Colors.red)),
            if (_country != null) ...[
              if (_country!.flagUrl.isNotEmpty)
                Image.network(_country!.flagUrl, height: 100),
              const SizedBox(height: 10),
              Text('Name: ${_country!.name}'),
              Text('Capital: ${_country!.capital}'),
              Text('Region: ${_country!.region}'),
              Text('Population: ${_country!.population}'),
            ]
          ],
        ),
      ),
    );
  }
}
