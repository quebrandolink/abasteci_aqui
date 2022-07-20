import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme/values/values.dart';

class BannerMenager {
  void _show({
    required BuildContext context,
    required String message,
    required IconData? icon,
    Color? backgroundColor,
    List<Widget>? actions,
  }) {
    final banner = MaterialBanner(
      backgroundColor: backgroundColor,
      actions: (actions != null)
          ? actions
          : [
              TextButton(
                style: TextButton.styleFrom(primary: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                },
                child: const Text("Fechar"),
              ),
            ],
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
        ],
      ),
    );
    ScaffoldMessenger.of(context).showMaterialBanner(banner);
  }

  showError(GlobalKey scaffoldKey, String message,
          {IconData? icon, List<Widget>? actions}) =>
      _show(
          context: scaffoldKey.currentContext!,
          message: message,
          icon: icon ?? Icons.dangerous_outlined,
          backgroundColor: AppColors.dangerColor,
          actions: actions);

  showWarning(GlobalKey scaffoldKey, String message,
          {IconData? icon, List<Widget>? actions}) =>
      _show(
          context: scaffoldKey.currentContext!,
          message: message,
          icon: icon ?? Icons.warning_amber_rounded,
          backgroundColor: AppColors.warningColor,
          actions: actions);

  showInfo(GlobalKey scaffoldKey, String message,
          {IconData? icon, List<Widget>? actions}) =>
      _show(
          context: scaffoldKey.currentContext!,
          message: message,
          icon: icon ?? Icons.info_outlined,
          backgroundColor: AppColors.infoColor,
          actions: actions);

  showSuccess(GlobalKey scaffoldKey, String message,
          {IconData? icon, List<Widget>? actions}) =>
      _show(
          context: scaffoldKey.currentContext!,
          message: message,
          icon: icon ?? Icons.task_alt_rounded,
          backgroundColor: AppColors.successColor,
          actions: actions);
}
