import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialLoginController {
  static GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  static FacebookAuth facebookAuth = FacebookAuth.instance;
}
