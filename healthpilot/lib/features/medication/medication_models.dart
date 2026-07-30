import 'package:intl/intl.dart';

const List<String> kDosageUnits = [
  'mg',
  'mcg',
  'ml',
  'g',
  'iu',
  'tabs',
  'caps',
  'drops',
];

class Medication {
  const Medication(
    this.medicationName,
    this.noTimesPerDay,
    this.miligrams, {
    this.id,
    this.dosageUnit = 'mg',
    this.isActive = true,
  });

  final int? id;
  final String medicationName;
  final int noTimesPerDay;
  final int miligrams;
  final String dosageUnit;
  final bool isActive;

  static int _parseDosageAmount(Map<String, dynamic> json) {
    final raw = json['dosage_amount'];
    if (raw is num) return raw.toInt();
    if (raw is String) {
      final parsed = double.tryParse(raw);
      if (parsed != null) return parsed.toInt();
    }
    final display = json['dosage_display'] as String?;
    if (display != null) {
      final match = RegExp(r'([\d.]+)').firstMatch(display);
      if (match != null) {
        return double.tryParse(match.group(1)!)?.toInt() ?? 0;
      }
    }
    return 0;
  }

  static String _parseDosageUnit(Map<String, dynamic> json) {
    final unit = json['dosage_unit'] as String?;
    if (unit != null && unit.isNotEmpty) return unit;
    final display = json['dosage_display'] as String?;
    if (display != null) {
      final match = RegExp(r'[\d.]+\s*(.+)$').firstMatch(display.trim());
      if (match != null) return match.group(1)!.trim();
    }
    return 'mg';
  }

  factory Medication.fromJson(Map<String, dynamic> json) => Medication(
        json['medication_name'] as String? ?? '',
        json['doses_per_day'] as int? ?? 1,
        _parseDosageAmount(json),
        id: json['id'] as int?,
        dosageUnit: _parseDosageUnit(json),
        isActive: json['is_active'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'medication_name': medicationName,
        'doses_per_day': noTimesPerDay,
        'dosage_amount': miligrams,
        'dosage_unit': dosageUnit,
      };

  Medication copyWith({
    int? id,
    String? medicationName,
    int? noTimesPerDay,
    int? miligrams,
    String? dosageUnit,
    bool? isActive,
  }) =>
      Medication(
        medicationName ?? this.medicationName,
        noTimesPerDay ?? this.noTimesPerDay,
        miligrams ?? this.miligrams,
        id: id ?? this.id,
        dosageUnit: dosageUnit ?? this.dosageUnit,
        isActive: isActive ?? this.isActive,
      );
}

class MedicationReminder {
  const MedicationReminder({
    this.id,
    required this.reminderTime,
    this.daysOfWeek = const [0, 1, 2, 3, 4, 5, 6],
  });

  final int? id;
  final String reminderTime; // "HH:MM" 24-hour
  final List<int> daysOfWeek; // 0 = Monday (backend convention)

  static String _normalizeReminderTime(String raw) {
    // Backend may return "08:00:00"; UI expects "HH:MM".
    final parts = raw.split(':');
    if (parts.length >= 2) {
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }
    return raw;
  }

  factory MedicationReminder.fromJson(Map<String, dynamic> json) =>
      MedicationReminder(
        id: json['id'] as int?,
        reminderTime:
            _normalizeReminderTime(json['reminder_time'] as String? ?? ''),
        daysOfWeek: List<int>.from(json['days_of_week'] as List? ?? const []),
      );

  Map<String, dynamic> toJson() => {
        'reminder_time': reminderTime,
        'days_of_week': daysOfWeek,
      };
}

class DoseLog {
  const DoseLog({
    this.id,
    required this.status,
    required this.scheduledAt,
    this.takenAt,
  });

  final int? id;
  final String status; // 'taken' | 'missed' | 'skipped'
  final DateTime scheduledAt;
  final DateTime? takenAt;

  factory DoseLog.fromJson(Map<String, dynamic> json) => DoseLog(
        id: json['id'] as int?,
        status: json['status'] as String,
        scheduledAt: DateTime.parse(json['scheduled_at'] as String),
        takenAt: json['taken_at'] != null
            ? DateTime.parse(json['taken_at'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'scheduled_at': scheduledAt.toIso8601String(),
        if (takenAt != null) 'taken_at': takenAt!.toIso8601String(),
      };

  String get formattedDate => DateFormat.yMMMd().format(scheduledAt);
}

/// Seed data used when FF_MEDICATIONS=false.
final List<Medication> kSeedMedications = [
  const Medication('Aspirin', 1, 100, id: 1, dosageUnit: 'mg'),
  const Medication('Vitamin D', 1, 1000, id: 2, dosageUnit: 'iu'),
];
