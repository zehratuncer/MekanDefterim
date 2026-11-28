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
## 📸 Faz 5 — Fotoğraf ve Dosya Yönetimi (Tamamlandı)
- [x] `image_picker` paketi ile galeri ve kamera üzerinden fotoğraf seçimi (otomatik yeniden boyutlandırma ve kalite sıkıştırması ile).
- [x] `PhotoStorageService`: Seçilen fotoğrafların uygulama özel dizinine (`place_photos/<placeId>/`) güvenli kopyalanması.
- [x] Bir mekâna en fazla 5 fotoğraf sınırı (`PlaceFormNotifier`) ve formda küçük önizleme şeridi / silme aksiyonu.
- [x] `PlaceDetailPage` üzerinde kaydırılabilir fotoğraf galerisi (`PageView`) ve `1 / N` sayaç rozeti.
- [x] Silinen mekânın veya kaldırılan fotoğrafın diskteki artık dosyalarının temizlenmesi.
- [x] Faz 5 birim testleri (`test/unit/photo_storage_service_test.dart`) ve `flutter analyze` / `flutter test` doğrulaması.
## 🔍 Faz 6 — Arama, Filtreleme ve Son Dokunuşlar (Tamamlandı)
- [x] Çoklu filtreleme (Kategori + Durum + Favoriler + Arama) ve filtre temizleme akışları (`PlacesListPage`).
- [x] Kalıcı tema yönetimi (`ThemeModeNotifier` + `AppPreferencesTable`), açık/koyu/sistem tema desteği (`AppTheme.lightTheme` & `darkTheme`) ve `SettingsPage` tema seçici.
- [x] Faz 6 birim/widget testleri (`test/widget/phase6_settings_test.dart`) ve `flutter analyze` / `flutter test` doğrulaması.
- **Faz 7 & 8 — Testler, Release İmzası ve Google Play Hazırlığı:**
  - API 36 hedefi, Keystore ve AAB derlemesi, 12 tester / 14 gün kapalı test süreci.


---

# ✨ Faz 9 — UI/UX Modernizasyonu (Animasyon ve Görsel Cila)

> **Amaç:** Mevcut kimliği (bordo, krem, altın, zümrüt yeşili, serif başlıklar, "defter" hissi) koruyarak uygulamayı daha modern, animasyonlu ve keyifli hale getirmek.
> **Kural:** Tüm işlevler çalışıyor. Yalnızca görsel ve etkileşim katmanı değişecek, iş mantığı, veritabanı ve testler bozulmayacak. Her adım sonunda `flutter analyze` ve `flutter test` temiz olmalı.
> **Çalışma şekli:** Adım adım, ekran ekran ilerlenecek. Biten maddeler `[x]` yapılacak.

### Önerilen paketler
- `flutter_animate`: kademeli, fade, slide ve scale animasyonları
- `lottie` veya `rive`: splash ve boş durum animasyonları
- `confetti`: "Gezildi" kutlaması
- `animations`: shared axis, fade-through ve container transform geçişleri
- `flutter_map_marker_cluster`: marker kümeleme
- `shimmer`: yükleme iskeletleri
- `sensors_plus` (opsiyonel): onboarding parallax

### Öncelik tablosu

| # | Değişiklik | Etki | Efor |
|---|---|---|---|
| 1 | Koyu/sepya harita stili ve marker kategori ikonları | Çok yüksek | Orta |
| 2 | Kademeli liste animasyonu, kalp burst, tap scale | Yüksek | Düşük |
| 3 | Detay sayfası hero görsel ve not kartı yenileme | Yüksek | Orta |
| 4 | "Gezildi" işaretlenince konfeti/tik animasyonu | Yüksek | Düşük |
| 5 | Splash ve onboarding animasyonları | Yüksek | Orta |
| 6 | Kategori ikon grid'i ve segmented kontrol (Mekân ekle) | Orta | Orta |
| 7 | Cam efektli arama ve alt bar, kayan nav göstergesi | Orta | Düşük |
| 8 | Marker kümeleme ve draggable alt kart | Orta | Yüksek |
| 9 | Rozetler ve "Sürpriz seç" | Orta | Yüksek |

**Önerilen uygulama sırası:** 9.0 → 9.2 (Koleksiyon/İstek) → 9.3 (Gezildi kutlaması) → 9.4 (cam efekti ve nav) → Harita → Detay → Splash/Onboarding → Mekân ekle → Konum seçimi → Ayarlar → Kümeleme/sheet → Ek özellikler.

---

## 9.0 Tasarım sistemi (temel)
- [ ] **Renk tokenları:** bordo zemin, kart rengi, altın vurgu (`#E8B27A`), biraz daha parlak/doygun zümrüt yeşil, metin renkleri. Tek yerden yönet (`AppTheme`/renk dosyası).
- [ ] **Kart stili:** Hafif gradient (üstten alta), 1px açık üst kenar parlaması, tutarlı gölge.
- [ ] **Köşe yarıçapı standardı:** 16 / 20 / 28 token olsun, her yerde aynısı kullanılsın.
- [ ] **Tipografi:** Tüm ekran başlıkları serif (Playfair/Lora). "Yeni Mekân", "Konum seç", "Mekân detayı" şu an sans-serif, serif'e çekilecek.
- [ ] **Arka plan dokusu:** Çok hafif kâğıt/grain dokusu (düşük opaklık).
- [ ] **Animasyon standardı:** Süre 200–300 ms, `easeOutCubic`; yaylanma için spring. Ortak sabitler dosyası.
- [ ] **`PressableScale` widget'ı:** Basınca scale 0.96 + haptic. Tüm dokunulabilir kart/butonlarda kullanılacak.
- [ ] **Haptic yardımcısı:** Kalp, tik, kaydet, sekme değişimi ve uzun basma için.
- [ ] **Erişilebilirlik:** İkincil metin ve placeholder kontrastı WCAG AA (≥ 4.5:1) seviyesine çıkarılacak.
- [ ] **Üst bar dili:** Haritadaki bordo gövdeli başlık ile diğer ekranlardaki düz başlık arasında tek stil seçilecek.
- [ ] **Ortak widget'lar:** `AppCard`, `AppChip`, `PressableScale`, `StaggeredList`, `ShimmerCard` (`AppEmptyState` zaten var, güncellenecek).
- [ ] **Açık tema uyumu:** Her yeni stil açık temada da (Faz 6'da eklenen) kontrol edilecek.

## 9.1 Genel geçişler ve altyapı
- [ ] **Sayfa geçişleri:** Varsayılan kaydırma yerine detayda Hero/container transform, sekmeler arasında yatay fade-through, alt sayfalarda shared axis (GoRouter `pageBuilder`).
- [ ] **Skeleton/shimmer:** Veri yüklenirken parlayan iskelet kartlar (Koleksiyon, İstek Listem).
- [ ] **Boş durum illüstrasyonları:** Onboarding motifleriyle (çiçek, kamera, pusula) markaya özel çizimler.
- [ ] **Pull-to-refresh** için özel animasyon (uçan kuşlar), opsiyonel.

## 9.2 Koleksiyon (`PlacesListPage`)
- [ ] Liste kartları açılışta kademeli (staggered) fade-up ile gelsin.
- [ ] Kaydırırken hafif parallax.
- [ ] Fotoğrafsız mekânlarda düz ikon yerine kategori renginde gradient + desen.
- [ ] Liste / Galeri (büyük görselli, gradient overlay) görünüm geçişi.
- [ ] **Kalp:** Dokununca burst animasyonu + haptic.
- [ ] **Swipe:** Sola kaydır = sil (onay ve geri al), sağa kaydır = "Gezildi".
- [ ] Collapsing/sliver app bar; başlık kaydırırken küçülsün.
- [ ] İstatistik sayaç animasyonu ("8 mekân · 6 gezildi · 2 yeni rota").
- [ ] Çip satırında sağ kenara solma (fade); "Favor..." kesiliyor, kaydırılabilirlik anlaşılsın.
- [ ] Arama sonucu boşsa çizimli illüstrasyon + mesaj.

## 9.3 İstek Listem (`WishlistPage`)
- [ ] **"Gezildi olarak işaretle":** Tik animasyonu, yeşile dönüş, konfeti, kartın sağa kayıp çıkması (ana "keyif anı").
- [ ] Kartlara mesafe ("2,3 km uzakta") ve kategori rozeti (konum izni yoksa gizlenir).
- [ ] Liste boşalınca "Hepsini gezdin! 🎉" illüstrasyonu.
- [ ] Sürükle-bırak ile öncelik sıralaması (veri modeline `sortOrder` gerekebilir, ayrıca değerlendirilecek).
- [ ] **"Sürpriz seç"** butonu: rastgele mekân, kart çevirme animasyonuyla.
- [ ] Alt boşluğa ilerleme çubuğu ("8 mekânın 6'sını gezdin").
- [ ] Kartlar kademeli girişle gelsin.

## 9.4 Cam efekti ve alt navigasyon
- [ ] Alt navigasyon: Seçili ikon hafif zıplasın; pill arka plan sekmeler arasında akarak kaysın.
- [ ] Alt bar ve arama çubukları için blur (`BackdropFilter`) cam efekti.

## 9.5 Harita (`PlacesMapPage`)
- [ ] **Harita stili:** Koyu temada koyu/sepya harita (CartoDB Dark Matter vb.) ya da mevcut karolara bordo/sepya renk filtresi. Lisans/atıf gereklilikleri kontrol edilecek.
- [ ] **Marker'lar (`PlaceMapMarker`):**
  - [ ] Ekrana girerken sırayla "pop" animasyonu.
  - [ ] İçinde kategori ikonu (kitap, kafe vb.); durum rengi/rozetle ayrışsın.
  - [ ] Seçili marker büyüsün, altında pulse halkası olsun.
- [ ] **Üst alan:** Başlık ve arama cam efektli, harita tüm ekranı kaplasın.
- [ ] **Filtre çipleri:** Seçili çip arkasında kayan pill animasyonu; sayılar animasyonla değişsin.
- [ ] **Alt önizleme kartı:**
  - [ ] Aşağıdan yaylanarak çıksın, aşağı çekince kapansın.
  - [ ] Küçük fotoğraf, mesafe ve "Yol tarifi" kısayolu.
- [ ] **FAB'lar:**
  - [ ] "+" basılınca 45° dönüp menüye açılsın (Mekân ekle, Konumumdan ekle).
  - [ ] Konum butonu bulurken radar dalgası göstersin.

## 9.6 Mekân detayı (`PlaceDetailPage`)
- [ ] Üstte büyük hero görsel/galeri (fotoğraf yoksa kategori gradient'i), kaydırınca küçülen başlık.
- [ ] Listeden gelirken görsel Hero ile büyüsün.
- [ ] Fotoğraf carousel; tıklayınca tam ekran + pinch-zoom.
- [ ] Durum, kategori ve **puan** rozetleri belirgin, ikonlu olsun (ekran görüntüsünde puan görünmüyordu, kontrol edilecek).
- [ ] **Not kartı:** Defter sayfası görünümü (satır çizgileri, kâğıt tonu, el yazısı font).
- [ ] Harita önizlemesi hafif zoom-in animasyonuyla açılsın; "Haritada gör" ile marker'a uçarak geçiş.
- [ ] Hızlı aksiyonlar: Yol tarifi, Paylaş, "Gezildi olarak işaretle".
- [ ] Silme için onay bottom sheet'i + geri al (undo) snackbar'ı.
- [ ] Başlığı serif yap.

## 9.7 Splash ve onboarding
**Splash**
- [ ] Arka planı beyazdan bordo gradient'e çevir (koyu temayla uyumlu).
- [ ] Native splash (Android/iOS) ile Flutter splash rengini eşitle (beyaz parlama olmasın).
- [ ] Logo: hafif scale-up + fade-in; konum pini yukarıdan düşüp zıplasın.
- [ ] Defter sayfası açılma animasyonu (Lottie/Rive), opsiyonel.
- [ ] Altta ince yükleme çizgisi ve "Güzel yerler sende kalsın" yazısı.
- [ ] Splash → onboarding geçişinde logo Hero animasyonu.

**Onboarding**
- [ ] Polaroid fotoğraf: hafif süzülme ve ±2° rotasyon.
- [ ] Yıldız ve kamera ikonları sırayla parlasın (twinkle); kuşlar yavaşça uçsun.
- [ ] Parallax katmanlar; opsiyonel gyroscope.
- [ ] Metinler satır satır fade-up ile gelsin.
- [ ] 3 sayfalık kaydırmalı akış (Hatırla / Listele / Keşfet) + nokta göstergesi.
- [ ] CTA butonu: hafif nefes alma (pulse), ok ikonu sağa kayan animasyon.

## 9.8 Mekân ekle / düzenle (`PlaceFormPage`)
- [ ] Seçili konum kartına küçük harita önizlemesi.
- [ ] **Kategori seçimi:** Dropdown yerine ikonlu grid/yatay çipler, seçince ikon animasyonu.
- [ ] **Durum seçimi:** Segmented control; seçili arka plan kayarak değişsin. "Gezildi" seçilince tik çizilme/konfeti.
- [ ] **Yıldız puanı:** Dokununca sırayla altın rengiyle dolsun, hafif sıçrasın, haptic.
- [ ] **Fotoğraf alanı:** Kesikli kenarlıklı, kamera ikonlu büyük alan; eklenen fotoğraflar scale-in ile gelsin.
- [ ] **Kaydet butonu:** Yüklenirken spinner → tik dönüşümü; sonra marker'ın haritada yerine uçarak inmesi (hero).
- [ ] Klavye açılınca kaydet butonu klavyenin üstünde sabit kalsın.
- [ ] Bölüm başlıkları ve ayırıcılarla adım adım hissi; başlık serif.

## 9.9 Konum seçimi (`LocationPickerPage`)
- [ ] Pin ekran ortasında sabit; sürüklerken yukarı kalksın, gölge küçülsün, bırakınca zıplayarak insin.
- [ ] Alt kart: seçilen adres + "Bu konumu seç" butonu (onay netleşsin).
- [ ] Arama sonuçları fade + slide ile gelsin; son aramalar listesi.
- [ ] Arama kutusu odaklanınca altın renkli kenarlık parlaması.
- [ ] Başlığı serif yap.

## 9.10 Ayarlar (`SettingsPage`)
- [ ] Gizlilik kartını sadeleştir: üç maddeyi kompakt ikonlu satırlara böl, bölüm başlıkları ekle.
- [ ] **Tema seçimi:** Açık / Koyu / Sistem önizleme kartları; seçince daire büyüyerek canlı tema geçişi.
- [ ] Yeni bölümler: uygulama sürümü, veriyi dışa aktar (yedek), hakkında.
- [ ] Debug bölümünde "Örnek Yükle" iki satırlı metin sıkışıklığını düzelt.
- [ ] "Temizle" pasif görünümünün nedenini göster (veri yoksa açıklama/ipucu).
- [ ] Başlık serif ve giriş animasyonları.

## 9.11 Gelişmiş harita etkileşimleri
- [ ] **Marker kümeleme:** Yakın marker'lar sayaçlı balon olsun, yakınlaşınca dağılsın (Kadıköy/Beyoğlu'nda üst üste biniyor).
- [ ] **Draggable alt kart:** Yukarı çekince tam detaya genişlesin.

## 9.12 Ek keyif özellikleri
- [ ] **Başarı anları:** İlk mekân eklenince kutlama; 10. mekânda "Kaşif" rozeti (basit gamification).
- [ ] Rozetler bölümü (Ayarlar veya Koleksiyon içinde).
- [ ] Haptic geri bildirimlerin tüm akışlara yayılması.
- [ ] Marka illüstrasyonlu tüm boş durumların tamamlanması.

---

## ✅ Her adım sonrası kontrol listesi
- [ ] Mevcut işlevler (ekle, düzenle, sil, filtrele, favori, gezildi, harita, fotoğraf) hâlâ çalışıyor
- [ ] `flutter analyze` ve `flutter test` temiz (gerekirse widget testleri animasyonlara göre güncellenir)
- [ ] Animasyonlar düşük donanımlı cihazda akıcı (60 fps)
- [ ] "Animasyonları azalt" erişilebilirlik ayarına saygı gösteriliyor
- [ ] Kontrast ve dokunma alanı (≥ 48dp) uygun
- [ ] Koyu ve açık temada kontrol edildi
