import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/hotel_list_page.dart';
import 'pages/profile_page.dart';
import 'widgets/home_screen.dart';
import 'layouts/tablet_layout.dart';
import 'widgets/custom_navbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const HotelApp());
}

class HotelApp extends StatelessWidget {
  const HotelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HOŞGELDİNİZ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // Rezervasyon bilgilerini tutacak liste
  final List<Map<String, String>> reservations = [];

  // Sayfalar arasında geçiş için kullanılan widget listesi
  List<Widget> get _widgetOptions {
    return <Widget>[
      const HomeScreen(),
      HotelListPage(reservations: reservations), // reservations parametresini burada geçiriyoruz
      ProfilePage(reservations: reservations), // reservations parametresi ProfilePage'e de aktarılıyor
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                return WebLayout(
                  selectedIndex: _selectedIndex,
                  onItemTapped: _onItemTapped,
                  widgetOptions: _widgetOptions,
                );
              } else if (constraints.maxWidth > 600) {
                return TabletLayout(
                  selectedIndex: _selectedIndex,
                  onItemTapped: _onItemTapped,
                  widgetOptions: _widgetOptions,
                );
              } else {
                return MobileLayout(
                  selectedIndex: _selectedIndex,
                  onItemTapped: _onItemTapped,
                  widgetOptions: _widgetOptions,
                );
              }
            },
          );
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
