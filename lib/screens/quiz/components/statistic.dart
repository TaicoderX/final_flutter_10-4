import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Statistic extends StatelessWidget {
  double totalQuestion;

  double wrongAnswer;

  Statistic({
    Key? key,
    required this.totalQuestion,
    required this.wrongAnswer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade700,
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade700,
        leading: IconButton(
          icon: const Icon(Icons.close, size: 30,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              color: Colors.green,
              value: totalQuestion - wrongAnswer,
              title: 'Đúng',
              radius: 50,
              titleStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff),
              ),
            ),
            PieChartSectionData(
              color: Colors.red,
              value: wrongAnswer,
              title: 'Sai',
              radius: 50,
              titleStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff),
              ),
            ),
          ],
          sectionsSpace: 0, // Không có khoảng cách giữa các phần
          centerSpaceRadius: 40, // Bán kính của không gian trung tâm
        ),
      ),
    );
  }
}
