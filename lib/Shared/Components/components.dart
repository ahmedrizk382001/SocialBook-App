import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:social_app/Shared/Components/constants.dart';

Future<dynamic> pushRemove(BuildContext context, Widget newRoute) =>
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => newRoute,
        ),
        (Route<dynamic> route) => false);

Future<dynamic> pushOnly(BuildContext context, Widget newRoute) =>
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => newRoute,
    ));

Widget builtTextFormField(
  BuildContext context, {
  TextInputType keyboardtype = TextInputType.text,
  required String? Function(String?) validatorFunc,
  required String labelText,
  required Widget prefixIcon,
  Widget? suffixIcon,
  bool isPassword = false,
  void Function()? onTap,
  void Function(String)? onChanged,
  void Function(String)? onFieldSubmitted,
  required TextEditingController? controller,
}) =>
    TextFormField(
      onFieldSubmitted: onFieldSubmitted,
      obscureText: isPassword,
      controller: controller,
      cursorColor: mainColor,
      onTap: onTap,
      onChanged: onChanged,
      keyboardType: keyboardtype,
      validator: validatorFunc,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: secondaryColor, width: 1.5)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: mainColor, width: 1.5)),
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: secondaryColor,
            ),
        hintMaxLines: 1,
        prefixIconColor: secondaryColor,
        suffixIconColor: secondaryColor,
        prefixIcon: prefixIcon,
      ),
    );

Widget centerIndicator() => Container(
      child: Center(child: LinearProgressIndicator(color: mainColor)),
      color: backGroundColor,
    );

Future<bool?> showToast(
  String message,
  Color backgroundColor,
  Color? textColor,
) =>
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: 16.0);

Widget buildAppTextFormField(
  BuildContext context, {
  required TextEditingController? controller,
  required String? hintText,
  required Function(String)? onChange,
  Widget? suffixIcon,
  Widget? prefixIcon,
  required BorderRadius borderRaduis,
  String? Function(String?)? validator,
  String? Function(String?)? onFieldSubmitted,
}) =>
    TextFormField(
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      onChanged: onChange,
      keyboardType: TextInputType.text,
      maxLines: null,
      minLines: 1,
      controller: controller,
      cursorColor: secondaryColor,
      decoration: InputDecoration(
        enabled: true,
        contentPadding: EdgeInsets.all(20),
        filled: true,
        fillColor: Color(0xffe4e8ec),
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: secondaryColor.withOpacity(0.5),
            ),
        border: OutlineInputBorder(
          borderRadius: borderRaduis,
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffixIcon,
        suffixStyle: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: secondaryColor),
        prefixIcon: prefixIcon,
        prefixStyle: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: secondaryColor),
      ),
    );

String formatTimestamp(DateTime dateTime) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays == 1) {
    return 'Yesterday';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  } else if (now.year == dateTime.year) {
    return DateFormat('MMM d').format(dateTime);
  } else {
    return DateFormat('MMM d, yyyy').format(dateTime);
  }
}
