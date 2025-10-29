import 'package:bayer/costante/app_constante.dart';
import 'package:bayer/costante/extension.dart';
import 'package:bayer/widget/button_widget.dart';
import 'package:lottie/lottie.dart';

import '../costante/export.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.press,
    required this.title,
    this.lottieSize,
    this.showButton = true,
    this.width,
    this.buttonText,
    this.buttonColor,
  });
  final Function()? press;
  final String title;
  final String? buttonText;
  final double? lottieSize;
  final double? width;
  final Color? buttonColor;
  final bool showButton;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            AppConstante.emptyLottie,
            height: lottieSize ?? 100,
          ),
          Text(
            textAlign: TextAlign.center,
            title,
            style: TextStyle(color: Colors.grey),
          ),
          10.height,
          press == null
              ? SizedBox()
              : SizedBox(
                  width: width ?? 200,
                  child: !showButton
                      ? null
                      : MyButton(
                          bgColor: buttonColor,
                          label: buttonText ?? 'Nouveau plan',
                          onTap: press)),
        ],
      ),
    );
  }
}
