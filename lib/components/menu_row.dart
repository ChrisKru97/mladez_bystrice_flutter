import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';
import 'package:mladez_zpevnik/components/search_info.dart';
import 'package:mladez_zpevnik/dialogs/number_select.dart';
import 'package:mladez_zpevnik/dialogs/search_song.dart';
import 'package:mladez_zpevnik/services/analytics_service.dart';

class ButtonContainer extends StatelessWidget {
  const ButtonContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    height: 40,
    width: 40,
    decoration: BoxDecoration(
      color: Get.isDarkMode ? Colors.grey[400] : Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Center(child: child),
  );
}

final buttonList = [
  {
    'icon': Icons.favorite_border,
    'onPressed': () {
      Get.find<AnalyticsService>().logScreenView('favorites');
      Get.toNamed('/favorite');
    },
  },
  {
    'icon': Icons.search,
    'onPressed': () {
      final songsController = Get.find<SongsController>();
      songsController.searchString.value = '';
      Get.find<AnalyticsService>().logEvent(name: 'open_search');
      Get.bottomSheet(const SearchSong());
    },
  },
  {
    'icon': Icons.keyboard_outlined,
    'onPressed': () {
      Get.find<AnalyticsService>().logEvent(name: 'open_number_select');
      Get.bottomSheet(NumberSelect());
    },
  },
  {
    'icon': Icons.history,
    'onPressed': () {
      Get.find<AnalyticsService>().logScreenView('history');
      Get.toNamed('/history');
    },
  },
  {
    'icon': Icons.queue_music,
    'onPressed': () {
      Get.find<AnalyticsService>().logScreenView('playlists');
      Get.toNamed('/playlists');
    },
  },
];

class MenuRow extends StatelessWidget {
  const MenuRow({super.key});

  @override
  Widget build(BuildContext context) => Container(
    color: Get.theme.primaryColor.withAlpha(100),
    padding: const EdgeInsets.symmetric(
      vertical: 20,
    ).copyWith(bottom: max(20, MediaQuery.of(context).padding.bottom)),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SearchInfo(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              buttonList
                  .map(
                    (button) => ButtonContainer(
                      child: IconButton(
                        icon: Icon(button['icon'] as IconData),
                        color: const Color(0xB2000000),
                        onPressed: button['onPressed'] as void Function()?,
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    ),
  );
}
