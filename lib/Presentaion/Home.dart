import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/Model/HourlyWeatherModel.dart';
import 'package:weather_app/Model/WeatherModel.dart';
import 'package:weather_app/Services/WeatherHourlyService.dart';
import 'package:weather_app/Services/WeatherServices.dart';
import 'package:weather_app/Widgets/loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  static String key = '908ee85c110f2216ce21db52fcc7f214'; //api key
  WeatherModel? weather;
  HourlyWeatherModel? hrweather;
  final WeatherService? service = WeatherService(apikey: key);
  final HourlyService hourlyservice = HourlyService(apikey: key);
  List<dynamic>? todaysWeather;
  bool searchbox = false;
  double searchboxwidth = 0;
  bool loading = true;
  TextEditingController searched_City = TextEditingController();

  fetchtemp() async {
    final citys = await service?.currentCity();

    try {
      final weathers = await service?.getWeather(citys!);
      setState(() {
        weather = weathers;
        loading = false;
      });
      await fetchhourlyweatherdata();
    } catch (e) {
      print(e);
    }
  }

  fetchtempofsearchcity(city) async {
    try {
      final weathers = await service?.getWeather(city);
      setState(() {
        weather = weathers;
        loading = false;
        searchbox = false;
        searchboxwidth = 0;
      });
    } catch (e) {
      print(e);
    }
  }

  fetchhourlyweatherdata() async {
    final listofweather =
        await hourlyservice.fetchHourlydata(weather!.cityName);
      hrweather = listofweather;
      
      List<dynamic> todayweather =  hrweather!.todaysWeather();
      setState(() {
         todaysWeather = todayweather;

      });
    
  }

  @override
  void initState() {
    super.initState();
    fetchtemp();
  }

  returnlottie(String main) {
    if (main.toLowerCase() == "clouds") {
      return 'Assets/cloud.json';
    } else if (main.toLowerCase() == "rain") {
      return 'Assets/rainy.json';
    } else if (main.toLowerCase() == "haze" || main.toLowerCase() == "fog") {
      return 'Assets/haze.json';
    } else if (main.toLowerCase() == "mist") {
      return 'Assets/mist.json';
    }
    return 'Assets/snow.json';
  }

  @override
  build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blueGrey[600],
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[600],
          actions: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  color: const Color.fromARGB(134, 69, 90, 100),
                  borderRadius: const BorderRadius.all(Radius.circular(30))),
              height: 50,
              width: searchboxwidth,
              child: TextField(
                controller: searched_City,
                cursorColor: const Color.fromARGB(183, 255, 255, 255),
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.only(bottom: 5, left: 20, right: 10),
                    border: InputBorder.none,
                    hintText: "Enter City/Pincode",
                    hintStyle: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(230, 231, 231, 231))),
              ),
            ),
            IconButton(
                onPressed: () {
                  print(hrweather?.list);
                  if (searchbox == true) {
                    if (searched_City.text == "") {
                      setState(() {
                        searchbox = false;
                        searchboxwidth = 0;
                      });
                    } else {
                      setState(() {
                        loading = true;
                      });
                      fetchtempofsearchcity(searched_City.text);
                      searched_City.text = "";
                    }
                  } else {
                    setState(() {
                      searchbox = true;
                      searchboxwidth = 170;
                    });
                  }
                },
                icon: const Icon(
                  Icons.search,
                  size: 40,
                  color: Color.fromARGB(255, 255, 255, 255),
                ))
          ],
          title: const Text(
            "Weatherly",
            style: TextStyle(
                fontSize: 30,
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 20, right: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(134, 69, 90, 100),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: loading
                      ? LottieBuilder.asset(
                          'Assets/waterloading.json',
                          width: 300,
                          height: 240,
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Lottie.asset(
                                    returnlottie(weather!.maincondition),
                                    width: 200),
                                Column(
                                  children: [
                                    Text('${weather?.temp.round()}°C',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 40)),
                                    Text('${weather?.maincondition}',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 30)),
                                  ],
                                )
                              ],
                            ),
                            Text(
                              '${weather?.cityName} , ${weather?.countryname}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 27),
                            ),
                          ],
                        ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(134, 69, 90, 100),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: loading
                      ? const Loadingscreen()
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('wind speed ${weather?.windspeed}',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 18)),
                                    Text('wind degree ${weather?.winddegree}',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 18)),
                                    Text('Visibility ${weather?.visibility}',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 18))
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Max Temp ${weather?.maxtemp.round()}',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 18)),
                                    Text('Min Temp ${weather?.mintemp.round()}',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 18)),
                                    Text('Pressure ${weather?.pressure}',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 18)),
                                  ],
                                )
                              ],
                            ),
                            Text('Humidity ${weather?.humidity}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18)),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
