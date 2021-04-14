import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import '../bloc/bloc_provider.dart';
import '../bloc/config_bloc.dart';
import '../classes/config.dart';
import '../components/my_raised_button.dart';
import 'bottom_sheet.dart';

class Settings extends StatelessWidget {
  void _selectColor(BuildContext context, bool secondary) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          final ConfigBloc provider = BlocProvider.of<ConfigBloc>(context);
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(width: 1)),
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: StreamBuilder<Config>(
                      stream: provider.stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<Config> snapshot) {
                        if (snapshot.data == null) {
                          provider.refresh();
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return Column(children: <Widget>[
                          Expanded(
                            child: MaterialColorPicker(
                              circleSize: 75,
                              selectedColor: secondary
                                  ? snapshot.data.secondary
                                  : snapshot.data.primary,
                              onColorChange: (Color color) {
                                provider.updateConfig(
                                    secondary ? 'secondary' : 'primary', color);
                              },
                            ),
                          ),
                          MyRaisedButton(
                            'Zavřít',
                            () {
                              Navigator.pop(context);
                            },
                          )
                        ]);
                      })));
        });
  }

  @override
  Widget build(BuildContext context) {
    final ConfigBloc provider = BlocProvider.of<ConfigBloc>(context);
    return CustomBottomSheet(
      child: StreamBuilder<Config>(
          stream: provider.stream,
          builder: (BuildContext context, AsyncSnapshot<Config> snapshot) {
            if (snapshot.data == null) {
              provider.refresh();
              return const Center(child: CircularProgressIndicator());
            }
            final Color primary =
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.black54
                    : snapshot.data.primary;
            return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              const Padding(
                  padding: EdgeInsets.all(15),
                  child:
                      Text('Pozadí aplikace', style: TextStyle(fontSize: 22))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const Text(
                    'Světlé',
                  ),
                  Switch(
                    value: snapshot.data.darkMode,
                    activeTrackColor: primary.withOpacity(0.6),
                    activeColor: primary,
                    onChanged: (bool value) {
                      provider.updateConfig('darkMode', value);
                    },
                  ),
                  const Text(
                    'Tmavé',
                  ),
                ],
              ),
              if (!snapshot.data.darkMode)
                const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Výběr barev aplikací',
                      style: TextStyle(fontSize: 22),
                    )),
              if (!snapshot.data.darkMode)
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('Primární barva'),
                      MyRaisedButton(
                        'Vybrat',
                        () {
                          _selectColor(context, false);
                        },
                      )
                    ]),
              if (!snapshot.data.darkMode)
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('Sekundární barva'),
                      MyRaisedButton(
                        'Vybrat',
                        () {
                          _selectColor(context, true);
                        },
                        secondary: true,
                      )
                    ])
            ]);
          }),
    );
  }
}
