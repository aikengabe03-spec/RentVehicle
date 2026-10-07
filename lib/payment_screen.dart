import 'package:flutter/material.dart';
import 'package:projectuts/data.dart';
import 'package:projectuts/home_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String nama;
  const PaymentScreen({super.key, required this.nama});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedMethod = 0;
  final List<Map<String, dynamic>> methods = [
    {'name': 'Bank Transfer', 'icon': Icons.account_balance_outlined},
    {'name': 'Credit Card', 'icon': Icons.credit_card_outlined},
    {'name': 'Pay at Counter', 'icon': Icons.storefront_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('CHECKOUT', style: TextStyle(fontSize: 14, letterSpacing: 2.0)),
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
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(color: const Color(0xFF161616), border: Border.all(color: const Color(0xFF2A2A2A))),
                      child: Column(
                        children: [
                          const Text('TOTAL AMOUNT', style: TextStyle(color: Color(0xFF8C8C8C), letterSpacing: 2.0, fontSize: 10)),
                          const SizedBox(height: 12),
                          Text('IDR ${formatRupiah(cartTotal())}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w300, color: Colors.white, letterSpacing: 1.0)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text('PAYMENT METHOD', style: TextStyle(color: Color(0xFF8C8C8C), fontSize: 10, letterSpacing: 2.0, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    for (int i = 0; i < methods.length; i++)
                      GestureDetector(
                        onTap: () => setState(() => selectedMethod = i),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: selectedMethod == i ? Colors.white : const Color(0xFF161616),
                            border: Border.all(color: selectedMethod == i ? Colors.white : const Color(0xFF333333)),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Row(
                            children: [
                              Icon(methods[i]['icon'], color: selectedMethod == i ? Colors.black : Colors.white),
                              const SizedBox(width: 16),
                              Expanded(child: Text(methods[i]['name'], style: TextStyle(color: selectedMethod == i ? Colors.black : Colors.white, fontWeight: selectedMethod == i ? FontWeight.bold : FontWeight.normal))),
                              if (selectedMethod == i) const Icon(Icons.check, color: Colors.black, size: 20),
                            ],
                          ),
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
                    String kode = 'KYG-${DateTime.now().millisecondsSinceEpoch % 100000}';
                    int total = cartTotal();
                    String method = methods[selectedMethod]['name'];
                    cart.clear();

                    Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmationScreen(nama: widget.nama, kode: kode, method: method, total: total)));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))),
                  child: const Text('CONFIRM PAYMENT', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmationScreen extends StatelessWidget {
  final String nama, kode, method;
  final int total;

  const ConfirmationScreen({super.key, required this.nama, required this.kode, required this.method, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline, size: 80, color: Colors.white),
              const SizedBox(height: 24),
              const Text('RESERVATION CONFIRMED', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300, color: Colors.white, letterSpacing: 2.0)),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: const Color(0xFF161616), border: Border.all(color: const Color(0xFF2A2A2A))),
                child: Column(
                  children: [
                    Text('BOOKING ID: $kode', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.0)),
                    const SizedBox(height: 16),
                    Text('Client: $nama', style: const TextStyle(color: Color(0xFFD4D4D4), fontSize: 12)),
                    const SizedBox(height: 4),
                    Text('Method: $method', style: const TextStyle(color: Color(0xFFD4D4D4), fontSize: 12)),
                    const SizedBox(height: 16),
                    Container(height: 1, color: const Color(0xFF333333)),
                    const SizedBox(height: 16),
                    Text('TOTAL: IDR ${formatRupiah(total)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))),
                  child: const Text('RETURN TO HOME', style: TextStyle(letterSpacing: 1.5, fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}