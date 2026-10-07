import 'package:flutter/material.dart';
import 'package:projectuts/data.dart';
import 'package:projectuts/cart_screen.dart';

class ScheduleScreen extends StatefulWidget {
  final Map<String, dynamic> vehicle;

  const ScheduleScreen({super.key, required this.vehicle});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int selectedDate = DateTime.now().day;
  String selectedTime = '09:00';
  int days = 1;
  bool withDriver = false;
  bool withInsurance = false;

  final List<String> times = ['09:00', '12:00', '15:00', '18:00'];
  final List<String> dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<String> monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  final DateTime now = DateTime.now();
  int get daysInMonth => DateTime(now.year, now.month + 1, 0).day;
  final ScrollController dateController = ScrollController(initialScrollOffset: (DateTime.now().day - 1) * 70.0);

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  int get total {
    int perDay = widget.vehicle['price'];
    if (withDriver) perDay += driverFee;
    if (withInsurance) perDay += insuranceFee;
    return perDay * days;
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
        title: const Text('RESERVATION', style: TextStyle(fontSize: 14, letterSpacing: 2.0)),
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
                    Row(
                      children: [
                        Container(
                          width: 60, height: 60,
                          decoration: BoxDecoration(color: const Color(0xFF161616), border: Border.all(color: const Color(0xFF2A2A2A))),
                          child: Icon(widget.vehicle['icon'], color: Colors.white, size: 30),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.vehicle['name'].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 1.0)),
                            const SizedBox(height: 4),
                            Text('IDR ${formatRupiah(widget.vehicle['price'])} / DAY', style: const TextStyle(color: Color(0xFF8C8C8C), fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text('START DATE - ${monthNames[now.month - 1].toUpperCase()} ${now.year}', style: const TextStyle(color: Color(0xFF8C8C8C), fontSize: 10, letterSpacing: 2.0)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        controller: dateController,
                        scrollDirection: Axis.horizontal,
                        itemCount: daysInMonth,
                        itemBuilder: (context, i) {
                          DateTime date = DateTime(now.year, now.month, i + 1);
                          bool isSelected = selectedDate == i + 1;
                          bool isPast = date.day < now.day;

                          return GestureDetector(
                            onTap: () {
                              if (!isPast) setState(() => selectedDate = i + 1);
                            },
                            child: Container(
                              width: 65,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white : (isPast ? Colors.transparent : const Color(0xFF161616)),
                                border: Border.all(color: isSelected ? Colors.white : (isPast ? const Color(0xFF222222) : const Color(0xFF333333))),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(dayNames[date.weekday - 1], style: TextStyle(fontSize: 10, color: isSelected ? Colors.black : (isPast ? const Color(0xFF333333) : const Color(0xFF8C8C8C)))),
                                  const SizedBox(height: 4),
                                  Text('${date.day}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? Colors.black : (isPast ? const Color(0xFF333333) : Colors.white))),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text('PICKUP TIME', style: TextStyle(color: Color(0xFF8C8C8C), fontSize: 10, letterSpacing: 2.0)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        for (var t in times)
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => selectedTime = t),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: selectedTime == t ? Colors.white : const Color(0xFF161616),
                                  border: Border.all(color: selectedTime == t ? Colors.white : const Color(0xFF333333)),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Text(t, textAlign: TextAlign.center, style: TextStyle(color: selectedTime == t ? Colors.black : Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text('DURATION', style: TextStyle(color: Color(0xFF8C8C8C), fontSize: 10, letterSpacing: 2.0)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () { if (days > 1) setState(() => days--); },
                          child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(border: Border.all(color: const Color(0xFF444444))), child: const Icon(Icons.remove, color: Colors.white, size: 20)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text('$days DAYS', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.0)),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => days++),
                          child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(border: Border.all(color: Colors.white), color: Colors.white), child: const Icon(Icons.add, color: Colors.black, size: 20)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text('CUSTOMIZATION', style: TextStyle(color: Color(0xFF8C8C8C), fontSize: 10, letterSpacing: 2.0)),
                    const SizedBox(height: 12),
                    buildCheckboxOption('Chauffeur Service (+IDR ${formatRupiah(driverFee)}/day)', withDriver, () => setState(() => withDriver = !withDriver)),
                    const SizedBox(height: 16),
                    buildCheckboxOption('Premium Insurance (+IDR ${formatRupiah(insuranceFee)}/day)', withInsurance, () => setState(() => withInsurance = !withInsurance)),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(color: Colors.black, border: Border(top: BorderSide(color: Color(0xFF222222)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('ESTIMATED TOTAL', style: TextStyle(color: Color(0xFF8C8C8C), fontSize: 10, letterSpacing: 1.0)),
                      const SizedBox(height: 4),
                      Text('IDR ${formatRupiah(total)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      DateTime date = DateTime(now.year, now.month, selectedDate);
                      cart.add({
                        'vehicle': widget.vehicle, 'date': formatTanggal(date), 'time': selectedTime,
                        'days': days, 'withDriver': withDriver, 'withInsurance': withInsurance, 'total': total,
                      });
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))),
                    child: const Text('ADD TO CART', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0, fontSize: 12)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCheckboxOption(String title, bool isChecked, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(isChecked ? Icons.check_box : Icons.check_box_outline_blank, color: isChecked ? Colors.white : const Color(0xFF555555)),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}