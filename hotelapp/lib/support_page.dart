import 'package:flutter/material.dart';
import 'report_issue_page.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Destek ve Yardım'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ExpansionTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.question_answer),
                ],
              ),
              title: const Center(child: Text('Sıkça Sorulan Sorular')),
              children: _buildFaqList(),
            ),
            ExpansionTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.contact_mail),
                ],
              ),
              title: const Center(child: Text('İletişim')),
              children: _buildContactInfo(),
            ),
            ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.report_problem),
                ],
              ),
              title: const Center(child: Text('Sorun Bildir')),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReportIssuePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFaqList() {
    final List<Map<String, String>> faqs = [
      {
        'question': 'Uygulama nasıl çalışır?',
        'answer': 'Uygulama, otel rezervasyonu yapmanızı sağlayan basit ve kullanımı kolay bir platformdur.'
      },
      {
        'question': 'Hesap ayarlarını nasıl değiştirebilirim?',
        'answer': 'Hesap ayarlarını profil sayfasından erişebileceğiniz "Hesap Ayarları" bölümünden değiştirebilirsiniz.'
      },
      {
        'question': 'Otel arama nasıl yapılır?',
        'answer': 'Ana sayfada yer alan arama çubuğunu kullanarak istediğiniz oteli arayabilirsiniz.'
      },
      {
        'question': 'Favori otellerimi nasıl görüntüleyebilirim?',
        'answer': 'Profil sayfasında yer alan "Favori Oteller" bölümünden favori otellerinizi görüntüleyebilirsiniz.'
      },
      {
        'question': 'Rezervasyonumu nasıl iptal edebilirim?',
        'answer': 'Rezervasyon iptali için profil kısmında bulunan rezervasyona tıklayıp rezervasyon iptali seçebilirsiniz'
      },


      {
        'question': 'Uygulamada nasıl otel beğenebilirim?',
        'answer': 'Otel detay sayfasında yer alan "Favorilere Ekle" butonunu kullanarak otelleri favorilerinize ekleyebilirsiniz.'
      },

      {
        'question': 'Uygulama güncellemeleri nasıl yapılır?',
        'answer': 'Uygulama güncellemeleri, cihazınıza gelen bildirimler aracılığıyla otomatik olarak yapılır.'
      },
    ];

    return faqs.map((faq) {
      return ListTile(
        title: Center(child: Text(faq['question']!, textAlign: TextAlign.center)),
        subtitle: Center(child: Text(faq['answer']!, textAlign: TextAlign.center)),
      );
    }).toList();
  }

  List<Widget> _buildContactInfo() {
    final List<Map<String, String>> contacts = [
      {
        'title': 'Müşteri Hizmetleri',
        'details': 'Telefon: +90 123 456 7890\nE-posta: destek@ornek.com'
      },
      {
        'title': 'Teknik Destek',
        'details': 'Telefon: +90 987 654 3210\nE-posta: teknik@ornek.com'
      },
      {
        'title': 'Genel İletişim',
        'details': 'Adres: Ornek Sokak, No: 123, Istanbul\nE-posta: info@ornek.com'
      },
    ];

    return contacts.map((contact) {
      return ListTile(
        title: Center(child: Text(contact['title']!, textAlign: TextAlign.center)),
        subtitle: Center(child: Text(contact['details']!, textAlign: TextAlign.center)),
      );
    }).toList();
  }
}
