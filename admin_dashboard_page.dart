import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedRange = 7;

  // ---------- MOCK DATA ----------
  final int approvedCount = 12;
  final int pendingCount = 3;
  final int rejectedCount = 2;

  final List<FlSpot> trend7Days = const [
    FlSpot(1, 1),
    FlSpot(2, 2),
    FlSpot(3, 3),
    FlSpot(4, 2),
    FlSpot(5, 4),
    FlSpot(6, 5),
    FlSpot(7, 4),
  ];

  final List<FlSpot> trend30Days = List.generate(
    30,
    (i) => FlSpot(
      (i + 1).toDouble(),
      (i % 6 + 1).toDouble(),
    ),
  );

  final List<Map<String, dynamic>> listings = [
    {
      'title': 'Office Chair',
      'listedBy': 'john@company.com',
      'type': 'Sell',
      'price': '₹2500',
      'date': '2025-12-01',
    },
    {
      'title': 'Books Set',
      'listedBy': 'alice@company.com',
      'type': 'Donation',
      'price': 'Free',
      'date': '2025-11-29',
    },
    {
      'title': 'Projector',
      'listedBy': 'mark@company.com',
      'type': 'Rent',
      'price': '₹500',
      'date': '2025-11-28',
    },
  ];

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    final trendData = _selectedRange == 7 ? trend7Days : trend30Days;

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ================= KPI ROW =================
            Row(
              children: [
                _kpi('Total Listings', '17', Icons.list_alt),
                _kpi('Approved', '$approvedCount', Icons.check_circle),
                _kpi('Pending', '$pendingCount', Icons.hourglass_top),
                _kpi('Rejected', '$rejectedCount', Icons.cancel),
              ],
            ),

            const SizedBox(height: 24),

            // ================= PIE + TREND =================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ---------- PIE CHART ----------
                Expanded(
                  flex: 2,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'Listing Status Distribution',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 200,
                            child: PieChart(
                              PieChartData(
                                centerSpaceRadius: 50,
                                sectionsSpace: 2,
                                sections: [
                                  PieChartSectionData(
                                    value: approvedCount.toDouble(),
                                    color: Colors.green,
                                    title: 'Approved',
                                    radius: 60,
                                  ),
                                  PieChartSectionData(
                                    value: pendingCount.toDouble(),
                                    color: Colors.orange,
                                    title: 'Pending',
                                    radius: 60,
                                  ),
                                  PieChartSectionData(
                                    value: rejectedCount.toDouble(),
                                    color: Colors.red,
                                    title: 'Rejected',
                                    radius: 60,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // ---------- TREND CHART ----------
                Expanded(
                  flex: 3,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Activity Overview',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              ToggleButtons(
                                isSelected: [
                                  _selectedRange == 7,
                                  _selectedRange == 30
                                ],
                                onPressed: (index) {
                                  setState(() {
                                    _selectedRange = index == 0 ? 7 : 30;
                                  });
                                },
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: Text('7 Days'),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: Text('30 Days'),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          SizedBox(
                            height: 260,
                            child: LineChart(
                              LineChartData(
                                minX: 1,
                                maxX: _selectedRange.toDouble(),
                                minY: 0,
                                maxY: 6,
                                gridData: FlGridData(show: true),
                                borderData: FlBorderData(show: true),

                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    axisNameWidget: const Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Text('Days'),
                                    ),
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval:
                                          _selectedRange == 7 ? 1 : 5,
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    axisNameWidget: const Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: Text('Listings Count'),
                                    ),
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 1,
                                      reservedSize: 40,
                                    ),
                                  ),
                                  rightTitles: const AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  topTitles: const AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                ),

                                lineBarsData: [
                                  LineChartBarData(
                                    isCurved: true,
                                    color: Colors.green,
                                    barWidth: 3,
                                    dotData: FlDotData(show: true),
                                    spots: trendData,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // ================= TABLE =================
            const Text(
              'Pending Listings',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Card(
              child: SizedBox(
                width: double.infinity,
                child: DataTable(
                  columnSpacing: 24,
                  columns: const [
                    DataColumn(label: Text('Title')),
                    DataColumn(label: Text('Listed By')),
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Uploaded')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: listings.map((item) {
                    return DataRow(cells: [
                      DataCell(Text(item['title'])),
                      DataCell(Text(item['listedBy'])),
                      DataCell(Text(item['type'])),
                      DataCell(Text(item['price'])),
                      DataCell(Text(item['date'])),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check,
                                  color: Colors.green),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.close, color: Colors.red),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kpi(String title, String value, IconData icon) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon),
              const SizedBox(height: 6),
              Text(value,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              Text(title, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
