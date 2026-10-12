import 'package:flutter/material.dart';
import 'package:rakshaa/core/constants/app_colors.dart';
import 'package:rakshaa/core/constants/app_constants.dart';

enum ActionType { call, sms, whatsapp }

void showContactActionSheet(BuildContext context, {
  required String name,
  required String phone,
  required ActionType actionType,
}) {
  String title;
  String text;
  String successMessage;
  String actionText;
  Color actionColor;

  switch (actionType) {
    case ActionType.call:
      title = "Call $name?";
      text = phone;
      successMessage = "Demo call action";
      actionText = "Call";
      actionColor = AppColors.rakshaaCoral;
      break;
    case ActionType.sms:
      title = "Send SMS to $name?";
      text = "Emergency communication will be available here.";
      successMessage = "SMS action is ready for future integration.";
      actionText = "Continue";
      actionColor = Colors.blueAccent;
      break;
    case ActionType.whatsapp:
      title = "WhatsApp $name?";
      text = "Rakshaa WhatsApp alerts will be connected here later.";
      successMessage = "WhatsApp action is ready for future integration.";
      actionText = "Continue";
      actionColor = AppColors.softGreen;
      break;
  }

  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.deepNavy,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              text,
              style: TextStyle(
                fontSize: actionType == ActionType.call ? 24 : 14,
                fontWeight: actionType == ActionType.call ? FontWeight.bold : FontWeight.normal,
                color: actionType == ActionType.call ? AppColors.rakshaaCoral : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    child: const Text("Cancel", style: TextStyle(color: AppColors.deepNavy)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(successMessage)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: actionColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    child: Text(actionText, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
