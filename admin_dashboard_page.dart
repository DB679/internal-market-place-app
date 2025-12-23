import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'listing.dart';
import 'listing_detail_page.dart';

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

  // Pending listings as `Listing` objects so admin can open full detail view
  final List<Listing> listings = [
    Listing(
      id: 'a1',
      title: 'Office Chair',
      imageUrl: 'https://images.pexels.com/photos/374746/pexels-photo-374746.jpeg',
      price: 2500,
      location: 'Head Office, Floor 3',
      date: '2025-12-01',
      category: 'Furniture',
      description: 'Comfortable office chair awaiting approval.',
      sellerName: 'john@company.com',
      sellerDepartment: 'Facilities',
      sellerPhone: '+1-555-0201',
      sellerEmail: 'john@company.com',
    ),
    Listing(
      id: 'a2',
      title: 'Books Set',
      imageUrl: 'https://images.pexels.com/photos/1370295/pexels-photo-1370295.jpeg',
      price: 0,
      location: 'Library',
      date: '2025-11-29',
      category: 'Books',
      isDonation: true,
      description: 'Donation: programming book collection.',
      sellerName: 'alice@company.com',
      sellerDepartment: 'Library',
      sellerPhone: '+1-555-0202',
      sellerEmail: 'alice@company.com',
    ),
    Listing(
      id: 'a3',
      title: 'Projector',
      imageUrl: 'https://images.pexels.com/photos/276024/pexels-photo-276024.jpeg',
      price: 500,
      location: 'Conference Room',
      date: '2025-11-28',
      category: 'Electronics',
      description: 'Portable projector for presentations.',
      sellerName: 'mark@company.com',
      sellerDepartment: 'AV',
      sellerPhone: '+1-555-0203',
      sellerEmail: 'mark@company.com',
    ),
  ];

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    final trendData = _selectedRange == 7 ? trend7Days : trend30Days;
    final width = MediaQuery.of(context).size.width;
    final isNarrow = width < 900;

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
            isNarrow
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Pie chart on top for narrow screens
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              const Text(
                                'Listing Status Distribution',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 180,
                                child: PieChart(
                                  PieChartData(
                                    centerSpaceRadius: 40,
                                    sectionsSpace: 2,
                                    sections: [
                                      PieChartSectionData(
                                        value: approvedCount.toDouble(),
                                        color: Colors.green,
                                        title: 'Approved',
                                        radius: 48,
                                      ),
                                      PieChartSectionData(
                                        value: pendingCount.toDouble(),
                                        color: Colors.orange,
                                        title: 'Pending',
                                        radius: 48,
                                      ),
                                      PieChartSectionData(
                                        value: rejectedCount.toDouble(),
                                        color: Colors.red,
                                        title: 'Rejected',
                                        radius: 48,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
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
                                        padding: EdgeInsets.symmetric(horizontal: 12),
                                        child: Text('7 Days'),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 12),
                                        child: Text('30 Days'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 220,
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
                                          interval: _selectedRange == 7 ? 1 : 5,
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
                                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                    ],
                  )
                : Row(
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
                                          padding: EdgeInsets.symmetric(horizontal: 12),
                                          child: Text('7 Days'),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 12),
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
                                            interval: _selectedRange == 7 ? 1 : 5,
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
                                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final tableWidth = constraints.maxWidth;
                    final narrowTable = tableWidth < 700;

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: narrowTable ? tableWidth : 900),
                        child: DataTable(
                          showCheckboxColumn: false,
                          columnSpacing: narrowTable ? 12 : 24,
                          dataRowHeight: narrowTable ? 48 : 56,
                          headingRowHeight: narrowTable ? 36 : 48,
                          columns: const [
                            DataColumn(label: Text('Title')),
                            DataColumn(label: Text('Listed By')),
                            DataColumn(label: Text('Uploaded')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: listings.asMap().entries.map((entry) {
                            final index = entry.key;
                            final item = entry.value;
                            return DataRow(
                              color: MaterialStateProperty.resolveWith<Color?>((states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Theme.of(context).colorScheme.primary.withOpacity(0.06);
                                }
                                return null;
                              }),
                              onSelectChanged: (selected) {
                                if (selected == true) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (c) => ListingDetailPage(listing: item, showInquiry: false, showAdminActions: true),
                                    ),
                                  ).then((result) {
                                    if (result != null && mounted) {
                                      if (result == 'accepted') {
                                        setState(() {
                                          listings.removeWhere((l) => l.id == item.id);
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Listing approved')),
                                        );
                                      } else if (result == 'rejected') {
                                        setState(() {
                                          listings.removeWhere((l) => l.id == item.id);
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Listing rejected')),
                                        );
                                      }
                                    }
                                  });
                                }
                              },
                              cells: [
                                DataCell(Text(item.title)),
                                DataCell(Text(item.sellerName ?? 'Unknown')),
                                DataCell(Text(item.date)),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.check, color: Colors.green),
                                        onPressed: () {
                                          setState(() {
                                            listings.removeAt(index);
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Listing approved')),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close, color: Colors.red),
                                        onPressed: () {
                                          setState(() {
                                            listings.removeAt(index);
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Listing rejected')),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
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
