import 'package:daily_dose_of_happiness/model/legal_doc_model.dart';
import 'package:daily_dose_of_happiness/repository/config_repository.dart';
import 'package:daily_dose_of_happiness/ui/consent_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConsentGate extends StatefulWidget {
  final Widget child; // deine AppShell/Home
  final ConsentRepository repo;

  const ConsentGate({super.key, required this.child, required this.repo});

  @override
  State<ConsentGate> createState() => _ConsentGateState();
}

class _ConsentGateState extends State<ConsentGate> {
  bool _loading = true;
  bool _needsConsent = false;
  LegalDoc? _privacyDoc;
  LegalDoc? _termsDoc; // optional

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    try {
      // Voraussetzung: user ist eingeloggt (auch anon)
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        // In deinem Bootstrap: erst anon sign-in, dann Gate.
        setState(() {
          _loading = false;
          _needsConsent = true;
        });
        return;
      }

      final compliance = await widget.repo.checkCompliance();
      final anyMissing = compliance.any((c) => !c.isOk);

      if (anyMissing) {
        // Hole aktive Docs für Anzeige/Links
        final privacy = await widget.repo.fetchActiveDoc('privacy_policy');

        // optional:
        // final terms = await widget.repo.fetchActiveDoc('terms');

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
      // Marktüblich: Fail-safe = blocken, statt “durchlassen”
      setState(() {
        _needsConsent = true;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_needsConsent) {
      return ConsentScreen(
        privacyDoc: _privacyDoc,
        // termsDoc: _termsDoc,
        onAccepted: () async {
          await _run(); // nach accept neu prüfen und dann in child
        },
      );
    }

    return widget.child;
  }
}
