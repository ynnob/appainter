// ignore_for_file: prefer_const_constructors
import 'dart:math';

import 'package:appainter/basic_theme/basic_theme.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:random_color_scheme/random_color_scheme.dart';

import '../utils.dart';

class MockBasicThemeService extends Mock implements BasicThemeService {}

void main() {
  late BasicThemeCubit cubit;
  late BasicThemeService service;

  late ColorScheme colorSchemeLight;
  late ColorScheme colorSchemeDark;
  late Color color;
  late int seed;

  setUpAll(() {
    colorSchemeLight = BasicThemeState.getColorScheme(false);
    colorSchemeDark = BasicThemeState.getColorScheme(true);
  });

  setUp(() {
    service = MockBasicThemeService();
    cubit = BasicThemeCubit(service: service);
    color = getRandomColor();
    seed = Random().nextInt(10);
  });

  group('test theme brightness', () {
    for (var isDark in [true, false]) {
      blocTest<BasicThemeCubit, BasicThemeState>(
        'should emit theme with isDark=$isDark',
        build: () => cubit,
        act: (cubit) => cubit.themeBrightnessChanged(isDark),
        expect: () => [
          BasicThemeState(
            colorScheme: isDark ? colorSchemeDark : colorSchemeLight,
            isDark: isDark,
          ),
        ],
      );
    }
  });

  group('test random theme', () {
    for (var isDark in [true, false]) {
      blocTest<BasicThemeCubit, BasicThemeState>(
        'should emit randomized theme with isDark=$isDark',
        seed: () => BasicThemeState(isDark: isDark),
        build: () => cubit,
        act: (cubit) => cubit.themeRandomized(seed),
        expect: () {
          final colorScheme = randomColorScheme(
            seed: seed,
            isDark: isDark,
            shouldPrint: false,
          );
          return [
            BasicThemeState(
              seedColor: colorScheme.primary,
              colorScheme: colorScheme,
              isDark: isDark,
            ),
          ];
        },
      );
    }
  });

  group('test default theme', () {
    for (var isDark in [true, false]) {
      blocTest<BasicThemeCubit, BasicThemeState>(
        'should emit default theme with isDark=$isDark',
        seed: () => BasicThemeState(
          colorScheme: isDark ? colorSchemeLight : colorSchemeDark,
          isDark: isDark,
        ),
        build: () => cubit,
        act: (cubit) => cubit.themeReset(),
        expect: () => [
          BasicThemeState(
            colorScheme: isDark ? colorSchemeDark : colorSchemeLight,
            isDark: isDark,
          ),
        ],
      );
    }
  });

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit seed color',
    build: () => cubit,
    act: (cubit) => cubit.seedColorChanged(color),
    expect: () => [
      BasicThemeState(
        seedColor: color,
        colorScheme: ColorScheme.fromSeed(seedColor: color),
      ),
    ],
  );

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit primary color',
    setUp: () {
      when(() => service.getOnKeyColor(color)).thenReturn(color);
      when(() => service.getContainerColor(color)).thenReturn(color);
      when(() => service.getOnContainerColor(color)).thenReturn(color);
    },
    build: () => cubit,
    act: (cubit) => cubit.primaryColorChanged(color),
    expect: () => [
      BasicThemeState(
        colorScheme: colorSchemeLight.copyWith(
          primary: color,
          onPrimary: color,
          primaryContainer: color,
          onPrimaryContainer: color,
        ),
      ),
    ],
  );

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit on primary color',
    build: () => cubit,
    act: (cubit) => cubit.onPrimaryColorChanged(color),
    expect: () => [
      BasicThemeState(colorScheme: colorSchemeLight.copyWith(onPrimary: color)),
    ],
  );

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit primary container color',
    setUp: () => when(() => service.getOnContainerColor(color)).thenReturn(
      color,
    ),
    build: () => cubit,
    act: (cubit) => cubit.primaryContainerColorChanged(color),
    expect: () => [
      BasicThemeState(
        colorScheme: colorSchemeLight.copyWith(
          primaryContainer: color,
          onPrimaryContainer: color,
        ),
      ),
    ],
  );

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit on primary container color',
    build: () => cubit,
    act: (cubit) => cubit.onPrimaryContainerColorChanged(color),
    expect: () => [
      BasicThemeState(
        colorScheme: colorSchemeLight.copyWith(onPrimaryContainer: color),
      ),
    ],
  );

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit secondary color',
    setUp: () {
      when(() => service.getOnKeyColor(color)).thenReturn(color);
      when(() => service.getContainerColor(color)).thenReturn(color);
      when(() => service.getOnContainerColor(color)).thenReturn(color);
    },
    build: () => cubit,
    act: (cubit) => cubit.secondaryColorChanged(color),
    expect: () => [
      BasicThemeState(
        colorScheme: colorSchemeLight.copyWith(
          secondary: color,
          onSecondary: color,
          secondaryContainer: color,
          onSecondaryContainer: color,
        ),
      )
    ],
  );

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit on secondary color',
    build: () => cubit,
    act: (cubit) => cubit.onSecondaryColorChanged(color),
    expect: () => [
      BasicThemeState(
        colorScheme: colorSchemeLight.copyWith(onSecondary: color),
      ),
    ],
  );

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit secondary container color',
    setUp: () => when(() => service.getOnContainerColor(color)).thenReturn(
      color,
    ),
    build: () => cubit,
    act: (cubit) => cubit.secondaryContainerColorChanged(color),
    expect: () => [
      BasicThemeState(
        colorScheme: colorSchemeLight.copyWith(
          secondaryContainer: color,
          onSecondaryContainer: color,
        ),
      ),
    ],
  );

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit on secondary container color',
    build: () => cubit,
    act: (cubit) => cubit.onSecondaryContainerColorChanged(color),
    expect: () => [
      BasicThemeState(
        colorScheme: colorSchemeLight.copyWith(onSecondaryContainer: color),
      ),
    ],
  );

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit tertiary color',
    setUp: () {
      when(() => service.getOnKeyColor(color)).thenReturn(color);
      when(() => service.getContainerColor(color)).thenReturn(color);
      when(() => service.getOnContainerColor(color)).thenReturn(color);
    },
    build: () => cubit,
    act: (cubit) => cubit.tertiaryColorChanged(color),
    expect: () => [
      BasicThemeState(
        colorScheme: colorSchemeLight.copyWith(
          tertiary: color,
          onTertiary: color,
          tertiaryContainer: color,
          onTertiaryContainer: color,
        ),
      )
    ],
  );

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit on tertiary color',
    build: () => cubit,
    act: (cubit) => cubit.onTertiaryColorChanged(color),
    expect: () => [
      BasicThemeState(
        colorScheme: colorSchemeLight.copyWith(onTertiary: color),
      ),
    ],
  );

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit tertiary container color',
    setUp: () => when(() => service.getOnContainerColor(color)).thenReturn(
      color,
    ),
    build: () => cubit,
    act: (cubit) => cubit.tertiaryContainerColorChanged(color),
    expect: () => [
      BasicThemeState(
        colorScheme: colorSchemeLight.copyWith(
          tertiaryContainer: color,
          onTertiaryContainer: color,
        ),
      ),
    ],
  );

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit on tertiary container color',
    build: () => cubit,
    act: (cubit) => cubit.onTertiaryContainerColorChanged(color),
    expect: () => [
      BasicThemeState(
        colorScheme: colorSchemeLight.copyWith(onTertiaryContainer: color),
      ),
    ],
  );

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit error color',
    setUp: () {
      when(() => service.getOnKeyColor(color)).thenReturn(color);
      when(() => service.getContainerColor(color)).thenReturn(color);
      when(() => service.getOnContainerColor(color)).thenReturn(color);
    },
    build: () => cubit,
    act: (cubit) => cubit.errorColorChanged(color),
    expect: () => [
      BasicThemeState(
        colorScheme: colorSchemeLight.copyWith(
          error: color,
          onError: color,
          errorContainer: color,
          onErrorContainer: color,
        ),
      )
    ],
  );

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit on error color',
    build: () => cubit,
    act: (cubit) => cubit.onErrorColorChanged(color),
    expect: () => [
      BasicThemeState(
        colorScheme: colorSchemeLight.copyWith(onError: color),
      ),
    ],
  );

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit error container color',
    setUp: () => when(() => service.getOnContainerColor(color)).thenReturn(
      color,
    ),
    build: () => cubit,
    act: (cubit) => cubit.errorContainerColorChanged(color),
    expect: () => [
      BasicThemeState(
        colorScheme: colorSchemeLight.copyWith(
          errorContainer: color,
          onErrorContainer: color,
        ),
      ),
    ],
  );

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit on error container color',
    build: () => cubit,
    act: (cubit) => cubit.onErrorContainerColorChanged(color),
    expect: () => [
      BasicThemeState(
        colorScheme: colorSchemeLight.copyWith(onErrorContainer: color),
      ),
    ],
  );

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit background color',
    setUp: () => when(() => service.getOnNeutralColor(color)).thenReturn(color),
    build: () => cubit,
    act: (cubit) => cubit.backgroundColorChanged(color),
    expect: () => [
      BasicThemeState(
        colorScheme: colorSchemeLight.copyWith(
          background: color,
          onBackground: color,
        ),
      ),
    ],
  );

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit on background color',
    build: () => cubit,
    act: (cubit) => cubit.onBackgroundColorChanged(color),
    expect: () => [
      BasicThemeState(
        colorScheme: colorSchemeLight.copyWith(onBackground: color),
      ),
    ],
  );

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit surface color',
    setUp: () => when(() => service.getOnNeutralColor(color)).thenReturn(color),
    build: () => cubit,
    act: (cubit) => cubit.surfaceColorChanged(color),
    expect: () => [
      BasicThemeState(
        colorScheme: colorSchemeLight.copyWith(
          surface: color,
          onSurface: color,
        ),
      ),
    ],
  );

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit on surface color',
    build: () => cubit,
    act: (cubit) => cubit.onSurfaceColorChanged(color),
    expect: () => [
      BasicThemeState(
        colorScheme: colorSchemeLight.copyWith(onSurface: color),
      ),
    ],
  );

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit surface variant color',
    setUp: () => when(() => service.getOnSurfaceVariantColor(color)).thenReturn(
      color,
    ),
    build: () => cubit,
    act: (cubit) => cubit.surfaceVariantColorChanged(color),
    expect: () => [
      BasicThemeState(
        colorScheme: colorSchemeLight.copyWith(
          surfaceVariant: color,
          onSurfaceVariant: color,
        ),
      ),
    ],
  );

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit on surface variant color',
    build: () => cubit,
    act: (cubit) => cubit.onSurfaceVariantColorChanged(color),
    expect: () => [
      BasicThemeState(
        colorScheme: colorSchemeLight.copyWith(onSurfaceVariant: color),
      ),
    ],
  );

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit outline color',
    build: () => cubit,
    act: (cubit) => cubit.outlineColorChanged(color),
    expect: () => [
      BasicThemeState(colorScheme: colorSchemeLight.copyWith(outline: color)),
    ],
  );

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit shadow color',
    build: () => cubit,
    act: (cubit) => cubit.shadowColorChanged(color),
    expect: () => [
      BasicThemeState(colorScheme: colorSchemeLight.copyWith(shadow: color)),
    ],
  );

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit inverse surface color',
    build: () => cubit,
    act: (cubit) => cubit.inverseSurfaceColorChanged(color),
    expect: () => [
      BasicThemeState(
        colorScheme: colorSchemeLight.copyWith(inverseSurface: color),
      ),
    ],
  );

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit on inverse surface color',
    build: () => cubit,
    act: (cubit) => cubit.onInverseSurfaceColorChanged(color),
    expect: () => [
      BasicThemeState(
        colorScheme: colorSchemeLight.copyWith(onInverseSurface: color),
      ),
    ],
  );

  blocTest<BasicThemeCubit, BasicThemeState>(
    'should emit inverse primary color',
    build: () => cubit,
    act: (cubit) => cubit.inversePrimaryColorChanged(color),
    expect: () => [
      BasicThemeState(
        colorScheme: colorSchemeLight.copyWith(inversePrimary: color),
      ),
    ],
  );
  group('test use material 3', () {
    for (var useMaterial3 in [true, false]) {
      blocTest<BasicThemeCubit, BasicThemeState>(
        'should emit useMaterial3=$useMaterial3',
        build: () => cubit,
        seed: () => BasicThemeState(useMaterial3: !useMaterial3),
        act: (cubit) => cubit.useMaterial3Changed(useMaterial3),
        expect: () => [BasicThemeState(useMaterial3: useMaterial3)],
      );
    }
  });
}
