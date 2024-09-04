import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HotelDetailPage extends StatefulWidget {
  final String hotelName;
  final String imageName;
  final List<Map<String, String>> reservations; // Rezervasyonları almak için eklenen parametre

  const HotelDetailPage({
    super.key,
    required this.hotelName,
    required this.imageName,
    required this.reservations, // Rezervasyonları almak için eklenen parametre
  });

  @override
  _HotelDetailPageState createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  bool isLiked = false;
  User? user;
  final _commentController = TextEditingController();
  List<String> reservedRooms = []; // Rezerve edilen odaları tutan liste

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _checkIfLiked();
  }

  void _checkIfLiked() async {
    if (user == null) return;

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favorites')
        .doc(widget.hotelName)
        .get();

    setState(() {
      isLiked = doc.exists;
    });
  }

  void _toggleFavorite() async {
    if (user == null) return;

    DocumentReference favRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favorites')
        .doc(widget.hotelName);

    if (isLiked) {
      await favRef.delete();
    } else {
      await favRef.set({
        'hotelName': widget.hotelName,
        'imageName': widget.imageName,
        'price': hotelPrices[widget.hotelName] ?? 'Bilinmiyor',
      });

      // Favorilere başarıyla eklendi mesajı
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.hotelName} başarıyla favorilere eklendi')),
      );
    }

    setState(() {
      isLiked = !isLiked;
    });
  }

  void _showReservationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final isMobile = MediaQuery.of(context).size.width < 600;
        return AlertDialog(
          title: const Text('Oda Seçimi'),
          content: SizedBox(
            width: double.maxFinite,
            child: Center(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 2 : 5,
                  childAspectRatio: 3,
                ),
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  String roomNumber = 'Oda ${index + 1}';
                  return Padding(
                    padding: const EdgeInsets.all(4.0), // Butonlar arasına boşluk
                    child: ElevatedButton(
                      onPressed: () {
                        _reserveRoom(roomNumber);
                        Navigator.of(context).pop(); // Pencereyi kapat
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isRoomReserved(roomNumber) ? Colors.grey : Colors.green,
                      ),
                      child: Text(roomNumber),
                    ),
                  );
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Kapat'),
            ),
          ],
        );
      },
    );
  }


  bool _isRoomReserved(String roomNumber) {
    return reservedRooms.contains(roomNumber);
  }

  void _reserveRoom(String roomNumber) {
    setState(() {
      if (!_isRoomReserved(roomNumber)) {
        reservedRooms.add(roomNumber);
        widget.reservations.add({
          'hotelName': widget.hotelName,
          'location': hotelLocations[widget.hotelName]!,
          'roomNumber': roomNumber,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$roomNumber için rezervasyon başarıyla yapıldı')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Üzgünüm, bu oda zaten rezerve edilmiş.')),
        );
      }
    });
  }

  Future<void> _submitComment() async {
    if (_commentController.text.isNotEmpty && user != null) {
      await FirebaseFirestore.instance
          .collection('hotels')
          .doc(widget.hotelName)
          .collection('comments')
          .add({
        'comment': _commentController.text,
        'userId': user!.uid,
        'timestamp': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Yorum başarıyla eklendi')),
      );

      _commentController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir yorum yazın')),
      );
    }
  }

  final Map<String, String> hotelDescriptions = {
    'Otel 1': 'Otelimiz 5 yıldızlı olup, lüks bir konaklama sunar. Denize sıfır konumda olup, özel plaj ve geniş bir yüzme havuzu bulunmaktadır. Aileler ve çocuklar için uygundur.',
    'Otel 2': 'Şehir merkezinde yer alan otelimiz, modern tasarımı ve yüksek hizmet kalitesi ile dikkat çekmektedir. Otelimizde spa, fitness merkezi ve çocuk oyun alanı mevcuttur.',
    'Otel 3': 'Otelimiz, doğa ile iç içe bir tatil isteyenler için mükemmeldir. Geniş bahçesi, açık yüzme havuzu ve yürüyüş parkurları ile huzurlu bir tatil imkanı sunar.',
    'Otel 4': 'Tarihi dokusu ile ön plana çıkan otelimiz, klasik mimarisi ve modern konforu bir araya getiriyor. Şehir turizmi için ideal bir konumdadır ve kültürel geziler için mükemmeldir.',
    'Otel 5': 'Deniz manzaralı odalarımız, şık restoranlarımız ve spa merkezimiz ile misafirlerimize unutulmaz bir tatil deneyimi sunuyoruz. Balayı çiftleri için özel paketlerimiz bulunmaktadır.',
    'Otel 6': 'Otelimiz, iş seyahatleri için ideal bir konaklama imkanı sunmaktadır. Yüksek hızda internet, tam donanımlı toplantı odaları ve merkezi bir konum ile hizmetinizdeyiz.',
    'Otel 7': 'Kapsamlı spor tesisleri, büyük bir yüzme havuzu ve açık hava etkinlik alanları ile otelimiz, hem tatilciler hem de spor severler için mükemmeldir.',
    'Otel 8': 'Otelimiz, çevre dostu tasarımı ile ön plana çıkmaktadır. Güneş enerjisi ile çalışan otelimizde organik yiyecekler sunulmaktadır. Doğa ile iç içe bir konaklama arayanlar için idealdir.',
    'Otel 9': 'Geniş ve ferah odalar, gurme restoranlar ve şehir merkezine yakın konum ile otelimiz, hem tatilciler hem de iş insanları için ideal bir konaklama sunmaktadır.',
    'Otel 10': 'Lüks ve konforun birleştiği otelimiz, modern tasarımı ile misafirlerimize özel bir deneyim sunuyor. Alışveriş merkezlerine yakın konumda olup, eğlence seçenekleri ile dolu bir tatil vaat ediyor.',
  };

  final Map<String, String> hotelPrices = {
    'Otel 1': '1.200 TL',
    'Otel 2': '950 TL',
    'Otel 3': '850 TL',
    'Otel 4': '1.100 TL',
    'Otel 5': '2.000 TL',
    'Otel 6': '800 TL',
    'Otel 7': '1.400 TL',
    'Otel 8': '1.250 TL',
    'Otel 9': '1.500 TL',
    'Otel 10': '1.800 TL',
  };

  final Map<String, String> hotelLocations = {
    'Otel 1': 'İstanbul, Beşiktaş',
    'Otel 2': 'İzmir, Çeşme',
    'Otel 3': 'Antalya, Kaş',
    'Otel 4': 'Muğla, Bodrum',
    'Otel 5': 'Ankara, Çankaya',
    'Otel 6': 'Bursa, Nilüfer',
    'Otel 7': 'Trabzon, Ortahisar',
    'Otel 8': 'Adana, Seyhan',
    'Otel 9': 'Mersin, Mezitli',
    'Otel 10': 'Aydın, Kuşadası',
  };

  final Map<String, List<String>> hotelFeatures = {
    'Otel 1': ['Denize Sıfır', 'Özel Plaj', 'Açık Havuz', 'Aile Dostu'],
    'Otel 2': [
      'Spa',
      'Fitness Merkezi',
      'Çocuk Oyun Alanı',
      'Şehir Merkezinde'
    ],
    'Otel 3': [
      'Doğa ile İç İçe',
      'Açık Havuz',
      'Yürüyüş Parkurları',
      'Huzurlu Tatil'
    ],
    'Otel 4': [
      'Tarihi Doku',
      'Klasik Mimari',
      'Şehir Turu',
      'Kültürel Geziler'
    ],
    'Otel 5': [
      'Deniz Manzaralı',
      'Şık Restoranlar',
      'Spa Merkezi',
      'Balayı Çiftleri İçin Uygun'
    ],
    'Otel 6': [
      'İş Seyahatleri İçin Uygun',
      'Toplantı Odaları',
      'Merkezi Konum',
      'Yüksek Hızda İnternet'
    ],
    'Otel 7': [
      'Spor Tesisleri',
      'Büyük Yüzme Havuzu',
      'Açık Hava Etkinlikleri',
      'Tatili Sevenler İçin'
    ],
    'Otel 8': [
      'Çevre Dostu',
      'Güneş Enerjisi',
      'Organik Yiyecekler',
      'Doğa İle İç İçe'
    ],
    'Otel 9': [
      'Geniş Odalar',
      'Gurme Restoranlar',
      'Şehir Merkezine Yakın',
      'İş Seyahatleri İçin Uygun'
    ],
    'Otel 10': [
      'Lüks ve Konfor',
      'Modern Tasarım',
      'Alışveriş Merkezine Yakın',
      'Eğlence Seçenekleri'
    ],
  };

  final Map<String, List<String>> hotelImages = {
    'Otel 1': [
      'assets/img/gorsel2.jpg',
      'assets/img/gorsel8.jpg',
      'assets/img/gorsel10.jpg'
    ],
    'Otel 2': [
      'assets/img/gorsel2.jpg',
      'assets/img/gorsel8.jpg',
      'assets/img/gorsel10.jpg'
    ],
    'Otel 3': [
      'assets/img/gorsel2.jpg',
      'assets/img/gorsel8.jpg',
      'assets/img/gorsel10.jpg'
    ],
    'Otel 4': [
      'assets/img/gorsel2.jpg',
      'assets/img/gorsel8.jpg',
      'assets/img/gorsel10.jpg'
    ],
    'Otel 5': [
      'assets/img/gorsel2.jpg',
      'assets/img/gorsel8.jpg',
      'assets/img/gorsel10.jpg'
    ],
    'Otel 6': [
      'assets/img/gorsel2.jpg',
      'assets/img/gorsel8.jpg',
      'assets/img/gorsel10.jpg'
    ],
    'Otel 7': [
      'assets/img/gorsel2.jpg',
      'assets/img/gorsel8.jpg',
      'assets/img/gorsel10.jpg'
    ],
    'Otel 8': [
      'assets/img/gorsel2.jpg',
      'assets/img/gorsel8.jpg',
      'assets/img/gorsel10.jpg'
    ],
    'Otel 9': [
      'assets/img/gorsel2.jpg',
      'assets/img/gorsel8.jpg',
      'assets/img/gorsel10.jpg'
    ],
    'Otel 10': [
      'assets/img/gorsel2.jpg',
      'assets/img/gorsel8.jpg',
      'assets/img/gorsel10.jpg'
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hotelName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  'assets/img/${widget.imageName}',
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 250,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.hotelName,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Konum: ${hotelLocations[widget.hotelName]}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Fiyat: ${hotelPrices[widget.hotelName] ?? 'Bilinmiyor'}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: _showReservationDialog,
                    icon: const Icon(Icons.book_online),
                    label: const Text('Rezervasyon Yap'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.grey,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  hotelDescriptions[widget.hotelName] ??
                      'Bu otel hakkında detaylı bilgi bulunmamaktadır.',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              if (hotelFeatures[widget.hotelName] != null) ...[
                const Text(
                  'Özellikler',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: hotelFeatures[widget.hotelName]!
                      .map((feature) =>
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(
                          feature,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ))
                      .toList(),
                ),
              ],
              const SizedBox(height: 20),
              if (hotelImages[widget.hotelName] != null) ...[
                const Text(
                  'Otel Resimleri',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i <
                        hotelImages[widget.hotelName]!.length; i++)
                      if (i < 2) _buildImageThumbnail(
                          hotelImages[widget.hotelName]![i]),
                    if (hotelImages[widget.hotelName]!.length > 2)
                      _buildImageThumbnailWithOverlay(
                        hotelImages[widget.hotelName]![2],
                        '10+',
                        onTap: () {
                          _showImageSlider(context, hotelImages[widget.hotelName]!);
                        },
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              const Text(
                'Yorumlar',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('hotels')
                    .doc(widget.hotelName)
                    .collection('comments')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final comments = snapshot.data!.docs;

                  if (comments.isEmpty) {
                    return const Center(
                      child: Text('Henüz yorum yapılmamış.'),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index]['comment'];
                      return ListTile(
                        title: Text(comment),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Yorum Ekle',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _commentController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Yorumunuz',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitComment,
                child: const Text('Yorumu Gönder'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageThumbnail(String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: 100,
          height: 100,
        ),
      ),
    );
  }

  Widget _buildImageThumbnailWithOverlay(String imagePath, String overlayText,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          _buildImageThumbnail(imagePath),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                ),
              ),
              child: Text(
                overlayText,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageSlider(BuildContext context, List<String> images) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CarouselSlider(
                items: images.map((imagePath) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.6,
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  height: MediaQuery.of(context).size.height * 0.6,
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Kapat',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
