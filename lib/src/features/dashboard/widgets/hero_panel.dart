import 'package:bon_appetit/src/core/assets/app_assets.dart';
import 'package:flutter/material.dart';

class HeroPanel extends StatelessWidget {
  const HeroPanel({
    super.key,
    required this.onExploreMenu,
    required this.onTrackOrder,
  });

  final VoidCallback onExploreMenu;
  final VoidCallback onTrackOrder;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 560;

        return SizedBox(
          height: isCompact ? 360 : 310,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(AppAssets.hero, fit: BoxFit.cover),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.70),
                        Colors.black.withOpacity(0.15),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(isCompact ? 16 : 24),
                  child: isCompact
                      ? _HeroContent(
                          compact: true,
                          onExploreMenu: onExploreMenu,
                          onTrackOrder: onTrackOrder,
                        )
                      : Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: _HeroContent(
                                compact: false,
                                onExploreMenu: onExploreMenu,
                                onTrackOrder: onTrackOrder,
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: _StackBadge(colors: colors),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeroContent extends StatelessWidget {
  const _HeroContent({
    required this.compact,
    required this.onExploreMenu,
    required this.onTrackOrder,
  });

  final bool compact;
  final VoidCallback onExploreMenu;
  final VoidCallback onTrackOrder;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          compact ? MainAxisAlignment.start : MainAxisAlignment.center,
      mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
      children: [
        Image.asset(AppAssets.logo, height: compact ? 38 : 52),
        SizedBox(height: compact ? 8 : 16),
        Text(
          'Bon Appetit',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Restaurants, bakery, delivery, orders and tracking in one local-first workspace.',
          maxLines: compact ? 2 : 3,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
              ),
        ),
        SizedBox(height: compact ? 12 : 18),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledButton.icon(
              onPressed: onExploreMenu,
              icon: const Icon(Icons.restaurant_outlined),
              label: const Text('Explore menu'),
            ),
            FilledButton.tonalIcon(
              onPressed: onTrackOrder,
              icon: const Icon(Icons.route_outlined),
              label: const Text('Track order'),
            ),
          ],
        ),
        if (compact) ...[
          const SizedBox(height: 12),
          _StackBadge(colors: Theme.of(context).colorScheme),
        ],
      ],
    );
  }
}

class _StackBadge extends StatelessWidget {
  const _StackBadge({required this.colors});

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface.withOpacity(0.92),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          'Flutter + Baker API + Postgres',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
