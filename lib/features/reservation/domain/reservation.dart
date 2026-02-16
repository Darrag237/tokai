class Reservation {
  final String id;
  final String userId;
  final String pickupText;
  final String dropoffText;
  final DateTime scheduledAt;
  final String repeatType; // none/daily/weekly/custom
  final List<int> repeatDays; // 1-7 (Mon-Sun) when custom
  final String? notes;
  final String status; // scheduled/cancelled/done
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Reservation({
    required this.id,
    required this.userId,
    required this.pickupText,
    required this.dropoffText,
    required this.scheduledAt,
    required this.repeatType,
    required this.repeatDays,
    required this.notes,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });
}
