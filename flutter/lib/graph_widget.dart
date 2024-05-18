import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LineChartSample5 extends StatefulWidget {
  const LineChartSample5({
    super.key,
    required this.graphData,
    Color? gradientColor1,
    Color? gradientColor2,
    Color? gradientColor3,
    Color? indicatorStrokeColor,
  })  : gradientColor1 = gradientColor1 ?? const Color(0xFF2196F3),
        gradientColor2 = gradientColor2 ?? const Color(0xFFFF3AF2),
        gradientColor3 = gradientColor3 ?? const Color(0xFFE80054),
        indicatorStrokeColor = indicatorStrokeColor ?? Colors.white;

  final Color gradientColor1;
  final Color gradientColor2;
  final Color gradientColor3;
  final Color indicatorStrokeColor;
  final Map<dynamic, dynamic> graphData;

  @override
  State<LineChartSample5> createState() => _LineChartSample5State();
}

class _LineChartSample5State extends State<LineChartSample5> {
  List<int> showingTooltipOnSpots = [];
  List<String> xLabels = [];
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _prepareXLabels();
    _updateShowingTooltipOnSpots();
  }

  @override
  void didUpdateWidget(covariant LineChartSample5 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.graphData != oldWidget.graphData) {
      _prepareXLabels();
      _updateShowingTooltipOnSpots();
    }
  }

  void _prepareXLabels() {
    final String formattedDate = DateFormat('dd-MM-yyyy').format(currentDate);
    final dailyData = widget.graphData[formattedDate];

    if (dailyData != null) {
      final Map<String, int> castedDailyData = Map<String, int>.from(dailyData as Map);
      xLabels = castedDailyData.keys.map((key) {
        final int hour = int.parse(key);
        final formattedHour = hour.toString().padLeft(2, '0');
        return '$formattedHour:00';
      }).toList();
    } else {
      xLabels = [];
    }
  }

  void _updateShowingTooltipOnSpots() {
    showingTooltipOnSpots = [0, (allSpots.length/2).ceil(), allSpots.length-1];
  }

  List<FlSpot> get allSpots {
    final String formattedDate = DateFormat('dd-MM-yyyy').format(currentDate);
    final dailyData = widget.graphData[formattedDate];

    if (dailyData == null) {
      return [];
    }

    final Map<String, int> castedDailyData = Map<String, int>.from(dailyData as Map);
    final List<FlSpot> spots = [];
    int index = 0;

    castedDailyData.forEach((key, value) {
      spots.add(FlSpot(index.toDouble(), value.toDouble()));
      index++;
    });

    return spots;
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final int index = value.toInt();
    final String label = (index >= 0 && index < xLabels.length) ? xLabels[index] : '';
    final style = TextStyle(
      fontWeight: FontWeight.bold,
      color: const Color(0xFFFF3AF2),
      fontFamily: 'Digital',
      fontSize: 12,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(label, style: style),
    );
  }

  void _previousDay() {
    final newDate = currentDate.subtract(Duration(days: 1));
    final String formattedDate = DateFormat('dd-MM-yyyy').format(newDate);
    if (widget.graphData.containsKey(formattedDate)) {
      setState(() {
        currentDate = newDate;
        _prepareXLabels();
        _updateShowingTooltipOnSpots();
      });
    }
  }

  void _nextDay() {
    final newDate = currentDate.add(Duration(days: 1));
    final String formattedDate = DateFormat('dd-MM-yyyy').format(newDate);
    if (widget.graphData.containsKey(formattedDate)) {
      setState(() {
        currentDate = newDate;
        _prepareXLabels();
        _updateShowingTooltipOnSpots();
      });
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
              widget.gradientColor1.withOpacity(0.4),
              widget.gradientColor2.withOpacity(0.4),
              widget.gradientColor3.withOpacity(0.4),
            ],
          ),
        ),
        dotData: const FlDotData(show: false),
        gradient: LinearGradient(
          colors: [
            widget.gradientColor1,
            widget.gradientColor2,
            widget.gradientColor3,
          ],
          stops: const [0.1, 0.4, 0.9],
        ),
      ),
    ];

    final tooltipsOnBar = lineBarsData[0];

    return AspectRatio(
      aspectRatio: 2,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousDay,
              ),
              Text(
                DateFormat('dd-MM-yyyy').format(currentDate),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: _nextDay,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
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
                      touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                        if (response == null || response.lineBarSpots == null) {
                          return;
                        }
                        if (event is FlTapUpEvent) {
                          final spotIndex = response.lineBarSpots!.first.spotIndex;
                          setState(() {
                            if (showingTooltipOnSpots.contains(spotIndex)) {
                              showingTooltipOnSpots.remove(spotIndex);
                            } else {
                              showingTooltipOnSpots.add(spotIndex);
                            }
                          });
                        }
                      },
                      mouseCursorResolver: (FlTouchEvent event, LineTouchResponse? response) {
                        if (response == null || response.lineBarSpots == null) {
                          return SystemMouseCursors.basic;
                        }
                        return SystemMouseCursors.click;
                      },
                      getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                        return spotIndexes.map((index) {
                          return TouchedSpotIndicatorData(
                            const FlLine(
                              color: Colors.pink,
                            ),
                            FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                                radius: 8,
                                color: lerpGradient(
                                  barData.gradient!.colors,
                                  barData.gradient!.stops!,
                                  percent / 100,
                                ),
                                strokeWidth: 2,
                                strokeColor: widget.indicatorStrokeColor,
                              ),
                            ),
                          );
                        }).toList();
                      },
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (touchedSpot) => Colors.pink,
                        tooltipRoundedRadius: 8,
                        getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                          return lineBarsSpot.map((lineBarSpot) {
                            return LineTooltipItem(
                              lineBarSpot.y.toString(),
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    lineBarsData: lineBarsData,
                    minY: 0,
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        axisNameWidget: Text('Times Moved'),
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
                          getTitlesWidget: bottomTitleWidgets,
                          reservedSize: 30,
                        ),
                      ),
                      topTitles: const AxisTitles(
                        axisNameWidget: Text(
                          '',
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
                        color: Colors.white54,
                      ),
                    ),
                    minX: 0,
                    maxX: (xLabels.length - 1).toDouble(),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

Color lerpGradient(List<Color> colors, List<double> stops, double t) {
  if (colors.isEmpty) {
    throw ArgumentError('"colors" is empty.');
  } else if (colors.length == 1) {
    return colors[0];
  }

  if (stops.length != colors.length) {
    stops = [];

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
