import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme/values/values.dart';

class SnackbarMenager {
  void _show(
      {required BuildContext context,
      required String message,
      required IconData? icon,
      Duration? duration,
      Color? backgroundColor}) {
    final snackbar = SnackBar(
      duration: duration ?? const Duration(seconds: 15),
      backgroundColor: backgroundColor,
      content: Row(
        children: [
          Icon(
            icon ?? Icons.message_outlined,
            color: Colors.white60,
            size: 40,
          ),
          const SizedBox(width: Sizes.DIVISIONS),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.openSans(
                  color: Colors.white60, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            tooltip: "Fechar",
            icon: const Icon(
              Icons.close,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  showError(BuildContext context, String message, {Duration? duration}) =>
      _show(
        context: context,
        message: message,
        icon: Icons.dangerous_outlined,
        backgroundColor: AppColors.dangerColor,
        duration: duration,
      );

  showWarning(BuildContext context, String message, {Duration? duration}) =>
      _show(
        context: context,
        message: message,
        icon: Icons.warning_amber_rounded,
        backgroundColor: AppColors.warningColor,
        duration: duration,
      );

  showInfo(BuildContext context, String message, {Duration? duration}) => _show(
        context: context,
        message: message,
        icon: Icons.info_outlined,
        backgroundColor: AppColors.infoColor,
        duration: duration,
      );

  showSuccess(BuildContext context, String message, {Duration? duration}) =>
      _show(
        context: context,
        message: message,
        icon: Icons.task_alt_rounded,
        backgroundColor: AppColors.successColor,
        duration: duration,
      );
}
