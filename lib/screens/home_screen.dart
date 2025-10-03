import 'package:brl_task_2/screens/login_screen.dart';
import 'package:brl_task_2/services/firebase_auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:brl_task_2/models/country_model.dart';
import 'package:brl_task_2/services/api_service.dart';
import 'package:provider/provider.dart';

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

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await context.read<FirebaseAuthMethods>().signOut(context);
            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            }
          },
        ),
        title: const Text('Countries Database', style: TextStyle(fontSize: 25)),
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset('assets/homeScreenBack.jpg', fit: BoxFit.cover),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: _controller,
                          style: const TextStyle(
                            fontSize: 25,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                          onChanged: _getSuggestions,
                          decoration: InputDecoration(
                            labelText: 'Enter country name',
                            labelStyle: const TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            filled: true,
                            fillColor: Color.fromRGBO(255, 255, 255, 0.7),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                        if (_suggestions.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              //color: Colors.white.withOpacity(0.8),
                              color: Color.fromRGBO(255, 255, 255, 0.8),
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SizedBox(
                              height: 200,
                              child: ListView(
                                shrinkWrap: true,
                                children: _suggestions.map((country) {
                                  return Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(8),
                                      onTap: () {
                                        _controller.text = country.name;
                                        _searchCountry();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          country.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
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
                                _pressed = true;
                              });
                              Future.delayed(
                                const Duration(milliseconds: 300),
                                () {
                                  if (mounted) setState(() => _pressed = false);
                                },
                              );
                              _searchCountry();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 10,
                              ),
                            ),
                            child: const Text(
                              'Search',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (_isLoading)
                          Image.asset(
                            'assets/loadingNew.gif',
                            width: 100,
                            height: 100,
                          ),
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
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.8),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (_country!.flagUrl.isNotEmpty)
                                  SizedBox(
                                    height: 150,
                                    child: Image.network(
                                      _country!.flagUrl,
                                      fit: BoxFit.contain,
                                      loadingBuilder:
                                          (
                                            BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress,
                                          ) {
                                            if (loadingProgress == null)
                                              return child; // fully loaded
                                            // Show a centered loading GIF while loading
                                            return Center(
                                              child: SizedBox(
                                                width: 60,
                                                height: 60,
                                                child: Image.asset(
                                                  'assets/loadingNew.gif',
                                                ),
                                              ),
                                            );
                                          },
                                    ),
                                  ),

                                const SizedBox(height: 10),
                                Text(
                                  'Name: ${_country!.name}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Capital: ${_country!.capital}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'Continent: ${_country!.region}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'Population: ${_country!.population}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
