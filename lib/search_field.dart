import 'package:flutter/material.dart';

class CityAutocomplete extends StatelessWidget {
  final List<String> cityNames;
  final Function(String) onCitySelected;
  final String title;

  const CityAutocomplete({
    Key? key,
    required this.cityNames,
    required this.onCitySelected,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return cityNames.where((String city) {
              return city.toLowerCase().contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: (String selection) {
            onCitySelected(selection);
          },
          fieldViewBuilder: (
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            return TextField(
              onChanged: (value) {
                onCitySelected(value);
              },
              controller: textEditingController,
              focusNode: focusNode,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: title,
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                prefixIcon: Icon(Icons.search, size: 18, color: Colors.grey.shade500),
              ),
              style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
            );
          },
        ),
      ],
    );
  }
}
