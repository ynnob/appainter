import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_theme/common/common.dart';
import 'package:flutter_theme/cubits/cubits.dart';
import 'package:flutter_theme/models/models.dart';
import 'package:flutter_theme/widgets/widgets.dart';

class TabBarEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      header: 'Tab Bar',
      children: [
        SideBySideList(
          children: [
            _LabelColorPicker(),
            _UnselectedLabelColorPicker(),
            _IndicatorSizeDropdown(),
          ],
        ),
      ],
    );
  }
}

class _LabelColorPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvancedThemeCubit, AdvancedThemeState>(
      buildWhen: (previous, current) {
        return previous.themeData.tabBarTheme.labelColor !=
            current.themeData.tabBarTheme.labelColor;
      },
      builder: (context, state) {
        return ColorListTile(
          title: 'Label Color',
          color: state.themeData.tabBarTheme.labelColor ??
              state.themeData.primaryTextTheme.bodyText1!.color!,
          onColorChanged: (color) {
            context.read<AdvancedThemeCubit>().tabBarLabelColorChanged(color);
          },
        );
      },
    );
  }
}

class _UnselectedLabelColorPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvancedThemeCubit, AdvancedThemeState>(
      buildWhen: (previous, current) {
        return previous.themeData.tabBarTheme.unselectedLabelColor !=
            current.themeData.tabBarTheme.unselectedLabelColor;
      },
      builder: (context, state) {
        final labelColor = state.themeData.tabBarTheme.labelColor ??
            state.themeData.primaryTextTheme.bodyText1!.color!;

        return ColorListTile(
          title: 'Unselected Label Color',
          color: state.themeData.tabBarTheme.unselectedLabelColor ??
              labelColor.withOpacity(kTabBarUnselectedColorOpacity),
          onColorChanged: (color) {
            context
                .read<AdvancedThemeCubit>()
                .tabBarUnselectedLabelColorChanged(color);
          },
        );
      },
    );
  }
}

class _IndicatorSizeDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvancedThemeCubit, AdvancedThemeState>(
      buildWhen: (previous, current) {
        return previous.themeData.tabBarTheme.indicatorSize !=
            current.themeData.tabBarTheme.indicatorSize;
      },
      builder: (context, state) {
        final size = state.themeData.tabBarTheme.indicatorSize ??
            TabBarIndicatorSize.tab;
        return DropdownListTile(
          title: 'Type',
          value: MyTabBarIndicatorSize().stringFromEnum(size),
          values: MyTabBarIndicatorSize().names,
          onChanged: (value) {
            context
                .read<AdvancedThemeCubit>()
                .tabBarIndicatorSizeChanged(value!);
          },
        );
      },
    );
  }
}
