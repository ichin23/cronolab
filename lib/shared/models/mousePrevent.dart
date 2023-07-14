import 'dart:async';
import 'dart:html' as uni;

import 'package:flutter/foundation.dart';

class MousePrevent with ChangeNotifier {
  StreamSubscription<uni.MouseEvent>? contextMenuListener;

  void disableRightClick() {
    if (kIsWeb) {
      contextMenuListener =
          uni.document.onContextMenu.listen((event) => event.preventDefault());
    }
  }

  void enableRightClick() {
    contextMenuListener?.cancel();
  }
}
