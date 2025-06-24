import 'package:flutter/material.dart';
import 'package:phone_away/screens/tree/tree_model.dart';

import '../../widgets/apple_tree.dart';

// Das StatefulWidget: Es hält die "final" Daten (hier das Model)
// und erstellt den State.

class TreePage extends StatefulWidget {
  final TreeModel model;

  const TreePage({super.key, required this.model});

  @override
  State<TreePage> createState() => _TreePageState(); // Der State wird OHNE Parameter erstellt
}

// Der State: Er ist veränderlich, hat einen Lebenszyklus (initState, build, dispose)
// und baut die eigentliche Benutzeroberfläche.

class _TreePageState extends State<TreePage> {
  // Es wird kein eigener Konstruktor benötigt.

  @override
  void initState() {
    super.initState();
    // Greife über "widget" auf die Eigenschaften des StatefulWidget zu.
    // Das ist der korrekte Weg.
    widget.model.loadApples();
  }

  @override
  Widget build(BuildContext context) {
    // Die build-Methode muss die UI-Widgets zurückgeben, aus denen
    // dein Screen besteht (z.B. ein Scaffold, Column, Text etc.).
    // Du greifst hier ebenfalls über "widget.model" auf deine Daten zu.

    return Scaffold(
      // Beispiel für eine UI-Struktur
      appBar: AppBar(
        // So greifst du auf die userId zu, immer aktuell.
        title: Text('Baum von User: ${widget.model.userId}'),
      ),
      body: Center(
        // Hier kommt dein AppleTree-Widget hin.
        // Angenommen, es benötigt eine Liste von Äpfeln aus dem Model.
        child: AppleTreeWidget(
          apples: widget.model.apples,
          rottenApples: widget.model.rottenApples,
        ),
      ),
    );
  }
}
