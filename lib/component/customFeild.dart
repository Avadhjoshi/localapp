import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CustomField extends StatefulWidget {



  final String hintText;
  final TextEditingController controller;
  final TextInputType? inputType;
  final List<TextInputFormatter>? formatters;
  final String? Function(String?)? validator;

  const CustomField({this.validator,this.formatters,this.inputType,required this.controller,this.hintText="",super.key});

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 40,
      child: TextFormField(

        controller: widget.controller,
        validator: widget.validator,


        onChanged: (s){
          setState(() {
          });
        },
        keyboardType:widget.inputType,
        inputFormatters:widget.formatters,
        decoration: InputDecoration(

          hintText: widget.hintText,
          contentPadding: const  EdgeInsets.symmetric(horizontal: 8),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            )
          ),
        ),
      ),
    );
  }
}
