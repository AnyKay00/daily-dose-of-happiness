import 'package:daily_dose_of_happiness/model/wish/wish_comment_model.dart';
import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  final WishCommentModel comment;
  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (comment.isMine)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Dein Kommentar',
                      style: AppTextStyle.getdynamicTextStyle(Colors.black, 14),
                    ),
                  ),
                const Spacer(),
                Text(
                  AppDesignHelper.formatDate(comment.createdAt),
                  style: AppTextStyle.getdynamicTextStyle(
                      Colors.black.withAlpha(55), 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              comment.body,
              style: AppTextStyle.getdynamicTextStyle(Colors.black, 14),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentComposer extends StatelessWidget {
  final TextEditingController controller;
  final bool sending;
  final VoidCallback onSend;

  const CommentComposer({
    super.key,
    required this.controller,
    required this.sending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          border: Border(
            top: BorderSide(color: Colors.black.withAlpha(50)),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: 'Kommentar schreiben…',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 48,
              width: 48,
              child: ElevatedButton(
                onPressed: sending ? null : onSend,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  padding: EdgeInsets.zero,
                ),
                child: sending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(
                        Icons.send,
                        size: 18,
                        color: Colors.black,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
