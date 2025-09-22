class Country {
  final String name;
  final String capital;
  final String region;
  final int population;
  final String flagUrl;

  Country({
    required this.name,
    required this.capital,
    required this.region,
    required this.population,
    required this.flagUrl,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name']['common'] ?? 'Unknown',
      capital: json['capital'] != null && json['capital'].isNotEmpty ? json['capital'][0] : 'Unknown',
      region: json['region'] ?? 'Unknown',
      population: json['population'] ?? 0,
      flagUrl: json['flags']['png'] ?? '',
    );
  }
}
