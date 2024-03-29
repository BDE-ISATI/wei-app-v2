import 'package:flutter/material.dart';
import 'package:isati_integration/utils/colors.dart';

class IsTextInput extends StatefulWidget {
  const IsTextInput({
    Key? key,
    this.formKey,
    this.obscureText = false,
    this.inputType = TextInputType.text,
    required this.controller,
    required this.validator,
    required this.labelText,
    this.suffixIcon,
    this.hintText,
    this.maxLines = 1,
    this.onSaved,
    this.onChanged,
    this.readOnly = false,
  }) : super(key: key);

  final Key? formKey;

  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String)? validator;
  final Function(String)? onSaved;
  final Function(String?)? onChanged;

  final IconData? suffixIcon;
  final String? hintText;
  final String labelText;

  final TextInputType inputType;
  final int maxLines;

  final bool readOnly;

  @override 
  _IsTextInput createState() => _IsTextInput();
}

class _IsTextInput extends State<IsTextInput> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();

    _obscureText = widget.obscureText;
  }

  @override
  void didUpdateWidget(covariant IsTextInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.labelText.toUpperCase(), style: const TextStyle(color: Colors.black54, fontSize: 12),),
        const SizedBox(height: 10.0,),
        Theme(
          data: ThemeData(
            primaryColor: colorSecondary,
          ),
          child: Container(
            color: colorScaffolddWhite,
            child: TextFormField(
              readOnly: widget.readOnly,
                key: widget.formKey,
                obscureText: _obscureText,
                controller: widget.controller,
                keyboardType: widget.inputType,
                maxLines: widget.maxLines,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(color: Color(Colors.grey[400]!.value)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black12,),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black12,),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  suffixIcon: widget.suffixIcon != null ? Icon(widget.suffixIcon) : !widget.obscureText ? null : InkWell(
                    onTap: _textVisibilityUpdated,
                    child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                  )
                ),
                validator: widget.validator == null ? null : (value) => widget.validator!(value ?? ""),
                onSaved: widget.onSaved != null ? (value) => widget.onSaved!(value ?? "") : null,
                onChanged: (value) {
                  if (widget.onChanged != null) {
                    widget.onChanged!(value);
                  }
                }
            ),
          ),
        ),
      ],
    );
  }

  void _textVisibilityUpdated() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}