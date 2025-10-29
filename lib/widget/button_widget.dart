import 'package:bayer/costante/export.dart';
import 'package:bayer/costante/extension.dart';

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

  const MyButton(
      {super.key,
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
      this.child});

  factory MyButton.icon({
    Key? key,
    IconData? icon,
    VoidCallback? onLongPress,
  }) {
    if (icon == null) {
      return const MyButton();
    }
    return MyButton(icon: icon);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        padding: const EdgeInsets.all(5),
        height: 30,
        decoration: BoxDecoration(
            color: bgColor ?? AppColors.primary,
            borderRadius:
                borderSize == null ? 0.boderRadius : borderSize!.boderRadius),
        child: Row(
            spacing: spacing,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              showIcon
                  ? child?.size(18, 18) ??
                      Icon(
                        icon ?? Icons.add,
                        color: fgColor ?? AppColors.white,
                        size: 20,
                      )
                  : const SizedBox(),
              (label ?? '')
                  .textColor(color: fgColor ?? AppColors.white, size: fontSize)
            ])).clickable(ontap: onTap);
  }
}
