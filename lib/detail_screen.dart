import 'package:flutter/material.dart';
import 'package:projectuts/data.dart';
import 'package:projectuts/schedule_screen.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> vehicle;

  const DetailScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          vehicle['name'].toUpperCase(),
          style: const TextStyle(fontSize: 14, letterSpacing: 2.0, fontWeight: FontWeight.w400),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF161616),
                          border: Border.all(color: const Color(0xFF2A2A2A)),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: vehicleImage(vehicle, 180),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      vehicle['name'].toUpperCase(),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w300, letterSpacing: 2.0, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'IDR ${formatRupiah(vehicle['price'])} / DAY',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(height: 1, color: const Color(0xFF2A2A2A)),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        buildInfo(Icons.event_seat_outlined, '${vehicle['seats']} SEATS'),
                        buildInfo(Icons.settings_outlined, vehicle['transmission'].toUpperCase()),
                        buildInfo(Icons.directions_car_outlined, vehicle['category'].toUpperCase()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(height: 1, color: const Color(0xFF2A2A2A)),
                    const SizedBox(height: 24),
                    const Text(
                      'OVERVIEW',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0, color: Color(0xFF8C8C8C)),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      vehicle['description'],
                      style: const TextStyle(color: Color(0xFFD4D4D4), height: 1.6, fontSize: 13),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'ADDITIONAL SERVICES',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0, color: Color(0xFF8C8C8C)),
                    ),
                    const SizedBox(height: 12),
                    buildServiceText('Minimum rental duration: 1 Day'),
                    buildServiceText('Chauffeur: +IDR ${formatRupiah(driverFee)} / day'),
                    buildServiceText('Insurance: +IDR ${formatRupiah(insuranceFee)} / day'),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.black,
                border: Border(top: BorderSide(color: Color(0xFF222222))),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScheduleScreen(vehicle: vehicle),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  child: const Text(
                    'SELECT SCHEDULE',
                    style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfo(IconData icon, String text) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 8),
          Text(text, style: const TextStyle(color: Color(0xFF8C8C8C), fontSize: 10, letterSpacing: 1.0)),
        ],
      ),
    );
  }

  Widget buildServiceText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Color(0xFF8C8C8C))),
          Expanded(child: Text(text, style: const TextStyle(color: Color(0xFFD4D4D4), fontSize: 13))),
        ],
      ),
    );
  }
}