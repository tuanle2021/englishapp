import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar {
  String? titleText = "";
  bool? isNotHasBackButton;
  CustomAppBar(this.titleText,
      {this.isNotHasBackButton = false,
      this.forcedCenterTitle = false,
      this.actions,
      this.onPressed});
  CustomAppBar.transparentAppBar();
  bool? forcedCenterTitle;
  Widget? actions;
  void Function()? onPressed;
  

  AppBar customAppBar(context) {
    if (this.isNotHasBackButton != null && this.isNotHasBackButton == true) {
      return AppBar(
          leading: null,
          backgroundColor: Theme.of(context).colorScheme.background,
          centerTitle: true,
          bottomOpacity: 0,
          shadowColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            // Status bar color
            // Status bar brightness (optional)
            statusBarIconBrightness:
                Theme.of(context).brightness, // For Android (dark icons)
            statusBarBrightness:
                Theme.of(context).brightness, // For iOS (dark icons)
          ),
          title: Text(
            titleText!,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          ));
    }
    return AppBar(
        actions: (actions != null) ? [actions!] : null,
        systemOverlayStyle: SystemUiOverlayStyle(
          // Status bar color
          // Status bar brightness (optional)
          statusBarIconBrightness:
              Theme.of(context).brightness, // For Android (dark icons)
          statusBarBrightness:
              Theme.of(context).brightness, // For iOS (dark icons)
        ),
        leading: IconButton(
          splashRadius: 20,
          icon: (Platform.isIOS)
              ? Icon(Icons.arrow_back_ios_new,
                  color: Theme.of(context).colorScheme.onBackground)
              : Icon(Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onBackground),
          onPressed:
              onPressed == null ? () => Navigator.of(context).pop(true) : onPressed,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        centerTitle:
            (this.forcedCenterTitle == true || Platform.isIOS) ? true : false,
        bottomOpacity: 0,
        shadowColor: Colors.transparent,
        title: Text(
          titleText!,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ));
  }

  AppBar removeAppBar(context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      toolbarHeight: 0,
      shadowColor: Colors.transparent,
      // status bar color
      systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        // Status bar brightness (optional)
        statusBarIconBrightness:
            Theme.of(context).brightness, // For Android (dark icons)
        statusBarBrightness:
            Theme.of(context).brightness, // For iOS (dark icons)
      ), // status bar brightness
    );
  }

  AppBar transparentAppbar(context) {
    return AppBar(
      toolbarHeight: 0,
      shadowColor: Colors.transparent,
      bottomOpacity: 0,
      backgroundColor: Theme.of(context).colorScheme.background,
      systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        // Status bar brightness (optional)
        statusBarIconBrightness:
            Theme.of(context).brightness, // For Android (dark icons)
        statusBarBrightness:
            Theme.of(context).brightness, // For iOS (dark icons)
      ),
    );
  }
}
