import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../shared/widgets/content_frame.dart';
import '../../shared/widgets/mountain_art.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onGuide;
  final VoidCallback onAuth;

  const HomePage({
    super.key,
    required this.onGuide,
    required this.onAuth,
  });

  @override
  Widget build(BuildContext context) {
    return ContentFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeroWithSearch(onGuide: onGuide),
          const SizedBox(height: 28),
          _SectionTitle(
            title: 'Popular destinations',
            action: 'Lihat semua →',
            onTap: onGuide,
          ),
          const SizedBox(height: 13),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 860
                  ? 3
                  : constraints.maxWidth >= 570
                      ? 2
                      : 1;
              final gap = 14.0;
              final cardWidth = columns == 1
                  ? constraints.maxWidth
                  : (constraints.maxWidth - (gap * (columns - 1))) / columns;

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: _destinations
                    .map(
                      (destination) => SizedBox(
                        width: cardWidth,
                        height: 152,
                        child: _DestinationCard(destination: destination),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 22),
          _BrowseCard(onTap: onAuth),
        ],
      ),
    );
  }
}

class _HeroWithSearch extends StatelessWidget {
  final VoidCallback onGuide;

  const _HeroWithSearch({required this.onGuide});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 680;
        final searchHeight = compact ? 152.0 : 76.0;

        return SizedBox(
          height: 202 + searchHeight - 28,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                bottom: searchHeight - 28,
                child: MountainArt(
                  style: MountainStyle.hero,
                  height: 202,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'GUEST MODE',
                            style: TextStyle(
                              color: Color(0xFFC9EEE6),
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Cari trip anda',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 7),
                          const Text(
                            'Explore guide dan itinerary tanpa perlu akaun.',
                            style: TextStyle(
                              color: Color(0xFFC9EEE6),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextButton(
                            onPressed: onGuide,
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.coral,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 17,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            child: const Text('Teroka sekarang'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 0,
                child: _SearchCard(compact: compact),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SearchCard extends StatelessWidget {
  final bool compact;

  const _SearchCard({required this.compact});

  @override
  Widget build(BuildContext context) {
    final fields = [
      const _SearchField(
        icon: Icons.location_on_outlined,
        label: 'DESTINASI',
        value: 'Ke mana anda mahu pergi?',
        flex: 3,
      ),
      const _SearchField(
        icon: Icons.calendar_today_outlined,
        label: 'TARIKH',
        value: 'Pilih tarikh',
        flex: 2,
      ),
    ];

    return Container(
      padding: EdgeInsets.all(compact ? 12 : 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F12394C),
            blurRadius: 18,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: compact
          ? Column(
              children: [
                ...fields.map(
                  (field) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: field,
                  ),
                ),
                const SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: _SearchButton(),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(flex: fields[0].flex, child: fields[0]),
                const SizedBox(width: 8),
                Expanded(flex: fields[1].flex, child: fields[1]),
                const SizedBox(width: 8),
                const SizedBox(
                  width: 145,
                  height: 48,
                  child: _SearchButton(),
                ),
              ],
            ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final int flex;

  const _SearchField({
    required this.icon,
    required this.label,
    required this.value,
    required this.flex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF7),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.teal),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.7,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchButton extends StatelessWidget {
  const _SearchButton();

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.search, size: 16),
      label: const Text('Cari service'),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.ink,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        textStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback onTap;

  const _SectionTitle({
    required this.title,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.teal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            textStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
          child: Text(action),
        ),
      ],
    );
  }
}

class _DestinationCard extends StatelessWidget {
  final _Destination destination;

  const _DestinationCard({required this.destination});

  @override
  Widget build(BuildContext context) {
    return MountainArt(
      style: destination.style,
      height: 152,
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.ink.withOpacity(0.56),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 14,
            right: 14,
            bottom: 13,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destination.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  destination.detail,
                  style: const TextStyle(
                    color: Color(0xFFE3F4F0),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BrowseCard extends StatelessWidget {
  final VoidCallback onTap;

  const _BrowseCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 19),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF7),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFE9F0EB)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 540;
          final text = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Boleh browse dahulu',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Akaun hanya diperlukan untuk tempahan, bayaran dan pengurusan trip.',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 11,
                ),
              ),
            ],
          );

          final button = TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              backgroundColor: AppColors.mint,
              foregroundColor: AppColors.tealDark,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              textStyle: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
            child: const Text('Cara ia berfungsi →'),
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text,
                const SizedBox(height: 13),
                button,
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: text),
              button,
            ],
          );
        },
      ),
    );
  }
}

class _Destination {
  final String name;
  final String detail;
  final MountainStyle style;

  const _Destination({
    required this.name,
    required this.detail,
    required this.style,
  });
}

const _destinations = [
  _Destination(
    name: 'Langkawi',
    detail: '12 service tersedia',
    style: MountainStyle.sea,
  ),
  _Destination(
    name: 'Bali',
    detail: '18 service tersedia',
    style: MountainStyle.sunset,
  ),
  _Destination(
    name: 'Kyoto',
    detail: '9 service tersedia',
    style: MountainStyle.lavender,
  ),
];
