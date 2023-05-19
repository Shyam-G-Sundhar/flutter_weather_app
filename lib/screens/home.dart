import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: MainNet(),
    );
  }
}

class MainNet extends StatefulWidget {
  const MainNet({super.key});

  @override
  State<MainNet> createState() => _MainNetState();
}

class _MainNetState extends State<MainNet> {
  TextEditingController cityController = new TextEditingController();
  var temp;
  var city;

  Future<void> getWeather() async {
    final String search = cityController.text;
    final String id = 'YOUR_API_KEY';
    var res = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$search&appid=$id&units=metric'));
    var data = json.decode(res.body);
    if (res.statusCode == 404) {
      citynotFound(context);
    }
    if (search.isEmpty) {
      blankfield(context);
    }
    setState(() {
      temp = data['main']['temp'];
      city = data['name'];
    });
  }

  detectConnection(connection) async {
    connection = await (Connectivity().checkConnectivity());
    if (connection != ConnectivityResult.mobile &&
        connection != ConnectivityResult.wifi) {
      noNet(context);
    } else {
      getWeather();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              'Weather App',
              style: GoogleFonts.reemKufi(
                  textStyle: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700])),
            ),
          ),
          SizedBox(
            width: 330,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 5.0,
                      spreadRadius: 1,
                    )
                  ]),
              width: 340,
              child: TextField(
                controller: cityController,
                onSubmitted: (callback) => {
                  detectConnection(context),
                },
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    filled: true,
                    fillColor: Colors.blue,
                    labelText: 'Search for a city...',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none)),
                obscureText: false,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40.0, bottom: 10),
            child: city == null
                ? Text(
                    "Type the City",
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700]),
                    ),
                  )
                : Text(
                    "Weather in $city",
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700]),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3.0, bottom: 10),
            child: temp == null
                ? Text(
                    "",
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700]),
                    ),
                  )
                : Text(
                    "$temp" "°C",
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                          fontSize: 33,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700]),
                    ),
                  ),
          ),
          Flexible(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Image.asset('assets/wetman.jpg'),
            ),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  citynotFound(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 260,
              width: 230,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      "City Not Found!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700]),
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/404.jpg',
                    height: 165,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Check the spelling or try a different city.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actionsPadding: EdgeInsets.all(10),
            contentPadding: EdgeInsets.all(10),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          );
        });
  }

  blankfield(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 170,
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      "Please enter a city name!",
                      style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actionsPadding: EdgeInsets.all(10),
            contentPadding: EdgeInsets.all(10),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          );
        });
  }

  noNet(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 170,
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/nosig.jpg',
                    height: 70,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      "No Internet",
                      style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actionsPadding: EdgeInsets.all(10),
            contentPadding: EdgeInsets.all(10),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          );
        });
  }
}
