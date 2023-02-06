import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:todo/components/constants/constants.dart';
import 'package:todo/components/frontend/textStyle.dart';

class MyTextFormFields extends StatelessWidget {
  const MyTextFormFields(
    this.controller, {
    Key? key,
    required this.focusNode,
    required this.secondaryTheme,
    this.onSuffixTap,
    required this.text,
    required this.hintText,
    required this.labelText,
    this.onChanged,
    this.validator,
    this.maxLength,
    this.inputFormatters,
  }) : super(key: key);

  final FocusNode focusNode;
  final int? maxLength;
  final TextEditingController controller;
  final String text, hintText, labelText;
  final Color secondaryTheme;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final VoidCallback? onSuffixTap;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    MyTextStyle ts = MyTextStyle();
    return Focus(
      focusNode: focusNode,
      child: TextFormField(
        controller: controller,
        cursorColor: secondaryTheme,
        style: const TextStyle(color: white, fontSize: 17.2),
        textCapitalization: TextCapitalization.sentences,
        inputFormatters: [
          FilteringTextInputFormatter.deny(regExpEmojis),
          ...(inputFormatters ?? []),
        ],
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          counter: AnimatedOpacity(
            opacity: text.isEmpty || maxLength == null ? 0 : 1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.linear,
            child: Text(
              "${text.length} / $maxLength",
              style: TextStyle(color: secondaryTheme),
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          contentPadding: EdgeInsets.zero,
          labelStyle: ts.content,
          hintStyle: ts.content,
          border: border(),
          enabledBorder: border(),
          focusedBorder: border(),
          errorBorder: border(color: red),
          focusedErrorBorder: border(color: red),
          suffix: GestureDetector(
            onTap: onSuffixTap,
            child: Container(
              decoration: BoxDecoration(
                color: secondaryTheme,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(3),
              margin: const EdgeInsets.all(6),
              child: const Icon(
                MdiIcons.close,
                size: 16,
                color: white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  UnderlineInputBorder border({Color? color}) {
    return UnderlineInputBorder(
      borderSide: BorderSide(color: color ?? secondaryTheme),
    );
  }
}
