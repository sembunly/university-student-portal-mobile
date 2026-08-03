import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static CupertinoThemeData get light {
    const defaults = CupertinoTextThemeData();

    return CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.blue,
      scaffoldBackgroundColor: AppColors.background,
      barBackgroundColor: const Color(0xF2F7F8FC),
      textTheme: CupertinoTextThemeData(
        textStyle: _nunito(
          defaults.textStyle.copyWith(color: AppColors.ink, fontSize: 16),
        ),
        actionTextStyle: _nunito(defaults.actionTextStyle),
        tabLabelTextStyle: _nunito(defaults.tabLabelTextStyle),
        navTitleTextStyle: _nunito(defaults.navTitleTextStyle),
        navLargeTitleTextStyle: _nunito(defaults.navLargeTitleTextStyle),
        navActionTextStyle: _nunito(defaults.navActionTextStyle),
        pickerTextStyle: _nunito(defaults.pickerTextStyle),
        dateTimePickerTextStyle: _nunito(defaults.dateTimePickerTextStyle),
      ),
    );
  }

  static TextStyle _nunito(TextStyle style) {
    return GoogleFonts.nunito(textStyle: style);
  }
}
