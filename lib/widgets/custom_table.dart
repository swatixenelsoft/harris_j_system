import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CustomTableView extends StatefulWidget {
  final List<Map<String, dynamic>> data;
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

    // print()
    return DataTable(
      columnSpacing: 15, // <-- add spacing between columns
      headingRowHeight: 38,
      dataRowMinHeight: 40,
      dataRowMaxHeight: 40,
      headingRowColor: MaterialStateProperty.all(const Color(0xFFF2F2F2)),
      columns: widget.heading
          .map((item) => DataColumn(
        label: Text(
          item['label']!,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 10,
            color: const Color(0xff1D212D),
          ),
        ),
      ))
          .toList(),
      rows: widget.data.map((row) {
        return DataRow(
          cells: widget.heading.map((item) {
            final key = item['key']!;
            final value = row[key];

            if (value is Map &&
                value.containsKey('label') &&
                value.containsKey('color')) {
              return DataCell(StatusLabel(
                label: value['label'],
                color: value['color'],
                containerColor: value['background'],
              ));
            }

            return  DataCell(
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 80,  // adjust based on your layout
                  maxWidth: 110, // prevent overflow
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
  final Color color;
  final Color containerColor;

  const StatusLabel({super.key, required this.label, required this.color,required this.containerColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4,vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: containerColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 3),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w700,
              fontSize: 10,
              color: color,
            ),

          )
        ],
      ),
    );
  }
}
