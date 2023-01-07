import 'package:flutter/material.dart';

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
    required this.text,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final Text text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.secondary,
      elevation: 4.0,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: text,
      ),
    );
  }
}

@immutable
class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    this.onPressed,
    required this.text,
  });

  final VoidCallback? onPressed;
  final Widget text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.secondary,
      elevation: 4.0,
      child: TextButton(
        onPressed: onPressed,
        child: text,
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(theme.colorScheme.secondary)),
      ),
    );
  }
}
