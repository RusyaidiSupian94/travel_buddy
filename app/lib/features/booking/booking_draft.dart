class BookingDraft {
  final String serviceName;
  final String vendorName;
  final String date;
  final int guestCount;
  final String pickupLocation;
  final int pricePerGuest;
  final int serviceFee;

  const BookingDraft({
    required this.serviceName,
    required this.vendorName,
    required this.date,
    required this.guestCount,
    required this.pickupLocation,
    required this.pricePerGuest,
    required this.serviceFee,
  });

  const BookingDraft.sample()
      : serviceName = 'Private island guide',
        vendorName = 'Ahmad Travel Services',
        date = '12 Jun 2025',
        guestCount = 2,
        pickupLocation = 'Masukkan lokasi meeting point',
        pricePerGuest = 250,
        serviceFee = 25;

  int get subtotal => pricePerGuest * guestCount;

  int get total => subtotal + serviceFee;
}
