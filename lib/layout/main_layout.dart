import 'package:flutter/material.dart';
import '../layout/nav_bar_delegate.dart';
import '../pages/home_page.dart';
import 'package:flutter/cupertino.dart';

class MainLayout extends StatefulWidget {
  final Widget body;
  final bool isMobile;

  const MainLayout({
    super.key,
    required this.body,
    required this.isMobile,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {

  // ✅ State-level variable
  String selectedCurrency = 'INR';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, __) {
          return [
            // TOP BAR
            SliverAppBar(
              backgroundColor: Colors.amber,
              toolbarHeight: 46,
              elevation: 0,
              pinned: false,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: const Text(
                'WEDDING SALE - 20% FLAT SALE ON GOLD RING',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ),

            // LUXURY ORNAMENTS HEADER
            SliverToBoxAdapter(
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 20, horizontal: 16),
                  color: Colors.white,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 🔹 Center Text
                      const Text(
                        'LUXURY ORNAMENTS',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),

                      // 🔹 Left Currency Selector
                      Positioned(
                        left: 0,
                        child: DropdownButton<String>(
                          value: selectedCurrency,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(
                                value: 'INR', child: Text('₹ INR')),
                            DropdownMenuItem(
                                value: 'USD', child: Text('\$ USD')),
                            DropdownMenuItem(
                                value: 'EUR', child: Text('€ EUR')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedCurrency = value!;
                            });
                          },
                        ),
                      ),

                      // 🔹 Right Icons
                      Positioned(
                        right: 0,
                        child:Row(
                          children: const [
                            Icon(CupertinoIcons.map_pin, size: 22),
                            SizedBox(width: 14),
                            Icon(CupertinoIcons.person, size: 22),
                            SizedBox(width: 14),
                            Icon(CupertinoIcons.bag, size: 22),
                          ],
                        )
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // NAV BAR
            SliverPersistentHeader(
              pinned: true,
              delegate: NavBarDelegate(isMobile: widget.isMobile),
            ),
          ];
        },
        body: widget.body,
      ),
    );
  }
}