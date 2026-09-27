import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/app_theme/app_colors.dart';
import '../../../../core/dimens/dimens.dart';
import '../../../../core/resources/app_translate.dart';
import '../courses_view_model.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimens.radius12),
      borderSide: BorderSide(color: AppColors.stroke(context)),
    );
    return Consumer<CoursesViewModel>(
      builder: (context, viewModel, child) {
        return TextField(
          controller: viewModel.searchController,
          textInputAction: TextInputAction.search,
          onChanged: viewModel.onSearchChanged,
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          decoration: InputDecoration(
            hintText: AppTranslate.searchCourses,
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: viewModel.hasSearchText
                ? IconButton(icon: const Icon(Icons.close_rounded), onPressed: viewModel.clearSearch)
                : const SizedBox.shrink(),
            filled: true,
            fillColor: AppColors.white(context),
            contentPadding: const EdgeInsets.symmetric(vertical: Dimens.padding12),
            border: border,
            enabledBorder: border,
            focusedBorder: border.copyWith(borderSide: BorderSide(color: AppColors.mainColor(context))),
          ),
        );
      },
    );
  }
}
