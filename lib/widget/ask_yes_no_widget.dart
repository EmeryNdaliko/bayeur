import 'package:bayer/costante/export.dart';
import 'package:lottie/lottie.dart';

class AskYesNoWidget extends StatelessWidget {
  final Widget? child;
  final Widget? middleText;
  final String? statut;
  final String? cancelText;
  final String? confirmText;

  final VoidCallback onConfirm;

  const AskYesNoWidget({
    super.key,
    this.middleText,
    this.child,
    required this.onConfirm,
    this.statut,
    this.cancelText,
    this.confirmText,
  });

  void show() {
    Get.dialog(this, barrierDismissible: false);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(10),
        width: 350,
        // height: 180,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  middleText ??
                      const Text(
                        "Voulez-vous vraiment supprimer cet élément ?",
                        textAlign: TextAlign.center,
                      ),
                  20.height,
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: MyButton(
                          bgColor: AppColors.red,
                          showIcon: false,
                          borderSize: 50,
                          onTap: () {
                            Get.back();
                            onConfirm();
                          },
                          label: confirmText ?? "Supprimer",
                        ),
                      ),
                      20.height,
                      Expanded(
                        child: MyButton.outlined(
                          onTap: () => Get.back(),
                          boder: 1,
                          label: cancelText ?? "Annuler",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: -50,
              child: SizedBox(
                height: 100,
                width: 100,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: child ??
                      Lottie.asset(
                        'assets/animation/question.json',
                        backgroundLoading: true,
                        width: 100,
                        height: 100,
                        delegates: LottieDelegates(
                          text: (p0) => 'text',
                          values: [
                            ValueDelegate.color(
                              const [], // chemin vers le calque
                              value: Colors.white, // nouvelle couleur
                            ),
                          ],
                        ),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
