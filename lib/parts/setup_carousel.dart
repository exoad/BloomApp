import 'package:blosso_mindfulness/bits/bits.dart';
import 'package:blosso_mindfulness/parts/parts.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

Widget launchCarousel(bool firstTimeFull) => InputDetailsCarousel(
      firstPage: (
        title: "Let's set you up",
        hint: "Tap > for the next step"
      ),
      submissionCallback: () {
        setIsNewUser(false);
        if(firstTimeFull)
          firstTimeValidateTelemetry();
      },
      otherPages: [
        makeTextInputDetails(
            title: "What should we call you?",
            hintText: "John",
            callback: setUserName),
        makeCustomInputDetails(
            title: "What is your age range?",
            child: Center(
              child: ActionableSlider(
                consumer: setUserAgeGroup,
                min: 10,
                max: 90,
                divisions: 8,
                labelConsumer: (val) =>
                    "Age Range: ${val.toInt()}-${(val + 10).toInt()}",
              ),
            )),
        makeCustomInputDetails(
            title: "Note",
            child: const Text(
              "The following forms are just to build your profile. They are not required.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            )),
        makeCustomInputDetails(
            title: "Your sex", child: const _UserSexSelection()),
        makeCustomInputDetails(
            title: "Select an avatar",
            child: const _UserSelectAvatar())
      ],
    );

class _UserSelectAvatar extends StatefulWidget {
  const _UserSelectAvatar({
    super.key,
  });

  @override
  State<_UserSelectAvatar> createState() => _UserSelectAvatarState();
}

class _UserSelectAvatarState extends State<_UserSelectAvatar> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      RandomAvatar(getUserAvatarSVG(), width: 108, height: 108),
      const SizedBox(height: 40),
      TextButton.icon(
          onPressed: () {
            String svg = RandomAvatarString(
                DateTime.now().toIso8601String(),
                trBackground: false);
            setUserAvatarSVG(svg);
            setState(() {});
          },
          icon: const Icon(Icons.replay_rounded),
          label: const Text("Generate"))
    ]);
  }
}

class _UserSexSelection extends StatelessWidget {
  const _UserSexSelection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _FemaleSex(),
          SizedBox(width: 20),
          _MaleSex(),
        ]);
  }
}

class _MaleSex extends StatefulWidget {
  const _MaleSex({
    super.key,
  });

  @override
  State<_MaleSex> createState() => _MaleSexState();
}

class _MaleSexState extends State<_MaleSex> {
  Color maleButtonColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setUserSex("male"),
      onTapDown: (details) {
        setState(() {
          maleButtonColor = Colors.blue.shade200;
        });
      },
      onTapUp: (details) {
        setState(() {
          maleButtonColor = Colors.blue;
        });
        setUserSex("male");
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: maleButtonColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.male_rounded,
                size: 64,
                color: Colors.white,
              ),
              Text(
                "Male",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FemaleSex extends StatefulWidget {
  const _FemaleSex({
    super.key,
  });

  @override
  State<_FemaleSex> createState() => _FemaleSexState();
}

class _FemaleSexState extends State<_FemaleSex> {
  Color femaleButtonColor = Colors.pink;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setUserSex("female"),
      onTapDown: (details) {
        setState(() {
          femaleButtonColor = Colors.pink.shade200;
        });
      },
      onTapUp: (details) {
        setState(() {
          femaleButtonColor = Colors.pink;
        });
        setUserSex("female");
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: femaleButtonColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.female_rounded,
                size: 64,
                color: Colors.white,
              ),
              Text(
                "Female",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AgeSlider extends StatefulWidget {
  final void Function(double) consumer;
  const _AgeSlider({super.key, required this.consumer});

  @override
  State<_AgeSlider> createState() => _AgeSliderState();
}

class _AgeSliderState extends State<_AgeSlider> {
  double _sliderVal = 50;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _sliderVal,
      onChanged: (val) {
        setState(() {
          _sliderVal = val;
        });
      },
      min: 10,
      max: 90,
      divisions: 9,
      allowedInteraction: SliderInteraction.tapAndSlide,
    );
  }
}
