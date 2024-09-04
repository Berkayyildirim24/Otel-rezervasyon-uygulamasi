import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth > 600 ? screenWidth * 0.1 : 16.0,  // Küçük ekranlarda daha az padding
            ),
            child: CarouselSlider(
              options: CarouselOptions(
                height: screenWidth > 600 ? 300.0 : 200.0,  // Küçük ekranlarda daha düşük yükseklik
                autoPlay: true,
                enlargeCenterPage: true,
              ),
              items: [
                'assets/img/slider1.jpg',
                'assets/img/slider2.jpg',
                'assets/img/slider3.jpg',
              ].map((imagePath) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(imagePath, fit: BoxFit.cover, width: screenWidth),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'En İyi Otelleri Keşfedin!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            'Şimdi rezervasyon yapın ve unutulmaz bir tatil deneyimi yaşayın.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          // Öne Çıkan Oteller Başlığı
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth > 600 ? screenWidth * 0.1 : 16.0),
            child: Align(
              alignment: screenWidth > 600 ? Alignment.centerLeft : Alignment.center,
              child: const Text(
                'Öne Çıkan Oteller',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth > 600 ? screenWidth * 0.1 : 16.0),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: screenWidth > 1200 ? 4 : (screenWidth > 600 ? 2 : 2), // Web'de 4x4, tablet modunda 2x2
              crossAxisSpacing: 8,
              mainAxisSpacing: 16,
              childAspectRatio: screenWidth > 1200 ? 1.5 : (screenWidth > 600 ? 1.3 : 1), // Kareye yakın oran
              children: List.generate(4, (index) {
                final List<String> imagePaths = [
                  'assets/img/gorsel1.jpg',
                  'assets/img/gorsel2.jpg',
                  'assets/img/gorsel3.jpg',
                  'assets/img/gorsel4.jpg',
                ];

                final List<String> hotelNames = [
                  'Otel 1',
                  'Otel 2',
                  'Otel 3',
                  'Otel 4',
                ];

                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        imagePaths[index],
                        fit: BoxFit.cover,
                        height: screenWidth > 1200 ? 180.0 : (screenWidth > 600 ? 150.0 : 120.0), // Tablet ve webde boyut farklı
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      hotelNames[index],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 40),

          // Kampanyalar ve Özel Teklifler Başlığı
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth > 600 ? screenWidth * 0.1 : 16.0),
            child: Align(
              alignment: screenWidth > 600 ? Alignment.centerLeft : Alignment.center,
              child: const Text(
                'Kampanyalar ve Özel Teklifler',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth > 600 ? screenWidth * 0.1 : 16.0),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: screenWidth > 1200 ? 4 : (screenWidth > 600 ? 2 : 2), // Web'de 4x4, tablet modunda 2x2
              crossAxisSpacing: 8,
              mainAxisSpacing: 16, // Bu değeri azaltarak iki grup arasındaki boşluğu azaltabilirsiniz
              childAspectRatio: screenWidth > 1200 ? 1.5 : (screenWidth > 600 ? 1.3 : 1), // Kareye yakın oran
              children: List.generate(4, (index) {
                final List<String> imagePaths = [
                  'assets/img/otell.jpg',
                  'assets/img/slider2.jpg',
                  'assets/img/slider3.jpg',
                  'assets/img/slider1.jpg',
                ];

                final List<String> offerNames = [
                  'Erken Rezervasyon %20 İndirim',
                  '3 Gece Kal 2 Gece Öde',
                  'Aile Tatil Paketi %15 İndirim',
                  'Balayı Çiftlerine Özel Fırsatlar',
                ];

                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        imagePaths[index],
                        fit: BoxFit.cover,
                        height: screenWidth > 1200 ? 180.0 : (screenWidth > 600 ? 150.0 : 120.0), // Tablet ve webde boyut farklı
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      offerNames[index],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
