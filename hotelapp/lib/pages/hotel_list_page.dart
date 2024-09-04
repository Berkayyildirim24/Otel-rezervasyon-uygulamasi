import 'package:flutter/material.dart';
import 'hotel_detail_page.dart';

class HotelListPage extends StatefulWidget {
  final List<Map<String, String>> reservations; // Rezervasyon bilgilerini tutan liste

  const HotelListPage({super.key, required this.reservations});

  @override
  _HotelListPageState createState() => _HotelListPageState();
}

class _HotelListPageState extends State<HotelListPage> {
  final List<Map<String, String>> hotels = [
    {'name': 'Otel 1', 'description': 'Otelimiz 5 yıldızlı olup, lüks bir konaklama sunar. Denize sıfır konumda olup, özel plaj ve geniş bir yüzme havuzu bulunmaktadır. Aileler ve çocuklar için uygundur.', 'image': 'gorsel1.jpg', 'price': '1.200 TL', 'location': 'İstanbul Beşiktaş'},
    {'name': 'Otel 2', 'description': 'Şehir merkezinde yer alan otelimiz, modern tasarımı ve yüksek hizmet kalitesi ile dikkat çekmektedir. Otelimizde spa, fitness merkezi ve çocuk oyun alanı mevcuttur.', 'image': 'gorsel2.jpg', 'price': '950 TL', 'location': 'İzmir Çeşme'},
    {'name': 'Otel 3', 'description': 'Otelimiz, doğa ile iç içe bir tatil isteyenler için mükemmeldir. Geniş bahçesi, açık yüzme havuzu ve yürüyüş parkurları ile huzurlu bir tatil imkanı sunar.', 'image': 'gorsel3.jpg', 'price': '850 TL', 'location': 'Antalya Kaş'},
    {'name': 'Otel 4', 'description': 'Tarihi dokusu ile ön plana çıkan otelimiz, klasik mimarisi ve modern konforu bir araya getiriyor. Şehir turizmi için ideal bir konumdadır ve kültürel geziler için mükemmeldir.', 'image': 'gorsel4.jpg', 'price': '1.100 TL', 'location': 'Muğla Bodrum'},
    {'name': 'Otel 5', 'description': 'Deniz manzaralı odalarımız, şık restoranlarımız ve spa merkezimiz ile misafirlerimize unutulmaz bir tatil deneyimi sunuyoruz. Balayı çiftleri için özel paketlerimiz bulunmaktadır.', 'image': 'gorsel5.jpg', 'price': '2.000 TL', 'location': 'Ankara Çankaya'},
    {'name': 'Otel 6', 'description': 'Otelimiz, iş seyahatleri için ideal bir konaklama imkanı sunmaktadır. Yüksek hızda internet, tam donanımlı toplantı odaları ve merkezi bir konum ile hizmetinizdeyiz.', 'image': 'gorsel6.jpg', 'price': '800 TL', 'location': 'Bursa Nilüfer'},
    {'name': 'Otel 7', 'description': 'Kapsamlı spor tesisleri, büyük bir yüzme havuzu ve açık hava etkinlik alanları ile otelimiz, hem tatilciler hem de spor severler için mükemmeldir.', 'image': 'gorsel7.jpg', 'price': '1.400 TL', 'location': 'Trabzon Ortahisar'},
    {'name': 'Otel 8', 'description': 'Otelimiz, çevre dostu tasarımı ile ön plana çıkmaktadır. Güneş enerjisi ile çalışan otelimizde organik yiyecekler sunulmaktadır. Doğa ile iç içe bir konaklama arayanlar için idealdir.', 'image': 'gorsel8.jpg', 'price': '1.250 TL', 'location': 'Adana Seyhan'},
    {'name': 'Otel 9', 'description': 'Geniş ve ferah odalar, gurme restoranlar ve şehir merkezine yakın konum ile otelimiz, hem tatilciler hem de iş insanları için ideal bir konaklama sunmaktadır.', 'image': 'gorsel9.jpg', 'price': '1.500 TL', 'location': 'Mersin Mezitli'},
    {'name': 'Otel 10', 'description': 'Lüks ve konforun birleştiği otelimiz, modern tasarımı ile misafirlerimize özel bir deneyim sunuyor. Alışveriş merkezlerine yakın konumda olup, eğlence seçenekleri ile dolu bir tatil vaat ediyor.', 'image': 'gorsel10.jpg', 'price': '1.800 TL', 'location': 'Aydın Kuşadası'},
  ];

  List<Map<String, String>> filteredHotels = [];

  @override
  void initState() {
    super.initState();
    filteredHotels = hotels;
  }

  void _filterHotels(String query) {
    final filtered = hotels.where((hotel) {
      final hotelName = hotel['name']!.toLowerCase();
      final input = query.toLowerCase();
      return hotelName.contains(input);
    }).toList();

    setState(() {
      filteredHotels = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SizedBox(
              width: screenWidth > 600 ? screenWidth * 0.5 : screenWidth,
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Otel Ara',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: _filterHotels,
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Container(
              width: screenWidth > 800 ? 800 : screenWidth * 0.9,
              child: ListView.builder(
                itemCount: filteredHotels.length,
                itemBuilder: (context, index) {
                  final hotel = filteredHotels[index];
                  return _buildHotelItem(
                    context,
                    hotel['image']!,
                    hotel['name']!,
                    hotel['description']!,
                    hotel['price']!,
                    hotel['location']!,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHotelItem(BuildContext context, String imagePath, String title, String subtitle, String price, String location) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HotelDetailPage(
              hotelName: title,
              imageName: imagePath,
              reservations: widget.reservations, // reservations listesini buradan geçiyoruz
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/img/$imagePath',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        price,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        location,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(subtitle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
