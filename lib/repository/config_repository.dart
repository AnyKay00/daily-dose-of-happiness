import 'dart:io';

import 'package:daily_dose_of_happiness/model/legal_doc_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConsentRepository {
  final SupabaseClient _client;
  ConsentRepository(this._client);

  Future<List<ComplianceRow>> checkCompliance() async {
    final res = await _client.rpc('is_user_compliant');
    final rows = (res as List).cast<Map<String, dynamic>>();
    return rows.map(ComplianceRow.fromJson).toList();
  }

  Future<LegalDoc> fetchActiveDoc(String docType) async {
    final res = await _client
        .from('active_legal_documents')
        .select('doc_type, version, title, url')
        .eq('doc_type', docType)
        .single();
    return LegalDoc.fromJson(res);
  }

  Future<void> acceptDoc({
    required String docType,
    required String version,
    required String locale,
  }) async {
    final info = await PackageInfo.fromPlatform();
    final platform = Platform.isIOS
        ? 'ios'
        : Platform.isAndroid
            ? 'android'
            : 'unknown';

    await _client.rpc('accept_legal_document', params: {
      'p_doc_type': docType,
      'p_version': version,
      'p_locale': locale,
      'p_app_version': '${info.version}+${info.buildNumber}',
      'p_platform': platform,
    });
  }
}
