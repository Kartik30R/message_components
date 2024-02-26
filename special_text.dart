import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SpecialText extends StatelessWidget {
   SpecialText({super.key, required this.text , this.normalTextStyle, this.specialTextStyle});
  final String text;
  final TextStyle? normalTextStyle;
  final TextStyle? specialTextStyle;

   TextSpan buildTextSpan({ TextStyle? normalTextStyle, TextStyle? specialTextStyle}) {
RegExp regExp = RegExp(
  r'(@\w+)|(#\w+)|(https?://(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|(?:www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}))',
  caseSensitive: false,
);



  var tags = regExp.allMatches(text);

  List<TextSpan> children = [];

  int currentPosition = 0;

  for (var tag in tags) {
    if (tag.start > currentPosition) {
      children.add(TextSpan(
        text: text.substring(currentPosition, tag.start),
        style: normalTextStyle,
      ));
    }

    children.add(TextSpan(
      
      text: text.substring(tag.start, tag.end),
      style:specialTextStyle?? TextStyle(color: Colors.blue),
 //GIVE ON TAP FUNCTION     
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          String span = text.substring(tag.start, tag.end);
          if(span.startsWith('@')){

             print(' pressed');
          };

        },
       
    ));

    currentPosition = tag.end;
  }

  if (currentPosition < text.length) {
    children.add(TextSpan(
      text: text.substring(currentPosition),
      style: normalTextStyle,
    ));
  }

  return TextSpan(children: children);
}

  @override
  Widget build(BuildContext context) {
    return RichText(text: buildTextSpan(

 //CAN STYLE TEXT HERE     
      specialTextStyle: specialTextStyle,
      normalTextStyle:normalTextStyle,
    ));
  }
}