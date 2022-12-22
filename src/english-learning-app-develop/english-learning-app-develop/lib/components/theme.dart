import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomColor {
  static final Color lightCorrect = Color(0xff4ba13d);
  static final Color darkCorrect = Color(0xff95e271);
}

class CustomTheme {
  static ThemeData getLightTheme() {
    TextTheme parentLightTxtTheme = ThemeData.light().textTheme;
    return ThemeData.light().copyWith(
        colorScheme: ColorScheme(
          primary: Color(0xff2992C5),
          background: Color.fromRGBO(242, 242, 247, 1),
          brightness: Brightness.light,
          error: Color(0xffB00020),
          onBackground: Colors.black,
          onError: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.black,
          secondary: Color(0xffF0ABC1),
          surface: Colors.white,
          primaryContainer: Color(0xff63caeb),
        ),
        textTheme: TextTheme(
          labelLarge: GoogleFonts.inter(
            textStyle: parentLightTxtTheme.labelLarge?.copyWith(
                // color: ColorTheme.primaryTextColor,
                // fontSize: FontSizeConstants.largeBody,

                ),
          ),
          labelMedium: GoogleFonts.inter(
            textStyle: parentLightTxtTheme.labelMedium?.copyWith(
                // color: ColorTheme.primaryTextColor,
                // fontSize: FontSizeConstants.largeBody,
                ),
          ),
          labelSmall: GoogleFonts.inter(
            textStyle: parentLightTxtTheme.labelSmall?.copyWith(
                // color: ColorTheme.primaryTextColor,
                // fontSize: FontSizeConstants.largeBody,
                ),
          ),
          displayLarge: GoogleFonts.inter(
            textStyle: parentLightTxtTheme.displayLarge?.copyWith(
                // color: ColorTheme.primaryTextColor,
                // fontSize: FontSizeConstants.largeBody,
                ),
          ),
          displayMedium: GoogleFonts.inter(
            textStyle: parentLightTxtTheme.displayMedium?.copyWith(
                // color: ColorTheme.primaryTextColor,
                // fontSize: FontSizeConstants.largeBody,
                ),
          ),
          displaySmall: GoogleFonts.inter(
            textStyle: parentLightTxtTheme.displaySmall?.copyWith(
                // color: ColorTheme.primaryTextColor,
                // fontSize: FontSizeConstants.largeBody,
                ),
          ),
          bodyLarge: GoogleFonts.inter(
            textStyle: parentLightTxtTheme.bodyLarge?.copyWith(
                // color: ColorTheme.primaryTextColor,
                // fontSize: FontSizeConstants.largeBody,
                ),
          ),
          bodyMedium: GoogleFonts.inter(
            textStyle: parentLightTxtTheme.bodyMedium?.copyWith(
                //color: ColorTheme.primaryTextColor,
                //fontSize: FontSizeConstants.smallBody,
                ),
          ),
          bodySmall: GoogleFonts.inter(
            textStyle: parentLightTxtTheme.bodySmall?.copyWith(
                //color: ColorTheme.primaryTextColor,
                //fontSize: FontSizeConstants.extraSmallBody,
                ),
          ),
          titleLarge: GoogleFonts.inter(
            textStyle: parentLightTxtTheme.titleLarge?.copyWith(
                //color: ColorTheme.primaryTextColor,
                //fontSize: FontSizeConstants.bigTitle,
                ),
          ),
          titleMedium: GoogleFonts.inter(
            textStyle: parentLightTxtTheme.titleMedium?.copyWith(
                //color: ColorTheme.primaryTextColor,
                //fontSize: FontSizeConstants.medTitle,
                ),
          ),
          titleSmall: GoogleFonts.inter(
            textStyle: parentLightTxtTheme.titleSmall?.copyWith(
                //color: ColorTheme.primaryTextColor,
                //fontSize: FontSizeConstants.smallTitle,
                ),
          ),
          headlineSmall: GoogleFonts.inter(
            textStyle: parentLightTxtTheme.headlineSmall?.copyWith(
                // color: ColorTheme.primaryTextColor,
                //fontSize: FontSizeConstants.smallHeading,
                ),
          ),
          headlineMedium: GoogleFonts.inter(
            textStyle: parentLightTxtTheme.headlineMedium?.copyWith(
                // color: ColorTheme.primaryTextColor,
                //fontSize: FontSizeConstants.medHeading,
                ),
          ),
          headlineLarge: GoogleFonts.inter(
            textStyle: parentLightTxtTheme.headlineLarge?.copyWith(
                //color: ColorTheme.primaryTextColor,
                //fontSize: FontSizeConstants.smallHeading,
                ),
          ),
        ),
        brightness: Brightness.light
        // next line is important!
        );
  }

  static ThemeData getDarkTheme() {
    TextTheme parentDarkTxtTheme = ThemeData.dark().textTheme;
    return ThemeData.dark().copyWith(
        canvasColor: Color(0xff212529),
        colorScheme: ColorScheme(
            primary: Color(0xff2992C5),
            background: Color(0xff212529),
            brightness: Brightness.dark,
            error: Color(0xffCF6679),
            onBackground: Colors.white,
            onError: Colors.black,
            onPrimary: Colors.white,
            onSecondary: Colors.black,
            onSurface: Colors.white,
            secondary: Color(0xffF0ABC1),
            surface: Color(0xff363636),
            primaryContainer: Color(0xff1c608f)),
        textTheme: TextTheme(
            bodyLarge: GoogleFonts.inter(
              textStyle: parentDarkTxtTheme.bodyLarge?.copyWith(
                  //color: ColorTheme.darkPrimaryTextColor,
                  //fontSize: FontSizeConstants.largeBody,
                  ),
            ),
            bodyMedium: GoogleFonts.inter(
              textStyle: parentDarkTxtTheme.bodyMedium?.copyWith(
                  //color: ColorTheme.darkPrimaryTextColor,
                  //fontSize: FontSizeConstants.smallBody,
                  ),
            ),
            bodySmall: GoogleFonts.inter(
              textStyle: parentDarkTxtTheme.bodySmall?.copyWith(
                  //color: ColorTheme.darkPrimaryTextColor,
                  //fontSize: FontSizeConstants.extraSmallBody,
                  ),
            ),
            titleLarge: GoogleFonts.inter(
              textStyle: parentDarkTxtTheme.titleLarge?.copyWith(
                  //color: ColorTheme.darkPrimaryTextColor,
                  //fontSize: FontSizeConstants.bigTitle,
                  ),
            ),
            titleMedium: GoogleFonts.inter(
              textStyle: parentDarkTxtTheme.titleMedium?.copyWith(
                  //color: ColorTheme.darkPrimaryTextColor,
                  //fontSize: FontSizeConstants.medTitle,
                  ),
            ),
            titleSmall: GoogleFonts.inter(
              textStyle: parentDarkTxtTheme.titleSmall?.copyWith(
                  //color: ColorTheme.darkPrimaryTextColor,
                  //fontSize: FontSizeConstants.smallTitle,
                  ),
            ),
            headlineSmall: GoogleFonts.inter(
              textStyle: parentDarkTxtTheme.headlineSmall?.copyWith(
                  //color: ColorTheme.darkPrimaryTextColor,
                  //fontSize: FontSizeConstants.smallHeading,
                  ),
            ),
            headlineMedium: GoogleFonts.inter(
              textStyle: parentDarkTxtTheme.headlineMedium?.copyWith(
                  //color: ColorTheme.darkPrimaryTextColor,
                  //fontSize: FontSizeConstants.medHeading,
                  ),
            ),
            headlineLarge: GoogleFonts.inter(
              textStyle: parentDarkTxtTheme.headlineLarge?.copyWith(
                  //color: ColorTheme.darkPrimaryTextColor,
                  // fontSize: FontSizeConstants.largeHeading,
                  ),
            ),
            labelLarge: GoogleFonts.inter(
              textStyle: parentDarkTxtTheme.labelLarge?.copyWith(
                  // color: ColorTheme.primaryTextColor,
                  // fontSize: FontSizeConstants.largeBody,
                  ),
            ),
            labelMedium: GoogleFonts.inter(
              textStyle: parentDarkTxtTheme.labelMedium?.copyWith(
                  // color: ColorTheme.primaryTextColor,
                  // fontSize: FontSizeConstants.largeBody,
                  ),
            ),
            labelSmall: GoogleFonts.inter(
              textStyle: parentDarkTxtTheme.labelSmall?.copyWith(
                  // color: ColorTheme.primaryTextColor,
                  // fontSize: FontSizeConstants.largeBody,
                  ),
            ),
            displayLarge: GoogleFonts.inter(
              textStyle: parentDarkTxtTheme.displayLarge?.copyWith(
                  // color: ColorTheme.primaryTextColor,
                  // fontSize: FontSizeConstants.largeBody,
                  ),
            ),
            displayMedium: GoogleFonts.inter(
              textStyle: parentDarkTxtTheme.displayMedium?.copyWith(
                  // color: ColorTheme.primaryTextColor,
                  // fontSize: FontSizeConstants.largeBody,
                  ),
            ),
            displaySmall: GoogleFonts.inter(
              textStyle: parentDarkTxtTheme.displaySmall?.copyWith(
                  // color: ColorTheme.primaryTextColor,
                  // fontSize: FontSizeConstants.largeBody,
                  ),
            )),
        brightness: Brightness.dark

        // next line is important!
        );
  }
}
