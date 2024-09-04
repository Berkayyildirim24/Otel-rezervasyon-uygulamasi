import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'icon_text_button.dart';

class MobileLayout extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final List<Widget> widgetOptions;

  const MobileLayout({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.widgetOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOŞGELDİNİZ', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: widgetOptions.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.hotel),
            label: 'Oteller',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.user),
            label: 'Profil',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: onItemTapped,
      ),
    );
  }
}

class WebLayout extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final List<Widget> widgetOptions;

  const WebLayout({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.widgetOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOŞGELDİNİZ', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconTextButton(
            icon: FontAwesomeIcons.home,
            label: 'Ana Sayfa',
            onPressed: () => onItemTapped(0),
            isSelected: selectedIndex == 0,
          ),
          IconTextButton(
            icon: FontAwesomeIcons.hotel,
            label: 'Oteller',
            onPressed: () => onItemTapped(1),
            isSelected: selectedIndex == 1,
          ),
          IconTextButton(
            icon: FontAwesomeIcons.user,
            label: 'Profil',
            onPressed: () => onItemTapped(2),
            isSelected: selectedIndex == 2,
          ),
        ],
      ),
      body: widgetOptions.elementAt(selectedIndex),
    );
  }
}
