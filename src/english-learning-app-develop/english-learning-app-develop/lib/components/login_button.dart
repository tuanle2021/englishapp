import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginButton extends StatelessWidget {
  LoginButton(
      {Key? key,
      required this.onPressed,
      required this.buttonLabel,
      required this.roundedLoadingButtonController,
      this.padding})
      : super(key: key);
  final VoidCallback? onPressed;
  final String buttonLabel;
  final RoundedLoadingButtonController roundedLoadingButtonController;

  EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RoundedLoadingButton(
        resetAfterDuration: false,
        width: MediaQuery.of(context).size.width,
        controller: roundedLoadingButtonController,
        onPressed: onPressed,
        height: 43,
        color: Theme.of(context).colorScheme.primary,
        child: Text(buttonLabel.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: Theme.of(context).colorScheme.onPrimary)),
      ),
    );
  }
}
