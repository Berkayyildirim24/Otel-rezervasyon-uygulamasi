import 'package:flutter/material.dart';

class TabletLayout extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final List<Widget> widgetOptions;

  const TabletLayout({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.widgetOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOŞGELDİNİZ', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => onItemTapped(0),
            color: selectedIndex == 0 ? Colors.blue : Colors.white,
          ),
          IconButton(
            icon: const Icon(Icons.hotel),
            onPressed: () => onItemTapped(1),
            color: selectedIndex == 1 ? Colors.blue : Colors.white,
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => onItemTapped(2),
            color: selectedIndex == 2 ? Colors.blue : Colors.white,
          ),
        ],
      ),
      body: widgetOptions[selectedIndex],
    );
  }
}
