import 'package:flutter/material.dart';
import 'package:projectuts/data.dart';
import 'package:projectuts/summary_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('YOUR FLEET', style: TextStyle(fontSize: 14, letterSpacing: 2.0)),
      ),
      body: Column(
        children: [
          Expanded(
            child: cart.isEmpty
                ? const Center(child: Text('YOUR CART IS EMPTY.', style: TextStyle(color: Color(0xFF8C8C8C), letterSpacing: 2.0)))
                : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                String opsi = '';
                if (item['withDriver']) opsi += 'Chauffeur ';
                if (item['withInsurance']) opsi += 'Insurance';
                if (opsi == '') opsi = 'Standard Service';

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161616),
                    border: Border.all(color: const Color(0xFF2A2A2A)),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 70, height: 50,
                        alignment: Alignment.center,
                        child: Icon(item['vehicle']['icon'], color: Colors.white, size: 35),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['vehicle']['name'].toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white, letterSpacing: 1.0)),
                            const SizedBox(height: 4),
                            Text('${item['date']} • ${item['time']} • ${item['days']} DAYS', style: const TextStyle(color: Color(0xFF8C8C8C), fontSize: 10)),
                            Text(opsi.toUpperCase(), style: const TextStyle(color: Color(0xFF8C8C8C), fontSize: 9, letterSpacing: 1.0)),
                            const SizedBox(height: 12),
                            Text('IDR ${formatRupiah(item['total'])}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFF555555)),
                        onPressed: () => setState(() => cart.removeAt(index)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (cart.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(color: Colors.black, border: Border(top: BorderSide(color: Color(0xFF222222)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TOTAL (${cart.length} ITEMS)', style: const TextStyle(color: Color(0xFF8C8C8C), fontSize: 10, letterSpacing: 1.0)),
                      const SizedBox(height: 4),
                      Text('IDR ${formatRupiah(cartTotal())}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SummaryScreen()));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))),
                    child: const Text('PROCEED', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 12)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}