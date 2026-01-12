

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
            style: const TextStyle(color: Colors.grey),
          ),
          10.height,
          press == null
              ? const SizedBox()
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
