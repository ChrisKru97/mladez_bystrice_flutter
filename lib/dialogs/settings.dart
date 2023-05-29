import 'package:flutter/material.dart';

import '../bloc/bloc_provider.dart';
import '../bloc/config_bloc.dart';
import '../classes/config.dart';
import 'bottom_sheet.dart';

class Settings extends StatelessWidget {
  const Settings({required this.bottom});
  final double bottom;

  @override
  Widget build(BuildContext context) {
    final ConfigBloc provider = BlocProvider.of<ConfigBloc>(context);
    return CustomBottomSheet(
      bottom: bottom,
      child: StreamBuilder<Config>(
          stream: provider.stream,
          builder: (BuildContext context, AsyncSnapshot<Config> snapshot) {
            if (snapshot.data == null) {
              provider.refresh();
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            final Color primary =
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.black54
                    : snapshot.data!.primary;
            const Color textColor = Colors.black;
            return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text('Pozadí aplikace',
                      style: TextStyle(fontSize: 22, color: textColor))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const Text('Světlé', style: TextStyle(color: textColor)),
                  Switch.adaptive(
                    value: snapshot.data!.darkMode,
                    activeTrackColor: primary.withOpacity(0.6),
                    activeColor: primary,
                    onChanged: (bool value) {
                      provider.updateConfig('darkMode', value);
                    },
                  ),
                  const Text('Tmavé', style: TextStyle(color: textColor)),
                ],
              ),
            ]);
          }),
    );
  }
}
