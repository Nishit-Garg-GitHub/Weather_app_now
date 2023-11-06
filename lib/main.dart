import 'package:flutter/material.dart';
import 'weather_service.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.blue,
      fontFamily: 'Roboto',
    ),
    home: WeatherHomePage(),
  ),
);

class WeatherHomePage extends StatefulWidget {
  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  WeatherService weatherService = WeatherService();
  Map<String, dynamic> weatherData = {};
  bool isLoading = false;


  Future<void> fetchWeatherData(String city) async {
    try {
      setState(() {
        isLoading = true;
      });
      weatherData = await weatherService.getWeatherData(city);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchWeatherData('Pilani');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (weatherData == null) {
      return Scaffold(body: Center(child: Text('Failed to load weather data')));
    } else {
      final temperature = (weatherData['main']['temp']) - 273.15;
      final weatherCondition = weatherData['weather'][0]['description'];
      final capitalizedWeatherCondition =
          weatherCondition[0].toUpperCase() + weatherCondition.substring(1);

      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManageCitiesPage(),
                ),
              );
            },
          ),
          title: Center(
            child: Text('Weather App'),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://static.vecteezy.com/system/resources/thumbnails/011/689/764/small/dark-grey-cloud-in-cloudy-sky-photo.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 40),
                Text(
                  'Vidyavihar',
                  style: TextStyle(fontSize: 35.0, color: Colors.black),
                ),
                Text(
                  '${temperature.toStringAsFixed(0)}°C', 
                  style: TextStyle(fontSize: 65.0, color: Colors.black),
                ),
                Text(
                  capitalizedWeatherCondition, 
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                ),
                Text('🥽 AQI 165',
                    style: TextStyle(fontSize: 14.0, color: Colors.black)),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(3),
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Handle the "More Details" button click
                    },
                    child: Text(
                      'More Details>',
                      style: TextStyle(fontSize: 15.0, color: Colors.blue),
                    ),
                  ),
                ),
                Card(
                  color: Colors.white,
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        WeatherInfoRow('Today', 'Haze 40°/23°'),
                        WeatherInfoRow('Tomorrow', 'Haze 40°/23°'),
                        WeatherInfoRow('Sunday', 'Haze 40°/23°'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 60),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FiveDayForecastPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                        ),
                        child: Text(
                          "5-day forecast",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    WeatherDataRow('Now', '15:00', '16:00', '17:00'),
                    WeatherDataRow('39°', '39°', '40°', '39°'),
                    WeatherDataRow('☁', '☁', '☁', '☁'),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}


class WeatherInfoRow extends StatelessWidget {
  final String day;
  final String forecast;

  WeatherInfoRow(this.day, this.forecast);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              day,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              forecast,
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ],
        ));
  }
}


class WeatherDataRow extends StatelessWidget {
  final String time1;
  final String time2;
  final String time3;
  final String time4;

  WeatherDataRow(this.time1, this.time2, this.time3, this.time4);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            time1,
            style: TextStyle(fontSize: 15.0, color: Colors.black),
          ),
          Text(
            time2,
            style: TextStyle(fontSize: 15.0, color: Colors.black),
          ),
          Text(
            time3,
            style: TextStyle(fontSize: 15.0, color: Colors.black),
          ),
          Text(
            time4,
            style: TextStyle(fontSize: 15.0, color: Colors.black),
          ),
        ]);
  }
}

class ManageCitiesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Manage Cities'),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Handle the '+' button click here (e.g., navigate to a new city screen).
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for cities...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 20),
                Container(
                  height: 80,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate back to the Weather home page
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Vidyavihar",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "AQI 158 39° / 24°",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.blue,
                            child: Center(
                              child: Text(
                                '39°',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 80,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle button click for the second city
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Delhi",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "AQI 158 39° / 24°",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.blue,
                            child: Center(
                              child: Text(
                                '37°',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
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




class FiveDayForecastPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
        flexibleSpace: Center(
          child: Text(
            '5-Day Forecast',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Today'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('6/10'),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.cloud_outlined),
                ],),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.mode_night_sharp),
                ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('→23.5km/h', style: TextStyle(fontSize: 8)),
                ],
              ),
            ],
          ),

          Column(
            children: [
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Tomorrow'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('7/10'),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.cloud_outlined),
                ],),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.mode_night_sharp),
                ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('↗18.5km/h', style: TextStyle(fontSize: 8)),
                ],
              ),
            ],
          ),

          Column(
            children: [
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Sun'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('8/10'),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.cloud_outlined),
                ],),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.mode_night_sharp),
                ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('→18.5km/h' , style: TextStyle(fontSize: 8) ),
                ],
              ),
            ],
          ),

          Column(
            children: [
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Thu'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('8/10'),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.cloud_outlined),
                ],),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.mode_night_sharp),
                ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('↗18.5km/h', style: TextStyle(fontSize: 8)),
                ],
              ),
            ],
          ),

          Column(
            children: [
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Mon'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('9/10'),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.cloud_outlined),
                ],),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.mode_night_sharp),
                ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('↗18.5km/h', style: TextStyle(fontSize: 8)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}



