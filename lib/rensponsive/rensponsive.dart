

import 'package:bayer/costante/export.dart';

class Rensponsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;
  const Rensponsive({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;
  static bool isTablette(BuildContext context) =>
      MediaQuery.of(context).size.width >= 850;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final Size size = MediaQuery.of(context).size;

        if (size.width >= 1100) {
          // EasyLoading.showToast('idesk');
          return desktop;
        } else if (size.width >= 850) {
          // EasyLoading.showToast('tablette');
          return tablet;
        } else {
          // EasyLoading.showToast('phone');
          return mobile;
        }
      },
    );
  }
}
