import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    String backgroundImage = screenWidth > 800 ? 'assets/img/ote.jpg' : 'assets/img/ot.jpg';

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController nameController = TextEditingController();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
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
                  // Ad Soyad TextField
                  SizedBox(
                    width: screenWidth > 600 ? 400 : double.infinity,
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Ad Soyad',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.white70,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // E-posta TextField
                  SizedBox(
                    width: screenWidth > 600 ? 400 : double.infinity,
                    child: TextField(
                      controller: emailController,
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
                      controller: passwordController,
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
                  // Kaydol Butonu
                  SizedBox(
                    width: screenWidth > 600 ? 400 : double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          // Kayıt başarılı olursa login ekranına yönlendir
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        } on FirebaseAuthException catch (e) {
                          // Hata durumunu ele al
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Kayıt hatası: ${e.message}')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Kaydol', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Zaten hesabın var mı? Giriş Yap Linki
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Giriş ekranına geri dön
                    },
                    child: const Text('Zaten hesabın var mı? Giriş Yap', style: TextStyle(color: Colors.white)),
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
