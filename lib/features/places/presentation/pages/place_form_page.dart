import 'package:flutter/material.dart';
import 'package:mekandefterim/core/theme/app_colors.dart';

class PlaceFormPage extends StatelessWidget {
  const PlaceFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Mekân'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Konum Alanı
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const Row(
                children: [
                  Icon(Icons.location_on_rounded, color: AppColors.accent),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Konum seçildi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('Moda, Kadıköy - İstanbul', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                      ],
                    ),
                  ),
                  Text('Değiştir', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Mekân adı', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Örn: Montag Coffee',
              ),
            ),
            const SizedBox(height: 20),
            const Text('Kategori', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: 'Kafe',
                  isExpanded: true,
                  dropdownColor: AppColors.surface,
                  items: const [
                    DropdownMenuItem(value: 'Kafe', child: Text('Kafe')),
                    DropdownMenuItem(value: 'Restoran', child: Text('Restoran')),
                    DropdownMenuItem(value: 'Kitapçı', child: Text('Kitapçı')),
                    DropdownMenuItem(value: 'Kültür & Sanat', child: Text('Kültür & Sanat')),
                    DropdownMenuItem(value: 'Açık hava', child: Text('Açık hava')),
                  ],
                  onChanged: (val) {},
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Mekânı Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
