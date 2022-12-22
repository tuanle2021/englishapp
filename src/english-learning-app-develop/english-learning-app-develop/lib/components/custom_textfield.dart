import 'dart:ui';

import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String textLabel;
  final double? customWidth;
  final ValueChanged<String> onChanged;
  FormFieldValidator<String>? validator;
  bool? isPassword = false;
  bool? disable;
  Key? textFieldKey;
  FocusNode? focusNode;
  TextEditingController? textEditingController;
  EdgeInsets? customPadding;
  final IconData? iconData;
  String? initialValue;
  CustomTextField(
      {Key? key,
      required this.textLabel,
      required this.onChanged,
      this.isPassword,
      this.validator,
      this.focusNode,
      this.textFieldKey,
      this.customWidth,
      this.customPadding,
      this.disable,
      this.iconData,
      this.initialValue,
      this.textEditingController})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    if (widget.iconData == null) {
      return Container(
          padding: (widget.customPadding == null)
              ? EdgeInsets.zero
              : widget.customPadding,
          width: (this.widget.customWidth == null)
              ? MediaQuery.of(context).size.width
              : this.widget.customWidth,
          child: Column(
            children: [
              TextFormField(
                enabled: widget.disable == null ? true : !widget.disable!,
                initialValue: widget.initialValue,
                key: widget.textFieldKey,
                focusNode: widget.focusNode,
                controller: widget.textEditingController,
                validator: widget.validator,
                obscureText:
                    (widget.isPassword != null) ? widget.isPassword! : false,
                onChanged: widget.onChanged,
                readOnly: (widget.disable != null) ? widget.disable! : false,
                cursorColor: Theme.of(context).colorScheme.onSurface,
                decoration: InputDecoration(
                  hintText: widget.textLabel,
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  contentPadding: EdgeInsetsDirectional.only(start: 15),
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ));
    }
    return Container(
        padding: (widget.customPadding == null)
            ? EdgeInsets.zero
            : widget.customPadding,
        width: (this.widget.customWidth == null)
            ? MediaQuery.of(context).size.width
            : this.widget.customWidth,
        child: TextFormField(
          enabled: widget.disable == null ? true : !widget.disable!,
          initialValue: widget.initialValue,
          readOnly: (widget.disable != null) ? widget.disable! : false,
          key: widget.textFieldKey,
          focusNode: widget.focusNode,
          controller: widget.textEditingController,
          validator: widget.validator,
          obscureText: (widget.isPassword != null) ? widget.isPassword! : false,
          onChanged: widget.onChanged,
          cursorColor: Theme.of(context).colorScheme.onSurface,
          decoration: InputDecoration(
              hintText: widget.textLabel,
              filled: true,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              contentPadding: EdgeInsets.all(0),
              prefixIcon: Icon(widget.iconData)),
          style: Theme.of(context).textTheme.bodyLarge,
        ));
  }
}
