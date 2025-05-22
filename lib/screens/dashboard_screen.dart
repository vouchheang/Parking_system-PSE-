import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parking_system/screens/securities_team.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const Color primaryBlue = Color(0xFF1A5F9C);
  static const Color primaryOrange = Color(0xFFFF8A00);
  static const Color lightBlue = Color(0xFFE6F0F9);
  static const Color lightOrange = Color(0xFFFFF0E0);
  static const Color textDark = Color(0xFF333333);
  static const Color textLight = Color(0xFF666666);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBlue.withValues(alpha: 0.3),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome back, Admin!',
              style: TextStyle(
                color: textDark,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage your parking in easy way!',
              style: TextStyle(color: textLight, fontSize: 16),
            ),
            const SizedBox(height: 24),
            // _buildQuickStatsRow(),
            const SizedBox(height: 24),
            _buildTotalUsersCard(),
            const SizedBox(height: 24),
            // _buildActionButtons(context),
            const SizedBox(height: 24),
            _buildSecurityListHeader(context),
            const SizedBox(height: 10),
            const SecurityTeamWidget(), // Use our new SecurityTeamWidget here
          ],
        ),
      ),
    );
  }

  Widget _buildTotalUsersCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.people, color: primaryBlue, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Total Users:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textDark,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '86',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryOrange,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Text(
                      'This Week',
                      style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: primaryBlue,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            width: double.infinity,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.grey.shade200, strokeWidth: 1);
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: textLight,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        );
                        String text;
                        switch (value.toInt()) {
                          case 0:
                            text = 'Mon';
                            break;
                          case 2:
                            text = 'Wed';
                            break;
                          case 4:
                            text = 'Fri';
                            break;
                          case 6:
                            text = 'Sun';
                            break;
                          default:
                            return Container();
                        }
                        return Text(text, style: style);
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: textLight,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 8,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 3),
                      FlSpot(1, 5),
                      FlSpot(2, 2),
                      FlSpot(3, 2.5),
                      FlSpot(4, 4),
                      FlSpot(5, 7),
                      FlSpot(6, 3),
                    ],
                    isCurved: true,
                    color: primaryOrange,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 6,
                          color: Colors.white,
                          strokeWidth: 3,
                          strokeColor: primaryOrange,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: primaryOrange.withValues(alpha: 0.2),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        return LineTooltipItem(
                          '${barSpot.y.toInt()} users',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityListHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Security Team',
          style: TextStyle(
            color: textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecuritiesTeam()),
            );
          },
          child: const Text(
            'View All',
            style: TextStyle(color: primaryOrange, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

// Our SecurityTeamWidget for the dashboard
class SecurityModel {
  final String id;
  final String fullname;
  final String status;
  final String? idcard;

  SecurityModel({
    required this.id,
    required this.fullname,
    this.idcard,
    required this.status,
  });

  factory SecurityModel.fromJson(Map<String, dynamic> json) {
    final securityData = json['security'] as Map<String, dynamic>?;

    return SecurityModel(
      id: json['id'].toString(),
      fullname: json['fullname'] ?? '',
      idcard: json['idcard']?.toString(),
      status: securityData?['status'] ?? json['status'] ?? 'active',
    );
  }
}

class SecurityTeamWidget extends StatefulWidget {
  const SecurityTeamWidget({super.key});

  @override
  State<SecurityTeamWidget> createState() => _SecurityTeamWidgetState();
}

class _SecurityTeamWidgetState extends State<SecurityTeamWidget> {
  static const Color primaryBlue = Color(0xFF1A5F9C);
  static const Color primaryOrange = Color(0xFFFF8A00);
  static const Color primaryGreen = Color(0xFF2E8B57);
  static const Color textDark = Color(0xFF333333);

  static const String baseUrl = 'https://pse-parking.final25.psewmad.org/api';
  static const String apiToken = '5|KgzNsnVTbbIhyiLNpD0R2v4WodiQO5oG7NshHPP81d26615f';

  List<SecurityModel> securities = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchSecurities();
  }

  // Add an error handling method
  void _handleApiError(dynamic error) {
    setState(() {
      if (error is http.ClientException) {
        errorMessage = 'Network error: ${error.message}';
      } else {
        errorMessage = 'Error: $error';
      }
      isLoading = false;
    });

    // Log the error for debugging
    debugPrint('API Error: $error');
  }

  // API Methods
  Future<void> fetchSecurities() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/security'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('API Response: ${response.body}');

        final dynamic responseData = json.decode(response.body);
        List<dynamic> data;

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('data')) {
          // Response is a Map with a 'data' key containing the list
          data = responseData['data'] as List<dynamic>;
        } else if (responseData is List) {
          // Response is directly a list
          data = responseData;
        } else {
          throw Exception('Unexpected response format: $responseData');
        }

        setState(() {
          securities = data
              .map((item) => SecurityModel.fromJson(item as Map<String, dynamic>))
              .toList();
          // Limiting to only 4 items as requested
          if (securities.length > 4) {
            securities = securities.sublist(0, 4);
          }
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load securities. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      _handleApiError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderRow(),
          const Divider(height: 30, thickness: 1),
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(color: primaryBlue),
              ),
            )
          else if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            )
          else if (securities.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: Text('No security team members found')),
            )
          else
            ...securities.map((security) => _buildSecurityItem(security)),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    const headerStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: textDark,
      fontSize: 16,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: const [
          Expanded(flex: 4, child: Text('Employee', style: headerStyle)),
          Expanded(child: Text('Status', style: headerStyle)),
        ],
      ),
    );
  }

  Widget _buildSecurityItem(SecurityModel security) {
    final bool isActive = security.status.toLowerCase() == 'active';
    final Color statusColor = isActive ? primaryOrange : primaryGreen;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFE3F2FD),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                security.fullname.isNotEmpty ? security.fullname[0] : '?',
                style: const TextStyle(
                  color: Color(0xFF2196F3),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  security.fullname,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF212121),
                  ),
                ),
                Text(
                  security.idcard ?? 'ID: Not available',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor),
            ),
            child: Text(
              security.status,
              style: TextStyle(
                color: statusColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}