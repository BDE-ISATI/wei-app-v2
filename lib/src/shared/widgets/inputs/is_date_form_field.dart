
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isati_integration/src/shared/widgets/inputs/is_text_field.dart';

class IsDateFormField extends FormField<DateTime> {
  IsDateFormField({
    Key? key,
    required BuildContext context,
    FormFieldSetter<DateTime>? onSave,
    Function(DateTime)? onChanged,
    FormFieldValidator<DateTime>? validator,
    DateTime? initialValue,
    required DateTime firstDate,
    required DateTime lastDate,
    SelectableDayPredicate? selectableDayPredicate,
    String label = "Date",
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled
  }) : super(
    key: key,
    onSaved: onSave,
    validator: validator,
    initialValue: initialValue,
    autovalidateMode: autovalidateMode,
    builder: (FormFieldState<DateTime> state) {
      final DateTime? currentValue = state.value;
      final String currentValueString = currentValue != null ? DateFormat("dd/MM/yyyy").format(currentValue) : "";

      return InkWell(
        onTap: () async {
          DateTime? newDate = await showDatePicker(
            context: context,
            firstDate: firstDate,
            lastDate: lastDate,
            initialDate: currentValue ?? initialValue ?? DateTime.now(),
            helpText: label,
            selectableDayPredicate: selectableDayPredicate,
          );

          if (newDate != null) {
            state.reset();
            newDate = newDate.add(const Duration(seconds: 1));
            
            if (onChanged != null) {
              onChanged(newDate);
            }
            state.didChange(newDate);
          }
        },
        child: AbsorbPointer(
          child: IsTextField(
            controller: TextEditingController()..text = currentValueString,
            onChanged: (value) {},
            labelText: label,
            hintText: "Date",
            readOnly: true, 
            suffixIcon: Icons.date_range,
          ),
        ),
      );
    }
  );
}