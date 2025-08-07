import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SimpleTapMultiSelectDropdown extends StatefulWidget {
  final String label;
  final String hint;
  final List<String> items;
  final List<String> selectedItems;
  final ValueChanged<List<String>> onChanged;

  const SimpleTapMultiSelectDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
  });

  @override
  State<SimpleTapMultiSelectDropdown> createState() =>
      _SimpleTapMultiSelectDropdownState();
}

class _SimpleTapMultiSelectDropdownState
    extends State<SimpleTapMultiSelectDropdown> {
  bool isExpanded = false;

  void toggleDropdown() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  void selectItem(String item) {
    if (!widget.selectedItems.contains(item)) {
      widget.onChanged([...widget.selectedItems, item]);
    }
    setState(() {
      isExpanded = false;
    });
  }

  void removeItem(String item) {
    widget.onChanged([...widget.selectedItems]..remove(item));
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = widget.selectedItems.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: const Color(0xFFFF1901),
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: toggleDropdown,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xffE8E6EA)),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    hasSelection ? 'Selected consultants...' : widget.hint,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      color: hasSelection ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xff8D91A0),
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xffE8E6EA)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final isSelected = widget.selectedItems.contains(item);

                return GestureDetector(
                  onTap: () => selectItem(item),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${index + 1} - $item',
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check,
                            size: 18,
                            color: Colors.green,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),

          ),
        if (hasSelection)
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 4),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.selectedItems.map((item) {
                return Chip(
                  label: Text(
                    item,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                  backgroundColor: const Color(0xFFF0F0F0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => removeItem(item),
                );
              }).toList(),
            ),
          ),


      ],
    );
  }
}
