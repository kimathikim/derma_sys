import 'package:flutter/material.dart';

class InventoryManagementPage extends StatefulWidget {
  const InventoryManagementPage({Key? key}) : super(key: key);

  @override
  _InventoryManagementPageState createState() => _InventoryManagementPageState();
}

class _InventoryManagementPageState extends State<InventoryManagementPage> {
  // Sample inventory data
  final List<Map<String, dynamic>> _inventoryItems = [
    {
      "name": "Benzoyl Peroxide Cream",
      "category": "Medication",
      "stock": 5,
      "expirationDate": "2024-11-01",
      "status": "Low Stock"
    },
    {
      "name": "Retinoid Cream",
      "category": "Skincare",
      "stock": 25,
      "expirationDate": "2025-03-12",
      "status": "In Stock"
    },
    {
      "name": "Hydrocortisone Ointment",
      "category": "Medication",
      "stock": 0,
      "expirationDate": "2024-09-30",
      "status": "Out of Stock"
    },
    {
      "name": "Salicylic Acid Solution",
      "category": "Skincare",
      "stock": 10,
      "expirationDate": "2023-12-15",
      "status": "Expiring Soon"
    },
  ];

  String _selectedFilter = "All";

  // Filter options
  final List<String> _filterOptions = ["All", "Low Stock", "Out of Stock", "Expiring Soon"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory Management"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilterDropdown(),
            const SizedBox(height: 10),
            Expanded(child: _buildInventoryList()),
          ],
        ),
      ),
    );
  }

  // Dropdown for filtering inventory items
  Widget _buildFilterDropdown() {
    return Row(
      children: [
        const Text(
          "Filter by Status:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10),
        DropdownButton<String>(
          value: _selectedFilter,
          onChanged: (String? newValue) {
            setState(() {
              _selectedFilter = newValue!;
            });
          },
          items: _filterOptions.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  // List of inventory items based on selected filter
  Widget _buildInventoryList() {
    // Filter inventory based on selected status
    List<Map<String, dynamic>> filteredItems = _selectedFilter == "All"
        ? _inventoryItems
        : _inventoryItems.where((item) => item["status"] == _selectedFilter).toList();

    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            leading: _buildStockIndicator(item["stock"]),
            title: Text(item["name"]),
            subtitle: Text(
              "Category: ${item["category"]}\nExpiration Date: ${item["expirationDate"]}\nStatus: ${item["status"]}",
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Navigate to item details or edit page
              },
            ),
          ),
        );
      },
    );
  }

  // Widget to display stock indicator
  Widget _buildStockIndicator(int stock) {
    Color color;
    if (stock == 0) {
      color = Colors.red;
    } else if (stock <= 5) {
      color = Colors.orange;
    } else {
      color = Colors.green;
    }

    return CircleAvatar(
      radius: 25,
      backgroundColor: color.withOpacity(0.2),
      child: Text(
        stock > 0 ? "$stock" : "0",
        style: TextStyle(
          fontSize: 16,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

