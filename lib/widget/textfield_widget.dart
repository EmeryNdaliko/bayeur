import '../costante/export.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    this.controller,
    this.icon,
  });

  final TextEditingController? controller;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 228, 232, 226),
        borderRadius: BorderRadius.circular(50),
      ),
      height: 30,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hint: const Text('Rechercher'),
          isDense: true,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
