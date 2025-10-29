import 'package:bayer/costante/export.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

extension Extentsion on String {
  Text get text => Text(this);
  Text textColor(
      {Color? color,
      double? size,
      bool isbold = false,
      FontWeight? fontweight,
      FontStyle? fontStyle,
      TextOverflow? overflow}) {
    return Text(
      this,
      style: TextStyle(
          overflow: overflow ?? TextOverflow.ellipsis,
          textBaseline: TextBaseline.alphabetic,
          color: color ?? Colors.black,
          fontSize: size,
          fontWeight: fontweight ?? (isbold ? FontWeight.bold : null),
          fontStyle: fontStyle),
    );
  }

  Text textSize(double size, {Color? textcolor}) => Text(
        this,
        style: TextStyle(fontSize: size, color: textcolor),
      );

  Text get bold => Text(this, style: TextStyle(fontWeight: FontWeight.bold));

  bool search(String query) => toLowerCase().contains(query.toLowerCase());
  String lower() {
    var isDouble = double.tryParse(this);
    if (isDouble == null) {
      return toLowerCase();
    } else {
      return isDouble.toString();
    }
  }

  String add(String val) => '$this $val';
  String firstMaj({bool lower = false, bool invert = false}) {
    if (isEmpty) {
      return '';
    }
    var val = this;
    if (lower) {
      val = val.toLowerCase();
    }
    if (invert) {
      val = val.split('').toList().reversed.join('');
    }

    return '${val[0].toUpperCase()}${val.substring(1)}';
  }

  LottieBuilder get lottie => Lottie.asset(this,
      errorBuilder: (context, error, stackTrace) =>
          Text('Chemin introuvable pour $this'));

  DateTime get toDate => DateFormat('dd-MM-yyyy').parse(this);
}

extension MyIntExtension on int {
  SizedBox get width => SizedBox(width: toDouble());
  SizedBox get height => SizedBox(height: toDouble());

  EdgeInsets get padding => EdgeInsets.all(toDouble());

  EdgeInsets get only => EdgeInsets.only(bottom: toDouble(), top: toDouble());

  EdgeInsets get vertical => EdgeInsets.symmetric(vertical: toDouble());

  EdgeInsets get horizontal => EdgeInsets.symmetric(horizontal: toDouble());

  EdgeInsets paddingAll(double x, double y) =>
      EdgeInsets.symmetric(horizontal: x, vertical: y);

  RoundedRectangleBorder get radius => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(toDouble()),
      );
  BorderRadiusGeometry get boderRadius => BorderRadius.circular(toDouble());

  BoxDecoration get cradius =>
      BoxDecoration(borderRadius: BorderRadius.circular(toDouble()));
}

extension MyDoubleExtension on double {
  SizedBox get width => SizedBox(width: toDouble());
  SizedBox get height => SizedBox(height: toDouble());

  EdgeInsets get padding => EdgeInsets.all(toDouble());

  EdgeInsets get only => EdgeInsets.only(bottom: toDouble(), top: toDouble());

  EdgeInsets get vertical => EdgeInsets.symmetric(vertical: toDouble());

  EdgeInsets get horizontal => EdgeInsets.symmetric(horizontal: toDouble());

  EdgeInsets paddingAll(double x, double y) =>
      EdgeInsets.symmetric(horizontal: x, vertical: y);

  RoundedRectangleBorder get radius => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(toDouble()),
      );
  BorderRadiusGeometry get boderRadius => BorderRadius.circular(toDouble());

  BoxDecoration get cradius =>
      BoxDecoration(borderRadius: BorderRadius.circular(toDouble()));
}

extension TextExtension on Text {
  TextStyle get bold => TextStyle(fontWeight: FontWeight.bold);
}

extension CustunExtOnDate on DateTime {
  String get format => DateFormat('dd-MM-yyyy').format(this);
  String get formatENG => DateFormat('yyyy-MM-dd').format(this);

  String get formatFr => DateFormat.yMMMMEEEEd('fr_FR').format(this);
  String get formatjjmmyy => DateFormat.yMMMMEEEEd('fr_FR').format(this);
  String get formatdMMy => DateFormat.yMMMd('fr_FR').format(this);
  int invervale(DateTime date) {
    return date.difference(this).inDays;
  }
}

extension WidgetExtension on Widget {
  SizedBox size(double width, double height) {
    return SizedBox(width: width, height: height, child: this);
  }

  Widget clickable({required VoidCallback? ontap}) => MouseRegion(
        cursor: ontap != null ? SystemMouseCursors.click : MouseCursor.defer,
        child: GestureDetector(
          onTap: ontap,
          child: this,
        ),
      );

  Widget circle({
    Color? color = Colors.white,
    bool showBadge = false,
    int count = 0,
  }) {
    if (showBadge) {
      return CircleAvatar(
        backgroundColor: color,
        child: Badge.count(count: count, child: this),
      );
    } else {
      return CircleAvatar(backgroundColor: color, child: this);
    }
  }
}

extension CustomExtonTexteditingController on TextEditingController {
  TextField textField({
    String? label,
    String? hint,
    IconData? icon,
    bool isPassword = false,
    bool isNumber = false,
    TextInputType? type,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: this,
      obscureText: isPassword,
      keyboardType: isNumber ? TextInputType.number : type,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label ?? '',
        hintText: hint ?? '',
        prefixIcon: icon != null ? Icon(icon) : null,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

extension ListExention on List {
  Row get torow => Row(spacing: 10, children: this as List<Widget>);
}

extension ObjectExtension on Object {
  int? get parse => int.parse(toString());
  int? get tryparse => int.tryParse(toString());
}
