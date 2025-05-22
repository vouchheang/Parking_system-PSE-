import 'package:flutter/material.dart';
import 'package:parking_system/screens/camera_screen.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = ''; // Changed from final to mutable
  String _selectedFilter = 'All'; // Changed from final to mutable

  final List<Map<String, dynamic>> _activitiesData = [
    {
      "name": "Nguon Chandaravit",
      "action": "Checked-in",
      "time": "30/05/25",
    },
    {
      "name": "Mom Vouchheang",
      "action": "Checked-in",
      "time": "29/05/25",
    },
    {
      "name": "Thorn Thearith",
      "action": "Checkout",
      "time": "29/05/25",
    },
    {
      "name": "Vann Tiang",
      "action": "Checked-in",
      "time": "29/05/25",
    },
    {
      "name": "Sang In",
      "action": "Checked-in",
      "time": "29/05/25",
    },
    {
      "name": "Nguon Chandaravit",
      "action": "Checked-in",
      "time": "30/05/25",
    },
    {
      "name": "Mom Vouchheang",
      "action": "Checked-in",
      "time": "29/05/25",
    },
    {
      "name": "Thorn Thearith",
      "action": "Checkout",
      "time": "29/05/25",
    },
    {
      "name": "Vann Tiang",
      "action": "Checked-in",
      "time": "29/05/25",
    },
    {
      "name": "Sang In",
      "action": "Checked-in",
      "time": "29/05/25",
    },
     {
      "name": "Nguon Chandaravit",
      "action": "Checked-in",
      "time": "30/05/25",
    },
    {
      "name": "Mom Vouchheang",
      "action": "Checked-in",
      "time": "29/05/25",
    },
    {
      "name": "Thorn Thearith",
      "action": "Checkout",
      "time": "29/05/25",
    },
    {
      "name": "Vann Tiang",
      "action": "Checked-in",
      "time": "29/05/25",
    },
    {
      "name": "Sang In",
      "action": "Checked-in",
      "time": "29/05/25",
    },
    {
      "name": "Nguon Chandaravit",
      "action": "Checked-in",
      "time": "30/05/25",
    },
    {
      "name": "Mom Vouchheang",
      "action": "Checked-in",
      "time": "29/05/25",
    },
    {
      "name": "Thorn Thearith",
      "action": "Checkout",
      "time": "29/05/25",
    },
    {
      "name": "Vann Tiang",
      "action": "Checked-in",
      "time": "29/05/25",
    },
    {
      "name": "Sang In",
      "action": "Checked-in",
      "time": "29/05/25",
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredData {
    if (_searchQuery.isEmpty) {
      if (_selectedFilter == 'All') {
        return _activitiesData;
      } else {
        return _activitiesData
            .where((entry) => entry['action'] == _selectedFilter)
            .toList();
      }
    }

    var filtered =
        _activitiesData.where((entry) {
          return entry['name'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              
              entry['action'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );
        }).toList();

    if (_selectedFilter != 'All') {
      filtered =
          filtered
              .where((entry) => entry['action'] == _selectedFilter)
              .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(context),
                _buildTableHeader(context),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: _buildTableContent(),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 15,
              left: 0,
              right: 0,
              child: _buildScanButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanButton(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QRScannerScreen()),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0277BD),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0277BD).withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.qr_code_scanner, color: Colors.white, size: 32),
              SizedBox(width: 10),
              Text(
                'SCAN HERE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'PSE PARKING SYSTEM',
                    style: TextStyle(
                      color: Color(0xFF0277BD),
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Manage your parking in easy way!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF616161),
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'User Activities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
             
            ],
          ),
          const SizedBox(height: 15),
          
          // Search bar and filter dropdown
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search by name',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.grey.shade500),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedFilter,
                    icon: const Icon(Icons.arrow_drop_down),
                    style: const TextStyle(color: Color(0xFF424242), fontSize: 16),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedFilter = newValue!;
                      });
                    },
                    items: <String>['All', 'Checked-in', 'Checkout']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    final headerStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Color(0xFF424242),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      color: Colors.grey.shade100,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text('Name', style: headerStyle),
            ),
          ),
          Expanded(flex: 2, child: Text('Action', style: headerStyle)),
          Expanded(flex: 2, child: Text('Time', style: headerStyle)),
        ],
      ),
    );
  }

  Widget _buildTableContent() {
    return filteredData.isEmpty
        ? _buildNoResultsFound()
        : ListView.builder(
          itemCount: filteredData.length,
          itemBuilder: (context, index) => _buildTableRow(filteredData[index]),
        );
  }
  Widget _buildNoResultsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 20),
          Text(
            'No matching records found',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Try adjusting your search criteria',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(Map<String, dynamic> entry) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            // Name
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  entry['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xFF212121),
                  ),
                ),
              ),
            ),
            // Action
            Expanded(
              flex: 2,
              child: Text(
                entry['action'],
                style: const TextStyle(color: Color(0xFF424242), fontSize: 16),
              ),
            ),
            // Time
            Expanded(
              flex: 2,
              child: Text(
                entry['time'],
                style: const TextStyle(color: Color(0xFF424242), fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}