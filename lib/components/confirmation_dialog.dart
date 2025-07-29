import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mladez_zpevnik/dialogs/bottom_dialog_container.dart';
import 'package:mladez_zpevnik/theme/design_system.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.confirmText,
    this.cancelText = 'Zrušit',
    this.confirmColor,
    this.onConfirm,
    this.onCancel,
  });

  final String title;
  final String confirmText;
  final String cancelText;
  final Color? confirmColor;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return BottomDialogContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: AppSpacing.md),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  if (onConfirm != null) {
                    onConfirm!();
                  } else {
                    Get.back(result: true);
                  }
                },
                child: Text(
                  confirmText,
                  style: TextStyle(
                    color: confirmColor ?? AppColors.favorite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (onCancel != null) {
                    onCancel!();
                  } else {
                    Get.back(result: false);
                  }
                },
                child: Text(
                  cancelText,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}