import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotelapp/main.dart';
import 'package:hotelapp/pages/signup_page.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Ekran genişliğine göre arka plan görselini seçtim
    String backgroundImage = screenWidth > 800 ? 'assets/img/ote.jpg' : 'assets/img/ot.jpg';

    // Firebase Authentication instance
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Arka plan görseli
          Image.asset(
            backgroundImage,
            fit: BoxFit.cover,
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  // Email TextField
                  SizedBox(
                    width: screenWidth > 600 ? 400 : double.infinity,
                    child: TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'E-posta',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                        filled: true,
                        fillColor: Colors.white70,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Şifre TextField
                  SizedBox(
                    width: screenWidth > 600 ? 400 : double.infinity,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Şifre',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                        filled: true,
                        fillColor: Colors.white70,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Giriş Yap Butonu
                  SizedBox(
                    width: screenWidth > 600 ? 400 : double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                          if (userCredential.user != null) {
                            // Giriş başarılı ise MainPage'e yönlendir
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const MainPage()),
                            );
                          }
                        } catch (e) {
                          // Hata durumu: Kullanıcıya mesaj göster
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Giriş Başarısız: ${e.toString()}')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Giriş Yap', style: TextStyle(fontSize: 18)),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Şifreni mi Unuttun? Linki
                  TextButton(
                    onPressed: () {

                    },
                    child: const Text('Şifreni mi unuttun?', style: TextStyle(color: Colors.white)),
                  ),

                  // Hesabın yok mu? Kaydol Linki
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignupPage()),
                      );
                    },
                    child: const Text('Hesabın yok mu? Kaydol', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// TextEditingController tanımlamaları
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
