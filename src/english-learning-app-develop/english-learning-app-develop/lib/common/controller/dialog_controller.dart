import 'package:flutter/material.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DialogController {
  static BuildContext? dialogContext;
  static Widget loadingDialog(
      {String? title, String? message, required BuildContext context}) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: PaddingConstants.large,
            ),
            LoadingAnimationWidget.dotsTriangle(
                size: 40, color: Theme.of(context).colorScheme.primary),
            SizedBox(
              height: PaddingConstants.small,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title ?? AppLocalizations.of(context).prepDataLoading,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                  message ?? AppLocalizations.of(context).pleaseAMomment,
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            SizedBox(
              height: PaddingConstants.large,
            ),
          ],
        ),
      ),
    );
  }

  static void dismisDialog() {
    if (dialogContext != null) {
      Navigator.of(dialogContext!).pop();
    }
  }

  static void showLoadingDialog({
    String? title,
    String? message,
    required BuildContext context,
  }) {
    dialogContext = context;
    showDialog(
        barrierDismissible: false,
        context: dialogContext!,
        builder: (_) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: PaddingConstants.large,
                    ),
                    LoadingAnimationWidget.dotsTriangle(
                        size: 40, color: Theme.of(context).colorScheme.primary),
                    SizedBox(
                      height: PaddingConstants.small,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          title ?? AppLocalizations.of(context).prepDataLoading,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                          message ??
                              AppLocalizations.of(context).pleaseAMomment,
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                    SizedBox(
                      height: PaddingConstants.large,
                    ),
                  ],
                ),
              ),
            ));
  }

  static void showErrorDialog(
      {required String title,
      String? message,
      required BuildContext context,
      VoidCallback? actionPositive,
      VoidCallback? actionNegative,
      required String buttonNamePositive,
      required String buttonNameNegative}) {
    dialogContext = context;
    showDialog(
        barrierDismissible: true,
        context: dialogContext!,
        builder: (_) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: PaddingConstants.large,
                    ),
                    Icon(
                      Icons.error,
                      size: 60,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    SizedBox(
                      height: PaddingConstants.small,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                      child: Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(message ?? "",
                          style: Theme.of(context).textTheme.labelLarge),
                    ),
                    SizedBox(
                      height: PaddingConstants.med,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: ElevatedButton(
                        onPressed: actionPositive,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(300, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          primary: Theme.of(context).colorScheme.primary,
                          elevation: 2,
                          padding: const EdgeInsets.all(10),
                        ),
                        child: Text(
                          buttonNamePositive.toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: actionNegative,
                        child: Text(buttonNameNegative.toUpperCase(),
                            style: Theme.of(context).textTheme.labelLarge!)),
                    SizedBox(
                      height: PaddingConstants.large,
                    ),
                  ],
                ),
              ),
            ));
  }

  static void showInfoDialog(
      {required String title,
      String? message,
      required BuildContext context,
      VoidCallback? actionPositive,
      VoidCallback? actionNegative,
      required String buttonNamePositive,
      required String buttonNameNegative}) {
    dialogContext = context;
    showDialog(
        barrierDismissible: true,
        context: dialogContext!,
        builder: (_) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: PaddingConstants.large,
                    ),
                    Icon(
                      Icons.info,
                      size: 60,
                      color: Colors.blue.shade700,
                    ),
                    SizedBox(
                      height: PaddingConstants.small,
                    ),
                    Center(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                        child: Text(
                          title,
                          textAlign:TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(message ?? "",
                          style: Theme.of(context).textTheme.labelLarge),
                    ),
                    SizedBox(
                      height: PaddingConstants.med,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: ElevatedButton(
                        onPressed: actionPositive,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(300, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          primary: Theme.of(context).colorScheme.primary,
                          elevation: 2,
                          padding: const EdgeInsets.all(10),
                        ),
                        child: Text(
                          buttonNamePositive.toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: actionNegative,
                        child: Text(buttonNameNegative.toUpperCase(),
                            style: Theme.of(context).textTheme.labelLarge!)),
                    SizedBox(
                      height: PaddingConstants.large,
                    ),
                  ],
                ),
              ),
            ));
  }

  static void showWarningDialog(
      {required String title,
      String? message,
      required BuildContext context,
      VoidCallback? actionPositive,
      VoidCallback? actionNegative,
      required String buttonNamePositive,
      required String buttonNameNegative}) {
    dialogContext = context;
    showDialog(
        barrierDismissible: true,
        context: dialogContext!,
        builder: (_) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: PaddingConstants.large,
                    ),
                    Icon(
                      Icons.warning,
                      size: 60,
                      color: Colors.yellow.shade700,
                    ),
                    SizedBox(
                      height: PaddingConstants.small,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                      child: Text(
                        title,
                        textAlign:TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(message ?? "",
                          style: Theme.of(context).textTheme.labelLarge),
                    ),
                    SizedBox(
                      height: PaddingConstants.med,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: ElevatedButton(
                        onPressed: actionPositive,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(300, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          primary: Theme.of(context).colorScheme.primary,
                          elevation: 2,
                          padding: const EdgeInsets.all(10),
                        ),
                        child: Text(
                          buttonNamePositive.toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: actionNegative,
                        child: Text(buttonNameNegative.toUpperCase(),
                            style: Theme.of(context).textTheme.labelLarge!)),
                    SizedBox(
                      height: PaddingConstants.large,
                    ),
                  ],
                ),
              ),
            ));
  }
}
