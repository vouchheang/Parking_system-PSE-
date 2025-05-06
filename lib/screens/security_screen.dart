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
      "name": "Thorn Tharen",
      "idCard": "21192-3",
      "licensePlate": "IBK-2345",
      "status": "Checked-in",
    },
    {
      "name": "Vann Teang",
      "idCard": "21192-4",
      "licensePlate": "IBK-3456",
      "status": "Checked-in",
    },
    {
      "name": "Seng In",
      "idCard": "21192-5",
      "licensePlate": "IBK-4567",
      "status": "Checked-in",
    },
    {
      "name": "Khom Sreymorkk",
      "idCard": "21192-6",
      "licensePlate": "IBK-5678",
      "status": "Checked-in",
    },
    {
      "name": "Lim Sreynoch",
      "idCard": "21192-7",
      "licensePlate": "IBK-6789",
      "status": "Checked-in",
    },
    {
      "name": "Lean Sopheak",
      "idCard": "21192-8",
      "licensePlate": "IBK-7890",
      "status": "Checked-in",
    },
    {
      "name": "Thorn Chandaravit",
      "idCard": "21192-9",
      "licensePlate": "IBK-8901",
      "status": "Checked-in",
    },
    {
      "name": "Mom Vouchheang",
      "idCard": "21192-10",
      "licensePlate": "IBK-9012",
      "status": "Checked-in",
    },
    {
      "name": "Thorn Tharen",
      "idCard": "21192-11",
      "licensePlate": "IBK-0123",
      "status": "Checked-in",
    },
    {
      "name": "Seng In",
      "idCard": "21192-12",
      "licensePlate": "IBK-1234",
      "status": "Checked-in",
    },
    {
      "name": "Khom Sreymorkk",
      "idCard": "21192-13",
      "licensePlate": "IBK-2345",
      "status": "Checked-in",
    },
    {
      "name": "Lim Sreynoch",
      "idCard": "21192-14",
      "licensePlate": "IBK-3456",
      "status": "Checked-in",
    },
    {
      "name": "Lean Sopheak",
      "idCard": "21192-15",
      "licensePlate": "IBK-4567",
      "status": "Checked-in",
    },
    {
      "name": "Lim Sreynoch",
      "idCard": "21192-16",
      "licensePlate": "IBK-5678",
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
      return _parkingData;
    }
    return _parkingData.where((entry) {
      return entry['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          entry['idCard'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          entry['licensePlate'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildTableHeader(context),
            _buildTableContent(),
          ],
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
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PSE PARKING SYSTEM',
          style: TextStyle(
            color: Color(0xFF0277BD),
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Manage your parking in easy way!',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade600,
            letterSpacing: 0.2,
          ),
        ),
      ],
    ),
    GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRScannerScreen(), // 👈 this screen contains the scanner
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Image.asset(
            'assets/images/camera.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    ),
  ],
),

          const SizedBox(height: 25),
          _buildSearchBar(),
          const SizedBox(height: 25),
          _buildFilterChips(),
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
        decoration: InputDecoration(
          hintText: 'Search by name, ID or license plate',
          hintStyle: TextStyle(color: const Color.fromARGB(255, 212, 212, 212)),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
          suffixIcon:
              _searchQuery.isNotEmpty
                  ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey.shade600),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                  )
                  : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip('All', isSelected: true),
          _buildChip('Checked-in'),
          _buildChip('Checked-out'),
        ],
      ),
    );
  }

  Widget _buildChip(String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        backgroundColor:
            isSelected
                ? const Color(0xFF0277BD).withValues(alpha: 0.1)
                : Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? const Color(0xFF0277BD) : Colors.grey.shade700,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? const Color(0xFF0277BD) : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    final headerStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.grey.shade700,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.grey.shade100,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Text('Name', style: headerStyle),
            ),
          ),
          Expanded(flex: 2, child: Text('ID Card', style: headerStyle)),
          Expanded(flex: 2, child: Text('License Plate', style: headerStyle)),
          Expanded(flex: 2, child: SizedBox()),
        ],
      ),
    );
  }

  Widget _buildTableContent() {
    return Expanded(
      child:
          filteredData.isEmpty
              ? _buildNoResultsFound()
              : ListView.builder(
                itemCount: filteredData.length,
                itemBuilder:
                    (context, index) => _buildTableRow(filteredData[index]),
              ),
    );
  }

  Widget _buildNoResultsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No matching records found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search criteria',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(Map<String, dynamic> entry) {
    final textColor = Colors.grey.shade700;

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Name
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  entry['name'],
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                ),
              ),
            ),
            // ID Card
            Expanded(
              flex: 2,
              child: Text(
                entry['idCard'],
                style: TextStyle(color: textColor, fontSize: 13),
              ),
            ),
            // License Plate
            Expanded(
              flex: 2,
              child: Text(
                entry['licensePlate'],
                style: TextStyle(color: textColor, fontSize: 13),
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
                    backgroundColor: Color(0xFF116692),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(15),
                    minimumSize: const Size(80, 30),
                  ),
                  child: const Text('View', style: TextStyle(fontSize: 12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
