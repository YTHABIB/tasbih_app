import 'package:flutter/material.dart';
import 'tasbeeh_page.dart';
import 'coming_soon_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151821), // Dark Theme Background

      // --- AppBar ---
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        leadingWidth: 35,
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_on_outlined, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),

      // মূল পরিবর্তনটি এখানে করা হয়েছে (ডাইনামিক বডি)
      body: _selectedIndex == 0 ? _buildHomeContent() : _buildComingSoonTab(),

      // --- Bottom Navigation Bar ---
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF1E222D), // Dark Bottom Bar
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF6C63FF),
          unselectedItemColor: Colors.white38,
          showUnselectedLabels: true,
          elevation: 20,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Calendar"),
            BottomNavigationBarItem(icon: Icon(Icons.schedule), label: "Schedule"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting"),
          ],
        ),
      ),
    );
  }

  // --- হোম পেজের মেইন কনটেন্ট ---
  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRamadanBanner(),
          const SizedBox(height: 25),
          const Center(child: Text("Category", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))),
          const SizedBox(height: 15),

          // --- ক্যাটাগরি বাটনগুলোর নেভিগেশন আপডেট ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Prayer Time -> Coming Soon পেজে যাবে
              _buildCategoryItem(Icons.handshake_outlined, "Prayer Time", () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ComingSoonPage(title: "Prayer Time")));
              }),

              // Tasbih -> ঠিকমতো তাসবিহ পেজে যাবে
              _buildCategoryItem(Icons.donut_large, "Tasbih", () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const TasbeehPage()));
              }),

              // Dua -> Coming Soon পেজে যাবে
              _buildCategoryItem(Icons.volunteer_activism, "Dua", () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ComingSoonPage(title: "Dua Collection")));
              }),

              // Quran -> Coming Soon পেজে যাবে
              _buildCategoryItem(Icons.menu_book, "Al-Quran", () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ComingSoonPage(title: "Al-Quran")));
              }),
            ],
          ),
          const SizedBox(height: 25),
          _buildTasbihPromo(context),
          const SizedBox(height: 25),
          _buildPrayerTimeSection(),
        ],
      ),
    );
  }

  // --- বটম নেভিগেশনের জন্য  ---
  Widget _buildComingSoonTab() {
    final tabNames = ["Home", "Calendar", "Schedule", "Settings"];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction_sharp, size: 80, color: const Color(0xFF6C63FF).withOpacity(0.5)),
          const SizedBox(height: 20),
          Text("${tabNames[_selectedIndex]}", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text("We are working on this feature. \n It will be added soon!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  // --- Widgets ---

  Widget _buildRamadanBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E222D), // Dark Card Background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10), // Subtle border
      ),
      child: Column(
        children: [
          const Text(
            "Today",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text(
            "7th Ramadan 1447",
            style: TextStyle(color: const Color(0xFF6C63FF), fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Text(
            "February 26, 2026",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimeChip("Sehri - 5:10 AM"),
              _buildTimeChip("Iftar - 6:05 PM"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF151821), // Inner dark background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 65,
            width: 65,
            decoration: BoxDecoration(
              color: const Color(0xFF1E222D), // Dark Card
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white10),
            ),
            child: Icon(icon, color: const Color(0xFF6C63FF), size: 30),
          ),
          const SizedBox(height: 8),
          Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70)
          ),
        ],
      ),
    );
  }

  Widget _buildTasbihPromo(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E222D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          const Text(
            "Start Your Day To Count\nTasbih",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TasbeehPage()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF), // Purple accent button
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text("Get Started", style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildPrayerTimeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E222D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          const Text(
            "Prayer Time",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text("25 Feb 2026", style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 15),

          // Tabs
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF151821), // Inner dark background
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Center(child: Text("Today", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  ),
                ),
                const Expanded(
                  child: Center(child: Text("30 Days", style: TextStyle(color: Colors.white70))),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          // Prayer List
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPrayerItem("Fajr", "5:30 AM"),
              _buildPrayerItem("Dhuhr", "1:00 PM"),
              _buildPrayerItem("Asr", "3:30 PM", isNext: true),
              _buildPrayerItem("Maghrib", "6:15 PM"),
              _buildPrayerItem("Isha", "7:45 PM"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerItem(String name, String time, {bool isNext = false}) {
    return Column(
      children: [
        Text(name, style: TextStyle(color: isNext ? const Color(0xFF6C63FF) : Colors.white70, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: isNext ? const Color(0xFF6C63FF).withOpacity(0.2) : const Color(0xFF151821),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isNext ? const Color(0xFF6C63FF) : Colors.transparent),
          ),
          child: Text(time, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isNext ? Colors.white : Colors.white70)),
        ),
      ],
    );
  }
}