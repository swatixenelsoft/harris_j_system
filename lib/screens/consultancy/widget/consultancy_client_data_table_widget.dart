import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/ulits/custom_icon_container.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// Generic DataGrid source class
class GenericDataSource extends DataGridSource {
  final List<Map<String, dynamic>> data; // List of maps (data rows)
  final List<String> columns; // Column names to display dynamically
  final Function(Map<String, dynamic>) onZoomTap;
  final int? selectedIndex;

  GenericDataSource({
    required this.data,
    required this.columns,
    required this.onZoomTap,
    this.selectedIndex,
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
  late List<Map<String, dynamic>> _originalRowData;

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final item = row.getCells();
    _originalRowData = data;
    final index = _dataGridRows.indexOf(row);
    final fullData = _originalRowData[index];
    final isSelected = index == selectedIndex;

    return DataGridRowAdapter(
      color: isSelected ? const Color(0xFFFFEEDA) : null,
      cells: item.map((cell) {
        final columnName = cell.columnName;
        final value = cell.value;

        Widget child;

        if (columnName == 'actions') {
          child = GestureDetector(
            onTap: () {
              print('✅ fullData: $fullData');
              onZoomTap(fullData);
            }, // assuming first cell is full consultancy data
            child: const CustomIconContainer(path: 'assets/icons/zoom.svg'),
          );
        } else if (columnName == 'status') {
          String queueValue = value.toString();
          Color circleColor = queueValue == 'Active'
              ? const Color(0xff1F9254)
              : queueValue == 'Notice Period'
                  ? const Color(0xff8D91A0)
                  : const Color(0xffA30D11);

          child = Row(
            children: [
              Container(
                width: 10,
                height: 10,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          );
        } else if (columnName == 'designation') {
          child = Container(
            height: 25,
            padding:
                const EdgeInsets.only(top: 6, bottom: 6, left: 8, right: 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: const Color(0xffE5F1FF),
                borderRadius: BorderRadius.circular(8)),
            child: Text(
              value.toString(),
              style: GoogleFonts.montserrat(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: const Color(0xff037EFF),
              ),
            ),
          );
        } else {
          child = Text(
            value.toString(),
            style: GoogleFonts.montserrat(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: const Color(0xff1D212D),
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment:
              columnName == 'actions' ? Alignment.center : Alignment.centerLeft,
          child: child,
        );
      }).toList(),
    );
  }
}