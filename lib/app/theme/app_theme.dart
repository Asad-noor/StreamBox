import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:streambox/app/theme/app_colors.dart';
import 'package:streambox/app/theme/app_radius.dart';
import 'package:streambox/app/theme/app_spacing.dart';
import 'package:streambox/app/theme/app_typography.dart';

/// Assembles the design tokens into the Material theme.
///
/// The application is dark-only by design: an OTT catalogue is displayed
/// against black so that artwork carries the colour. There is deliberately no
/// light theme to maintain.
abstract final class AppTheme {
  static ThemeData get dark {
    final colorScheme = _colorScheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      fontFamily: AppTypography.fontFamily,
      textTheme: AppTypography.textTheme,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: _appBarTheme,
      bottomSheetTheme: _bottomSheetTheme,
      cardTheme: _cardTheme,
      chipTheme: _chipTheme,
      dialogTheme: _dialogTheme,
      dividerTheme: _dividerTheme,
      filledButtonTheme: _filledButtonTheme,
      iconTheme: _iconTheme,
      inputDecorationTheme: _inputDecorationTheme,
      listTileTheme: _listTileTheme,
      navigationBarTheme: _navigationBarTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      pageTransitionsTheme: _pageTransitionsTheme,
      progressIndicatorTheme: _progressIndicatorTheme,
      snackBarTheme: _snackBarTheme,
      textButtonTheme: _textButtonTheme,
      textSelectionTheme: _textSelectionTheme,
    );
  }

  /// Light status-bar icons on a transparent bar, so hero artwork can run to
  /// the top edge of the screen.
  static const SystemUiOverlayStyle systemOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: AppColors.background,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  static const ColorScheme _colorScheme = ColorScheme.dark(
    primary: AppColors.red,
    onPrimary: AppColors.onRed,
    primaryContainer: AppColors.redPressed,
    onPrimaryContainer: AppColors.onRed,
    secondary: AppColors.textSecondary,
    onSecondary: AppColors.background,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    surfaceContainerHighest: AppColors.surfaceMuted,
    surfaceContainerHigh: AppColors.surfaceElevated,
    onSurfaceVariant: AppColors.textSecondary,
    error: AppColors.error,
    onError: AppColors.onRed,
    outline: AppColors.border,
    outlineVariant: AppColors.divider,
  );

  static final AppBarTheme _appBarTheme = AppBarTheme(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    foregroundColor: AppColors.textPrimary,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    systemOverlayStyle: systemOverlayStyle,
    titleTextStyle: AppTypography.headlineMedium,
  );

  static final NavigationBarThemeData _navigationBarTheme =
      NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.redSubtle,
        elevation: 0,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: const WidgetStatePropertyAll(
          IconThemeData(size: 24, color: AppColors.textTertiary),
        ),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
            color: AppColors.textTertiary,
          ),
        ),
      );

  static const CardThemeData _cardTheme = CardThemeData(
    color: AppColors.surface,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    margin: EdgeInsets.zero,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
  );

  static const DividerThemeData _dividerTheme = DividerThemeData(
    color: AppColors.divider,
    thickness: 1,
    space: 1,
  );

  static const IconThemeData _iconTheme = IconThemeData(
    color: AppColors.textPrimary,
    size: 24,
  );

  static const ProgressIndicatorThemeData _progressIndicatorTheme =
      ProgressIndicatorThemeData(
        color: AppColors.red,
        linearTrackColor: AppColors.surfaceMuted,
        circularTrackColor: Colors.transparent,
      );

  static const TextSelectionThemeData _textSelectionTheme =
      TextSelectionThemeData(
        cursorColor: AppColors.red,
        selectionColor: AppColors.redSubtle,
        selectionHandleColor: AppColors.red,
      );

  static final ChipThemeData _chipTheme = ChipThemeData(
    backgroundColor: AppColors.surfaceElevated,
    selectedColor: AppColors.red,
    side: const BorderSide(color: AppColors.border),
    labelStyle: AppTypography.textTheme.labelMedium,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.sm,
      vertical: AppSpacing.xxs,
    ),
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.allPill),
  );

  static final BottomSheetThemeData _bottomSheetTheme = BottomSheetThemeData(
    backgroundColor: AppColors.surfaceElevated,
    surfaceTintColor: Colors.transparent,
    modalBarrierColor: Colors.black.withValues(alpha: 0.6),
    showDragHandle: true,
    dragHandleColor: AppColors.textTertiary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
  );

  static final DialogThemeData _dialogTheme = DialogThemeData(
    backgroundColor: AppColors.surfaceElevated,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: AppTypography.textTheme.titleLarge,
    contentTextStyle: AppTypography.textTheme.bodyMedium,
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.allLg),
  );

  static final ListTileThemeData _listTileTheme = ListTileThemeData(
    iconColor: AppColors.textSecondary,
    textColor: AppColors.textPrimary,
    titleTextStyle: AppTypography.textTheme.titleSmall,
    subtitleTextStyle: AppTypography.textTheme.bodySmall,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.pageGutter,
      vertical: AppSpacing.xxs,
    ),
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.allMd),
  );

  static final SnackBarThemeData _snackBarTheme = SnackBarThemeData(
    backgroundColor: AppColors.surfaceElevated,
    contentTextStyle: AppTypography.textTheme.bodyMedium?.copyWith(
      color: AppColors.textPrimary,
    ),
    actionTextColor: AppColors.red,
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.allMd),
  );

  static final InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceElevated,
        hintStyle: AppTypography.textTheme.bodyMedium?.copyWith(
          color: AppColors.textTertiary,
        ),
        prefixIconColor: AppColors.textTertiary,
        suffixIconColor: AppColors.textTertiary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        border: _inputBorder(AppColors.border),
        enabledBorder: _inputBorder(AppColors.border),
        focusedBorder: _inputBorder(AppColors.red),
        errorBorder: _inputBorder(AppColors.error),
        focusedErrorBorder: _inputBorder(AppColors.error),
      );

  static final FilledButtonThemeData _filledButtonTheme = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.red,
      foregroundColor: AppColors.onRed,
      disabledBackgroundColor: AppColors.surfaceMuted,
      disabledForegroundColor: AppColors.textTertiary,
      minimumSize: const Size(0, _minimumTouchTarget),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      textStyle: AppTypography.textTheme.labelLarge,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.allSm),
    ),
  );

  static final OutlinedButtonThemeData _outlinedButtonTheme =
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border),
          minimumSize: const Size(0, _minimumTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          textStyle: AppTypography.textTheme.labelLarge,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.allSm),
        ),
      );

  static final TextButtonThemeData _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.red,
      minimumSize: const Size(0, _minimumTouchTarget),
      textStyle: AppTypography.textTheme.labelLarge,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.allSm),
    ),
  );

  static const PageTransitionsTheme _pageTransitionsTheme =
      PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      );

  /// The Material accessibility minimum for interactive targets.
  static const double _minimumTouchTarget = 48;

  static OutlineInputBorder _inputBorder(Color color) => OutlineInputBorder(
    borderRadius: AppRadius.allSm,
    borderSide: BorderSide(color: color),
  );
}
