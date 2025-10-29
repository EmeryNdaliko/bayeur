import '../costante/export.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    this.controller,
  });

  final TextEditingController? controller;
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
        decoration: const InputDecoration(
          hint: Text('Rechercher'),
          isDense: true,
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
