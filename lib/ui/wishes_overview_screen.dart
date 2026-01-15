import 'package:daily_dose_of_happiness/bloc/wish_bloc/wish_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/wish_bloc/wish_event.dart';
import 'package:daily_dose_of_happiness/bloc/wish_bloc/wish_state.dart';
import 'package:daily_dose_of_happiness/bloc/wish_list_bloc/wish_list_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/wish_list_bloc/wish_list_event.dart';
import 'package:daily_dose_of_happiness/bloc/wish_list_bloc/wish_list_state.dart';
import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:daily_dose_of_happiness/widgets/error_empty_state_widget.dart';
import 'package:daily_dose_of_happiness/widgets/wish_bottomsheet_widget.dart';
import 'package:daily_dose_of_happiness/widgets/wish_card_widget.dart';
import 'package:daily_dose_of_happiness/ui/wish_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ------------------------------------------------------------
/// WISH LIST (Reddit-like feed)
/// ------------------------------------------------------------
class WishOverviewScreen extends StatefulWidget {
  const WishOverviewScreen({super.key});

  @override
  State<WishOverviewScreen> createState() => _WishOverviewScreenState();
}

class _WishOverviewScreenState extends State<WishOverviewScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WishListBloc>().add(LoadWishesEvent());
  }

  Future<void> _openCreateWishSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CreateWishBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Ideenbox',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCreateWishSheet(context),
        backgroundColor: AppColors.primaryColor,
        elevation: 5,
        child: const Icon(Icons.add),
      ),
      body: MultiBlocListener(
        listeners: [
          // On any successful action (vote/comment/wish create/update) reload list for correct sorting
          BlocListener<WishBloc, WishState>(
            listenWhen: (prev, next) => next is WishActionSuccess,
            listener: (context, state) {
              context.read<WishListBloc>().add(LoadWishesEvent());
            },
          ),
        ],
        child: BlocBuilder<WishListBloc, WishListState>(
          builder: (context, state) {
            if (state is WishListLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is WishListError) {
              return ErrorState(
                message: state.message,
                onRetry: () =>
                    context.read<WishListBloc>().add(LoadWishesEvent()),
              );
            }
            if (state is EmptyWishList) {
              return const EmptyState(
                title: 'Noch keine Ideen',
                subtitle:
                    'Sei die erste Person, die einen Wunsch oder Feedback teilt.',
              );
            }

            if (state is WishListLoaded) {
              if (state.wishes.isEmpty) {
                return const EmptyState(
                  title: 'Noch keine Ideen',
                  subtitle:
                      'Sei die erste Person, die einen Wunsch oder Feedback teilt.',
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<WishListBloc>().add(LoadWishesEvent());
                },
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  itemBuilder: (context, index) {
                    final wish = state.wishes[index];
                    return WishFeedCardWidget(
                      wish: wish,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => WishDetailScreen(wish: wish),
                          ),
                        );
                      },
                      onUpvote: () {
                        // Reddit-like: tap toggles
                        final current = wish.myVote ?? 0;
                        if (current == 1) {
                          context
                              .read<WishBloc>()
                              .add(WishVoteCleared(wishId: wish.id));
                        } else {
                          context.read<WishBloc>().add(
                              WishVoteRequested(wishId: wish.id, value: 1));
                        }
                      },
                      onDownvote: () {
                        final current = wish.myVote ?? 0;
                        if (current == -1) {
                          context
                              .read<WishBloc>()
                              .add(WishVoteCleared(wishId: wish.id));
                        } else {
                          context.read<WishBloc>().add(
                              WishVoteRequested(wishId: wish.id, value: -1));
                        }
                      },
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemCount: state.wishes.length,
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
      // Optional: Reddit-like "create post" entrypoint (not requested to implement, so left out)
    );
  }
}
