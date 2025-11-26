import 'package:bayer/costante/export.dart';

class MyButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onTap;
  final Color? fgColor;
  final Color? bgColor;
  final double? width;
  final double? height;
  final double? borderSize;
  final double? fontSize;
  final IconData? icon;
  final double spacing;
  final bool showIcon;
  final Widget? child;
  final double? borderWidth;

  const MyButton({
    super.key,
    this.bgColor,
    this.fgColor,
    this.fontSize,
    this.width,
    this.icon,
    this.label,
    this.onTap,
    this.height,
    this.borderSize,
    this.spacing = 0.0,
    this.showIcon = true,
    this.child,
    this.borderWidth,
  });

  factory MyButton.icon(
      {required IconData? icon,
      required VoidCallback? onPressed,
      String? label,
      Color? backgroundColor,
      Color? foregroundColor,
      double borderSize = 0}) {
    if (icon == null) {
      return const MyButton();
    }
    return MyButton(
      bgColor: backgroundColor,
      fgColor: foregroundColor,
      icon: icon,
      label: label,
      borderSize: borderSize,
      onTap: onPressed,
    );
  }

  factory MyButton.outlined(
      {double? boder, required String label, VoidCallback? onTap}) {
    if (boder == null) return MyButton();
    return MyButton(
      bgColor: AppColors.primaryLightAccent,
      label: label,
      fgColor: AppColors.primary,
      borderWidth: boder,
      borderSize: 50,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        padding: const EdgeInsets.all(5),
        height: height ?? 30,
        decoration: BoxDecoration(
          color: bgColor ?? AppColors.primary,
          borderRadius:
              borderSize == null ? 0.boderRadius : borderSize!.boderRadius,
          border: borderWidth != null ? Border.all() : null,
        ),
        child: Row(
            spacing: spacing,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null)
                Icon(
                  // icon ?? Icons.add,
                  icon,
                  color: fgColor ?? AppColors.white,
                  size: 20,
                ),
              (label ?? '')
                  .textColor(color: fgColor ?? AppColors.white, size: fontSize)
            ])).clickable(ontap: onTap);
  }
}
