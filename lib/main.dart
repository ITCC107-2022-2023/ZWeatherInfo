import 'package:flutter/material.dart';
import 'weather.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zamboanga Weather Info',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WeatherScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Weather weather = Weather();
  String cityName = 'Zamboanga City'; // Default city
  Map<String, dynamic> weatherData = {};
  List<dynamic> forecastData = [];

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  void fetchWeatherData() async {
    try {
      final data = await weather.getWeather(cityName);
      final forecast = await weather.getForecast(cityName);

      setState(() {
        weatherData = data;
        forecastData = forecast;
      });
    } catch (e) {
      print(e);
    }
  }

  void navigateToAboutScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AboutScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Zamboanga Weather Info'),
      backgroundColor: Color(0xFF90e0ef),),
      body: Container(
        color: Color(0xFFcaf0f8), // background color
        child: Center(
          child: weatherData.isEmpty
              ? Text(
            'Fetching weather data...',
            style: TextStyle(fontSize: 20.0),
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50.0,
                height: 50.0,
                child: CachedNetworkImage(
                  imageUrl:
                  'http://openweathermap.org/img/w/${weatherData['weather'][0]['icon']}.png',
                  placeholder: (context, url) =>
                      CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(height: 12.0),
              Text(
                cityName,
                style: TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Text(
                '${(weatherData['main']['temp'] / 10).toStringAsFixed(1)}°C',
                style: TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                '${weatherData['weather'][0]['description']}',
                style: TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 60.0),
              Text(
                'Forecast in the next days:',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 20.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: forecastData
                      .where((forecast) {
                    final dateTime =
                    DateTime.fromMillisecondsSinceEpoch(
                        forecast['dt'] * 1000);
                    return dateTime.weekday >= 1 &&
                        dateTime.weekday <= 7;
                  })
                      .toSet()
                      .map((forecast) {
                    final dateTime =
                    DateTime.fromMillisecondsSinceEpoch(
                        forecast['dt'] * 1000);
                    final temperature =
                    forecast['main']['temp'];
                    final weatherDescription = forecast['weather'][0]
                    ['description'];
                    final iconCode = forecast['weather'][0]['icon'];

                    return Container(
                      width: 120.0,
                      padding:
                      EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          Text(
                            getDayOfWeek(dateTime.weekday),
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          CachedNetworkImage(
                            imageUrl:
                            'http://openweathermap.org/img/w/$iconCode.png',
                            width: 50.0,
                            height: 50.0,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '${(temperature / 10).toStringAsFixed(1)}°C',
                          ),
                          Text(weatherDescription),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ElevatedButton.icon(
        onPressed: navigateToAboutScreen,
        icon: Icon(FeatherIcons.info),
        label: Text('About'),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF90e0ef)),
        ),
      ),
    );
  }

  String getDayOfWeek(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }
}

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About Weather'),
      backgroundColor: Color(0xFF90e0ef),),
      body: Container(
        color: Color(0xFFcaf0f8), // Set the background color here
        padding: EdgeInsets.all(16.0), // Add some padding for better display
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/openweathermap_logo.png',
                width: 170.0,
                height: 170.0,
              ),
              Text('openweathermap.org', style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 16.0),
              Text(
                'This simple weather informative app provides real-time weather updates and forecasts for Zamboanga City. It displays the current weather status, including temperature, weather description, and an icon representation. The app fetches the weather data from the OpenWeatherMap API, ensuring accurate and up-to-date information. Stay informed about the weather conditions in Zamboanga City with this intuitive and user-friendly weather app.',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.justify, // Justify the text
              ),
            ],
          ),
        ),
      ),
    );
  }
}