import 'package:flutter/material.dart';
import '../bloc/bloc_provider.dart';
import '../bloc/search_bloc.dart';

class SearchSong extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.all(15),
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
        height: 80,
        padding: const EdgeInsets.all(15),
        child: TextField(
          decoration: InputDecoration(border: InputBorder.none),
          style: TextStyle(color: Colors.white),
          autofocus: true,
          autocorrect: false,
          textAlign: TextAlign.left,
          onChanged: BlocProvider.of<SearchBloc>(context).search,
        ),
      );
}
