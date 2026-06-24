import 'package:flutter/material.dart';

enum AppButtonType { filled, outlined, duoTone }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.label,
    this.icon,
    this.color,
    this.onPressed,
    this.height,
    this.width,
    this.borderRadius,
    this.type = AppButtonType.filled,
    this.labelStyle,
    this.isFullWidth = false,
    this.loading = false,
  });

  final String?        label;
  final IconData?      icon;
  final Color?         color;
  final VoidCallback?  onPressed;
  final double?        height;
  final double?        width;
  final BorderRadius?  borderRadius;
  final AppButtonType  type;
  final TextStyle?     labelStyle;
  final bool           isFullWidth;
  final bool           loading;

  @override
  Widget build(BuildContext context) {
    final base  = color ?? Theme.of(context).colorScheme.primary;
    final h     = height ?? 46.0;

    Color typo, bg, border;
    double borderWidth;

    switch (type) {
      case AppButtonType.filled:
        typo        = Colors.white;
        bg          = base;
        border      = Colors.transparent;
        borderWidth = 0;
      case AppButtonType.duoTone:
        typo        = base;
        bg          = base.withAlpha(30);
        border      = base.withAlpha(10);
        borderWidth = 1.5;
      case AppButtonType.outlined:
        typo        = base;
        bg          = Colors.transparent;
        border      = base;
        borderWidth = 1.5;
    }

    final radius = borderRadius ?? BorderRadius.circular(h * 0.35);
    final hPad   = h * 0.6;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth:  isFullWidth ? double.infinity : (width ?? h),
        minHeight: h,
        maxWidth:  width ?? double.infinity,
      ),
      child: IntrinsicWidth(
        child: MaterialButton(
          color: bg,
          disabledColor: bg.withAlpha(50),
          onPressed: loading ? null : onPressed,
          minWidth: h,
          padding: width != null
              ? EdgeInsets.zero
              : EdgeInsets.symmetric(horizontal: hPad),
          height: h,
          elevation: 0,
          focusElevation: 0,
          highlightElevation: 0,
          hoverElevation: 0,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(width: borderWidth, color: border),
          ),
          splashColor: typo.withAlpha(40),
          child: loading
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: typo,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null)
                      Icon(icon, color: typo, size: h * 0.45),
                    if (icon != null && label != null)
                      SizedBox(width: h * 0.3),
                    if (label != null)
                      Text(
                        label!,
                        style: TextStyle(color: typo).merge(labelStyle),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
