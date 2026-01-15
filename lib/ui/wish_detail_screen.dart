import 'package:daily_dose_of_happiness/bloc/wish_bloc/wish_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/wish_bloc/wish_event.dart';
import 'package:daily_dose_of_happiness/bloc/wish_bloc/wish_state.dart';
import 'package:daily_dose_of_happiness/model/wish/wish_model.dart';
import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:daily_dose_of_happiness/widgets/error_empty_state_widget.dart';
import 'package:daily_dose_of_happiness/widgets/wish_comment_widget.dart';
import 'package:daily_dose_of_happiness/widgets/wish_header_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ------------------------------------------------------------
/// WISH DETAIL (comments page)
/// ------------------------------------------------------------
class WishDetailScreen extends StatefulWidget {
  final WishModel wish;

  const WishDetailScreen({
    super.key,
    required this.wish,
  });

  @override
  State<WishDetailScreen> createState() => _WishDetailScreenState();
}

class _WishDetailScreenState extends State<WishDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    context.read<WishBloc>().add(WishCommentsLoadRequested(widget.wish.id));
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _sendComment(BuildContext context) async {
    final text = _commentController.text.trim();
    if (text.isEmpty || _sending) return;

    setState(() => _sending = true);
    try {
      context
          .read<WishBloc>()
          .add(WishCommentAddRequested(wishId: widget.wish.id, body: text));
      _commentController.clear();

      // Reload comments after action success is emitted.
      // We also optimistically reload here to keep UX snappy.
      await Future.delayed(const Duration(milliseconds: 250));
      context.read<WishBloc>().add(WishCommentsLoadRequested(widget.wish.id));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        title: const Text(
          'Kommentare',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
            child: WishHeaderCard(wish: widget.wish),
          ),
          Expanded(
            child: BlocBuilder<WishBloc, WishState>(
              builder: (context, state) {
                if (state is WishActionInProgress) {
                  // Note: WishBloc is shared for multiple actions; if you prefer,
                  // keep separate states for comment loading.
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is WishActionError) {
                  return ErrorState(
                    message: state.message,
                    onRetry: () => context
                        .read<WishBloc>()
                        .add(WishCommentsLoadRequested(widget.wish.id)),
                  );
                }

                if (state is WishCommentsLoaded &&
                    state.wishId == widget.wish.id) {
                  if (state.comments.isEmpty) {
                    return const EmptyState(
                      title: 'Noch keine Kommentare',
                      subtitle: 'Starte die Diskussion.',
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    itemBuilder: (context, i) {
                      final c = state.comments[i];
                      return CommentCard(comment: c);
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemCount: state.comments.length,
                  );
                }

                // Initial / unrelated state
                return const SizedBox.shrink();
              },
            ),
          ),
          CommentComposer(
            controller: _commentController,
            sending: _sending,
            onSend: () => _sendComment(context),
          ),
        ],
      ),
    );
  }
}
