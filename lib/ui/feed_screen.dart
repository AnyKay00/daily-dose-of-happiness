import 'package:daily_dose_of_happiness/bloc/action_bloc/action_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/action_bloc/action_event.dart';
import 'package:daily_dose_of_happiness/bloc/action_bloc/action_state.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_list_bloc/feeling_list_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_list_bloc/feeling_list_event.dart';
import 'package:daily_dose_of_happiness/bloc/joke_bloc/joke_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/joke_bloc/joke_event.dart';
import 'package:daily_dose_of_happiness/bloc/joke_bloc/joke_state.dart';
import 'package:daily_dose_of_happiness/bloc/motivation_bloc/motivation_event.dart';
import 'package:daily_dose_of_happiness/bloc/motivation_bloc/motivation_state.dart';
import 'package:daily_dose_of_happiness/bloc/motivation_bloc/motivation_bloc.dart';
import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:daily_dose_of_happiness/ui/memory_book.dart';
import 'package:daily_dose_of_happiness/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: AppDrawer(),
      backgroundColor: AppColors.backgroundColor,
      body: _getBody(),
    );
  }

  Widget _getDailys(int index) {
    switch (index) {
      case 0:
        return _getMotivationContainer();
      case 1:
        return _getJokeContainer();
      case 2:
        return _getActionContainer();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _getBody() {
    var height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(gradient: AppGradients.backgroundGradient),
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Stack(children: [
        PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: 3, //dynamic?
          itemBuilder: (context, index) {
            return _getDailys(index);
          },
        ),
        Align(alignment: Alignment.topRight, child: _getHeader()),
      ]),
    );
  }

  Widget _getMotivationContainer() {
    return BlocBuilder<MotivationBloc, MotivationState>(
        builder: (context, state) {
      if (state is LoadedMotivationState) {
        bool isLiked = state.motivation.liked;
        bool isSaved = state.motivation.saved;
        return StatefulBuilder(builder: (context, setter) {
          return Stack(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.motivation.text,
                      textAlign: TextAlign.center,
                      style:
                          AppTextStyle.getdynamicTextStyle(Colors.black87, 26),
                    ),
                    if (state.motivation.authorName.isNotEmpty)
                      Text('- ' + state.motivation.authorName,
                          style: AppTextStyle.getdynamicTextStyle(
                              Colors.black45, 20)),
                  ],
                ),
              ),
              _getBottomText('Daily Motivation #' + state.motivation.id),
              _getButtons(isLiked, isSaved, state.motivation.id, () {
                setter(() {
                  isLiked = !isLiked;
                });
                BlocProvider.of<MotivationBloc>(context)
                    .add(LikeMotivationEvent(
                  id: state.motivation.id,
                ));
              }, () {
                setter(() {
                  isSaved = !isSaved;
                });
                BlocProvider.of<MotivationBloc>(context)
                    .add(SaveMotivationToMemoryBookEvent(
                  id: state.motivation.id,
                ));
              })
            ],
          );
        });
      } else if (state is LoadingMotivationState) {
        return const Center(child: CircularProgressIndicator());
      }
      //Todo
      return Container();
    });
  }

  Widget _getBottomText(String text) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom + 20),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(text,
            style: AppTextStyle.getdynamicTextStyle(Colors.black87, 20)),
      ),
    );
  }

  Widget _getJokeContainer() {
    return BlocBuilder<JokeBloc, JokeState>(builder: (context, state) {
      if (state is LoadedJokeState) {
        bool isLiked = state.joke.liked;
        bool isSaved = state.joke.saved;
        return StatefulBuilder(builder: (context, setter) {
          return Stack(
            children: [
              Center(
                child: Text(
                  state.joke.joke,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.getdynamicTextStyle(Colors.black87, 26),
                ),
              ),
              _getBottomText('Daily Joke #' + state.joke.id),
              _getButtons(isLiked, isSaved, state.joke.id, () {
                setter(() {
                  isLiked = !isLiked;
                });
                BlocProvider.of<JokeBloc>(context).add(LikeJokeEvent(
                  id: state.joke.id,
                ));
              }, () {
                setter(() {
                  isSaved = !isSaved;
                });
                BlocProvider.of<JokeBloc>(context)
                    .add(SaveJokeToMemoryBookEvent(
                  id: state.joke.id,
                ));
              })
            ],
          );
        });
      }
      //Todo
      return Container();
    });
  }

  Widget _getActionContainer() {
    return BlocBuilder<ActionBloc, ActionState>(builder: (context, state) {
      if (state is LoadedActionState) {
        bool isLiked = state.action.liked;
        bool isSaved = state.action.saved;
        return StatefulBuilder(builder: (context, setter) {
          return Stack(
            children: [
              Center(
                child: Text(
                  state.action.actionText,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.getdynamicTextStyle(Colors.black87, 26),
                ),
              ),
              _getBottomText('Daily Affirmation #' + state.action.id),
              _getButtons(isLiked, isSaved, state.action.id, () {
                setter(() {
                  isLiked = !isLiked;
                });
                BlocProvider.of<ActionBloc>(context).add(LikeActionEvent(
                  id: state.action.id,
                ));
              }, () {
                setter(() {
                  isSaved = !isSaved;
                });
                BlocProvider.of<ActionBloc>(context)
                    .add(SaveActionToMemoryBookEvent(
                  id: state.action.id,
                ));
              })
            ],
          );
        });
      }
      //Todo
      return Container();
    });
  }

  Widget _getButtons(bool isLiked, bool isSaved, String id, Function onTapLike,
      Function onTapSave) {
    return Positioned(
      key: UniqueKey(),
      right: 16,
      bottom: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // LIKE BUTTON
          _buildActionButton(
              id: id,
              icon: isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? AppColors.likeColor : Colors.white,
              label: "like",
              onTap: () => onTapLike()),

          const SizedBox(height: 25),

          // SHARE BUTTON
          _buildActionButton(
            id: id,
            icon: isSaved ? Icons.bookmark_added_sharp : Icons.bookmark_border,
            color: Colors.white,
            label: "Save",
            onTap: () {
              onTapSave();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String id,
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withAlpha(80), // Semi-transparent background
            ),
            child: Center(child: Icon(icon, size: 35, color: color)),
          ),
          /*  const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ) */
        ],
      ),
    );
  }

  Widget _getHeader() {
    return Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).viewPadding.top + 20, right: 10),
        child:
            //round button for memory book
            _buildMemoryBookButton());
  }

  Widget _buildMemoryBookButton() {
    return GestureDetector(
      onTap: () {
        //trigger bloc
        BlocProvider.of<FeelingListBloc>(context)
            .add(LoadLastWeekFeelingsEvent());

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MemoryBookScreen()));
      },
      child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(70),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(15),
          child: Icon(Icons.menu_book_rounded, color: Colors.white)),
    );
  }
}
