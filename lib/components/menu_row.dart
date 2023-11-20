import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/dialogs/search_song.dart';
import 'package:mladez_zpevnik/dialogs/settings.dart';
import '../dialogs/number_select.dart';

class ButtonContainer extends StatelessWidget {
  const ButtonContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // color: Colors.white,
        ),
        child: Center(child: child),
      );
}

class MenuRow extends StatelessWidget {
  const MenuRow({super.key});

  @override
  Widget build(BuildContext context) => Container(
        // color: Colors.black54,
        padding: const EdgeInsets.symmetric(vertical: 20)
            .copyWith(bottom: max(20, MediaQuery.of(context).padding.bottom)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ButtonContainer(
              child: IconButton(
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                onPressed: () => Get.toNamed('/favourite'),
              ),
            ),
            ButtonContainer(
              child: IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  onPressed: () => Get.bottomSheet(const SearchSong())),
            ),
            ButtonContainer(
                child: IconButton(
                    icon: const Icon(
                      Icons.keyboard,
                      color: Colors.black,
                    ),
                    onPressed: () => Get.bottomSheet(NumberSelect()))),
            ButtonContainer(
              child: IconButton(
                icon: const Icon(
                  Icons.history,
                  color: Colors.black,
                ),
                onPressed: () => Get.toNamed('/history'),
              ),
            ),
            ButtonContainer(
              child: IconButton(
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                  onPressed: () => Get.bottomSheet(const Settings())),
            )
          ],
        ),
      );
}
