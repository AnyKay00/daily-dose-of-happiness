import 'package:daily_dose_of_happiness/bloc/wish_bloc/wish_bloc.dart'
    show WishBloc;
import 'package:daily_dose_of_happiness/bloc/wish_bloc/wish_event.dart';
import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ------------------------------------------------------------
/// Create Wish Bottom Sheet
/// ------------------------------------------------------------
class CreateWishBottomSheet extends StatefulWidget {
  const CreateWishBottomSheet({super.key});

  @override
  State<CreateWishBottomSheet> createState() => _CreateWishBottomSheetState();
}

class _CreateWishBottomSheetState extends State<CreateWishBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    final text = _controller.text.trim();
    if (text.isEmpty || _submitting) return;

    setState(() => _submitting = true);
    try {
      context.read<WishBloc>().add(WishCreateRequested(text));
      // Close sheet quickly for reddit-like flow; list reload is handled by listener
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      // Repository/BLoC already handles errors; keep sheet behavior simple
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            boxShadow: [
              BoxShadow(
                blurRadius: 24,
                spreadRadius: 0,
                offset: const Offset(0, -6),
                color: Colors.black.withAlpha(30),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(30),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Du hast einen Wunsch an die App?',
                        style: AppTextStyle.getdynamicTextStyle(
                                Colors.black.withAlpha(180), 18)
                            .copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      splashRadius: 20,
                    ),
                  ],
                ),

                const SizedBox(height: 6),
                Text(
                  'Beschreibe kurz und klar was du dir wünschst, damit wir deine Idee bestmöglich umsetzen können.',
                  style: AppTextStyle.getdynamicTextStyle(
                      Colors.black.withAlpha(180), 16),
                ),
                const SizedBox(height: 30),

                TextField(
                  controller: _controller,
                  minLines: 4,
                  maxLines: 10,
                  autofocus: true,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText:
                        'z.B. „Ich wünsche mir eine Erinnerungsfunktion …“',
                    filled: true,
                    fillColor: AppColors.backgroundColor,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.black.withAlpha(30)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.black.withAlpha(30)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.black.withAlpha(30)),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _submitting ? null : () => _submit(context),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _submitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            'Posten',
                            style: AppTextStyle.getdynamicTextStyle(
                                Colors.black.withAlpha(180), 18),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
