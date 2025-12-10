import 'package:daily_dose_of_happiness/bloc/action_bloc/action_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/action_bloc/action_state.dart';
import 'package:daily_dose_of_happiness/bloc/joke_bloc/joke_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/joke_bloc/joke_state.dart';
import 'package:daily_dose_of_happiness/bloc/motivation_bloc/motivation_state.dart';
import 'package:daily_dose_of_happiness/bloc/motivation_bloc/movtivation_bloc.dart';
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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        drawer: AppDrawer(),
        backgroundColor: AppColors.backgroundColor,
        body: _getBody(),
      ),
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
    var height = MediaQuery.of(context).size.height -
        MediaQuery.paddingOf(context).bottom -
        MediaQuery.paddingOf(context).top;
    return Container(
      decoration: BoxDecoration(gradient: AppGradients.backgroundGradient),
      height: height,
      child: Stack(children: [
        Align(alignment: Alignment.topRight, child: _getHeader()),
        PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: 3, //dynamic?
          itemBuilder: (context, index) {
            return _getDailys(index);
          },
        )
      ]),
    );
  }

  Widget _getMotivationContainer() {
    return BlocBuilder<MotivationBloc, MotivationState>(
        builder: (context, state) {
      if (state is LoadedMotivationState) {
        bool isLiked = state.motivation.liked ?? false;
        return Stack(
          children: [
            Center(
              child: Column(
                children: [
                  Text(state.motivation.text),
                  Text(state.motivation.authorName),
                ],
              ),
            ),
            Positioned(
              right: 16,
              bottom: 100, // Positioned slightly above the bottom edge
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // LIKE BUTTON
                  _buildActionButton(
                      id: state.motivation.id,
                      icon: isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.white,
                      label: "like",
                      onTap: () {}),

                  const SizedBox(height: 25),

                  // SHARE BUTTON
                  _buildActionButton(
                    id: state.motivation.id,
                    icon: Icons.share,
                    color: Colors.white,
                    label: "Share",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        );
      }
      //Todo
      return Container();
    });
  }

  Widget _getJokeContainer() {
    return BlocBuilder<JokeBloc, JokeState>(builder: (context, state) {
      if (state is LoadedJokeState) {
        bool isLiked = state.joke.liked ?? false;
        return Stack(
          children: [
            Center(
              child: Text(state.joke.joke),
            ),
            Positioned(
              right: 16,
              bottom: 100, // Positioned slightly above the bottom edge
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // LIKE BUTTON
                  _buildActionButton(
                      id: state.joke.id,
                      icon: isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.white,
                      label: "like",
                      onTap: () {}),

                  const SizedBox(height: 25),

                  // SHARE BUTTON
                  _buildActionButton(
                    id: state.joke.id,
                    icon: Icons.share,
                    color: Colors.white,
                    label: "Share",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        );
      }
      //Todo
      return Container();
    });
  }

  Widget _getActionContainer() {
    return BlocBuilder<ActionBloc, ActionState>(builder: (context, state) {
      if (state is LoadedActionState) {
        bool isLiked = state.action.liked ?? false;
        return Stack(
          children: [
            Center(
              child: Text(state.action.actionText),
            ),
            Positioned(
              right: 16,
              bottom: 100, // Positioned slightly above the bottom edge
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // LIKE BUTTON
                  _buildActionButton(
                      id: state.action.id,
                      icon: isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.white,
                      label: "like",
                      onTap: () {}),

                  const SizedBox(height: 25),

                  // SHARE BUTTON
                  _buildActionButton(
                    id: state.action.id,
                    icon: Icons.share,
                    color: Colors.white,
                    label: "Share",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        );
      }
      //Todo
      return Container();
    });
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
              color:
                  Colors.black.withOpacity(0.4), // Semi-transparent background
            ),
            child: Icon(icon, size: 35, color: color),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

  Widget _getHeader() {
    return Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).viewPadding.top + 20, right: 20),
        child:
            //round button for memory book
            _buildMemoryBookButton());
  }

  Widget _buildMemoryBookButton() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.secondaryColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.menu_book_rounded, color: Colors.white),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MemoryBookScreen()));
        },
      ),
    );
  }
}
