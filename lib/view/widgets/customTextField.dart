import 'package:dream2/my_library.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String? hintText;
  final Function? onSaved;
  final Icon? iconData;
  final int? maxLine;
  final TextInputType? textInputType;
  final Color? fillColor;
  final String? textInitialValue;
  TextEditingController? textEditingController;
  final bool? confirmPass;

  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? password;
  final Function? validator;
  final Function? onTap;

  final bool? autofocus;
  final bool? readOnly;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry? contentPadding;
  FocusNode? focusNode;

  CustomTextFormField(
      {Key? key,
      this.hintText,
      this.onSaved,
      this.iconData,
      this.textInputType,
      this.textEditingController,
      this.textInitialValue,
      this.suffixIcon,
      this.maxLine = 1,
      this.autofocus = false,
      this.textAlign,
      this.password = false,
      this.fillColor,
      this.contentPadding,
      this.prefixIcon,
      this.validator,
      this.confirmPass = false,
      this.focusNode,
      this.onTap, this.readOnly = false});

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  IconData iconData = FontAwesomeIcons.eyeSlash;
  bool toggleEye = true;

  Function? validator;

  fmToggleEye() {
    toggleEye = !toggleEye;
    iconData = toggleEye ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.textInputType == TextInputType.emailAddress) {
      validator = Helper.validationEmail;
    } else if (widget.textInputType == TextInputType.name) {
      validator = Helper.validationNull;
    } else if (widget.textInputType == TextInputType.phone) {
      validator = Helper.validationNull;
    } else if (widget.textInputType == TextInputType.number) {
      validator = Helper.validationNull;
    } else {
      validator = Helper.validationNull;
    }

    return TextFormField(

      style: TextStyle(
          color: AppColors.textBlack,
          fontSize: 16.sp,
          fontFamily: "Cairo",
          fontWeight: FontWeight.w700),
      initialValue: widget.textInitialValue,
      controller: widget.textEditingController,
      autofocus: widget.autofocus!,
      maxLines: widget.maxLine,
      onTap: widget.onTap != null ? () => widget.onTap!() : null,
      readOnly:widget.readOnly!,
      textAlign: widget.textAlign ?? TextAlign.start,
      validator: (value) =>
          widget.confirmPass! ? widget.validator!(value) : validator!(value),
      onSaved: (newValue) => widget.onSaved!(newValue),
      onChanged: (value) {
        // widget.onSaved(value);
      },
      obscureText: widget.password! ? toggleEye : false,
      cursorColor: Colors.grey,
      keyboardType: widget.textInputType,
      focusNode: widget.focusNode,
      obscuringCharacter: '*',
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        suffixIconConstraints: BoxConstraints(
            minHeight: 24.h,
            minWidth: 24.w
        ),
        prefixIconConstraints: BoxConstraints(
            minHeight: 24.h,
            minWidth: 24.w
        ),
        suffix: widget.password!
            ? GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    iconData,
                    color: Color(0xffD8D8D8),
                  ),
                ),
                onTap: () {
                  fmToggleEye();
                },
              )
            : null,
        suffixIcon: widget.suffixIcon,
        contentPadding:
            widget.contentPadding ?? EdgeInsets.symmetric(horizontal: 16.w),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontFamily: "Cairo",
          fontSize: 15.sp,
          color: AppColors.subTextBlack,
        ),
        border: UnderlineInputBorder(

          borderSide: BorderSide(
            color: AppColors.borderColor,
          ),
        ),
        focusedBorder: UnderlineInputBorder(

          borderSide: BorderSide(
            color: AppColors.primaryColor,
          ),
        ),
        enabledBorder: UnderlineInputBorder(

          borderSide: BorderSide(
            color: AppColors.borderColor,
          ),
        ),
        errorBorder: OutlineInputBorder(

          borderSide: BorderSide(
            color: Colors.redAccent,
            width: 1.0.w,
          ),
        ),
      ),
    );
  }
}
