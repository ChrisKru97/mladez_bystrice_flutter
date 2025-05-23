import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';

class SearchInfo extends StatelessWidget {
  const SearchInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final songsController = Get.find<SongsController>();
    return Obx(
      () =>
          songsController.searchString.value.isEmpty
              ? const Center()
              : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ).copyWith(bottom: 20),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(220),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                              text: 'Hledám: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: '"${songsController.searchString.value}"',
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          songsController.searchString.value = '';
                        },
                        child: const Text('Zrušit'),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
