import 'package:flutter/material.dart';
import 'package:hashtag/components/message/special_textfield_controller.dart';

//PROBLEMS :
//SUGGESTION IS NOT REMOVING AFTER SELECTING SUGGESTION
// ONCE OPENED ITS NOT HIDING AGAIN EVEN IF TEXTFIELD IS CLEAR AND IF SPACE ' ' IS TAKEN IN TEXTFIELD

class SpecialTextfield extends StatefulWidget {
  SpecialTextfield(
      {Key? key, required this.controller, required this.suggestionBoxPosition})
      : super(key: key);
  final num suggestionBoxPosition;
  final SpecialTextEditingController controller;

  @override
  State<SpecialTextfield> createState() => _SpecialTextfieldState();
}

class _SpecialTextfieldState extends State<SpecialTextfield> {
  // @override
  // void initState() {
  //   super.initState();
  //   widget.controller.addListener(_updateState);
  // }

  // @override
  // void dispose() {
  //   widget.controller.removeListener(_updateState);
  //   super.dispose();
  // }

  // void _updateState() {
  //   setState(() {});
  // }

  OverlayEntry? _overlayEntry;
  final layerLink = LayerLink();

  final List<String> _allMentions = ['john', 'alice', 'adam', 'will'];
  final List<String> _allHashtags = ['india', 'erk', 'usa', 'canada'];
  List<String> _filteredItems = [];

  void _showOverlay() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Positioned(
            width: size.width,
            // YET TO FIND THE OFFSET VALUE WHICH WILL SET POSITION AT TOP OF TEXTFIELD EVEN IF TEXTFIELD CAN CHANGE SIZE
            child: CompositedTransformFollower(
                offset: Offset(0, offset.dy - size.height),
                link: layerLink,
                showWhenUnlinked: false,
                child: buildOverlay(size)));
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget buildOverlay(Size size) {
    return Material(
      child: Container(
        constraints: BoxConstraints(maxHeight: 3 * size.height),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _filteredItems.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(_filteredItems[index]),
              onTap: () {
                _replaceWord(_filteredItems[index]);
              },
            );
          },
        ),
      ),
    );
  }

  String _getMentionStartsWith(String text) {
    RegExp regExp = RegExp(r'@\w*');
    var matches = regExp.allMatches(text);
    return matches.isNotEmpty ? matches.last.group(0)!.substring(1) : '';
  }

  String _getHashtagStartsWith(String text) {
    RegExp regExp = RegExp(r'#\w*');
    var matches = regExp.allMatches(text);
    return matches.isNotEmpty ? matches.last.group(0)!.substring(1) : '';
  }

//HIDE OVERLAY
  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

//UPDATE LIST AS WE WRITE
  void _updateOverlay(String text) {
    if (text.isEmpty ||
        text.trim().endsWith(' ') ||
        text.trim().endsWith('#')) {
      _hideOverlay();
      return;
    }

    if (text.contains('@')) {
      _filteredItems = _allMentions
          .where((mention) => mention
              .toLowerCase()
              .startsWith(_getMentionStartsWith(text).toLowerCase()))
          .toList();
      _showOverlay();
    } else if (text.contains('#')) {
      _filteredItems = _allHashtags
          .where((hashtag) => hashtag
              .toLowerCase()
              .startsWith(_getHashtagStartsWith(text).toLowerCase()))
          .toList();
      _showOverlay();
    } else {
      _hideOverlay();
    }
  }

  // REPLACE WORD WITH SUGGESTION
  void _replaceWord(String replacement) {
    final TextEditingValue value = widget.controller.value;
    final String currentText = value.text;
    final int selectionStart = value.selection.start;
    final int wordStart =
        currentText.lastIndexOf(RegExp(r'[@#]\w*'), selectionStart);

    if (wordStart != -1) {
      final String leadingSymbol = currentText[wordStart];
      final String newText = currentText.replaceRange(
          wordStart, selectionStart, '$leadingSymbol$replacement');

      widget.controller.value = TextEditingValue(
        text: newText,
        selection:
            TextSelection.collapsed(offset: wordStart + replacement.length + 1),
      );
      _hideOverlay();
    }

    _hideOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: TextField(
        controller: widget.controller,
        onChanged: _updateOverlay,
      ),
    );
  }
}
