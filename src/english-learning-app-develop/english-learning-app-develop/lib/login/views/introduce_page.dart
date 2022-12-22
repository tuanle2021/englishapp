import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learning_english_app/components/custom_app_bar.dart';
import 'package:learning_english_app/components/login_button.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IntroducePage extends StatefulWidget {
  IntroducePage({Key? key}) : super(key: key);

  @override
  State<IntroducePage> createState() => _IntroducePageState();
}

class _IntroducePageState extends State<IntroducePage> {
  final controller = PageController(viewportFraction: 1, keepPage: false);
  final startButtonController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    return Scaffold(
      appBar: CustomAppBar("").removeAppBar(context),
      body: SafeArea(
        bottom: false,
        child: Container(
          color: Theme.of(context).colorScheme.background,
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: Theme.of(context).textTheme.titleLarge,
                      children: [
                        TextSpan(
                            text: "My",
                            style: GoogleFonts.copse(
                                    textStyle:
                                        Theme.of(context).textTheme.displayMedium)
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                        TextSpan(
                            text: "Language",
                            style: GoogleFonts.copse(
                                    textStyle:
                                        Theme.of(context).textTheme.displayMedium)
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary)),
                      ])),
            ),
            Expanded(
              child: PageView(
                controller: controller,
                children: <Widget>[
                  Container(
                    color: Theme.of(context).colorScheme.background,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          (brightness == Brightness.light)
                              ? Image.asset(
                                  "assets/images/carousel1.gif",
                                  width: 320,
                                  height: 320,
                                )
                              : Image.asset(
                                  "assets/images/carousel1_dark.gif",
                                  width: 320,
                                  height: 320,
                                ),
                          SizedBox(height: 10),
                          RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  style: Theme.of(context).textTheme.titleLarge,
                                  children: [
                                    TextSpan(
                                        text: AppLocalizations.of(context)
                                            .textCarousel1)
                                  ]))
                        ]),
                  ),
                 
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: PaddingConstants.large),
            ),
            SmoothPageIndicator(
              controller: controller,
              count: 1,
              effect: ExpandingDotsEffect(
                  radius: 12,
                  dotWidth: 12,
                  dotHeight: 12,
                  // strokeWidth: 5,
                  activeDotColor: Theme.of(context).colorScheme.secondary),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(
                  vertical: 40, horizontal: PaddingConstants.large),
              child: LoginButton(
                  onPressed: () {
                    startButtonController.reset();
                    Navigator.of(context).pushNamed('/login');
                  },
                  buttonLabel:
                      AppLocalizations.of(context).login_screen_welcome_text2,
                  roundedLoadingButtonController: startButtonController),
            )
          ]),
        ),
      ),
    );
  }
}
