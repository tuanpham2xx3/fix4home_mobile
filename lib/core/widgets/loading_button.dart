import 'package:flutter/material.dart';

/// A reusable button widget that displays a loading indicator inside the button
/// when loading, replacing the text.
///
/// Supports two usage patterns:
/// 1. Self-managed loading: Provide [onPressedAsync] to let the button manage loading state
/// 2. External loading state: Provide [onPressed] and [isLoading] for external state management
class LoadingButton extends StatefulWidget {
  /// The text to display on the button
  final String text;

  /// Self-managed loading: Async function that the button will call and manage loading for
  final Future<void> Function()? onPressedAsync;

  /// External loading state: Callback function
  final VoidCallback? onPressed;

  /// External loading state: Whether the button is currently loading
  final bool isLoading;

  /// Background color of the button
  final Color? backgroundColor;

  /// Foreground color (text and icon color) of the button
  final Color? foregroundColor;

  /// Padding inside the button
  final EdgeInsets? padding;

  /// Border radius of the button
  final double? borderRadius;

  /// Text style for the button text
  final TextStyle? textStyle;

  /// Optional icon to display before the text
  final Widget? icon;

  /// Size of the loading indicator
  final double loadingIndicatorSize;

  /// Color of the loading indicator
  final Color? loadingIndicatorColor;

  /// Stroke width of the loading indicator
  final double loadingIndicatorStrokeWidth;

  const LoadingButton({
    super.key,
    required this.text,
    this.onPressedAsync,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.borderRadius,
    this.textStyle,
    this.icon,
    this.loadingIndicatorSize = 20,
    this.loadingIndicatorColor,
    this.loadingIndicatorStrokeWidth = 2,
  });

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _internalLoading = false;

  bool get _isLoading {
    // If onPressedAsync is provided, use internal loading state
    if (widget.onPressedAsync != null) {
      return _internalLoading;
    }
    // Otherwise, use external loading state
    return widget.isLoading;
  }

  VoidCallback? get _onPressed {
    if (_isLoading) {
      return null;
    }

    if (widget.onPressedAsync != null) {
      return () async {
        setState(() {
          _internalLoading = true;
        });
        try {
          await widget.onPressedAsync!();
        } finally {
          if (mounted) {
            setState(() {
              _internalLoading = false;
            });
          }
        }
      };
    }

    return widget.onPressed;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.backgroundColor ?? const Color(0xFFFF9800);
    final foregroundColor = widget.foregroundColor ?? Colors.white;
    final padding = widget.padding ?? const EdgeInsets.symmetric(vertical: 16);
    final borderRadius = widget.borderRadius ?? 12;
    final loadingColor = widget.loadingIndicatorColor ?? foregroundColor;

    return ElevatedButton(
      onPressed: _onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        disabledBackgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        disabledForegroundColor: foregroundColor,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 0,
      ),
      child: _isLoading
          ? SizedBox(
              height: widget.loadingIndicatorSize,
              width: widget.loadingIndicatorSize,
              child: CircularProgressIndicator(
                strokeWidth: widget.loadingIndicatorStrokeWidth,
                valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
              ),
            )
          : widget.icon != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.icon!,
                    const SizedBox(width: 8),
                    Text(
                      widget.text,
                      style: widget.textStyle ??
                          const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                )
              : Text(
                  widget.text,
                  style: widget.textStyle ??
                      const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                ),
    );
  }
}

