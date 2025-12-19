import 'package:flutter/material.dart';
import 'package:kareem_tarek/core/utils/app_constants.dart';

abstract class Styles {
  static TextStyle styleRegular14(BuildContext context) {
    return TextStyle(
      fontSize: getResoponsiveFontSize(context, fontSize: 14),
      fontWeight: FontWeight.w400,
      fontFamily: AppConstants.font,
      color: const Color(0xff00060D),
    );
  }

  static TextStyle styleMedium16(BuildContext context) {
    return TextStyle(
      fontSize: getResoponsiveFontSize(context, fontSize: 16),
      fontWeight: FontWeight.w500,
      fontFamily: AppConstants.font,
      color: const Color(0xff00060D),
    );
  }

  static TextStyle styleMedium12(BuildContext context) {
    return TextStyle(
      fontSize: getResoponsiveFontSize(context, fontSize: 12),
      fontWeight: FontWeight.w500,
      fontFamily: AppConstants.font,
      color: const Color(0xff00060D),
    );
  }

  static TextStyle styleRegular12(BuildContext context) {
    return TextStyle(
      fontSize: getResoponsiveFontSize(context, fontSize: 12),
      fontWeight: FontWeight.w400,
      fontFamily: AppConstants.font,
      color: const Color(0xff00060D),
    );
  }

  static TextStyle styleBold16(BuildContext context) {
    return TextStyle(
      fontSize: getResoponsiveFontSize(context, fontSize: 16),
      fontWeight: FontWeight.w700,
      fontFamily: AppConstants.font,
      color: const Color(0xff00060D),
    );
  }

  static TextStyle styleBold22(BuildContext context) {
    return TextStyle(
      fontSize: getResoponsiveFontSize(context, fontSize: 22),
      fontWeight: FontWeight.w700,
      fontFamily: AppConstants.font,
      color: const Color(0xff00060D),
    );
  }

  static TextStyle styleBold24(BuildContext context) {
    return TextStyle(
      fontSize: getResoponsiveFontSize(context, fontSize: 24),
      fontWeight: FontWeight.w700,
      fontFamily: AppConstants.font,
      color: const Color(0xff00060D),
    );
  }

  static TextStyle styleRegular16(BuildContext context) {
    return TextStyle(
      fontSize: getResoponsiveFontSize(context, fontSize: 16),
      fontWeight: FontWeight.w400,
      fontFamily: AppConstants.font,
      color: const Color(0xff00060D),
    );
  }

  static TextStyle styleBold19(BuildContext context) {
    return TextStyle(
      fontSize: getResoponsiveFontSize(context, fontSize: 19),
      fontWeight: FontWeight.w700,
      fontFamily: AppConstants.font,
      color: const Color(0xff00060D),
    );
  }

  static TextStyle styleBold18(BuildContext context) {
    return TextStyle(
      fontSize: getResoponsiveFontSize(context, fontSize: 18),
      fontWeight: FontWeight.w700,
      fontFamily: AppConstants.font,
      color: const Color(0xff00060D),
    );
  }

  static TextStyle styleMedium14(BuildContext context) {
    return TextStyle(
      fontSize: getResoponsiveFontSize(context, fontSize: 14),
      fontWeight: FontWeight.w500,
      fontFamily: AppConstants.font,
      color: const Color(0xff00060D),
    );
  }

  static TextStyle styleRegular9(BuildContext context) {
    return TextStyle(
      fontSize: getResoponsiveFontSize(context, fontSize: 9),
      fontWeight: FontWeight.w400,
      fontFamily: AppConstants.font,
      color: const Color(0xff00060D),
    );
  }

  static TextStyle styleMedium19(BuildContext context) {
    return TextStyle(
      fontSize: getResoponsiveFontSize(context, fontSize: 19),
      fontWeight: FontWeight.w500,
      fontFamily: AppConstants.font,
      color: const Color(0xff00060D),
    );
  }
}

double getResoponsiveFontSize(
  BuildContext context, {
  required double fontSize,
}) {
  double scaleFactor = getScaleFactor(context);
  double responsiveFotSize = fontSize * scaleFactor;

  double lowerLimit = fontSize * .8;
  double upperLimit = fontSize * 1.2;

  return responsiveFotSize.clamp(lowerLimit, upperLimit);
}

double getScaleFactor(BuildContext context) {
  double width = MediaQuery.sizeOf(context).width;

  return width / 400;
}
