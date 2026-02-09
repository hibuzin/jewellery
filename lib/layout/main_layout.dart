import 'package:flutter/material.dart';
import 'package:jewellery/cart.dart';
import 'package:jewellery/profile.dart';
import 'package:jewellery/wishlist.dart';
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
      backgroundColor: Colors.white,
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
                      vertical: 10, horizontal: 14), // Reduced vertical padding
                  color: Colors.white,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 🔹 Center Text
                      const Text(
                        'LUXURY GOLDS',
                        style: TextStyle(
                          fontSize: 26,       // Slightly smaller if needed
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5, // Reduced letter spacing
                        ),
                      ),

                      // 🔹 Left Currency Selector
                      // 🔹 Currency + Need Help with Icon
                      Positioned(
                        left: 0,
                        child: Row(
                          children: [
                            DropdownButton<String>(
                              value: selectedCurrency,
                              underline: const SizedBox(),
                              items: const [
                                DropdownMenuItem(value: 'INR', child: Text('₹ INR')),
                                DropdownMenuItem(value: 'USD', child: Text('\$ USD')),
                                DropdownMenuItem(value: 'EUR', child: Text('€ EUR')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedCurrency = value!;
                                });
                              },
                            ),
                            const SizedBox(width: 12), // spacing
                          ],
                        ),
                      ),

                      // 🔹 Right Icons
                      // 🔹 Right Icons
                      Positioned(
                        right: 0,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                debugPrint('Location icon pressed');
                              },
                              child: Icon(
                                widget.isMobile ? CupertinoIcons.map_pin : CupertinoIcons.map_pin,
                                size: widget.isMobile ? 18 : 22, // smaller on mobile
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: widget.isMobile ? 6 : 10), // smaller spacing on mobile

                            InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
                              },
                              child: Icon(
                                widget.isMobile ?  CupertinoIcons.person : CupertinoIcons.person,
                                size: widget.isMobile ? 18 : 22,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: widget.isMobile ? 6 : 10),

                            InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => WishlistPage()));
                              },
                              child: Icon(
                                widget.isMobile ? CupertinoIcons.heart : CupertinoIcons.heart,
                                size: widget.isMobile ? 18 : 22,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: widget.isMobile ? 6 : 10),

                            InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage()));
                              },
                              child: Icon(
                                widget.isMobile ? CupertinoIcons.bag : CupertinoIcons.bag,
                                size: widget.isMobile ? 18 : 22,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

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