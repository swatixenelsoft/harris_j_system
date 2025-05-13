import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/ulits/custom_icon_container.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// Generic DataGrid source class
class GenericDataSource extends DataGridSource {
  final List<Map<String, dynamic>> data; // List of maps (data rows)
  final List<String> columns; // Column names to display dynamically
  final Function(Map<String, dynamic>) onZoomTap;

  GenericDataSource({
    required this.data,
    required this.columns,
    required this.onZoomTap,
  }) {
    // Creating rows dynamically from the provided data and columns
    _dataGridRows = data.map<DataGridRow>((item) {
      return DataGridRow(
          cells: columns.map((column) {
        return DataGridCell<String>(
            columnName: column, value: item[column]?.toString() ?? "");
      }).toList());
    }).toList();
  }

  late List<DataGridRow> _dataGridRows;

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final item = row.getCells();
    return DataGridRowAdapter(
      cells: item.map((cell) {
        final columnName = cell.columnName;
        final value = cell.value;

        print('value fggh ${item}');

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment:
              columnName == 'actions' ? Alignment.center : Alignment.centerLeft,
          child: columnName == 'actions'
              ?
          GestureDetector(
            onTap: () => onZoomTap(row.getCells()[2].value as Map<String, dynamic>), // item[0].value should be consultancy map
                  child:
                      const CustomIconContainer(path: 'assets/icons/zoom.svg'),
                )
              : Text(
                  value ?? '',
                  style: GoogleFonts.montserrat(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff1D212D),
                  ),
                ),
        );
      }).toList(),
    );
  }
}
