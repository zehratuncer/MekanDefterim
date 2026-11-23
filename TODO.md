# Mekan Defteri'm — Geliştirme Yol Haritası & Faz 2 Detaylı TODO

Bu doküman, ana proje planındaki (`MekanDefteri_Proje_Plani.md`) gereksinimler, kullanıcı senaryoları ve arayüz tasarımları doğrultusunda **Faz 2 (Veri Modeli ve Yerel Veritabanı)** başta olmak üzere tüm geliştirme adımlarını mikro görevlere ayırarak detaylandırır.

---

## 📌 Geliştirme Prensipleri & Git Kuralları
- **Aktif Geliştirme Dalı:** `develop`
- **Özellik Dalları:** `develop` üzerinden `feature/<ozellik-adi>` veya `fix/<hata-adi>` şeklinde açılır.
- **Commit Formatı:** Anlamlı ve konvansiyonel commit mesajları (`feat:`, `chore:`, `fix:`, `test:`, `docs:`).
- **Test ve Kalite:** Her geliştirme dalı tamamlandığında `flutter analyze` ve `flutter test` çalıştırılıp temiz sonuç alındıktan sonra `develop` dalına entegre edilir.

---

## 🚀 Faz 2 — Veri Modeli ve Yerel Veritabanı (Detaylı TODO)

Bu fazın amacı: UI bağımlılığı olmadan, tüm mekân CRUD akışının, ilişkisel tabloların, doğrulama kurallarının ve veri kaynaklarının testlerle doğrulanmış sağlam bir temel üzerine oturtulmasıdır.

### 2.1 Paket ve Altyapı Kurulumu
- [x] `drift`, `sqlite3_flutter_libs`, `path` paketlerini bağımlılıklara ekle.
- [x] `drift_dev`, `build_runner` paketlerini `dev_dependencies` altına ekle.
- [x] SQLite platform desteğini doğrula (Android, iOS, test ortamları).

### 2.2 Domain Modelleri ve Entity Tasarımı
- [x] **`PlaceStatus` Enum:** `visited` (Gezildi) ve `planned` (Gitmek istiyorum) durumları.
- [x] **`PlaceCategory` Enum / Modeli:** Kafe, Restoran, Kitapçı, Doğa / Park, Müze / Kültür, Alışveriş, Sahil / Manzara, Diğer (ikon ve etiket eşleşmeleriyle).
- [x] **`Place` Entity:**
  - `id`: UUID (String)
  - `name`: String (boş olamaz, trim kontrolü)
  - `categoryKey`: String
  - `status`: PlaceStatus
  - `latitude`: double (-90..90 aralığında)
  - `longitude`: double (-180..180 aralığında)
  - `addressLabel`: String? (kullanıcıya gösterilen semt/şehir bilgisi)
  - `note`: String? (isteğe bağlı kişisel not)
  - `rating`: int? (1-5 arası, yalnızca `visited` durumunda geçerli)
  - `isFavorite`: bool (varsayılan false)
  - `visitedAt`: DateTime? (ziyaret tarihi)
  - `createdAt`: DateTime
  - `updatedAt`: DateTime
- [x] **`PlacePhoto` Entity:**
  - `id`: UUID (String)
  - `placeId`: String (ilişkili mekân id'si)
  - `filePath`: String (yerel dosya yolu)
  - `thumbnailPath`: String? (liste performansı için önizleme yolu)
  - `sortOrder`: int (galeri sıralaması)
  - `createdAt`: DateTime
- [x] **İş Mantığı ve Doğrulama Kuralları:**
  - Mekân adı boş veya sadece boşluklardan oluşamaz.
  - Koordinat sınırları doğrulaması.
  - `planned` durumundayken `rating` null olmalı veya sıfırlanmalı.
  - Bir mekâna en fazla 5 fotoğraf eklenebilme kuralı.

### 2.3 Drift / SQLite Tablo Tanımları & Veritabanı Katmanı
- [x] `Places` Drift tablosunu oluştur:
  - Primary Key: `id` (Text)
  - Check constraint veya model seviyesinde doğrulama.
- [x] `PlacePhotos` Drift tablosunu oluştur:
  - Primary Key: `id` (Text)
  - Foreign Key: `placeId -> Places.id` ile `ON DELETE CASCADE`.
- [x] `AppPreferences` Drift tablosu (veya yerel ayar saklama tablosu):
  - Tema, son harita merkezi vb. için anahtar-değer tablosu.
- [x] `AppDatabase` sınıfını oluştur ve bağlantı yapılandırmasını (native bağlantı) tamamla.
- [x] `build_runner` çalıştırarak Drift kod üretimini (`app_database.g.dart`) gerçekleştir.

### 2.4 Data Source & Repository Katmanı
- [x] **`PlaceRepository` (Domain Interface):**
  - `watchPlaces({PlaceFilter? filter})`: Stream dinleme (harita ve liste için gerçek zamanlı akış).
  - `getPlaceById(String id)`: Tekil mekân getirme.
  - `savePlace(Place place)`: Yeni mekân ekleme / güncelleme.
  - `deletePlace(String id)`: Mekân ve ilişkili fotoğrafları silme.
  - `toggleFavorite(String id)`: Favori durumunu tersine çevirme.
  - `updateStatus(String id, PlaceStatus newStatus)`: Ziyaret durumunu güncelleme (örn. İstek Listesinden Gezildi'ye alma).
  - `getPlaces({PlaceFilter? filter})`: Arama ve filtreleme.
- [x] **`PlaceLocalDataSource` (Data Implementation):**
  - Drift sorgularını çalıştıran yerel veri kaynağı.
- [x] **`PlaceRepositoryImpl`:**
  - Veri dönüştürücüleri (DTO / Drift Data Class <-> Domain Entity).
  - Silme akışı sırasında hem veritabanı kaydının silinmesini hem de dosya sistemindeki fotoğrafların güvenli temizliğini yöneten orkestrasyon.

### 2.5 Riverpod Sağlayıcıları (DI)
- [x] `appDatabaseProvider`: Veritabanı singleton sağlayıcısı.
- [x] `placeRepositoryProvider`: Repository sağlayıcısı.
- [x] Test ortamları için in-memory veritabanı mock/override desteği.

### 2.6 Birim ve Entegrasyon Testleri
- [x] In-memory Drift veritabanı ile CRUD testleri:
  - Yeni mekân ekleme ve okuma.
  - Mekân güncelleme (`Place` alanlarının güncellenmesi).
  - Mekân silme ve ilişkili `PlacePhoto` kayıtlarının cascade silindiğinin doğrulanması.
  - Favori filtreleme, durum (`visited` / `planned`) filtreleme testleri.
  - İsim ile arama sorgusu testi.
- [x] Entity doğrulama testleri (geçersiz koordinat, boş isim, geçersiz puan vb.).
- [x] `flutter analyze` ve `flutter test` ile %100 temiz çalıştırma.

---

## 🔮 Sonraki Fazların Genel Özeti

- **Faz 3 — Mekân Yönetimi UI:**
  - Mekân kartı, arama alanı, filtre barları.
  - 2 adımlı ekleme/düzenleme formu (konum seçimi ve detay girişi).
  - Detay sayfası, fotoğraf galerisi, not alanı, favorileme ve silme onay diyaloğu.
  - İstek listesi ve tek tıkla "Gezildi olarak işaretle" butonu.
- **Faz 4 — Harita ve Konum:**
  - `flutter_map` + OSM uyumlu tile katmanı (atıf ve kurallara uygun).
  - Pin gösterimi (Gezildi için yeşil tik, İstek için turuncu kalp).
  - Haritada nokta seçerek koordinat alma.
  - "Konumum" butonu ve dinamik izin yönetimi (izin reddedildiğinde çökmeden devam edebilme).
- **Faz 5 — Fotoğraf ve Dosya Yönetimi:**
  - Fotoğraf seçici (`image_picker`), uygulama özel dizinine kopyalama.
  - Sıkıştırma ve thumbnail üretimi, en fazla 5 fotoğraf sınırı.
  - Silinen mekânın artık dosyalarını temizleme.
- **Faz 6 — Arama, Filtreleme ve Son Dokunuşlar:**
  - Çoklu filtreleme (Kategori + Durum + Favoriler).
  - Tema ve ayarlar yönetimi.
- **Faz 7 & 8 — Testler, Release İmzası ve Google Play Hazırlığı:**
  - API 36 hedefi, Keystore ve AAB derlemesi, 12 tester / 14 gün kapalı test süreci.
