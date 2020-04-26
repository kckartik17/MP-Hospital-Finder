import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';

DayNightAnimationController animationController = DayNightAnimationController();
AnimationStates _currentAnimationState =
    widgetvalue ? AnimationStates.night_idle : AnimationStates.day_idle;
AnimationStates get currentAnimationState => _currentAnimationState;

set currentAnimationState(AnimationStates value) {
  _currentAnimationState = value;
  animationController.changeAnimationState(value);
}

bool widgetvalue;
Function(bool) onSelectionChange;

class DayNightSwitch extends StatefulWidget {
  double height, width;
  bool value;

  DayNightSwitch(
      {this.height = 0.0,
      this.width = 0.0,
      Function(bool) onSelection,
      this.value}) {
    onSelectionChange = onSelection;
  }

  @override
  _DayNightSwitchState createState() => _DayNightSwitchState();
}

enum AnimationStates { day_idle, switch_day, night_idle, switch_night }

extension on AnimationStates {
  String getName() {
    return this.toString().split('.').last;
  }
}

class _DayNightSwitchState extends State<DayNightSwitch> {
  @override
  void initState() {
    super.initState();
    widgetvalue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: GestureDetector(
        child: FlareActor(
          'assets/Animation_button.flr',
          controller: animationController,
        ),
        onTap: () {
          if (currentAnimationState == AnimationStates.night_idle) {
            currentAnimationState = AnimationStates.switch_day;
          } else {
            currentAnimationState = AnimationStates.switch_night;
          }
        },
      ),
    );
  }
}

class DayNightAnimationController extends FlareControls {
  @override
  void onCompleted(String name) {
    if (name == AnimationStates.switch_night.getName()) {
      play(AnimationStates.night_idle.getName());
      currentAnimationState = AnimationStates.night_idle;
      onSelectionChange(true);
    }
    if (name == AnimationStates.switch_day.getName()) {
      play(AnimationStates.day_idle.getName());
      currentAnimationState = AnimationStates.day_idle;
      onSelectionChange(false);
    }
    super.onCompleted(name);
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    super.initialize(artboard);
    if (widgetvalue) {
      play(AnimationStates.night_idle.getName());
    } else {
      play(AnimationStates.day_idle.getName());
    }
  }

  void changeAnimationState(AnimationStates states) {
    play(states.getName());
  }
}
