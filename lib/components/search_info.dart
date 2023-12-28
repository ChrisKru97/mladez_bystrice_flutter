import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/bloc/songs_controller.dart';

class SearchInfo extends StatelessWidget {
  const SearchInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final songsController = Get.find<SongsController>();
    return Obx(
      () => songsController.searchString.value.isEmpty
          ? const Center()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16)
                  .copyWith(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(TextSpan(
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'Hledám: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                          text: '"${songsController.searchString.value}"',
                          style: const TextStyle(fontStyle: FontStyle.italic)),
                    ],
                  )),
                  TextButton(
                      onPressed: () {
                        songsController.searchString.value = '';
                      },
                      child: const Text('Zrušit'))
                ],
              ),
            ),
    );
  }
}
