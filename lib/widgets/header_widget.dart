import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  dynamic scaffoldKey;
  HeaderWidget({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Stack(
      //  mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          constraints: const BoxConstraints(),
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => scaffoldKey.currentState!.openDrawer(),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text('DAILY DOSE OF HAPPINESS',
                style: AppTextStyle.getHeaderTextStyle(
                    Colors.white.withOpacity(0.6))),
          ),
        ),
      ],
    );
  }
}
