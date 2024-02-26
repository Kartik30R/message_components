import 'package:flutter/material.dart';

class SpecialTextEditingController extends TextEditingController{

  final ValueNotifier<String> textNotifier = ValueNotifier<String>('');


@override
TextSpan buildTextSpan({BuildContext? context, TextStyle? style, required bool withComposing}) {
RegExp regExp = RegExp(
  r'(@\w+)|(#\w+)|(https?://(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|(?:www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}))',
  caseSensitive: false,
);



  var tags = regExp.allMatches(value.text);

  List<TextSpan> children = [];

  int currentPosition = 0;

  for (var tag in tags) {
    if (tag.start > currentPosition) {
      children.add(TextSpan(
        text: value.text.substring(currentPosition, tag.start),
        style: style,
      ));
    }

    children.add(TextSpan(
      text: value.text.substring(tag.start, tag.end),
      style: const TextStyle(color: Colors.blue), 
    ));

    currentPosition = tag.end;
  }

  if (currentPosition < value.text.length) {
    children.add(TextSpan(
      text: value.text.substring(currentPosition),
      style: style,
    ));
  }

  return TextSpan(children: children);
}
}