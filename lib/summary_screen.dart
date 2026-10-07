import 'package:flutter/material.dart';
import 'package:projectuts/data.dart';
import 'package:projectuts/payment_screen.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController hpController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();
  String? errorMessage;

  @override
  void dispose() {
    namaController.dispose();
    hpController.dispose();
    lokasiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('SUMMARY', style: TextStyle(fontSize: 14, letterSpacing: 2.0)),
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
                    const Text('CLIENT DETAILS', style: TextStyle(color: Color(0xFF8C8C8C), fontSize: 10, letterSpacing: 2.0, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    buildTextField(namaController, 'Full Name', Icons.person_outline, TextInputType.text),
                    const SizedBox(height: 16),
                    buildTextField(hpController, 'Phone Number', Icons.phone_outlined, TextInputType.phone),
                    const SizedBox(height: 16),
                    buildTextField(lokasiController, 'Pickup Location', Icons.location_on_outlined, TextInputType.text),

                    if (errorMessage != null)
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(border: Border.all(color: Colors.red.shade900), color: Colors.red.withOpacity(0.1)),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red.shade400, size: 18),
                            const SizedBox(width: 12),
                            Text(errorMessage!, style: TextStyle(color: Colors.red.shade400, fontSize: 12)),
                          ],
                        ),
                      ),

                    const SizedBox(height: 32),
                    const Text('ORDER OVERVIEW', style: TextStyle(color: Color(0xFF8C8C8C), fontSize: 10, letterSpacing: 2.0, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    for (var item in cart)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: const Color(0xFF161616), border: Border.all(color: const Color(0xFF2A2A2A))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['vehicle']['name'].toUpperCase(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.0)),
                            const SizedBox(height: 12),
                            buildDetailRow('Category', item['vehicle']['category']),
                            buildDetailRow('Date', '${item['date']} (${item['days']} days)'),
                            buildDetailRow('Time', item['time']),
                            buildDetailRow('Chauffeur', item['withDriver'] ? "Included" : "None"),
                            buildDetailRow('Insurance', item['withInsurance'] ? "Premium" : "None"),
                            const SizedBox(height: 12),
                            Container(height: 1, color: const Color(0xFF333333)),
                            const SizedBox(height: 12),
                            Text('IDR ${formatRupiah(item['total'])}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(color: Colors.black, border: Border(top: BorderSide(color: Color(0xFF222222)))),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (namaController.text.trim().isEmpty || hpController.text.trim().isEmpty || lokasiController.text.trim().isEmpty) {
                      setState(() => errorMessage = 'Please complete all client details.');
                    } else {
                      setState(() => errorMessage = null);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(nama: namaController.text.trim())));
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))),
                  child: Text('PAY IDR ${formatRupiah(cartTotal())}', style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label, IconData icon, TextInputType type) {
    return TextField(
      controller: controller,
      keyboardType: type,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF8C8C8C), letterSpacing: 1.0),
        prefixIcon: Icon(icon, color: const Color(0xFF8C8C8C)),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF333333))),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      ),
    );
  }

  Widget buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(title, style: const TextStyle(color: Color(0xFF8C8C8C), fontSize: 11))),
          Text(':  $value', style: const TextStyle(color: Color(0xFFD4D4D4), fontSize: 11)),
        ],
      ),
    );
  }
}