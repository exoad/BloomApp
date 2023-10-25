import 'package:flutter/material.dart';
import 'package:blosso_mindfulness/bits/consts.dart';
import 'package:blosso_mindfulness/bits/telemetry.dart';

class Block extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;
  final EdgeInsets padding;
  const Block(
      {super.key,
      required this.backgroundColor,
      required this.child,
      required this.padding});

  const Block.claimed(
      {super.key,
      required this.backgroundColor,
      required this.child,
      this.padding = LaF.homeComponentPadding});

  Block.text(
      {super.key,
      required String titleText,
      this.padding = LaF.homeComponentPadding,
      required String subText,
      TextStyle titleTextStyle = LaF.blockTitleTextStyle,
      TextStyle subTextStyle = LaF.blockSubTextStyle,
      Widget? sideLabel,
      required this.backgroundColor})
      : child = sideLabel == null
            ? Text.rich(TextSpan(children: <InlineSpan>[
                TextSpan(text: titleText, style: titleTextStyle),
                TextSpan(text: subText, style: subTextStyle)
              ]))
            : Row(children: [
                sideLabel,
                Text.rich(TextSpan(children: <InlineSpan>[
                  TextSpan(text: titleText, style: titleTextStyle),
                  TextSpan(text: subText, style: subTextStyle)
                ]))
              ]);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: padding,
              child: Container(
                  decoration: ShapeDecoration(
                    color: backgroundColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          LaF.roundedRectBorderRadius),
                    ),
                  ),
                  child: Padding(
                      padding: padding,
                      child: Center(
                        heightFactor: 1,
                        child: child,
                      ))))
        ]);
  }
}

class NamePrompt extends StatefulWidget {
  final void Function() afterCallback;
  const NamePrompt({super.key, required this.afterCallback});

  @override
  NamePromptState createState() => NamePromptState();
}

class NamePromptState extends State<NamePrompt> {
  TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Your Name'),
      content: TextField(
        controller: _nameController,
        decoration: const InputDecoration(
          hintText: 'Your Name',
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Lets go!"),
          onPressed: () {
            String userName = _nameController.text;
            setUserName(userName);
            setIsNewUser(false);
            widget.afterCallback.call();
          },
        ),
      ],
    );
  }
}
