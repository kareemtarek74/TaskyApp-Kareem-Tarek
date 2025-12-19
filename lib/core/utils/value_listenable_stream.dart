import 'dart:async';

import 'package:flutter/foundation.dart';

class ValueListenableStream<T> extends Stream<T> {
  final ValueListenable<T> valueListenable;

  ValueListenableStream(this.valueListenable);

  @override
  StreamSubscription<T> listen(
    void Function(T event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    final controller = StreamController<T>();

    void listener() {
      controller.add(valueListenable.value);
    }

    controller.add(valueListenable.value);

    valueListenable.addListener(listener);

    controller.onCancel = () {
      valueListenable.removeListener(listener);
    };

    return controller.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}
