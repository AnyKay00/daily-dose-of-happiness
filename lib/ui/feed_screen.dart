import 'package:daily_dose_of_happiness/bloc/happiness_pack_bloc/happiness_pack_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/happiness_pack_bloc/happiness_pack_state.dart';
import 'package:daily_dose_of_happiness/bloc/memory_book_bloc/memory_book_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/memory_book_bloc/memory_book_event.dart';
import 'package:daily_dose_of_happiness/bloc/wish_list_bloc/wish_list_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/wish_list_bloc/wish_list_event.dart';
import 'package:daily_dose_of_happiness/model/dailys/happiness_package_model.dart';
import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:daily_dose_of_happiness/ui/memory_book.dart';
import 'package:daily_dose_of_happiness/ui/wishes_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool _showIntro = true;
  double _introOpacity = 1.0;
  int _pageIndex = 0;
  double width = 0;
  late HappinessPackModel hPack;
  @override
  void didChangeDependencies() {
    width = MediaQuery.sizeOf(context).width;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    // Kurze Zeit anzeigen, dann ausblenden
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        _introOpacity = 0.0;
      });

      // Nach dem Fade-Out komplett entfernen
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        setState(() {
          _showIntro = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: BlocBuilder<HappinessPackBloc, HappinessPackState>(
          builder: (context, state) {
        if (state is LoadedHappinessPackState) {
          hPack = state.pack;
          return _getBody();
        } else if (state is LoadingHappinessPackState) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return SizedBox();
        }
      }),
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
          onPageChanged: (index) => setState(() => _pageIndex = index),
          scrollDirection: Axis.vertical,
          itemCount: 3, //dynamic?
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 10),
              child: _getDailys(index),
            );
          },
        ),
        Align(alignment: Alignment.topRight, child: _getHeader()),

        _DotsIndicator(
            expanded: width > 800 ? true : false, count: 3, index: _pageIndex),
        // Intro-Overlay mit Pina + Sprechblase
        if (_showIntro)
          Positioned(
            top: height / 3.5,
            right: 0,
            left: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _introOpacity,
              child: _buildIntroOverlay(),
            ),
          ),
      ]),
    );
  }

  /// Overlay mit pina_happy und Sprechblase
  Widget _buildIntroOverlay() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bild von Pina
          Image.asset(
            'assets/feelings/pina_happy.png',
            height: 120,
            fit: BoxFit.cover,
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(end: 8, duration: 1.seconds)
              .rotate(end: 0.02, begin: -0.02),
          const SizedBox(width: 16),
          // Sprechblase
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: AppGradients.pinaGradient,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                "Ich habe dir dein heutiges Happiness-Paket zusammengestellt",
                style: AppTextStyle.getdynamicTextStyle(
                  Colors.black87,
                  18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getMotivationContainer() {
    if (hPack.motivation != null) {
      bool isLiked = false;
      bool isSaved = false;
      return StatefulBuilder(builder: (context, setter) {
        return Stack(
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    hPack.motivation!.text,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.getdynamicTextStyle(Colors.black87, 26),
                  ),
                  if (hPack.motivation!.authorName.isNotEmpty ||
                      hPack.motivation!.authorName != 'null')
                    Text('- ${hPack.motivation!.authorName}',
                        style: AppTextStyle.getdynamicTextStyle(
                            Colors.black45, 20)),
                ],
              ),
            ),
            _getBottomText('Daily Motivation #${hPack.motivation!.shortId}'),
            /*  _getButtons(isLiked, isSaved, hPack.motivation!.id, () {
              setter(() {
                isLiked = !isLiked;
              });
              BlocProvider.of<MotivationBloc>(context).add(LikeMotivationEvent(
                id: hPack.motivation!.id,
              ));
            }, () {
              setter(() {
                isSaved = !isSaved;
              });
              BlocProvider.of<MotivationBloc>(context)
                  .add(SaveMotivationToMemoryBookEvent(
                id: hPack.motivation!.id,
              ));
            }) */
          ],
        );
      });
    } else {
      //TODO Error
      return SizedBox();
    }
  }

  Widget _getBottomText(String text) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom + 20),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(text,
            style: AppTextStyle.getdynamicTextStyle(Colors.black87, 16)),
      ),
    );
  }

  Widget _getJokeContainer() {
    if (hPack.joke != null) {
      bool isLiked = hPack.joke!.liked;
      bool isSaved = hPack.joke!.saved;
      return StatefulBuilder(builder: (context, setter) {
        return Stack(
          children: [
            Center(
              child: Text(
                hPack.joke!.jokeText,
                textAlign: TextAlign.center,
                style: AppTextStyle.getdynamicTextStyle(Colors.black87, 26),
              ),
            ),
            _getBottomText('Daily Joke #${hPack.joke!.shortId}'),
            /*  _getButtons(isLiked, isSaved, hPack.joke!.id, () {
              setter(() {
                isLiked = !isLiked;
              });
              BlocProvider.of<JokeBloc>(context).add(LikeJokeEvent(
                id: hPack.joke!.id,
              ));
            }, () {
              setter(() {
                isSaved = !isSaved;
              });
              BlocProvider.of<JokeBloc>(context).add(SaveJokeToMemoryBookEvent(
                id: hPack.joke!.id,
              ));
            }) */
          ],
        );
      });
    } else {
      //TODO Error
      return SizedBox();
    }
  }

  Widget _getActionContainer() {
    if (hPack.action != null) {
      bool isLiked = hPack.action!.liked;
      bool isSaved = hPack.action!.saved;
      return StatefulBuilder(builder: (context, setter) {
        return Stack(
          children: [
            Center(
              child: Text(
                hPack.action!.actionText,
                textAlign: TextAlign.center,
                style: AppTextStyle.getdynamicTextStyle(Colors.black87, 26),
              ),
            ),
            _getBottomText('Daily Affirmation #${hPack.action!.shortId}'),
            /* _getButtons(isLiked, isSaved, hPack.action!.id, () {
              setter(() {
                isLiked = !isLiked;
              });
              BlocProvider.of<ActionBloc>(context).add(LikeActionEvent(
                id: hPack.action!.id,
              ));
            }, () {
              setter(() {
                isSaved = !isSaved;
              });
              BlocProvider.of<ActionBloc>(context)
                  .add(SaveActionToMemoryBookEvent(
                id: hPack.action!.id,
              ));
            }) */
          ],
        );
      });
    } else {
      //TODO error
      return SizedBox();
    }
  }

  /*  Widget _getButtons(bool isLiked, bool isSaved, String id, Function onTapLike,
      Function onTapSave) {
    return Positioned(
      key: UniqueKey(),
      right: 0,
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
  } */

  /* Widget _buildActionButton({
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
  } */

  Widget _getHeader() {
    return Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).viewPadding.top + 20, right: 10),
        child:
            //round button for memory book
            Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildWishboxButton(),
            SizedBox(width: 15),
            _buildMemoryBookButton(),
          ],
        ));
  }

  Widget _buildMemoryBookButton() {
    return GestureDetector(
      onTap: () {
        //trigger bloc
        BlocProvider.of<MemoryBookBloc>(context)
            .add(LoadLast7DaysFeelingsEvent());

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

  Widget _buildWishboxButton() {
    return GestureDetector(
      onTap: () {
        //trigger bloc
        BlocProvider.of<WishListBloc>(context).add(LoadWishesEvent());

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const WishOverviewScreen()));
      },
      child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(70),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(15),
          child: Icon(Icons.feed, color: Colors.white)),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  final int count;
  final int index;
  final bool expanded;

  const _DotsIndicator({
    required this.count,
    required this.index,
    required this.expanded,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(vertical: 5),
          height: expanded && isActive
              ? 28
              : !expanded && isActive
                  ? 10
                  : 18,
          width: expanded ? 18 : 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99),
            border: Border.all(width: 0.5, color: Colors.white),
            color: isActive ? AppColors.secondaryColor : Colors.white,
          ),
        );
      }),
    );
  }
}
