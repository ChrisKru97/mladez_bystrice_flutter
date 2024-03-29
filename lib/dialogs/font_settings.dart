import 'dart:math';

import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../bloc/bloc_provider.dart';
import '../bloc/config_bloc.dart';
import '../classes/config.dart';

class FontSettings extends StatelessWidget {
  const FontSettings({required this.bottom});
  final double bottom;

  @override
  Widget build(BuildContext context) {
    final ConfigBloc provider = BlocProvider.of<ConfigBloc>(context);
    return StreamBuilder<Config>(
        stream: provider.stream,
        builder: (_, AsyncSnapshot<Config> snapshot) {
          if (snapshot.data == null) {
            provider.refresh();
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          return Container(
            margin: const EdgeInsets.all(20).copyWith(bottom: max(20, bottom)),
            decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[700]
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                      color: Colors.black54,
                      offset: Offset(0, 0),
                      blurRadius: 10,
                      spreadRadius: 1)
                ]),
            height: 160,
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'Akordy',
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black),
                            )),
                        Switch.adaptive(
                          value: snapshot.data!.showChords,
                          onChanged: (bool value) {
                            provider.updateConfig('showChords', value);
                          },
                        ),
                      ],
                    ),
                    ToggleSwitch(
                      icons: const <IconData>[
                        Icons.format_align_left,
                        Icons.format_align_center
                      ],
                      initialLabelIndex: snapshot.data!.alignCenter ? 1 : 0,
                      activeFgColor: Colors.white,
                      labels: const <String>['', ''],
                      inactiveBgColor: Colors.black26,
                      activeBgColor: [Theme.of(context).secondaryHeaderColor],
                      inactiveFgColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                      onToggle: (int? selected) {
                        provider.updateConfig('alignCenter', 1 == selected);
                      },
                    )
                  ],
                ),
                Slider.adaptive(
                  min: MediaQuery.of(context).size.width * 0.02 >
                          snapshot.data!.songFontSize
                      ? snapshot.data!.songFontSize
                      : MediaQuery.of(context).size.width * 0.02,
                  max: MediaQuery.of(context).size.width * 0.1 <
                          snapshot.data!.songFontSize
                      ? snapshot.data!.songFontSize
                      : MediaQuery.of(context).size.width * 0.1,
                  onChanged: (double value) {
                    provider.updateConfig('songFontSize', value);
                  },
                  value: snapshot.data!.songFontSize,
                ),
              ],
            ),
          );
        });
  }
}
