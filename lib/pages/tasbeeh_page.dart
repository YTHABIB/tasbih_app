import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// --- যিকিরের মডেল ---
class ZikrModel {
  final String arabic;
  final String pronunciation;
  final String meaning;
  final int target;

  ZikrModel(this.arabic, this.pronunciation, this.meaning, this.target);
}

class TasbeehPage extends StatefulWidget {
  const TasbeehPage({super.key});

  @override
  State<TasbeehPage> createState() => _TasbeehPageState();
}

class _TasbeehPageState extends State<TasbeehPage> {
  int _counter = 0;
  int _lap = 0;


  // যিকিরের লিস্ট
  final List<ZikrModel> _zikrList = [
    ZikrModel('سُبْحَانَ اللَّهِ', 'সুবহানাল্লাহ', 'আল্লাহ', 33),
    ZikrModel('ٱلْحَمْدُ لِلَّهِ', 'আলহামদুলিল্লাহ', 'আল্লাহ', 33),
    ZikrModel('اللَّهُ أَكْبَرُ', 'আল্লাহু আকবার', 'আল্লাহ', 100),
    ZikrModel('لَا إِلَٰهَ إِلَّا اللَّهُ', 'লা ইলাহা ইল্লাল্লাহ', 'আল্লাহ', 100),
  ];

  late ZikrModel _selectedZikr;

  @override
  void initState() {
    super.initState();
    _selectedZikr = _zikrList[0];
  }

  // --- Functions ---
  void _incrementCounter() {
    setState(() {
      _counter++;
      if (_counter == _selectedZikr.target) {
        HapticFeedback.lightImpact();
        _lap++;
        _counter = 0;
      }
    });
  }

  void _resetCounter() {
    HapticFeedback.mediumImpact();
    setState(() {
      _counter = 0;
      _lap = 1;
    });
  }

  void _undoCounter() {
    if (_counter > 0) {
      HapticFeedback.selectionClick();
      setState(() => _counter--);
    }
  }

  // --- Bottom Sheet Function ---
  void _showZikrSelectionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E222D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title & Custom Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Select Your Zikir",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white24),

                  // Zikir List
                  Expanded(
                    child: ListView.builder(
                      itemCount: _zikrList.length,
                      itemBuilder: (context, index) {
                        final zikr = _zikrList[index];
                        final isSelected = _selectedZikr == zikr;
                        return _buildZikrListItem(zikr, isSelected, () {
                          setState(() => _selectedZikr = zikr);
                          setSheetState(() {});
                          Navigator.pop(context);
                          _resetCounter();
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151821),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        leadingWidth: 25,
        title: const Text("Tasbih Counter", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.history, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // 1. Top Card
          _buildTopCard(),

          const Spacer(),
          // 2. Big Ripple Tap Button
          GestureDetector(
            onTap: _incrementCounter,
            child: _buildRippleButton(),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  // --- Widgets (Reusable Components) --- //

  Widget _buildTopCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E222D),
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage('https://img.freepik.com/free-vector/silhouette-taj-mahal-vector_53876-58379.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          // Laps & Target
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSmallChip(Icons.sync, "Lap $_lap"),
              const SizedBox(width: 30),
              _buildSmallChip(Icons.flag, "Goal ${_selectedZikr.target}"),
            ],
          ),
          const SizedBox(height: 20),

          // Main Counter
          Text(
            '$_counter',
            style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.white),
          ),

          // Zikr Selector Button
          GestureDetector(
            onTap: _showZikrSelectionSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_selectedZikr.pronunciation, style: const TextStyle(color: Colors.white70)),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.white70, size: 20),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Bottom Controls (Reset, Undo, Save)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildIconButton(Icons.refresh, _resetCounter),
                  const SizedBox(width: 10),
                  _buildIconButton(Icons.undo, _undoCounter),
                  const SizedBox(width: 10),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.save, size: 18),
                label: const Text("Save"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white10,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRippleButton() {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blueGrey.withOpacity(0.1)),
      child: Center(
        child: Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blueGrey.withOpacity(0.2)),
          child: Center(
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.lightBlue.shade200, Colors.blueGrey.shade500],
                ),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20, spreadRadius: 5)],
              ),
              child: const Center(
                child: Icon(Icons.touch_app_outlined, size: 40, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Components ---

  Widget _buildSmallChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 14),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: Colors.white70, size: 20),
      ),
    );
  }

  Widget _buildZikrListItem(ZikrModel zikr, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? Colors.blueGrey : Colors.transparent),
        ),
        child: Row(
          children: [
            Icon(isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected ? Colors.lightBlue.shade200 : Colors.white38),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(zikr.arabic, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(zikr.pronunciation, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)),
              child: Text("${zikr.target}x", style: const TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }
}