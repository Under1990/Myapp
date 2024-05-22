import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  int temperature = 0;
  int temperature2 = 0;
  List<FlSpot> tempSpots = [];
  List<FlSpot> tempSpots2 = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    _fetchData();
  }

  void _fetchData() {
    _databaseReference.child('sensor1').onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        final temp = data['temperature1'].toDouble();
        setState(() {
          temperature = temp.toInt();
          tempSpots.add(FlSpot(tempSpots.length.toDouble(), temp));
          if (tempSpots.length > 6) tempSpots.removeAt(0);
          _saveData();
        });
      }
    });

    _databaseReference.child('sensor2').onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        final temp2 = data['temperature2'].toDouble();
        setState(() {
          temperature2 = temp2.toInt();
          tempSpots2.add(FlSpot(tempSpots2.length.toDouble(), temp2));
          if (tempSpots2.length > 6) tempSpots2.removeAt(0);
          _saveData();
        });
      }
    });
  }

  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tempSpotsString = tempSpots.map((spot) => jsonEncode({'x': spot.x, 'y': spot.y})).toList();
    List<String> tempSpots2String = tempSpots2.map((spot) => jsonEncode({'x': spot.x, 'y': spot.y})).toList();
    await prefs.setStringList('tempSpots', tempSpotsString);
    await prefs.setStringList('tempSpots2', tempSpots2String);
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? tempSpotsString = prefs.getStringList('tempSpots');
    List<String>? tempSpots2String = prefs.getStringList('tempSpots2');

    if (tempSpotsString != null) {
      setState(() {
        tempSpots = tempSpotsString.map((spotString) {
          Map<String, dynamic> spotMap = jsonDecode(spotString);
          return FlSpot(spotMap['x'], spotMap['y']);
        }).toList();
      });
    }

    if (tempSpots2String != null) {
      setState(() {
        tempSpots2 = tempSpots2String.map((spotString) {
          Map<String, dynamic> spotMap = jsonDecode(spotString);
          return FlSpot(spotMap['x'], spotMap['y']);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF31c5a3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Refrigerator1',
                    style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Refrigerator2',
                    style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    temperature.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '°C',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  Spacer(),
                  Text(
                    temperature2.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '°C',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.sentiment_satisfied, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'Temperature Graph',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.all(16),
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                      ),
                      borderData: FlBorderData(show: true),
                      minX: 0,
                      maxX: 5,
                      minY: 20,
                      maxY: 30,
                      lineBarsData: [
                        LineChartBarData(
                          spots: tempSpots,
                          isCurved: true,
                          barWidth: 4,
                          color: Color(0xFF31c5a3),
                          belowBarData: BarAreaData(show: true, color: Color(0xFF31c5a3).withOpacity(0.3)),
                        ),
                        LineChartBarData(
                          spots: tempSpots2,
                          isCurved: true,
                          barWidth: 4,
                          color: Color(0xFF76c7c0),
                          belowBarData: BarAreaData(show: true, color: Color(0xFF76c7c0).withOpacity(0.3)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
