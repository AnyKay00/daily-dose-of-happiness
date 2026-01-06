import 'package:daily_dose_of_happiness/model/wish/wish_model.dart';
import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:daily_dose_of_happiness/ui/widgets/status_pill_widget.dart';
import 'package:flutter/material.dart';

class WishFeedCardWidget extends StatelessWidget {
  final WishModel wish;
  final VoidCallback onTap;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;

  const WishFeedCardWidget({super.key, 
    required this.wish,
    required this.onTap,
    required this.onUpvote,
    required this.onDownvote,
  });

  @override
  Widget build(BuildContext context) {
    final myVote = wish.myVote ?? 0;
    final upActive = myVote == 1;
    final downActive = myVote == -1;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reddit-like vote rail
              VoteRailWidget(
                score: wish.score,
                upActive: upActive,
                downActive: downActive,
                onUpvote: onUpvote,
                onDownvote: onDownvote,
              ),
              const SizedBox(width: 10),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // meta line
                    Row(
                      children: [
                        if (wish.isMine)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              'Deins',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        StatusPillWidget(status: wish.status),
                        const Spacer(),
                        Text(
                          AppDesignHelper.formatDate(wish.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withAlpha(55),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      wish.body,
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // actions row (Reddit-like)
                    Row(
                      children: [
                        Icon(Icons.mode_comment_outlined,
                            size: 18, color: Colors.black.withAlpha(60)),
                        const SizedBox(width: 6),
                        Text(
                          'Kommentare',
                          style: TextStyle(
                              fontSize: 13, color: Colors.black.withAlpha(60)),
                        ),
                        const Spacer(),
                        Icon(Icons.chevron_right,
                            color: Colors.black.withAlpha(60)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VoteRailWidget extends StatelessWidget {
  final int score;
  final bool upActive;
  final bool downActive;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;

  const VoteRailWidget({
    super.key,
    required this.score,
    required this.upActive,
    required this.downActive,
    required this.onUpvote,
    required this.onDownvote,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      child: Column(
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onUpvote,
            icon: Icon(
              upActive ? Icons.arrow_upward : Icons.arrow_upward_outlined,
              color: upActive ? Colors.orange : Colors.black.withAlpha(120),
            ),
          ),
          Text(
            score.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: upActive
                  ? Colors.orange
                  : downActive
                      ? Colors.blueGrey
                      : Colors.black.withAlpha(100),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onDownvote,
            icon: Icon(
              downActive ? Icons.arrow_downward : Icons.arrow_downward_outlined,
              color: downActive ? Colors.blueGrey : Colors.black.withAlpha(120),
            ),
          ),
        ],
      ),
    );
  }
}
