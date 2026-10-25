import 'package:flutter/material.dart';

/// Écran temporaire, remplacé au fur et à mesure par les vrais écrans.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(child: Text(title)),
      );
}
