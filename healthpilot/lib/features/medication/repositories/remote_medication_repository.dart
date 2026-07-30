import 'package:healthpilot/core/network/api_client.dart';
import 'package:healthpilot/core/network/api_constants.dart';
import 'package:healthpilot/core/repositories/i_medication_repository.dart';
import 'package:healthpilot/features/medication/medication_models.dart';

class RemoteMedicationRepository implements IMedicationRepository {
  const RemoteMedicationRepository(this._client);
  final ApiClient _client;

  /// Fetches every page of a DRF-paginated endpoint, following `next` until
  /// it is null, returning the concatenated `results`.
  Future<List<dynamic>> _fetchAllPages(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    final all = <dynamic>[];
    final seen = <String>{};
    while (true) {
      final data = await _client.get(path, queryParameters: query);
      if (data is! Map) {
        if (data is List) all.addAll(data);
        break;
      }
      final results = data['results'];
      if (results is List) all.addAll(results);
      final next = data['next'];
      if (next is! String || next.isEmpty) break;
      final nextQuery = Uri.parse(next).queryParameters;
      final key = nextQuery.toString();
      if (nextQuery.isEmpty || !seen.add(key)) break;
      query = Map<String, dynamic>.from(nextQuery);
    }
    return all;
  }

  @override
  Future<List<Medication>> fetchMedications({bool activeOnly = true}) async {
    final items = await _fetchAllPages(
      '${ApiConstants.medicationsBase}/',
      query: activeOnly ? {'active': true} : null,
    );
    return items
        .map((e) => Medication.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Medication> fetchMedication(int id) async {
    final data = await _client.get('${ApiConstants.medicationsBase}/$id/');
    return Medication.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<Medication> addMedication(Medication medication) async {
    final data = await _client.post(
      '${ApiConstants.medicationsBase}/',
      data: medication.toJson(),
    );
    return Medication.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<Medication> updateMedication(Medication medication) async {
    final data = await _client.patch(
      '${ApiConstants.medicationsBase}/${medication.id}/',
      data: medication.toJson(),
    );
    return Medication.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteMedication(int id) async =>
      _client.delete('${ApiConstants.medicationsBase}/$id/');

  @override
  Future<List<MedicationReminder>> fetchReminders(int medicationId) async {
    final data = await _client
        .get('${ApiConstants.medicationsBase}/$medicationId/reminders/');
    final items = data is List ? data : const [];
    return items
        .map((e) => MedicationReminder.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<MedicationReminder> addReminder(
      int medicationId, MedicationReminder reminder) async {
    final data = await _client.post(
      '${ApiConstants.medicationsBase}/$medicationId/reminders/',
      data: reminder.toJson(),
    );
    return MedicationReminder.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<MedicationReminder> updateReminder(
      int medicationId, MedicationReminder reminder) async {
    final data = await _client.patch(
      '${ApiConstants.medicationsBase}/$medicationId/reminders/${reminder.id}/',
      data: reminder.toJson(),
    );
    return MedicationReminder.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteReminder(int medicationId, int reminderId) async =>
      _client.delete(
          '${ApiConstants.medicationsBase}/$medicationId/reminders/$reminderId/');

  @override
  Future<List<DoseLog>> fetchDoses(int medicationId) async {
    final items = await _fetchAllPages(
      '${ApiConstants.medicationsBase}/$medicationId/doses/',
    );
    return items
        .map((e) => DoseLog.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<DoseLog> logDose(int medicationId, DoseLog dose) async {
    final data = await _client.post(
      '${ApiConstants.medicationsBase}/$medicationId/doses/',
      data: dose.toJson(),
    );
    return DoseLog.fromJson(data as Map<String, dynamic>);
  }
}
