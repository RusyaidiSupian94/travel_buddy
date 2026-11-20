import 'package:material_ui/material_ui.dart';

import '../../core/app_colors.dart';
import '../../core/app_session.dart';
import '../../shared/widgets/content_frame.dart';
import '../../shared/widgets/mountain_art.dart';
import '../booking/booking_draft.dart';

class CheckoutPage extends StatelessWidget {
  final AppSession session;
  final BookingDraft booking;
  final VoidCallback onPay;

  const CheckoutPage({
    super.key,
    required this.session,
    required this.booking,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    return ContentFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.mint,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppColors.teal,
                  size: 17,
                ),
                const SizedBox(width: 8),
                Text(
                  'Selamat datang, ${session.displayName}',
                  style: const TextStyle(
                    color: AppColors.tealDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 5),
                const Expanded(
                  child: Text(
                    'Anda sudah login. Tempahan diteruskan.',
                    style: TextStyle(
                      color: AppColors.tealDark,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 23),
          const Text(
            'Semak tempahan',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Maklumat yang dipilih sebelum login masih disimpan.',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 21),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 820;
              final details = _BookingDetails(booking: booking, onPay: onPay);
              final summary = _SummaryCard(
                booking: booking,
                onPay: onPay,
              );

              if (compact) {
                return Column(
                  children: [
                    details,
                    const SizedBox(height: 18),
                    summary,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: details),
                  const SizedBox(width: 20),
                  SizedBox(width: 330, child: summary),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BookingDetails extends StatelessWidget {
  final BookingDraft booking;
  final VoidCallback onPay;

  const _BookingDetails({
    required this.booking,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF7FAF7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 92,
                height: 80,
                child: MountainArt(
                  style: MountainStyle.sea,
                  height: 80,
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'GUIDE',
                      style: TextStyle(
                        color: AppColors.teal,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      booking.serviceName,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${booking.vendorName} · ${booking.guestCount} guests',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _money(booking.subtotal),
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'Maklumat perjalanan',
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 520;
            final date = _FormField(
              label: 'TARIKH',
              value: booking.date,
              icon: Icons.calendar_today_outlined,
            );
            final guests = _FormField(
              label: 'PESERTA',
              value: '${booking.guestCount} orang',
              icon: Icons.people_outline,
            );

            if (compact) {
              return Column(
                children: [
                  date,
                  const SizedBox(height: 10),
                  guests,
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: date),
                const SizedBox(width: 10),
                Expanded(child: guests),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        _FormField(
          label: 'LOKASI PICKUP',
          value: booking.pickupLocation,
          icon: Icons.location_on_outlined,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: onPay,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.coral,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Bayar & sahkan tempahan'),
          ),
        ),
      ],
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _FormField({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF7),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.teal, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
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

class _SummaryCard extends StatelessWidget {
  final BookingDraft booking;
  final VoidCallback onPay;

  const _SummaryCard({
    required this.booking,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'RINGKASAN BAYARAN',
            style: TextStyle(
              color: Color(0xFFA8D9D1),
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 20),
          _SummaryRow(
            label: 'Service',
            value: _money(booking.subtotal),
          ),
          const SizedBox(height: 13),
          _SummaryRow(
            label: '${booking.guestCount} guests × ${_money(booking.pricePerGuest)}',
            value: _money(booking.subtotal),
          ),
          const SizedBox(height: 13),
          _SummaryRow(
            label: 'Platform fee',
            value: _money(booking.serviceFee),
          ),
          const SizedBox(height: 17),
          const Divider(color: Color(0x446B9AA1), height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Jumlah',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                _money(booking.total),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onPay,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.coral,
                padding: const EdgeInsets.symmetric(vertical: 13),
              ),
              child: const Text('Teruskan ke bayaran'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFFB9DDD7),
              fontSize: 10,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

String _money(int amount) => 'RM$amount';
