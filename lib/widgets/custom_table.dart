import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTableView extends StatefulWidget {
  final List<dynamic> data;
  final List<Map<String, dynamic>> heading;

  const CustomTableView({
    super.key,
    required this.data,
    required this.heading,
  });

  @override
  State<CustomTableView> createState() => _CustomTableViewState();
}

class _CustomTableViewState extends State<CustomTableView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('data a ${widget.data}');

    // Limit to 5 rows (or fewer if data length < 5)
    final limitedData = widget.data.take(3).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // For horizontal scroll if needed
      child: SingleChildScrollView(
        controller: _scrollController,
        child: DataTable(
          columnSpacing: 25,
          headingRowHeight: 38,
          dataRowMinHeight: 40,
          dataRowMaxHeight: 40,
          headingRowColor: MaterialStateProperty.all(const Color(0xFFF2F2F2)),
          columns: List.generate(widget.heading.length, (index) {
            final item = widget.heading[index];
            final isFirstColumn = index == 0;

            return DataColumn(
              label: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: isFirstColumn ? 90 : 70,
                  maxWidth: isFirstColumn ? 140 : 100,
                ),
                child: Text(
                  item['label']!,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                    color: const Color(0xff1D212D),
                  ),
                ),
              ),
            );
          }),
          rows: limitedData.map((row) {
            return DataRow(
              cells: widget.heading.map((item) {
                final key = item['key']!;
                final value = row[key];
                print('value $key $value');

                if (key == 'status' && value is Map<String, dynamic>) {
                  return DataCell(StatusLabel(
                    label: value['label']?.toString() ?? '',
                    color: value['color'] as Color?,
                    containerColor: value['background'] as Color?,
                  ));
                }

                return DataCell(
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 70,
                      maxWidth: 100,
                    ),
                    child: Text(
                      value?.toString() ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                        color: const Color(0xff1D212D),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }

}

class TableHeader extends StatelessWidget {
  final String text;
  const TableHeader({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
        fontWeight: FontWeight.w700,
        fontSize: 10,
        color: const Color(0xff1D212D),
      ),
    );
  }
}



class StatusLabel extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? containerColor;

  const StatusLabel({
    super.key,
    required this.label,
    this.color,
    this.containerColor,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = label.toLowerCase() == 'active';

    // Use green colors if status is Active, else fallback to passed colors
    final dotColor = isActive ? const Color(0xff1F9254) : (color ?? Colors.black);
    final bgColor = isActive ? const Color(0xffEBF9F1) : (containerColor ?? Colors.grey.shade300);
    final textColor = isActive ? const Color(0xff1F9254) : (color ?? Colors.black);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Colored dot
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          // Status text
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}


