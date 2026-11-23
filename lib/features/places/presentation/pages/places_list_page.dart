import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mekandefterim/core/theme/app_colors.dart';
import 'package:mekandefterim/core/widgets/app_empty_state.dart';

class PlacesListPage extends StatelessWidget {
  const PlacesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Koleksiyon'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => context.push('/places/new'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kendi küçük atlasın.',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '0 mekân · 0 gezildi · 0 yeni rota',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: AppEmptyState(
                icon: Icons.bookmark_border_rounded,
                title: 'Henüz bir mekân eklemedin',
                subtitle: 'Gezdiğin veya keşfetmek istediğin ilk noktayı ekleyerek kendi defterini oluştur.',
                actionLabel: 'İlk mekânını ekle',
                onAction: () => context.push('/places/new'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
