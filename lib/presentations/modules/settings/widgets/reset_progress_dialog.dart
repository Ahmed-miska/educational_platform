import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/app_theme/colors_theme.dart';
import '../../../../core/resources/app_translate.dart';
import '../../../../core/resources/font_size.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../progress_view_model.dart';

class ResetProgressDialog extends StatelessWidget {
  const ResetProgressDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: CustomText(title: AppTranslate.resetProgressConfirm, fontSize: AppFonts.font16),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(AppTranslate.cancel)),
        TextButton(
          onPressed: () => context.read<ProgressViewModel>().confirmResetProgress(),
          child: Text(AppTranslate.confirm, style: TextStyle(color: AppColors.error(context))),
        ),
      ],
    );
  }
}
