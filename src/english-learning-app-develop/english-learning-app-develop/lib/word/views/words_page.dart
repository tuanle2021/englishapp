import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WordsScreen extends StatefulWidget {
  WordsScreen({Key? key}) : super(key: key);

  @override
  State<WordsScreen> createState() => _WordsScreenState();
}

class _WordsScreenState extends State<WordsScreen> {
  final double originalRadius = 60;
  final ScrollController subjectListController = new ScrollController();
  
  bool pressed = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        left: false,
        right: false,
        child: Container(
        ))
    );
  }
}
