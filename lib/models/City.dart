class City{
  final String name;
  final double temp;
  final String icon;
  final String text;

  City({required this.name, required this.temp, required this.icon, required this.text});

  static City fromJson(Map json){
    return City(
      name: json['location']['name'],
      temp: json['current']['temp_c'],
      icon: json['current']['condition']['icon'],
      text: json['current']['condition']['text']
    );
  }

}