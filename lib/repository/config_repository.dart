import 'dart:io' show Platform;

import 'package:daily_dose_of_happiness/model/legal_doc_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConsentRepository {
  final SupabaseClient _client;

  ConsentRepository(this._client);

  /// Returns a list (possibly empty) of compliance rows.
  Future<List<ComplianceRow>> checkCompliance() async {
    try {
      final dynamic res = await _client.rpc('is_user_compliant');

      // Supabase RPC typically returns List<dynamic> for set-returning functions.
      final list = (res is List) ? res : const <dynamic>[];

      final rows = <Map<String, dynamic>>[];
      for (final item in list) {
        if (item is Map) {
          rows.add(Map<String, dynamic>.from(item));
        }
      }

      return rows.map(ComplianceRow.fromJson).toList();
    } on PostgrestException catch (e) {
      throw Exception('checkCompliance RPC failed: ${e.message}');
    } catch (e) {
      throw Exception('checkCompliance failed: $e');
    }
  }

  /// Fetches the active legal document for a given docType.
  Future<LegalDoc> fetchActiveDoc(String docType) async {
    try {
      final dynamic res = await _client
          .from('active_legal_documents')
          .select('doc_type, version, title, url')
          .eq('doc_type', docType)
          .single();

      if (res is! Map) {
        throw const FormatException(
            'Unexpected response format for active doc.');
      }

      final map = Map<String, dynamic>.from(res);
      return LegalDoc.fromJson(map);
    } on PostgrestException catch (e) {
      throw Exception('fetchActiveDoc failed: ${e.message}');
    } catch (e) {
      throw Exception('fetchActiveDoc failed: $e');
    }
  }

  /// Records the user's acceptance for a legal document.
  Future<void> acceptDoc({
    required String docType,
    required String version,
    required String locale,
  }) async {
    try {
      final info = await PackageInfo.fromPlatform();

      final String platform = () {
        try {
          if (Platform.isIOS) return 'ios';
          if (Platform.isAndroid) return 'android';
          return 'unknown';
        } catch (_) {
          return 'unknown';
        }
      }();

      final appVersion = '${info.version}+${info.buildNumber}';

      await _client.rpc(
        'accept_legal_document',
        params: <String, dynamic>{
          'p_doc_type': docType,
          'p_version': version,
          'p_locale': locale,
          'p_app_version': appVersion,
          'p_platform': platform,
        },
      );
    } on PostgrestException catch (e) {
      throw Exception('acceptDoc RPC failed: ${e.message}');
    } catch (e) {
      throw Exception('acceptDoc failed: $e');
    }
  }
}
