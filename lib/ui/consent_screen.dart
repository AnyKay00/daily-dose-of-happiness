import 'package:daily_dose_of_happiness/model/legal_doc_model.dart';
import 'package:daily_dose_of_happiness/repository/config_repository.dart';
import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConsentScreen extends StatefulWidget {
  final LegalDoc? privacyDoc;
  final VoidCallback onAccepted;

  const ConsentScreen(
      {super.key, required this.privacyDoc, required this.onAccepted});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool _checked = false;
  bool _saving = false;
  String? _error;

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not open url');
    }
  }

  Future<void> _accept() async {
    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final doc = widget.privacyDoc;
      if (doc == null) throw Exception('Missing active privacy policy');

      final locale = Localizations.localeOf(context).toLanguageTag();

      final repo = ConsentRepository(Supabase.instance.client);
      await repo.acceptDoc(
          docType: 'privacy_policy', version: doc.version, locale: locale);

      // optional: terms
      // await repo.acceptDoc(docType: 'terms', version: widget.termsDoc!.version, locale: locale);

      widget.onAccepted();
    } catch (e) {
      setState(() {
        print(e);
        _error =
            'Zustimmung konnte nicht gespeichert werden. Bitte erneut versuchen.';
      });
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final doc = widget.privacyDoc;

    return PopScope(
      canPop: false, // Back-Button deaktivieren
      child: Scaffold(
        backgroundColor: AppColors.secondaryColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  const Text(
                    'Datenschutz',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Bevor du startest: Bitte nimm dir kurz Zeit für die Datenschutzerklärung. '
                    'Du kannst sie jederzeit in den Einstellungen erneut aufrufen.',
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Kurzüberblick',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text(
                            '• Wir verarbeiten Daten, um Kernfunktionen der App bereitzustellen.'),
                        Text(
                            '• Du behältst Kontrolle über deine Inhalte und Einstellungen.'),
                        Text(
                            '• Details findest du in der vollständigen Erklärung.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (doc != null)
                    TextButton(
                      onPressed: () => _openUrl(doc.url),
                      child: Text(
                          'Datenschutzerklärung öffnen (Version ${doc.version})'),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Checkbox(
                        value: _checked,
                        onChanged: _saving
                            ? null
                            : (v) => setState(() => _checked = v ?? false),
                      ),
                      const Expanded(
                        child: Text(
                            'Ich habe die Datenschutzerklärung gelesen und stimme zu.'),
                      ),
                    ],
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  ],
                  const Spacer(),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: (_checked && !_saving) ? _accept : null,
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(AppColors.primaryColor)),
                      child: _saving
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : Text(
                              'Zustimmen & fortfahren',
                              style: AppTextStyle.getdynamicTextStyle(
                                  AppColors.textColor, 18),
                            ),
                    ),
                  ),
                  const SizedBox(height: 26),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
