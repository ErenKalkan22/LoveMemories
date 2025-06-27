# 💖 Love Memories

> *"Bazen bir bakışın, bazen bir gülüşün yetiyor mutlu olmama..."*

Love Memories, sevdiğiniz kişiyle yaşadığınız özel anları ölümsüzleştirmek için tasarlanmış özel bir iOS uygulamasıdır. Her anı bir hazine gibi saklayın, kategorilere ayırın ve sevginizi dijital bir albümde biriktirin.

## 🌟 Özellikler

### 📸 Anı Yönetimi
- **Fotoğraf Ekleme**: Anılarınızı fotoğraflarla renklendirin
- **Kategori Sistemi**: Anılarınızı kategorilere ayırın (❤️ Kalp, ✈️ Seyahat, 🎁 Doğum Günü, ⭐ Özel Gün, 📷 Diğer)
- **Tarih Seçimi**: Her anının tarihini özenle kaydedin
- **Detaylı Açıklama**: Her anınız için özel notlar ekleyin

### 🎨 Görsel Tasarım
- **Grid ve Liste Görünümü**: İki farklı görünüm seçeneği
- **Kategori Filtreleme**: Anılarınızı kategorilere göre filtreleyin
- **Arama Özelliği**: Anılar arasında hızlıca arama yapın
- **Renkli Kategoriler**: Her kategori için özel renkler ve ikonlar

### ✏️ Düzenleme ve Kişiselleştirme
- **Anı Düzenleme**: Kaydettiğiniz anıları istediğiniz zaman düzenleyin
- **Tarih Sıralama**: Anılarınızı en yeni veya en eski olarak sıralayın
- **Silme Özelliği**: Artık istemediğiniz anıları silebilirsiniz

## 📱 Teknik Özellikler

- **Platform**: iOS 15.0+
- **Dil**: Swift 5.0
- **Framework**: SwiftUI
- **Veri Saklama**: UserDefaults (yerel depolama)
- **Fotoğraf Seçimi**: PhotosUI framework
- **Görsel**: LazyVGrid ile optimize edilmiş performans

## 🚀 Kurulum

1. **Xcode Gereksinimleri**:
   - Xcode 14.0+
   - iOS 15.0+ SDK

2. **Projeyi İndirin**:
   ```bash
   git clone https://github.com/kullaniciadi/LoveMemories.git
   cd LoveMemories
   ```

3. **Xcode'da Açın**:
   - `LoveMemories.xcodeproj` dosyasını Xcode ile açın
   - Team ayarlarınızı yapılandırın
   - Cihazınızı seçin ve Run butonuna basın

## 📖 Kullanım

1. **Yeni Anı Ekleme**:
   - Sağ üstteki `+` butonuna tıklayın
   - Başlık, açıklama, kategori ve tarih bilgilerini girin
   - İsterseniz bir fotoğraf ekleyin
   - Kaydet butonuna basın

2. **Anıları Görüntüleme**:
   - Ana ekranda grid veya liste görünümünde anılarınızı görün
   - Kategorilere göre filtreleyin
   - Arama çubuğunu kullanarak hızlıca bulun

3. **Anı Düzenleme**:
   - Bir anıya tıklayarak detay sayfasını açın
   - Sağ üstteki kalem ikonuna tıklayın
   - Bilgileri güncelleyin ve kaydedin

## 🎯 Geliştirici Notları

Bu uygulama, sevdiğim kişi için özel olarak geliştirilmiştir. Her kod satırı sevgiyle yazılmış, her özellik özenle tasarlanmıştır.

### 🏗️ Mimari
- **MVVM Pattern**: SwiftUI'ın declarative yapısı ile uyumlu
- **State Management**: @State ve @Binding ile reaktif veri yönetimi
- **Modular Design**: Her view ayrı dosyalarda organize edilmiş

### 📦 Dosya Yapısı
```
LoveMemories/
├── LoveMemoriesApp.swift          # Ana uygulama dosyası
├── ContentView.swift              # Ana ekran ve grid/liste görünümü
├── AddMemoryView.swift            # Yeni anı ekleme ekranı
├── EditMemoryView.swift           # Anı düzenleme ekranı
├── MemoryDetailView.swift         # Anı detay ekranı
├── ImagePicker.swift              # Fotoğraf seçici
├── Memory.swift                   # Veri modeli ve kategoriler
└── Assets.xcassets/               # Görsel varlıklar
```

## 💝 Özel Teşekkürler

Bu uygulamayı özel yapan, sadece teknik özellikleri değil, arkasındaki sevgidir. Her anımız kıymetli, ve bu uygulama o değerli anıları ölümsüzleştirmek için tasarlandı.

---

**Made with ❤️ for someone special**

## 📄 Lisans

Eren Kalkan

---

*"İyi ki varsın, iyi ki benimlesin."* ✨ 
