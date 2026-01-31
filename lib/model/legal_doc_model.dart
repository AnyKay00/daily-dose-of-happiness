class LegalDoc {
  final String docType;
  final String version;
  final String title;
  final String url;

  LegalDoc(
      {required this.docType,
      required this.version,
      required this.title,
      required this.url});

  factory LegalDoc.fromJson(Map<String, dynamic> json) => LegalDoc(
        docType: json['doc_type'] as String,
        version: json['version'] as String,
        title: json['title'] as String,
        url: json['url'] as String,
      );
}

class ComplianceRow {
  final String docType;
  final String requiredVersion;
  final String? acceptedVersion;
  final bool isOk;

  ComplianceRow(
      {required this.docType,
      required this.requiredVersion,
      required this.acceptedVersion,
      required this.isOk});

  factory ComplianceRow.fromJson(Map<String, dynamic> json) => ComplianceRow(
        docType: json['doc_type'] != null ? json['doc_type'] as String : '',
        requiredVersion: json['required_version'] != null
            ? json['required_version'] as String
            : '',
        acceptedVersion: json['accepted_version'] as String?,
        isOk: json['is_ok'] != null ? json['is_ok'] as bool : false,
      );
}
