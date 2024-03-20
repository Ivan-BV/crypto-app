import 'package:cryptoapp/src/cfg/api_client.dart';
import 'package:cryptoapp/src/cfg/models.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CoinMarketChart extends StatelessWidget {
  final String coinId;

  const CoinMarketChart({super.key, required this.coinId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MarketChart>(
        future: ApiClient().getCoinMarketChartInfo(coinId),
        builder: (context, marketChart) {
          Widget child = const Center(child: CircularProgressIndicator());
          if (marketChart.hasData) {
            child = LineChart(
              curve: Curves.linear,
              mainData(marketChart.data!),
            );
          }
          return SizedBox(
            width: 370,
            height: 250,
            child: child,
          );
        });
  }

  LineChartData mainData(MarketChart marketChart) {
    List<Color> gradientColors = [
      const Color(0xff23b6e6),
      const Color(0xff02d39a),
    ];

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: true,
        horizontalInterval: (marketChart.maxPrice - marketChart.minPrice) / 6,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 0.1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 3,
              getTitlesWidget: (value, meta) {
                return bottomTitleWidgets(
                    marketChart.prices[value.toInt()].timestamp, meta);
              }),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            interval: 3,
            getTitlesWidget: (value, meta) {
              return leftTitleWidgets(value, meta);
            },
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: false,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: (marketChart.prices.length - 1).toDouble(),
      minY: marketChart.minPrice,
      maxY: marketChart.maxPrice,
      lineBarsData: [
        LineChartBarData(
          spots: buildChartData(marketChart),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double timestamp, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );

    var time = DateTime.fromMillisecondsSinceEpoch(timestamp.toInt());
    var dateFormatter = DateFormat('dd/MM');

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.0,
      child: Text(dateFormatter.format(time), style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );

    return Text(value.toString(), style: style, textAlign: TextAlign.left);
  }

  List<FlSpot> buildChartData(MarketChart marketChart) {
    List<FlSpot> data = [];

    marketChart.prices.asMap().forEach((index, pricePoint) {
      String formatedDot = NumberFormat("####.##").format(pricePoint.price);
      data.add(FlSpot(
          index.toDouble(), NumberFormat().parse(formatedDot).toDouble()));
    });

    return data;
  }
}
