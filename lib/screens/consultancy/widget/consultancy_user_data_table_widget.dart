import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/ulits/custom_icon_container.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ConsultancyUserDataSource extends DataGridSource {
  final List<Map<String, dynamic>> consultancies;
  final Function(Map<String, dynamic>) onZoomTap;

  ConsultancyUserDataSource({
    required this.consultancies,
    required this.onZoomTap,
  }) {
    _dataGridRows = consultancies.map<DataGridRow>((consultancy) {
      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: 'user_id', value: consultancy['user_id']),
        DataGridCell<String>(
            columnName: 'designation',
            value: consultancy['designation'].toString()),
        DataGridCell<Map<String, dynamic>>(
            columnName: 'actions', value: consultancy),
      ]);
    }).toList();
  }

  late List<DataGridRow> _dataGridRows;

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final consultancy = row.getCells()[2].value as Map<String, dynamic>;

    print('consultancy $consultancy');
    return DataGridRowAdapter(
      cells: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.centerLeft,
          child: Text(
            consultancy['user_id'],
            style: GoogleFonts.montserrat(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: const Color(0xff1D212D),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            width: 110,
            height: 25,
            decoration: BoxDecoration(
              color: const Color(0xffE5F1FF),
              borderRadius: BorderRadius.circular(8), // optional
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.center,
            child: Text(
              consultancy['designation'], // or consultancy['designation']
              style: GoogleFonts.montserrat(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: const Color(0xff037EFF),
              ),
            ),
          ),
        ),
        Container(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () => onZoomTap(row.getCells()[2].value as Map<String,
                  dynamic>), // item[0].value should be consultancy map
              child: const CustomIconContainer(path: 'assets/icons/zoom.svg'),
            )),
      ],
    );
  }
}
