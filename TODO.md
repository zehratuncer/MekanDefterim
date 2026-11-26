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

## 🎨 Faz 3 — Mekân Yönetimi UI (Detaylı Tasarım ve Görev Listesi)

Bu fazın amacı: Harita entegrasyonu öncesinde, kullanıcının tasarımlarda gördüğü tüm UI bileşenlerini (`Koleksiyon`, `Mekân Detayı`, `Yeni Mekân Ekle / Düzenle`, `İstek Listem`), form validasyonlarını ve gerçek SQLite veritabanına bağlı CRUD akışlarını eksiksiz çalıştırmaktır.

### 3.1 State Yönetimi & Presentation Notifier'ları (Riverpod)
- [x] **`PlacesListController` & `placesListProvider`:**
  - `PlaceFilter` durumunu yönetme (aktif arama metni, seçilen kategori çipi, gezildi/istekler durumu, favoriler filtresi).
  - Veritabanındaki `watchPlaces(filter: ...)` stream'ini dinleyerek koleksiyon sayacını (*"X mekân · Y gezildi · Z yeni rota"*) hesaplama ve UI'a reaktif aktarma.
  - Hızlı arama debounce mekanizması.
- [x] **`PlaceFormController` & `placeFormControllerProvider`:**
  - Form state modeli (`name`, `categoryKey`, `status`, `latitude`, `longitude`, `addressLabel`, `note`, `rating`, `photos`).
  - Dinamik validasyon: Durum `planned` yapıldığında puanı ve ziyaret tarihini otomatik temizleme / UI'da gizleme.
  - Kaydetme esnasında çifte tıklamayı önleme (`isSubmitting` kilidi).
- [x] **`PlaceDetailController`:**
  - Tekil mekân detayını ve fotoğraflarını dinleme.
  - Hızlı aksiyonlar: Tek dokunuşla favori açma/kapatma, tek dokunuşla "Gezildi olarak işaretle".

### 3.2 Özel Arayüz Bileşenleri (Custom Widgets)
- [x] **`PlaceCard` (Koleksiyon Kartı — Tasarım: `06 · Koleksiyon.png`):**
  - Sol tarafta önizleme / placeholder görsel alanı veya mini konum göstergesi.
  - Mekân adı, kategori etiketi, semt/şehir bilgisi.
  - Gezildi rozeti (`✓ Gezildi · Gün Ay`), 1-5 yıldız puanı.
  - Sağ üstte hızlı favori kalp butonu (dolu/boş animasyonlu).
  - Dokunulduğunda detay sayfasına geçiş.
- [x] **`WishlistCard` (İstek Listesi Kartı — Tasarım: `08 · İstek Listem.png`):**
  - Sol tarafta şık kategori ikonu (Restoran çatal-bıçak, Müze sütun, Açık hava yaprak vb.).
  - Mekân adı, kategori · semt bilgisi, tırnak içinde kısa gezi notu (*"Arkadaşımla git..."*).
  - Kartın altında zümrüt yeşili *"✓ Gezildi olarak işaretle"* butonu (tek tıkla durumu `visited` yapıp Gezildi listesine taşır).
- [x] **`PlaceFilterBar` & `CategoryChips`:**
  - Yatay kaydırılabilir modern kategori filtre çipleri (`Tümü`, `Kafe`, `Restoran`, `Kitapçı` vb.).
  - Durum seçim çipi (`Tümü`, `Gezildi`, `İstekler`) ve `Favoriler ♡` hızlı filtresi.
  - Aktif filtre varken *"Filtreleri temizle"* bağlantısı.
- [x] **`AppDeleteDialog` (Silme Onay Penceresi):**
  - Şık, tasarım diliyle uyumlu onay diyaloğu (*"Bu mekânı silmek istediğine emin misin? İlişkili fotoğraflar da cihazından temizlenecektir."*).

### 3.3 Ekran Geliştirmeleri (Pages)
- [x] **Koleksiyon Ekranı (`PlacesListPage`):**
  - Üstte *"Kendi küçük atlasın."* başlığı ve dinamik sayaç.
  - Arama alanı (temizleme `x` ikonu ile).
  - Filtre çipleri barı.
  - `ListView.builder` ile kart listesi.
  - Boş durum (`AppEmptyState`): Arama sonucu boşsa ayrı, veritabanı tamamen boşsa *"İlk keşfini ekle"* çağrısı.
- [x] **İstek Listem Ekranı (`WishlistPage`):**
  - *"Bir sonraki durağın?"* başlığı ve *"X mekân keşfedilmeyi bekliyor"* sayacı.
  - `PlaceStatus.planned` olan kayıtların özel listesi.
  - Tek tıkla "Gezildi"ye dönüştürme aksiyonu.
  - Boş liste durumu tasarımı.
- [x] **Yeni Mekân Ekle / Düzenle Ekranı (`PlaceFormPage` — Tasarımlar: `04` & `05`):**
  - Üstte Adım göstergesi (`2/2`).
  - Seçilen Konum özeti kartı (*"Caferağa, Kadıköy - İstanbul · Değiştir"*).
  - Mekân adı metin kutusu (zorunlu alan kontrolü).
  - Kategori açılır menüsü / modal seçici.
  - Durum seçici: İki parça toggle buton `[✓ Gezildi]  [♡ Gitmek istiyorum]`.
  - **Dinamik görünüm:**
    - `Gezildi` seçiliyse: Fotoğraf ekle butonu, 1-5 yıldız değerlendirme seçicisi, *"Kendime not"* alanı.
    - `Gitmek istiyorum` seçiliyse: Puan gizlenir, *"Bu mekân İstek Listem'de görünecek..."* bilgilendirme kutusu gösterilir.
  - Kaydet butonu (`Mekânı kaydet`) ve altta *"Yalnızca bu cihazda, sana özel."* güvencesi.
- [x] **Mekân Detay Ekranı (`PlaceDetailPage` — Tasarım: `07 · Mekân detayı.png`):**
  - Üstte fotoğraf galerisi / büyük görsel alanı (ör. 1/1 sayacı, yer tutucu görseli).
  - Sağ üstte favori kalp ve silme çöp kutusu ikonu.
  - Mekân adı ve rozetler (Kategori rozeti, Gezildi yeşil rozeti, Puan rozeti).
  - *"KENDİME NOT"* kartı (tarih damgası ile).
  - *"Haritada gör"* konumsal önizleme kartı.
  - Altta ana aksiyonlar: Zümrüt yeşili *"Düzenle"* butonu ve yanında silme butonu.

### 3.4 Yönlendirme & Navigasyon Entegrasyonu (GoRouter)
- [x] `/places/:id` rota tanımı (Detay sayfası).
- [x] `/places/:id/edit` rota tanımı (Düzenleme modu).
- [x] Formdan çıkarken kaydedilmemiş değişiklik varsa uyarı diyaloğu (PopScope).

### 3.5 Testler ve Kalite Doğrulaması
- [x] Form controller ve state testleri (durum geçişleri, validasyonlar).
- [x] Widget testleri:
  - Kartların doğru veriyi göstermesi.
  - Favori butonuna dokunulduğunda veritabanı akışının tetiklenmesi.
  - "Gezildi olarak işaretle" butonunun durumu güncellemesi.
  - Boş liste ve arama sonucu bulunamadı durumlarının çizilmesi.
- [x] `flutter analyze` ve `flutter test` ile tam doğrulama.
## 🗺️ Faz 4 — Harita ve Konum (Tamamlandı)
- [x] `flutter_map`, `latlong2` ve `geolocator` paketlerinin eklenmesi ve Android konum/internet izinlerinin yapılandırılması.
- [x] OSM uyumlu tile katmanı ve `OpenStreetMap` atıf katmanı (`RichAttributionWidget`) ile `PlacesMapPage` harita entegrasyonu.
- [x] Pin gösterimi (`PlaceMapMarker`): Gezildi için zümrüt yeşili tik, İstek için turuncu kalp; pine dokunulduğunda alt önizleme kartı ve detaya geçiş.
- [x] Harita üzerinde arama, durum filtresi (`Tümü`, `Gezildi`, `İstekler`) ve uzun basma ile yeni mekân ekleme.
- [x] Haritada nokta seçerek koordinat alma (`LocationPickerPage`) ve `PlaceFormPage` ("Değiştir") + `PlaceDetailPage` ("Haritada gör") entegrasyonu.
- [x] "Konumum" butonu ve dinamik izin yönetimi (`LocationService` — izin reddedildiğinde veya konum kapalıyken çökmeden bilgilendirme).
- [x] Faz 4 widget testleri (`test/widget/phase4_map_test.dart`) ve `flutter analyze` / `flutter test` doğrulaması.
- **Faz 5 — Fotoğraf ve Dosya Yönetimi:**
  - Fotoğraf seçici (`image_picker`), uygulama özel dizinine kopyalama.
  - Sıkıştırma ve thumbnail üretimi, en fazla 5 fotoğraf sınırı.
  - Silinen mekânın artık dosyalarını temizleme.
- **Faz 6 — Arama, Filtreleme ve Son Dokunuşlar:**
  - Çoklu filtreleme (Kategori + Durum + Favoriler).
  - Tema ve ayarlar yönetimi.
- **Faz 7 & 8 — Testler, Release İmzası ve Google Play Hazırlığı:**
  - API 36 hedefi, Keystore ve AAB derlemesi, 12 tester / 14 gün kapalı test süreci.
