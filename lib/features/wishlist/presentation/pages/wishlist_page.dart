import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mekandefterim/core/widgets/app_empty_state.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İstek Listem'),
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
              'Bir sonraki durağın?',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '0 mekân keşfedilmeyi bekliyor.',
              style: TextStyle(fontSize: 13, color: Colors.white60),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: AppEmptyState(
                icon: Icons.favorite_border_rounded,
                title: 'İstek listen henüz boş',
                subtitle: 'Gitmek istediğin yerleri kaydet, vakti geldiğinde ziyaret edip gezildi olarak işaretle.',
                actionLabel: 'İstek ekle',
                onAction: () => context.push('/places/new'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
