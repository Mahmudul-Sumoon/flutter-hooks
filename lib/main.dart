import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

const url =
    'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/220px-Image_created_with_a_mobile_phone.png';

enum Action {
  rotateLeft,
  rotateRight,
  lessVisible,
  moreVisible,
}

@immutable
class State {
  final double? rotationDeg;
  final double? alpha;
  const State({
    this.rotationDeg,
    this.alpha,
  });
  const State.zero()
      : rotationDeg = 0.0,
        alpha = 1.0;

  State rotateRight() => State(
        alpha: alpha,
        rotationDeg: rotationDeg! + 10.0,
      );
  State rotateLeft() => State(
        alpha: alpha,
        rotationDeg: rotationDeg! - 10.0,
      );
  State moreVisible() => State(
        alpha: min(alpha! + 0.1, 1.0),
        rotationDeg: rotationDeg!,
      );
  State lessVisible() => State(
        alpha: max(alpha! - 0.1, 0.1),
        rotationDeg: rotationDeg!,
      );
}

State reducer(State oldState, Action? action) {
  switch (action) {
    case Action.rotateLeft:
      return oldState.rotateLeft();
    case Action.rotateRight:
      return oldState.rotateRight();
    case Action.lessVisible:
      return oldState.lessVisible();
    case Action.moreVisible:
      return oldState.moreVisible();
    case null:
      return oldState;
  }
}

class MyHomePage extends HookWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = useReducer<State, Action?>(
      reducer,
      initialState: const State.zero(),
      initialAction: null,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  store.dispatch(Action.rotateRight);
                },
                child: const Text('Rotate right'),
              ),
              TextButton(
                onPressed: () {
                  store.dispatch(Action.rotateLeft);
                },
                child: const Text('Rotate left'),
              ),
              TextButton(
                onPressed: () {
                  print(Action.moreVisible.toString());
                  store.dispatch(Action.moreVisible);
                },
                child: const Text('More Visible'),
              ),
              TextButton(
                onPressed: () {
                  print(Action.lessVisible.toString());
                  store.dispatch(Action.lessVisible);
                },
                child: const Text('Less Visible'),
              ),
            ],
          ),
          const SizedBox(
            height: 100,
          ),
          Opacity(
            opacity: store.state.alpha!,
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(
                store.state.rotationDeg! / 360.0,
              ),
              child: Image.network(url),
            ),
          ),
        ],
      ),
    );
  }
}
