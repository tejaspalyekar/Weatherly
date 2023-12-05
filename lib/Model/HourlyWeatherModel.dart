class HourlyWeatherModel {
  final String cityName;
  final String countryname;
  List<dynamic> list;

  HourlyWeatherModel(
      {required this.cityName, required this.countryname, required this.list});

  static fromJson(Map<String, dynamic> json) {
    return HourlyWeatherModel(
        cityName: json["city"]["name"],
        countryname: json["city"]["country"],
        list: json["list"]);
  }

  List<dynamic> todaysWeather() {
    List<dynamic> today = [];
    String currday = DateTime.now().day.toString();

    for (int i = 0; i < list.length; i++) {
      String date = list[i]["dt_txt"];
      String day = date.substring(9, 10);
      if (currday == day) {
        today.add(list[i]);
      }
    }
    return today;
  }
}
