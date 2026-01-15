import 'package:daily_dose_of_happiness/bloc/wish_bloc/wish_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/wish_bloc/wish_event.dart';
import 'package:daily_dose_of_happiness/model/wish/wish_model.dart';
import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:daily_dose_of_happiness/widgets/status_pill_widget.dart';
import 'package:daily_dose_of_happiness/widgets/wish_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishHeaderCard extends StatelessWidget {
  final WishModel wish;
  const WishHeaderCard({super.key, required this.wish});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VoteRailWidget(
              score: wish.score,
              upActive: (wish.myVote ?? 0) == 1,
              downActive: (wish.myVote ?? 0) == -1,
              onUpvote: () {
                // Reddit-like: tap toggles
                final current = wish.myVote ?? 0;
                if (current == 1) {
                  context
                      .read<WishBloc>()
                      .add(WishVoteCleared(wishId: wish.id));
                } else {
                  context
                      .read<WishBloc>()
                      .add(WishVoteRequested(wishId: wish.id, value: 1));
                }
              },
              onDownvote: () {
                final current = wish.myVote ?? 0;
                if (current == -1) {
                  context
                      .read<WishBloc>()
                      .add(WishVoteCleared(wishId: wish.id));
                } else {
                  context
                      .read<WishBloc>()
                      .add(WishVoteRequested(wishId: wish.id, value: -1));
                }
              },
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
