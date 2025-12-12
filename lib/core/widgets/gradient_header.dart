import 'package:flutter/material.dart';

/// A reusable yellow gradient header widget that can be used across different screens.
/// 
/// This widget provides a consistent header design with a yellow gradient fade effect
/// that matches the app's design system.
class GradientHeader extends StatelessWidget {
  /// The title text to display in the header
  final String title;
  
  /// Whether to show a back button
  final bool showBackButton;
  
  /// Custom action when back button is pressed
  /// If null, will use Navigator.pop(context)
  final VoidCallback? onBackPressed;
  
  /// Custom widget to display on the left side (replaces back button if provided)
  final Widget? leading;
  
  /// Custom widgets to display on the right side
  final List<Widget>? actions;
  
  /// Padding for the header content
  final EdgeInsetsGeometry? padding;

  const GradientHeader({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBackPressed,
    this.leading,
    this.actions,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.only(top: 20, bottom: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFD54F),
            Color(0xFFFFC107),
            Color(0xCCFFC107),
            Color(0x99FFC107),
            Color(0x66FFC107),
            Color(0x33FFC107),
            Color(0x10FFC107),
            Colors.transparent,
          ],
          stops: [0.0, 0.2, 0.4, 0.55, 0.7, 0.85, 0.95, 1.0],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Left side: back button or custom leading
          if (showBackButton || leading != null)
            Positioned(
              left: 16,
              child: leading ??
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black87,
                    ),
                    onPressed: onBackPressed ?? () => Navigator.pop(context),
                  ),
            ),
          // Center: title
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: (showBackButton || leading != null) ? 60 : 16,
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Right side: actions
          if (actions != null && actions!.isNotEmpty)
            Positioned(
              right: 16,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: actions!,
              ),
            ),
        ],
      ),
    );
  }
}

