# Kullanıcıya sunulacak README.md içeriğini .md dosyası olarak kaydediyoruz.

readme_content = """
# 📚 English with News – Flutter & Firebase

Flutter kullanarak geliştirdiğim bu projede, kullanıcıların güncel haberler üzerinden İngilizce öğrenme süreçlerini kolaylaştırmayı hedefledim.  
Modern, kullanıcı dostu ve Firebase altyapısıyla entegre çalışan bir dil öğrenme uygulamasıdır.

---

## 📁 Proje Yapısı

```plaintext
lib/
├── components/                # Yeniden kullanılabilir widget'lar
├── controllers/               # Sayfa controller'ları (login, register, home, profile vs.)
├── helpers/                   # Yardımcı fonksiyonlar
├── model/                     # Veri modelleri (User, NewsArticle vs.)
├── services/                  # Firebase, ImageKit, Auth servisleri
├── theme/                     # Uygulama teması
├── views/                     # Sayfalar (Login, Register, Home, etc.)
├── widgets/                   # Özel widget'lar
├── firebase_options.dart      # Firebase yapılandırması
└── main.dart                  # Uygulama giriş noktası
```

---

## 🚀 Kurulum ve Çalıştırma

### 1. Flutter bağımlılıklarını yükle:
```bash
flutter pub get
```

### 2. Firebase yapılandırması:
- `firebase_options.dart` dosyasının oluşturulduğundan emin olun (`flutterfire configure` komutu ile).
- `google-services.json` dosyasını `android/app/` dizinine ekleyin.
- `GoogleService-Info.plist` dosyasını `ios/Runner/` klasörüne ekleyin (iOS için).

### 3. Uygulamayı çalıştır:
```bash
flutter run
```

---

## 🧰 Kullanılan Teknolojiler

| Teknoloji       | Açıklama                                           |
|-----------------|----------------------------------------------------|
| 🧩 Flutter       | Mobil uygulama geliştirme SDK'sı                   |
| 🔥 Firebase      | Gerçek zamanlı veritabanı, auth, storage           |
| 🖼️ ImageKit.io   | Haber ve profil görsellerinin CDN ile yönetimi     |
| 🔐 Google Auth   | Güvenli kullanıcı giriş ve kimlik doğrulama       |

---

## 📲 Özellikler

- 🔐 Google Auth ile kullanıcı kayıt/giriş sistemi  
- 🗞️ Güncel haberler üzerinden İngilizce öğrenme deneyimi  
- 🌙 Tema yönetimi (dark/light mod)  
- 🖼️ Görsel yükleme ve optimize sunum (ImageKit ile)  
- 🧠 Öğrenmeye yardımcı arayüzler ve bileşenler  
- ✅ Flutter MVVM benzeri yapı  

---

## 🎥 Demo

🎬 [YouTube: Tanıtım Videosu İzle](https://youtu.be/2yIojc1aaxo?si=9eDrZGh6-59Iw0JU)
![english_with_news1](https://github.com/user-attachments/assets/c7970e91-126a-449b-910b-e35b83408339)
![english_with_news2](https://github.com/user-attachments/assets/a3bb2680-1346-4a57-bb7e-e17b670b1b19)
![english_with_news3](https://github.com/user-attachments/assets/6ae5a6b1-0bbd-49a5-a49e-2821405b8f31)
![english_with_news4](https://github.com/user-attachments/assets/914d1472-26f3-4294-a88a-d50893636fff)

---

## 🤝 Katkı Sağlamak

Katkı sunmak istersen:

1. Fork oluştur  
2. Yeni bir branch aç (`feature/yeni-özellik`)  
3. Geliştirmeleri yap ve commit et  
4. Pull Request gönder 🚀

---

## 📩 Geri Bildirim

Fikirlerinizi, yorumlarınızı ve önerilerinizi duymaktan mutluluk duyarım!  
İletişim: [LinkedIn](https://www.linkedin.com/in/osmankizilkaya3423/)

---
