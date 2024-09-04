import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotelapp/pages/login_page.dart';
import 'package:hotelapp/support_page.dart';
import 'package:hotelapp/change_password_page.dart';

class ProfilePage extends StatefulWidget {
  final List<Map<String, String>> reservations; // Rezervasyon bilgilerini tutan liste

  const ProfilePage({super.key, required this.reservations});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? cancellationMessage; // İptal mesajı için bir değişken

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50, // Avatar boyutu
                backgroundImage: AssetImage('assets/img/profile_picture.jpg'),
              ),
              const SizedBox(height: 20),
              if (user != null) ...[
                const SizedBox(height: 10),
                Text(
                  'E-posta: ${user.email ?? "E-posta bilinmiyor"}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                ),
              ] else ...[
                const Text(
                  'Kullanıcı bilgileri alınamadı.',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildProfileOption(
                      context,
                      Icons.settings,
                      'Hesap Ayarları',
                      'Şifre değiştir',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
                        );
                      },
                    ),
                    _buildProfileOption(
                      context,
                      Icons.notifications,
                      'Rezervasyon',
                      'Rezervasyonları gör',
                      onTap: () {
                        _showReservations(context); // Rezervasyonları göster
                      },
                    ),
                    _buildProfileOption(
                      context,
                      Icons.favorite,
                      'Favoriler',
                      'Beğendiğiniz Oteller',
                      onTap: () {
                        _showFavoriteHotels(context, user);
                      },
                    ),
                    _buildProfileOption(
                      context,
                      Icons.help,
                      'Destek ve Yardım',
                      'SSS, İletişim',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SupportPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              if (cancellationMessage != null) ...[
                const SizedBox(height: 20),
                Text(
                  cancellationMessage!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(
      BuildContext context, IconData icon, String title, String subtitle,
      {VoidCallback? onTap}) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5, // Buton genişliğini %50 olarak ayarladım
        child: GestureDetector(
          onTap: onTap,
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(icon, size: 36, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showFavoriteHotels(BuildContext context, User? user) {
    if (user == null) return;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('favorites')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final favoriteHotels = snapshot.data!.docs;

            if (favoriteHotels.isEmpty) {
              return const Center(
                child: Text('Favori otel bulunmamaktadır.'),
              );
            }

            return ListView.builder(
              itemCount: favoriteHotels.length,
              itemBuilder: (context, index) {
                final hotel = favoriteHotels[index];
                return ListTile(
                  leading: Image.asset(
                    'assets/img/${hotel['imageName']}',
                    width: 100,  // Görsel genişliği
                    height: 200, // Görsel yüksekliği
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    hotel['hotelName'],
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    hotel['price'],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection('favorites')
                          .doc(hotel.id)
                          .delete();
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showReservations(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return widget.reservations.isEmpty
            ? const Center(child: Text('Henüz rezervasyon yapılmamış.'))
            : StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return ListView.builder(
              itemCount: widget.reservations.length,
              itemBuilder: (context, index) {
                final reservation = widget.reservations[index];
                return ListTile(
                  leading: const Icon(Icons.hotel, color: Colors.blue),
                  title: Text(reservation['hotelName']!),
                  subtitle: Text(
                    '${reservation['location']} - ${reservation['roomNumber']}',
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.reservations.removeAt(index);
                      });
                      setState(() {
                        cancellationMessage = 'Rezervasyonunuz başarıyla iptal edilmiştir';
                      });
                    },
                    child: const Text('İptal Et'),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
