import 'package:cric_spot/core/extensions/color_extension.dart';
import 'package:flutter/material.dart';

class CricCard extends StatelessWidget {
  const CricCard({
    super.key,
    required this.child,
    this.elevation,
    this.color,
    this.shape,
  });

  final Widget child;
  final Color? color;
  final double? elevation;
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
      color: color ?? context.surfaceVariant,
      clipBehavior: Clip.antiAlias,
      elevation: elevation ?? 2.0,
      shadowColor: color ?? context.shadow,
      child: child,
    );
  }
}

class CricOutlineCard extends StatelessWidget {
  const CricOutlineCard(
      {super.key, required this.child, this.shape, this.color});

  final Widget child;
  final ShapeBorder? shape;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              width: 1,
              color: context.outline,
            ),
          ),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: color ?? context.surface,
      shadowColor: context.shadow,
      child: child,
    );
  }
}

class CricFilledCard extends StatelessWidget {
  const CricFilledCard({
    super.key,
    required this.child,
    this.shape,
    this.color,
  });

  final Widget child;
  final Color? color;
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: color ?? context.surfaceVariant,
      shadowColor: context.shadow,
      child: child,
    );
  }
}
