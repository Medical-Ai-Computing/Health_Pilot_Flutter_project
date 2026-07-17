import 'package:healthpilot/core/network/api_client.dart';
import 'package:healthpilot/core/network/api_constants.dart';
import 'package:healthpilot/core/repositories/i_contacts_repository.dart';
import 'package:healthpilot/features/profile/personal_info_contact_models.dart';

class RemoteContactsRepository implements IContactsRepository {
  const RemoteContactsRepository(this._client);
  final ApiClient _client;

  Future<List<dynamic>> _fetchAllPages(String path) async {
    final all = <dynamic>[];
    final seen = <String>{};
    Map<String, dynamic>? query;
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
  Future<List<EmergencyContactEntry>> fetchEmergencyContacts() async {
    final items = await _fetchAllPages(
      '${ApiConstants.profileBase}/emergency-contacts/',
    );
    return items
        .map((e) => EmergencyContactEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<EmergencyContactEntry> addEmergencyContact(
      EmergencyContactEntry contact) async {
    final data = await _client.post(
      '${ApiConstants.profileBase}/emergency-contacts/',
      data: contact.toJson(),
    );
    return EmergencyContactEntry.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<EmergencyContactEntry> updateEmergencyContact(
      EmergencyContactEntry contact) async {
    final data = await _client.patch(
      '${ApiConstants.profileBase}/emergency-contacts/${contact.id}/',
      data: contact.toJson(),
    );
    return EmergencyContactEntry.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteEmergencyContact(String id) async =>
      _client.delete('${ApiConstants.profileBase}/emergency-contacts/$id/');

  @override
  Future<List<PersonalDoctorEntry>> fetchDoctors() async {
    final items =
        await _fetchAllPages('${ApiConstants.profileBase}/doctors/');
    return items
        .map((e) => PersonalDoctorEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PersonalDoctorEntry> addDoctor(PersonalDoctorEntry doctor) async {
    final data = await _client.post(
      '${ApiConstants.profileBase}/doctors/',
      data: doctor.toJson(),
    );
    return PersonalDoctorEntry.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<PersonalDoctorEntry> updateDoctor(PersonalDoctorEntry doctor) async {
    final data = await _client.patch(
      '${ApiConstants.profileBase}/doctors/${doctor.id}/',
      data: doctor.toJson(),
    );
    return PersonalDoctorEntry.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteDoctor(String id) async =>
      _client.delete('${ApiConstants.profileBase}/doctors/$id/');
}
