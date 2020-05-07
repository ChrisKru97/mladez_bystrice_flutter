import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../bloc/bloc_provider.dart';
import '../bloc/config_bloc.dart';
import '../classes/config.dart';

class FontSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ConfigBloc provider = BlocProvider.of<ConfigBloc>(context);
    return StreamBuilder<Config>(
        stream: provider.stream,
        builder: (_, AsyncSnapshot<Config> snapshot) {
          if (snapshot.data == null) {
            provider.refresh();
            return Center(child: CircularProgressIndicator());
          }
          return Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
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
                        const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Akordy',
                              style: TextStyle(fontSize: 22),
                            )),
                        Switch(
                          value: snapshot.data.showChords,
//                          activeTrackColor:
//                              Theme.of(context).primaryColor.withOpacity(0.6),
//                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (bool value) {
                            provider.updateConfig('showChords', value);
                          },
                        ),
                      ],
                    ),
                    ToggleSwitch(
                      icons: <IconData>[
                        Icons.format_align_left,
                        Icons.format_align_center
                      ],
                      initialLabelIndex: snapshot.data.alignCenter ? 1 : 0,
                      activeTextColor: Colors.white,
                      labels: const <String>['', ''],
                      inactiveBgColor: Colors.black26,
                      activeBgColor: Theme.of(context).secondaryHeaderColor,
                      inactiveTextColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                      onToggle: (int selected) {
                        provider.updateConfig('alignCenter', 1 == selected);
                      },
                    )
                  ],
                ),
                Slider(
                  min: 12,
                  max: 60,
                  onChanged: (double value) {
                    provider.updateConfig('songFontSize', value);
                  },
                  value: snapshot.data.songFontSize,
                ),
              ],
            ),
          );
        });
  }
}
