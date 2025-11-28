import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 237, 234, 242),
            borderRadius: BorderRadius.circular(15),
          ),
          child: DropdownButtonHideUnderline( 
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: items
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, style: const TextStyle(fontSize: 14,  )
                        
                      ),
                      ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
