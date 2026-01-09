import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/services/listing_provider.dart';
import 'package:flutter_application_1/services/listing_api.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedRange = 7;

  // dynamic values from API
  int approvedCount = 0;
  int pendingCount = 0;
  int rejectedCount = 0;
  List<FlSpot> trend7Days = [];
  List<FlSpot> trend30Days = [];
  
  // Track selected row for expansion
  int? _selectedRowIndex;

  @override
  void initState() {
    super.initState();
    // Fetch pending listings and stats when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListingProvider>().fetchPending();
      _loadAdminStats();
    });
  }
  
  // ✅ Auto-refresh when page resumes
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ListingProvider>().fetchPending();
    _loadAdminStats();
  }

  Future<void> _loadAdminStats() async {
    try {
      final data = await ListingApi.fetchAdminStats();
      if (!mounted) return;

      setState(() {
        approvedCount = data['approved'] ?? 0;
        pendingCount = data['pending'] ?? 0;
        rejectedCount = data['rejected'] ?? 0;

        final trend = (data['trend'] as List<dynamic>?) ?? [];
        // build spots for 7-day or 30-day fallback
        trend7Days = trend
            .asMap()
            .entries
            .map((e) => FlSpot((e.key + 1).toDouble(), (e.value['count'] as num).toDouble()))
            .toList();
        trend30Days = trend7Days; // fallback; server currently returns 7-day trend
      });
    } catch (e) {
      // ignore errors, keep mock values
    }
  }

  Future<void> _updateStatus(int id, String status) async {
    final provider = context.read<ListingProvider>();
    final action = (status == 'approved') ? 'approve' : 'reject';
    
    try {
      final success = (await ListingApi.updateListingStatus(id, action)) == true;
      if (!mounted) return;
      
      if (success) {
        // Refresh all data after status change
        await provider.refreshAll();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Listing $status')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update listing status')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating listing')),
      );
    }
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    return Consumer<ListingProvider>(
      builder: (context, provider, _) {
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
                _kpi('Total Listings', (approvedCount + pendingCount + rejectedCount).toString(), Icons.list_alt),
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

            // ================= PENDING LISTINGS TABLE (SELECTABLE) =================
            const Text(
              'Pending Listings',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RefreshIndicator(
                  onRefresh: () => provider.fetchPending(),
                  child: provider.loadingPending && provider.pendingListings.isEmpty
                      ? const SizedBox(
                          height: 200,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : provider.pendingListings.isEmpty
                          ? SizedBox(
                              height: 120,
                              child: Center(
                                child: Text(
                                  'No pending listings',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: provider.pendingListings.length,
                              itemBuilder: (context, index) {
                                final item = provider.pendingListings[index];
                              final isSelected = _selectedRowIndex == index;
                              final title = item['title'] ?? 'No title';
                              final type = item['listing_type'] ?? '';
                              final price = item['price'] ?? 0;
                              final listedBy = item['listed_by'] ?? '';
                              final description = item['description'] ?? '';
                              final images = (item['images'] as List<dynamic>?) ?? [];
                              
                              return Column(
                                children: [
                                  // ✅ SELECTABLE ROW
                                  Material(
                                    color: isSelected
                                        ? Colors.blue.shade50
                                        : Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedRowIndex =
                                              isSelected ? null : index;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Row(
                                          children: [
                                            Icon(
                                              isSelected
                                                  ? Icons.expand_less
                                                  : Icons.expand_more,
                                              color: Colors.blue,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    title,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        type.toUpperCase(),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors
                                                              .grey[600],
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        price == 0 || price == null
                                                            ? 'FREE'
                                                            : '₹$price',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors
                                                              .green[700],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              listedBy,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // ✅ EXPANDED DETAIL VIEW
                                  if (isSelected)
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        border: Border(
                                          top: BorderSide(
                                            color: Colors.grey[300]!,
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Images gallery
                                          if (images.isNotEmpty)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Images',
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                SizedBox(
                                                  height: 100,
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        images.length,
                                                    itemBuilder:
                                                        (context, imgIndex) {
                                                      final imgUrl =
                                                          images[imgIndex]
                                                                  ['image'] ??
                                                              '';
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 8),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          child: Image.network(
                                                            imgUrl,
                                                            width: 100,
                                                            height: 100,
                                                            fit: BoxFit
                                                                .cover,
                                                            errorBuilder: (
                                                              context,
                                                              error,
                                                              stackTrace,
                                                            ) =>
                                                                Container(
                                                              width: 100,
                                                              height: 100,
                                                              color: Colors
                                                                  .grey[300],
                                                              child: const Icon(
                                                                Icons
                                                                    .broken_image,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                              ],
                                            ),

                                          // Description
                                          const Text(
                                            'Description',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            description,
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(height: 12),

                                          // Listed by
                                          Row(
                                            children: [
                                              const Text(
                                                'Listed by: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                listedBy,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),

                                          // ✅ APPROVE / REJECT BUTTONS
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton.icon(
                                                  onPressed: () =>
                                                      _updateStatus(
                                                    item['id'],
                                                    'approved',
                                                  ),
                                                  icon: const Icon(
                                                    Icons.check_circle,
                                                    size: 18,
                                                  ),
                                                  label: const Text(
                                                    'Approve',
                                                  ),
                                                  style: ElevatedButton
                                                      .styleFrom(
                                                    backgroundColor:
                                                        Colors.green,
                                                    foregroundColor:
                                                        Colors.white,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: ElevatedButton.icon(
                                                  onPressed: () =>
                                                      _updateStatus(
                                                    item['id'],
                                                    'rejected',
                                                  ),
                                                  icon: const Icon(
                                                    Icons.cancel,
                                                    size: 18,
                                                  ),
                                                  label: const Text(
                                                    'Reject',
                                                  ),
                                                  style: ElevatedButton
                                                      .styleFrom(
                                                    backgroundColor:
                                                        Colors.red,
                                                    foregroundColor:
                                                        Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                  if (index <
                                      provider.pendingListings.length - 1)
                                    Divider(
                                      color: Colors.grey[300],
                                      height: 1,
                                    ),
                                ],
                              );
                            },
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
      },
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
