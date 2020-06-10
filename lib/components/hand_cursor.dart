import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart';

class HandCursor extends MouseRegion {

  static final appContainer = window.document.getElementById('app-container');

  HandCursor({Widget child}) : super(
    onHover: (PointerHoverEvent evt) {
      appContainer.style.cursor='pointer';
    },
    onExit: (PointerExitEvent evt) {
      appContainer.style.cursor='default';
    },
    child: child
  );
}
