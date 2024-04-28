import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tempapp/appManager/time_manager.dart';
import 'package:tempapp/appManager/view_manager.dart';

///การแสดงผลของกราฟ
class LineChartTemp extends StatefulWidget {
  final String lengthType;
  final double tempData1;
  final double tempData2;
  final String typeShowChart;
  final String date1;

  LineChartTemp(
      {Key? key,
      required this.lengthType,
      required this.tempData1,
      required this.typeShowChart,
      required this.tempData2,
      required this.date1})
      : super(key: key);

  @override
  State<LineChartTemp> createState() => _LineChartTempState();
}

class _LineChartTempState extends State<LineChartTemp> {
  List<int> showingTooltipOnSpots = [0, 1, 2, 3, 4, 5, 6];
  double plotDataX = 0.0;
  bool haveData = false;

  List<FlSpot> get allSpots => widget.typeShowChart == "sensor1"
      ? [
          FlSpot(0, widget.tempData1),
          FlSpot(1, 0),
          FlSpot(2, 0),
          FlSpot(3, 0),
          FlSpot(4, 0),
          FlSpot(5, 0),
          FlSpot(6, 0),
        ]
      : [
          FlSpot(0, widget.tempData2),
          FlSpot(1, 0),
          FlSpot(2, 0),
          FlSpot(3, 0),
          FlSpot(4, 0),
          FlSpot(5, 0),
          FlSpot(6, 0),
        ];

  @override
  void initState() {
    TimeManager.timeSixtyRange();
    TimeManager.timeTwentyHour();
    TimeManager.timeSevenDays();
    TimeManager.timeThirtyDays();
    super.initState();
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    final style = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'Digital',
      fontSize: 16 * chartWidth / 600,
    );
    if (widget.lengthType == "24 ชั่วโมง") {
      List<String> timeRange = TimeManager.reducedTwentyHour;
      String text;
      switch (value.toInt()) {
        case 0:
          text = timeRange[0].toString();
          break;
        case 1:
          text = timeRange[1].toString();
          break;
        case 2:
          text = timeRange[2].toString();
          break;
        case 3:
          text = timeRange[3].toString();
          break;
        case 4:
          text = timeRange[4].toString();
          break;
        case 5:
          text = timeRange[5].toString();
          break;
        case 6:
          text = timeRange[6].toString();
          break;
        default:
          return Container();
      }

      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(text, style: style),
      );
    } else if (widget.lengthType == "30 วัน") {
      List<String> timeRange = TimeManager.reducedThirtyDays;
      String text;
      switch (value.toInt()) {
        case 0:
          text = timeRange[0].toString();
          break;
        case 1:
          text = timeRange[1].toString();
          break;
        case 2:
          text = timeRange[2].toString();
          break;
        case 3:
          text = timeRange[3].toString();
          break;
        case 4:
          text = timeRange[4].toString();
          break;
        case 5:
          text = timeRange[5].toString();
          break;
        case 6:
          text = timeRange[6].toString();
          break;
        default:
          return Container();
      }

      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(text, style: style),
      );
    } else if (widget.lengthType == "7 วัน") {
      List<String> timeRange = TimeManager.reducedSevenDays;
      String text;
      switch (value.toInt()) {
        case 0:
          text = timeRange[0].toString();
          break;
        case 1:
          text = timeRange[1].toString();
          break;
        case 2:
          text = timeRange[2].toString();
          break;
        case 3:
          text = timeRange[3].toString();
          break;
        case 4:
          text = timeRange[4].toString();
          break;
        case 5:
          text = timeRange[5].toString();
          break;
        case 6:
          text = timeRange[6].toString();
          break;
        default:
          return Container();
      }

      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(text, style: style),
      );
    } else {
      List<String> timeRange = TimeManager.reducedTimesSixty;
      String text;
      switch (value.toInt()) {
        case 0:
          text = timeRange[0].toString();
          break;
        case 1:
          text = timeRange[1].toString();
          break;
        case 2:
          text = timeRange[2].toString();
          break;
        case 3:
          text = timeRange[3].toString();
          break;
        case 4:
          text = timeRange[4].toString();
          break;
        case 5:
          text = timeRange[5].toString();
          break;
        case 6:
          text = timeRange[6].toString();
          break;
        default:
          return Container();
      }

      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(text, style: style),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lineBarsData = [
      LineChartBarData(
        showingIndicators: showingTooltipOnSpots,
        spots: allSpots,
        isCurved: true,
        barWidth: 4,
        shadow: const Shadow(
          blurRadius: 8,
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              Colors.red.withOpacity(0.4),
              Colors.green.withOpacity(0.4),
              Colors.blue.withOpacity(0.4),
            ],
          ),
        ),
        dotData: const FlDotData(show: false),
        gradient: LinearGradient(
          colors: [Colors.red, Colors.green, Colors.blue],
          stops: const [0.1, 0.4, 0.9],
        ),
      ),
    ];

    final tooltipsOnBar = lineBarsData[0];

    return AspectRatio(
      aspectRatio: 2.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 10,
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          return LineChart(
            LineChartData(
              showingTooltipIndicators: showingTooltipOnSpots.map((index) {
                return ShowingTooltipIndicators([
                  LineBarSpot(
                    tooltipsOnBar,
                    lineBarsData.indexOf(tooltipsOnBar),
                    tooltipsOnBar.spots[index],
                  ),
                ]);
              }).toList(),
              lineTouchData: LineTouchData(
                enabled: true,
                handleBuiltInTouches: false,
                mouseCursorResolver:
                    (FlTouchEvent event, LineTouchResponse? response) {
                  if (response == null || response.lineBarSpots == null) {
                    return SystemMouseCursors.basic;
                  }
                  return SystemMouseCursors.click;
                },
                getTouchedSpotIndicator:
                    (LineChartBarData barData, List<int> spotIndexes) {
                  return spotIndexes.map((index) {
                    if (index == 0) {
                      return TouchedSpotIndicatorData(
                        FlLine(
                          color: Colors.transparent,
                        ),
                        FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                            radius: 8,
                            color: lerpGradient(
                              barData.gradient!.colors,
                              barData.gradient!.stops!,
                              percent / 100,
                            ),
                            strokeWidth: 2,
                            strokeColor: ColorManager().primaryColor,
                          ),
                        ),
                      );
                    }
                  }).toList();
                },
                touchTooltipData: LineTouchTooltipData(
                  tooltipRoundedRadius: 8,
                  getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                    return lineBarsSpot.map((lineBarSpot) {
                      if (lineBarSpot.y != 0) {
                        return LineTooltipItem(
                          lineBarSpot.y.toString(),
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    }).toList();
                  },
                ),
              ),
              lineBarsData: lineBarsData,
              minY: -3,
              maxY: 50,
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  axisNameSize: 24,
                  sideTitles: SideTitles(
                    showTitles: false,
                    reservedSize: 0,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      print('value $value');
                      return bottomTitleWidgets(
                        value,
                        meta,
                        constraints.maxWidth,
                      );
                    },
                    reservedSize: 30,
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                    reservedSize: 0,
                  ),
                ),
                topTitles: const AxisTitles(
                  axisNameWidget: Text(
                    'Temperature',
                    textAlign: TextAlign.left,
                  ),
                  axisNameSize: 24,
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 0,
                  ),
                ),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: Colors.black,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Lerps between a [LinearGradient] colors, based on [t]
Color lerpGradient(List<Color> colors, List<double> stops, double t) {
  if (colors.isEmpty) {
    throw ArgumentError('"colors" is empty.');
  } else if (colors.length == 1) {
    return colors[0];
  }

  if (stops.length != colors.length) {
    stops = [];

    /// provided gradientColorStops is invalid and we calculate it here
    colors.asMap().forEach((index, color) {
      final percent = 1.0 / (colors.length - 1);
      stops.add(percent * index);
    });
  }

  for (var s = 0; s < stops.length - 1; s++) {
    final leftStop = stops[s];
    final rightStop = stops[s + 1];
    final leftColor = colors[s];
    final rightColor = colors[s + 1];
    if (t <= leftStop) {
      return leftColor;
    } else if (t < rightStop) {
      final sectionT = (t - leftStop) / (rightStop - leftStop);
      return Color.lerp(leftColor, rightColor, sectionT)!;
    }
  }
  return colors.last;
}
