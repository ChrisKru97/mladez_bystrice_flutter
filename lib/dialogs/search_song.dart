import 'package:flutter/material.dart';
import '../bloc/bloc_provider.dart';
import '../bloc/search_bloc.dart';

class SearchSong extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.black26, borderRadius: BorderRadius.circular(15)),
        height: 80,
        padding: const EdgeInsets.all(15),
        child: TextField(
          decoration: InputDecoration(border: InputBorder.none),
          autofocus: true,
          textAlign: TextAlign.left,
          onChanged: BlocProvider.of<SearchBloc>(context).search,
        ),
      );
}
