import 'package:flutter/material.dart';

class CityAutocomplete extends StatefulWidget {
  final List<String> cityNames;
  final Future<void> Function(String) onCitySelected;
  final String title;

  const CityAutocomplete({
    Key? key,
    required this.cityNames,
    required this.onCitySelected,
    required this.title,
  }) : super(key: key);

  @override
  State<CityAutocomplete> createState() => _CityAutocompleteState();
}

class _CityAutocompleteState extends State<CityAutocomplete> {
  String? _selectedValue;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        final text = textEditingValue.text;
        if (text.isEmpty || text == _selectedValue) {
          return const Iterable<String>.empty();
        }
        return widget.cityNames.where((city) =>
            city.toLowerCase().contains(text.toLowerCase()));
      },
      onSelected: (String selection) {
        _selectedValue = selection;
        _focusNode.unfocus();
        widget.onCitySelected(selection);
      },
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        // Sync the external focusNode with our tracked one so unfocus works.
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          onChanged: (value) {
            if (value != _selectedValue) _selectedValue = null;
            if (value.isEmpty) widget.onCitySelected('');
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: widget.title,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            prefixIcon:
                Icon(Icons.search, size: 18, color: Colors.grey.shade500),
          ),
          style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
        );
      },
    );
  }
}
