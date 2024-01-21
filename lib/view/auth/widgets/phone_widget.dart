import 'package:dream2/my_library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class PhoneNumber {
  String? countryISOCode;
  String? countryCode;
  String? number;

  PhoneNumber({
    @required this.countryISOCode,
    @required this.countryCode,
    @required this.number,
  });

  String get completeNumber {
    return countryCode! + number!;
  }
}

class IntlPhoneField extends StatefulWidget {
  final bool? obscureText;
  final TextAlign? textAlign;
  final VoidCallback? onTap;

  /// {@macro flutter.widgets.editableText.readOnly}
  final bool? readOnly;
  final FormFieldSetter<PhoneNumber>? onSaved;

  /// {@macro flutter.widgets.editableText.onChanged}
  ///
  /// See also:
  ///
  ///  * [inputFormatters], which are called before [onChanged]
  ///    runs and can validate and change ("format") the input value.
  ///  * [onEditingComplete], [onSubmitted], [onSelectionChanged]:
  ///    which are more specialized input change notifications.
  final ValueChanged<PhoneNumber>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool autoValidate;

  /// {@macro flutter.widgets.editableText.keyboardType}
  final TextInputType? keyboardType;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  /// Defines the keyboard focus for this widget.
  ///
  /// The [focusNode] is a long-lived object that's typically managed by a
  /// [StatefulWidget] parent. See [FocusNode] for more information.
  ///
  /// To give the keyboard focus to this widget, provide a [focusNode] and then
  /// use the current [FocusScope] to request the focus:
  ///
  /// ```dart
  /// FocusScope.of(context).requestFocus(myFocusNode);
  /// ```
  ///
  /// This happens automatically when the widget is tapped.
  ///
  /// To be notified when the widget gains or loses the focus, add a listener
  /// to the [focusNode]:
  ///
  /// ```dart
  /// focusNode.addListener(() { print(myFocusNode.hasFocus); });
  /// ```
  ///
  /// If null, this widget will create its own [FocusNode].
  ///
  /// ## Keyboard
  ///
  /// Requesting the focus will typically cause the keyboard to be shown
  /// if it's not showing already.
  ///
  /// On Android, the user can hide the keyboard - without changing the focus -
  /// with the system back button. They can restore the keyboard's visibility
  /// by tapping on a text field.  The user might hide the keyboard and
  /// switch to a physical keyboard, or they might just need to get it
  /// out of the way for a moment, to expose something it's
  /// obscuring. In this case requesting the focus again will not
  /// cause the focus to change, and will not make the keyboard visible.
  ///
  /// This widget builds an [EditableText] and will ensure that the keyboard is
  /// showing when it is tapped by calling [EditableTextState.requestKeyboard()].
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.editableText.onSubmitted}
  ///
  /// See also:
  ///
  ///  * [EditableText.onSubmitted] for an example of how to handle moving to
  ///    the next/previous field when using [TextInputAction.next] and
  ///    [TextInputAction.previous] for [textInputAction].
  final void Function(String)? onSubmitted;

  /// If false the text field is "disabled": it ignores taps and its
  /// [decoration] is rendered in grey.
  ///
  /// If non-null this property overrides the [decoration]'s
  /// [Decoration.enabled] property.
  final bool? enabled;

  /// The appearance of the keyboard.
  ///
  /// This setting is only honored on iOS devices.
  ///
  /// If unset, defaults to the brightness of [ThemeData.primaryColorBrightness].
  final Brightness? keyboardAppearance;

  /// Initial Value for the field.
  /// This property can be used to pre-fill the field.
  final String? initialValue;

  /// 2 Letter ISO Code
  final String? initialCountryCode;

  /// The decoration to show around the text field.
  ///
  /// By default, draws a horizontal line under the text field but can be
  /// configured to show an icon, label, hint text, and error text.
  ///
  /// Specify null to remove the decoration entirely (including the
  /// extra padding introduced by the decoration to save space for the labels).
  final InputDecoration? decoration;

  /// The style to use for the text being edited.
  ///
  /// This text style is also used as the base style for the [decoration].
  ///
  /// If null, defaults to the `subtitle1` text style from the current [Theme].
  final TextStyle? style;
  final bool? showDropdownIcon;

  final BoxDecoration? dropdownDecoration;

  /// {@macro flutter.widgets.editableText.inputFormatters}
  final List<TextInputFormatter>? inputFormatters;

  /// Placeholder Text to Display in Searchbar for searching countries
  final String? searchText;

  /// Color of the country code
  final Color? countryCodeTextColor;

  /// Color of the drop down arrow
  final Color? dropDownArrowColor;

  final int? maxLength;

  final TextInputAction? textInputAction;

  IntlPhoneField({
    this.initialCountryCode,
    this.maxLength,
    this.obscureText = false,
    this.textAlign = TextAlign.left,
    this.onTap,
    this.readOnly = false,
    this.initialValue,
    this.keyboardType = TextInputType.number,
    this.autoValidate = true,
    this.controller,
    this.focusNode,
    this.decoration,
    this.style,
    this.onSubmitted,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.showDropdownIcon = true,
    this.dropdownDecoration = const BoxDecoration(),
    this.inputFormatters,
    this.enabled = true,
    this.keyboardAppearance = Brightness.light,
    this.searchText = 'Search by Country Name',
    this.countryCodeTextColor,
    this.dropDownArrowColor,
    this.textInputAction,
  });

  @override
  _IntlPhoneFieldState createState() => _IntlPhoneFieldState();
}

class _IntlPhoneFieldState extends State<IntlPhoneField> {
  Map<String, String> _selectedCountry =
      countries.firstWhere((item) => item['code'] == 'US');
  List<Map<String, String>> filteredCountries = countries;
  FormFieldValidator<String>? validator;
  bool taped = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialCountryCode != null) {
      _selectedCountry = countries
          .firstWhere((item) => item['code'] == widget.initialCountryCode);
    }
    validator = widget.autoValidate
        ? (value) => value!.length != 10 ? 'Invalid Mobile Number' : null
        : widget.validator;

  }

  Future<void> _changeCountry() async {
    filteredCountries = countries;
    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => StatefulBuilder(
        builder: (ctx, setState) => Dialog(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    labelText: widget.searchText,
                  ),
                  onChanged: (value) {
                    setState(() {
                      filteredCountries = countries
                          .where((country) => country['name']!
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredCountries.length,
                    itemBuilder: (ctx, index) => Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            filteredCountries[index]['name']!,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          trailing: Text(
                            filteredCountries[index]['dial_code']!,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          leading: Image.asset(
                            'assets/flags/${filteredCountries[index]['code']!.toLowerCase()}.png',
                             width: 32,
                          ),
                          onTap: () {
                            _selectedCountry = filteredCountries[index];
                            Navigator.of(context).pop();
                          },
                        ),
                        Divider(thickness: 1),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {  
    return Container(
      child: Row(
        children: [
          Stack(
            children: [
              _buildFlagsButton(),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Container(
              //     height: 0.5.h,
              //     color: AppColors.primaryColor,
              //     width: 80.w,
              //   ),
              // ),
            ],
          ),
          SizedBox(width: 17.w,),
          Expanded(
            child: TextFormField(

              onTap: () {
                if (widget.onTap != null) widget.onTap!();
              },
              cursorColor: AppColors.primaryColor,
              onFieldSubmitted: (s) {
                if (widget.onSubmitted != null) widget.onSubmitted!(s);
              },


              decoration: widget.decoration ??InputDecoration(

                contentPadding: EdgeInsets.only(top: 10.h, ),

                hintText: '(000)     000',
                hintStyle: TextStyle(
                    color: AppColors.borderColor,
                    fontSize: 16.sp,
                     fontFamily: 'Helvetica Neue LT Arabic',
                    fontWeight: FontWeight.w400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.r),
                  borderSide: BorderSide(
                    color: AppColors.borderColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.r),
                  borderSide: BorderSide(
                    color: AppColors.primaryColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.r),
                  borderSide: BorderSide(
                    color: AppColors.borderColor,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.r),
                  borderSide: BorderSide(
                    color: Colors.redAccent,
                  ),
                ),
              ),
              style: TextStyle(
                  color: AppColors.line,
                  fontSize: 16.sp,
                  fontFamily: 'Helvetica Neue LT Arabic',
                  letterSpacing: 1.16,
                   fontWeight: FontWeight.w400),
               onSaved: (value) {
                if (widget.onSaved != null)
                  widget.onSaved!(
                    PhoneNumber(
                      countryISOCode: _selectedCountry['code'],
                      countryCode: _selectedCountry['dial_code'],
                      number: value,
                    ),
                  );
              },
              onChanged: (value) {
                if (widget.onChanged != null)
                  widget.onChanged!(
                    PhoneNumber(
                      countryISOCode: _selectedCountry['code'],
                      countryCode: _selectedCountry['dial_code'],
                      number: value,
                    ),
                  );
              },
              // validator: validator,
              keyboardType: widget.keyboardType,
              inputFormatters: widget.inputFormatters,
              enabled: widget.enabled,
              keyboardAppearance: widget.keyboardAppearance,
              textInputAction: widget.textInputAction,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlagsButton() {
    return Container(
      width: 80.w,
      height: 50.h,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color:   AppColors.primaryColor
               , width: 0.5.w
          )
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.zero,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Image.asset(
              //   'assets/flags/${_selectedCountry['code'].toLowerCase()}.png',
              //    width: 32,
              // ),
              // SizedBox(width: 5.w),
              // Icon(
              //   Icons.keyboard_arrow_down_rounded,
              //   color: AppColors.textBlack,
              // ),
              // Column(
              //   children: [
              //     Expanded(
              //       child: Container(
              //          width: 1.w,
              //         margin: EdgeInsets.symmetric(horizontal: 4.w),
              //         color: AppColors.line,
              //       ),
              //     ),
              //   ],
              // ),
              Text(
                _selectedCountry['dial_code']!,
                style: TextStyle(
                    color: AppColors.line,
                    fontSize: 16.sp,
                    fontFamily: 'Helvetica Neue LT Arabic',
                    letterSpacing: 1.16.w,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        onTap: _changeCountry,
      ),
    );
  }
}
