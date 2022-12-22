import 'dart:math';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

extension StringValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  bool isValidPassword() {
    if (kReleaseMode) {
      if (this.length < 6) return false;
      if (!this.contains(RegExp(r"[a-z]"))) return false;
      if (!this.contains(RegExp(r"[A-Z]"))) return false;
      if (!this.contains(RegExp(r"[0-9]"))) return false;
      return true;
    } else {
      return true;
    }
  }

  String? removeAllWhitespace() {
    return this.replaceAll(new RegExp(r"\s+\b|\b\s|\s|\b"), "");
  }
}

class ExtensionMethod {
  static int random(min, max) {
    return min + Random().nextInt(max - min);
  }

  static int uniqueNotificationId() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static Uint8List imageFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
}

extension DynamicExtension on Map {
  Map parseApiResponse() {
    if (this != null) {
      this["created_at"] = this["created_at"].toString();
      this["updated_at"] = this["updated_at"].toString();
      this["id"] = this["_id"];
      this["subCategoryId"] != null
          ? this["subCategory"] = this["subCategoryId"]
          : 1;
      return this;
    }
    return this;
  }

  Map parseDate() {
    if (this != null) {
      this["created_at"] = this["created_at"]["\$date"]["\$numberLong"];
      this["updated_at"] = this["updated_at"]["\$date"]["\$numberLong"];
      return this;
    }
    return this;
  }

  Map parseId() {
    this["id"] = this["_id"]["\$oid"];
    this["category"] != null ? this["category"] = this["category"]["\$oid"] : 1;
    this["subCategoryId"] != null
        ? this["subCategory"] = this["subCategoryId"]["\$oid"]
        : 1;
    this["lessonId"] != null ? this["lessonId"] = this["lessonId"]["\$oid"] : 1;
    this["wordId"] != null ? this["wordId"] = this["wordId"]["\$oid"] : 1;
    this["wordIdOne"] != null
        ? this["wordIdOne"] = this["wordIdOne"]["\$oid"]
        : 1;
    return this;
  }
}

extension StringOptionalValidator on String? {
  bool isNotNullOrEmpty() {
    return this != null && this != "";
  }

  DateTime? parseMongoDBDate(
      {String currentFormat = "yyyy-MM-ddTHH:mm:ssZ",
      String desiredFormat = "yyyy-MM-dd HH:mm:ss",
      isUtc = false}) {
    DateTime? dateTime = DateTime.now();
    if (this != null || this!.isNotEmpty) {
      try {
        dateTime = DateFormat(currentFormat).parse(this!, isUtc).toLocal();
      } catch (e) {
        print("$e");
      }
    }
    return dateTime;
  }

  String? replaceCharAt(int index, String newChar) {
    if (this != null) {
      return (this!.substring(0, index) + newChar + this!.substring(index + 1));
    }
    return this;
  }

  String? removeAllWhitespace() {
    // Remove all white space.
    if (this != null) {
      return this!.replaceAll(new RegExp(r"\s+\b|\b\s|\s|\b"), "");
    }
    return this;
  }
}

typedef CallBack<T, E> = void Function(T value, E value2);

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}
