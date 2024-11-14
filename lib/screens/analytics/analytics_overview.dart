import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AnalyticsOverviewPage extends StatefulWidget {
  const AnalyticsOverviewPage({super.key});

  @override
  _AnalyticsOverviewPageState createState() => _AnalyticsOverviewPageState();
}

class _AnalyticsOverviewPageState extends State<AnalyticsOverviewPage> {
  // Sample data for charts
  final List<ChartData> _appointmentTrendData = [
    ChartData(1, 30), // Use numeric values for labels
    ChartData(2, 40),
    ChartData(3, 35),
    ChartData(4, 50),
    ChartData(5, 45),
  ];

  final List<ChartData> _treatmentSuccessRateData = [
    ChartData("Q1", 85),
    ChartData("Q2", 88),
    ChartData("Q3", 90),
    ChartData("Q4", 92),
  ];

  final List<ChartData> _patientSatisfactionData = [
    ChartData("Q1", 80),
    ChartData("Q2", 83),
    ChartData("Q3", 85),
    ChartData("Q4", 87),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics Overview"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Clinic Performance Analytics",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildChartCard(
                "Appointment Trends",
                _buildLineChart(_appointmentTrendData),
              ),
              const SizedBox(height: 20),
              _buildChartCard(
                "Treatment Success Rate",
                _buildBarChart(_treatmentSuccessRateData),
              ),
              const SizedBox(height: 20),
              _buildChartCard(
                "Patient Satisfaction",
                _buildPieChart(_patientSatisfactionData),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for displaying each chart section with a title
  Widget _buildChartCard(String title, Widget chart) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200, // Adjust height as needed
              child: chart,
            ),
          ],
        ),
      ),
    );
  }

  // Line chart for appointment trends
  Widget _buildLineChart(List<ChartData> data) {
    return charts.LineChart(
      [
        charts.Series<ChartData, int>( // Change the type to int
          id: 'Appointments',
          domainFn: (ChartData data, _) => data.label,
          measureFn: (ChartData data, _) => data.value,
          data: data,
        )
      ],
      animate: true,
      primaryMeasureAxis: const charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // Bar chart for treatment success rates
  Widget _buildBarChart(List<ChartData> data) {
    return charts.BarChart(
      [
        charts.Series<ChartData, String>(
          id: 'Treatment Success Rate',
          domainFn: (ChartData data, _) => data.label,
          measureFn: (ChartData data, _) => data.value,
          data: data,
        )
      ],
      animate: true,
    );
  }

  // Pie chart for patient satisfaction
  Widget _buildPieChart(List<ChartData> data) {
    return charts.PieChart(
      [
        charts.Series<ChartData, String>(
          id: 'Patient Satisfaction',
          domainFn: (ChartData data, _) => data.label,
          measureFn: (ChartData data, _) => data.value,
          data: data,
          labelAccessorFn: (ChartData data, _) => '${data.value}%',
        )
      ],
      animate: true,
      defaultRenderer: charts.ArcRendererConfig(
        arcRendererDecorators: [
          charts.ArcLabelDecorator(),
        ],
      ),
    );
  }
}

// Model for chart data
class ChartData {
  final dynamic label; // Use dynamic for flexibility
  final int value;

  ChartData(this.label, this.value);
}
