import 'package:flutter/material.dart';
import 'package:projectuts/data.dart';
import 'package:projectuts/detail_screen.dart';
import 'package:projectuts/cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedCategory;

  final Color bgDark = const Color(0xFF0F0F0F);
  final Color navBlack = const Color(0xFF000000);
  final Color navDarkGrey = const Color(0xFF141414);
  final Color textPlatinum = const Color(0xFFD4D4D4);

  bool get isMobile => MediaQuery.of(context).size.width < 600;

  List<Map<String, dynamic>> get filteredVehicles {
    if (selectedCategory == null) {
      return [];
    }
    if (selectedCategory == 'Semua') {
      return vehicles;
    }
    return vehicles.where((v) => v['category'] == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> featuredVehicles = List.from(vehicles);
    featuredVehicles.sort((a, b) => (b['likes'] as int).compareTo(a['likes'] as int));
    List<Map<String, dynamic>> top3Vehicles = featuredVehicles.take(3).toList();

    return Scaffold(
      backgroundColor: bgDark,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDoubleNavBar(),
            buildLexusHero(),
            const SizedBox(height: 40),

            buildSectionTitle('CURATED SELECTION', 'MOST POPULAR FLEET'),
            const SizedBox(height: 10),
            for (var v in top3Vehicles) buildVehicleCard(v),

            const SizedBox(height: 40),

            buildInteractiveCategorySelector(),

            if (selectedCategory != null) ...[
              const SizedBox(height: 20),
              buildCategoryGridSection(),
            ],

            const SizedBox(height: 40),
            buildChauffeurOverviewSection(),
            const SizedBox(height: 20),
            buildDeals(),
            buildSectionTitle('EXPERIENCE', 'HOW IT WORKS'),
            buildSteps(),
            const SizedBox(height: 40),
            buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget buildDoubleNavBar() {
    bool isNarrow = MediaQuery.of(context).size.width < 1000;

    return Column(
      children: [
        if (!isNarrow)
          Container(
            color: navBlack,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                buildTopLink('Configure'),
                buildTopLink('WhatsApp'),
                buildTopLink('L/STYLE'),
                buildTopLink('KeyGo Collection'),
                buildTopLink('Promotions'),
                buildTopLink('Select a Gallery', isLast: true),
              ],
            ),
          ),
        Container(
          color: navDarkGrey,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Row(
            children: [
              const Icon(Icons.vpn_key_outlined, color: Colors.white, size: 24),
              const SizedBox(width: 10),
              const Text(
                'KEYGO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 4.0,
                ),
              ),
              const Spacer(),

              if (!isNarrow) ...[
                Row(
                  children: [
                    buildMainMenu('Models'),
                    buildMainMenu('Electrified'),
                    buildMainMenu('Model Tools'),
                    buildMainMenu('Privileges & Support'),
                    buildMainMenu('Discover KeyGo'),
                  ],
                ),
                const Spacer(),
              ],

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  ).then((value) {
                    setState(() {});
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 22),
                    ),
                    if (cart.isNotEmpty)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${cart.length}',
                              style: const TextStyle(
                                fontSize: 9,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              if (isNarrow) ...[
                const SizedBox(width: 16),
                const Icon(Icons.menu, color: Colors.white),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTopLink(String text, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(right: isLast ? 0 : 16),
      child: Text(
        text,
        style: TextStyle(color: textPlatinum, fontSize: 10, letterSpacing: 0.5),
      ),
    );
  }

  Widget buildMainMenu(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down, color: Colors.white70, size: 14),
        ],
      ),
    );
  }

  Widget buildLexusHero() {
    double heroFont = isMobile ? 28 : 42;
    double lineWidth = isMobile ? 200 : 320;
    double leftSpace = isMobile ? 24 : 40;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 500,
          decoration: const BoxDecoration(
            color: Color(0xFF222222),
            image: DecorationImage(
              image: NetworkImage(
                  'https://images.unsplash.com/photo-1555215695-3004980ad54e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 500,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black87, Colors.transparent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.0, 0.6],
            ),
          ),
        ),
        Positioned(
          left: leftSpace,
          top: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'The All-New KeyGo Fleet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: lineWidth,
                height: 1,
                color: Colors.white54,
              ),
              const SizedBox(height: 16),
              Text(
                'EVOLUTION OF',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: heroFont,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 3.0,
                ),
              ),
              Text(
                'ELEGANCE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: heroFont,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 3.0,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Container(
                width: 20,
                height: 32,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  width: 2,
                  height: 6,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildInteractiveCategorySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SELECT A CATEGORY',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w300,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var c in categories)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = c;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 24),
                      padding: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: selectedCategory == c ? Colors.white : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        c.toUpperCase(),
                        style: TextStyle(
                          color: selectedCategory == c
                              ? Colors.white
                              : textPlatinum.withOpacity(0.5),
                          fontSize: 12,
                          letterSpacing: 1.5,
                          fontWeight:
                          selectedCategory == c ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryGridSection() {
    double width = MediaQuery.of(context).size.width;
    int columns = 3;
    double aspect = 1.4;
    if (width < 600) {
      columns = 1;
      aspect = 3.0;
    } else if (width < 900) {
      columns = 2;
      aspect = 2.2;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredVehicles.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: aspect,
        ),
        itemBuilder: (context, index) {
          final v = filteredVehicles[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailScreen(vehicle: v)),
              ).then((value) {
                setState(() {});
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF161616),
                border: Border.all(color: const Color(0xFF2A2A2A)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(v['icon'], color: textPlatinum, size: 28),
                      Text(
                        'IDR ${formatRupiah(v['price'])}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        v['name'].toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          letterSpacing: 1.0,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${v['category']} • ${v['transmission']}',
                        style: TextStyle(
                          color: textPlatinum.withOpacity(0.6),
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildChauffeurOverviewSection() {
    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: EdgeInsets.symmetric(vertical: 60, horizontal: isMobile ? 24 : 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'THE CHAUFFEUR SERVICE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w300,
              letterSpacing: 3.0,
            ),
          ),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 6, child: buildVideoCardContent()),
                    const SizedBox(width: 40),
                    Expanded(flex: 5, child: buildTextDescriptionContent()),
                  ],
                );
              } else {
                return Column(
                  children: [
                    buildVideoCardContent(),
                    const SizedBox(height: 30),
                    buildTextDescriptionContent(),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildVideoCardContent() {
    return Container(
      height: 320,
      decoration: const BoxDecoration(
        color: Color(0xFF161616),
        image: DecorationImage(
          image: NetworkImage(
              'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(color: Colors.black.withOpacity(0.3)),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white54, width: 1),
            ),
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }

  Widget buildTextDescriptionContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Luxury evolves with every journey.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'For over a decade, KeyGo Chauffeur has embodied refined luxury through exceptional professionalism, comfort, and safety. Today, our professional driver service carries that legacy forward with a strict code of conduct, intuitive route mastery, and absolute discretion, offering the freedom to embrace premium travel your way.',
          style: TextStyle(
            color: textPlatinum.withOpacity(0.7),
            fontSize: 13,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Professional chauffeurs and insured rides are available.',
          style: TextStyle(
            color: textPlatinum.withOpacity(0.5),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Explore chauffeur packages',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }

  Widget buildVehicleCard(Map<String, dynamic> v) {
    double iconWidth = isMobile ? 56 : 100;
    double gap = isMobile ? 12 : 24;
    double cardPadding = isMobile ? 14 : 20;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailScreen(vehicle: v)),
        ).then((value) {
          setState(() {});
        });
      },
      onDoubleTap: () {
        setState(() {
          v['isLiked'] = !v['isLiked'];
          v['isLiked'] ? v['likes']++ : v['likes']--;
        });
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: const Color(0xFF161616),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Row(
          children: [
            Container(
              width: iconWidth,
              height: 70,
              alignment: Alignment.center,
              child: Icon(v['icon'], size: isMobile ? 34 : 45, color: textPlatinum),
            ),
            SizedBox(width: gap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    v['name'].toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      letterSpacing: 1.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${v['category']}  |  ${v['transmission'].toUpperCase()}',
                    style: TextStyle(
                      color: textPlatinum.withOpacity(0.6),
                      fontSize: 10,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'IDR ${formatRupiah(v['price'])} / DAY',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: isMobile ? 12 : 14,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            v['isLiked'] ? Icons.favorite : Icons.favorite_border,
                            color: v['isLiked'] ? Colors.white : textPlatinum.withOpacity(0.4),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${v['likes']}',
                            style: TextStyle(fontSize: 12, color: textPlatinum.withOpacity(0.6)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDeals() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EXCLUSIVE OFFERS',
            style: TextStyle(
              color: textPlatinum.withOpacity(0.6),
              fontSize: 10,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'UNCOMPROMISED\nLUXURY.',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              letterSpacing: 2.0,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              buildDeal('SEDAN', '500.000'),
              buildDeal('SUV', '650.000'),
              buildDeal('PREMIUM', '1.800.000'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDeal(String title, String price) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F0F),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 9,
                letterSpacing: 1.0,
                color: textPlatinum.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'IDR $price',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 8),
            Container(height: 1, color: const Color(0xFF333333)),
            const SizedBox(height: 8),
            Text(
              'Free Cancel',
              style: TextStyle(fontSize: 8, color: textPlatinum.withOpacity(0.5)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String small, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            small,
            style: TextStyle(
              color: textPlatinum.withOpacity(0.6),
              fontSize: 10,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w300,
              letterSpacing: 2.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSteps() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildStep(Icons.search, 'SEARCH'),
          buildStep(Icons.calendar_today, 'RESERVE'),
          buildStep(Icons.vpn_key_outlined, 'COLLECT'),
          buildStep(Icons.route_outlined, 'DRIVE'),
        ],
      ),
    );
  }

  Widget buildStep(IconData icon, String title) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: textPlatinum.withOpacity(0.6),
              fontSize: 9,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFooter() {
    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.vpn_key_outlined, color: Colors.white24, size: 40),
          const SizedBox(height: 20),
          const Text(
            'KEYGO RENTAL',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w300,
              letterSpacing: 4.0,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '© 2026 KEYGO INDONESIA. ALL RIGHTS RESERVED.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textPlatinum.withOpacity(0.4),
              fontSize: 9,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}