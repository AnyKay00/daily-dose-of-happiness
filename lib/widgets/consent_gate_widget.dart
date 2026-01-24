import 'package:daily_dose_of_happiness/model/legal_doc_model.dart';
import 'package:daily_dose_of_happiness/repository/config_repository.dart';
import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:daily_dose_of_happiness/ui/consent_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConsentGate extends StatefulWidget {
  final Widget child;

  const ConsentGate({super.key, required this.child});

  @override
  State<ConsentGate> createState() => _ConsentGateState();
}

class _ConsentGateState extends State<ConsentGate> {
  bool _loading = true;
  bool _needsConsent = false;
  LegalDoc? _privacyDoc;
  //LegalDoc? _termsDoc; // optional
  late ConsentRepository repo;

  @override
  void initState() {
    super.initState();
    repo = ConsentRepository(Supabase.instance.client);
    _run();
  }

  Future<void> _run() async {
    try {
      final compliance = await repo.checkCompliance();
      final anyMissing = compliance.any((c) => !c.isOk);

      if (anyMissing) {
        // Hole aktive Docs für Anzeige/Links
        final privacy = await repo.fetchActiveDoc('privacy_policy');

        // final terms = await repo.fetchActiveDoc('terms');

        setState(() {
          _privacyDoc = privacy;
          // _termsDoc = terms;
          _needsConsent = true;
          _loading = false;
        });
      } else {
        setState(() {
          _needsConsent = false;
          _loading = false;
        });
      }
    } catch (_) {
      setState(() {
        _needsConsent = true;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
          backgroundColor: AppColors.secondaryColor,
          body: Center(child: CircularProgressIndicator()));
    }

    if (_needsConsent) {
      return ConsentScreen(
        privacyDoc: _privacyDoc,
        // termsDoc: _termsDoc,
        onAccepted: () async {
          await _run();
        },
      );
    }

    return widget.child;
  }
}
