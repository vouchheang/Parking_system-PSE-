import 'package:flutter/material.dart';
import 'package:parking_system/screens/camera_screen.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _parkingData = [
    {
      "name": "Nguon Chandaravit",
      "idCard": "21192-1",
      "licensePlate": "IBK-5678",
      "status": "Checked-in",
    },
    {
      "name": "Mom Vouchheang",
      "idCard": "21192-2",
      "licensePlate": "IBK-1234",
      "status": "Checked-in",
    },
    {
      "name": "Lim Sreynoch",
      "idCard": "21192-16",
      "licensePlate": "IBK-5678",
      "status": "Checked-in",
    },
    {
      "name": "Thorn Thearith",
      "idCard": "21192-3",
      "licensePlate": "IBK-9012",
      "status": "Checked-in",
    },
    {
      "name": "Vann Tiang",
      "idCard": "21192-4",
      "licensePlate": "IBK-3456",
      "status": "Checked-in",
    },
    {
      "name": "Sang In",
      "idCard": "21192-5",
      "licensePlate": "IBK-7890",
      "status": "Checked-in",
    },
    {
      "name": "Nguon Chandaravit",
      "idCard": "21192-1",
      "licensePlate": "IBK-5678",
      "status": "Checked-in",
    },
    {
      "name": "Mom Vouchheang",
      "idCard": "21192-2",
      "licensePlate": "IBK-1234",
      "status": "Checked-in",
    },
    {
      "name": "Vann Tiang",
      "idCard": "21192-4",
      "licensePlate": "IBK-3456",
      "status": "Checked-in",
    },
    {
      "name": "Sang In",
      "idCard": "21192-5",
      "licensePlate": "IBK-7890",
      "status": "Checked-in",
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
        return _parkingData;
      } else {
        return _parkingData
            .where((entry) => entry['status'] == _selectedFilter)
            .toList();
      }
    }

    var filtered =
        _parkingData.where((entry) {
          return entry['name'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              entry['idCard'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              entry['licensePlate'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );
        }).toList();

    if (_selectedFilter != 'All') {
      filtered =
          filtered
              .where((entry) => entry['status'] == _selectedFilter)
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
                color: const Color(0xFF0277BD).withValues(alpha: 0.3),
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
            color: Colors.grey.withValues(alpha: 0.2),
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
          _buildSearchBar(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Search by name, ID or license plate',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600, size: 24),
          suffixIcon:
              _searchQuery.isNotEmpty
                  ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.grey.shade600,
                      size: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                  )
                  : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
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
          Expanded(flex: 2, child: Text('ID Card', style: headerStyle)),
          Expanded(flex: 2, child: Text('License', style: headerStyle)),
          Expanded(flex: 2, child: Container()),
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
            // ID Card
            Expanded(
              flex: 2,
              child: Text(
                entry['idCard'],
                style: const TextStyle(color: Color(0xFF424242), fontSize: 16),
              ),
            ),
            // License Plate
            Expanded(
              flex: 2,
              child: Text(
                entry['licensePlate'],
                style: const TextStyle(color: Color(0xFF424242), fontSize: 16),
              ),
            ),
            // View Button
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle view button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(16),
                    elevation: 3,
                  ),
                  child: const Text(
                    'View',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
