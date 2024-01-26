import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CricTextFormField extends StatelessWidget {
  const CricTextFormField(
      {super.key,
      this.controller,
      required this.hintText,
      this.keyboardType = TextInputType.none,
      this.validator,
      this.onChanged,
      this.enabled = true,
      this.maxLength,
      this.maxLines,
      this.label,
      this.inputFormatters,
      this.counterText,
      this.textCapitalization = TextCapitalization.sentences,
      this.focusNode,
      this.autofillHints});

  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final String? counterText;
  final bool? enabled;
  final String hintText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType keyboardType;
  final String? label;
  final int? maxLength;
  final int? maxLines;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofillHints: autofillHints,
      focusNode: focusNode,
      maxLength: maxLength,
      maxLines: maxLines,
      enabled: enabled,
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        counterText: "",
        hintText: hintText,
        label: label != null ? Text(label!) : null,
      ),
      validator: validator,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
    );
  }
}

class CricTextField extends StatelessWidget {
  const CricTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    this.onChanged,
    this.enabled = true,
    this.maxLength,
    this.maxLines,
    this.label,
    this.inputFormatters,
  });

  final Function(String)? onChanged;
  final TextEditingController controller;
  final bool? enabled;
  final String hintText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType keyboardType;
  final String? label;
  final int? maxLength;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: maxLength,
      maxLines: maxLines,
      enabled: enabled,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        label: label != null ? Text(label!) : null,
      ),
      onChanged: onChanged,
      inputFormatters: inputFormatters,
    );
  }
}

// class AutoCompleteCricTextField<T> extends StatelessWidget {
//   const AutoCompleteCricTextField(
//       {super.key,
//       this.controller,
//       required this.hintText,
//       required this.keyboardType,
//       this.onChanged,
//       this.enabled = true,
//       this.maxLength,
//       this.maxLines,
//       this.label,
//       this.inputFormatters,
//       required this.itemBuilder,
//       required this.onSelected,
//       required this.suggestionsCallback});

//   final Function(String)? onChanged;
//   final TextEditingController? controller;
//   final bool? enabled;
//   final String hintText;
//   final List<TextInputFormatter>? inputFormatters;
//   final TextInputType keyboardType;
//   final String? label;
//   final int? maxLength;
//   final int? maxLines;
//   final Widget Function(BuildContext, T) itemBuilder;
//   final void Function(T)? onSelected;
//   final FutureOr<List<T>> Function(String) suggestionsCallback;

//   @override
//   Widget build(BuildContext context) {
//     return TypeAheadField<T>(
//         suggestionsCallback: suggestionsCallback,
//         onSelected: onSelected,
//         itemBuilder: itemBuilder,
//         builder: (context, controller, focusNode) {
//           return TextField(
//             maxLength: maxLength,
//             maxLines: maxLines,
//             enabled: enabled,
//             controller: controller,
//             keyboardType: keyboardType,
//             decoration: InputDecoration(
//               hintText: hintText,
//               label: label != null ? Text(label!) : null,
//             ),
//             onChanged: onChanged,
//             inputFormatters: inputFormatters,
//           );
//         });
//   }
// }
