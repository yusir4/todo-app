import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/core/transformers/transformers.dart';
import 'package:todo/ui/todo_list_screen.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: TransformerPageView(
        scrollDirection: Axis.vertical,
        curve: Curves.easeInBack,
        transformer: transformers[4],
        itemCount: 3,
        loop: false,
        itemBuilder: (context, index) {
          return TodoListScreeen(
            index: index,
          );
        },
      ),
    );
  }
}
