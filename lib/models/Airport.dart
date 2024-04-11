class Airport{
  final String name;
  final String country;
  final String city;

  Airport({required this.name, required this.country, required this.city});

  static Airport fromJson(Map json) {
    return Airport(
      name: json['name'],
      country: json['country'],
      city: json['city'],
    );
  }


  @override
  String toString(){
    return 'Instance of Airport: $name';
  }
}