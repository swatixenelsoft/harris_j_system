import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/consultant_provider.dart';
import 'package:harris_j_system/screens/bom/bom_add_consultancy_screen.dart';
import 'package:harris_j_system/services/api_constant.dart';
import 'package:harris_j_system/ulits/common_function.dart';
import 'package:harris_j_system/ulits/custom_icon_container.dart';
import 'package:harris_j_system/ulits/delete_pop_up.dart';
import 'package:harris_j_system/ulits/toast_helper.dart';
import 'package:harris_j_system/widgets/bottom_sheet_content.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseListView extends ConsumerStatefulWidget {
  const ExpenseListView({super.key,required this.entries,this.selectedMonth,this.selectedYear,required this.isFromHrScreen});

  final List entries;
  final String? selectedMonth;
  final String? selectedYear;
  final bool isFromHrScreen;


  @override
  ConsumerState<ExpenseListView> createState() => _ExpenseListViewState();
}

class _ExpenseListViewState extends ConsumerState<ExpenseListView> {

  Future<void> _getConsultantTimeSheet() async {
    final prefs = await SharedPreferences.getInstance();

   final token = prefs.getString('token');
    await ref.read(consultantProvider.notifier).consultantClaimSheet(token!);
    await ref.read(consultantProvider.notifier).consultantTimesheetRemarks(
      ApiConstant.getClaimRemarks,
      token,
     widget. selectedMonth.toString(),
      widget.  selectedYear.toString(),
    );

    await ref.read(consultantProvider.notifier).consultantClaimAndCopies(
      token,
      widget.   selectedMonth.toString(),
      widget.  selectedYear.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 260, // Adjust height based on your design
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        itemCount: widget.entries.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          final expense = widget.entries[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: expenseRow(
              context: context,
              expense: expense,

              onEdit: () async {
                // Close the current bottom sheet
                // Navigator.pop(context);
                print('dggg');

                final result = await showModalBottomSheet<Map<String, dynamic>>(
                  context: context,
                  isScrollControlled: true,
                  isDismissible: true,
                  enableDrag: true,
                  builder: (context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return LeaveBottomSheetContent(
                          startValue: 0,
                          endValue: 0,
                          selectedOption: "",
                          dateRange: expense['date'],
                          isFromClaimScreen: true,
                          expense: expense
                      );
                    });
                  },
                );
                if (result!['success']) {
                  await _getConsultantTimeSheet();
                  context.pop(true);

                  //  Show success toast
                  ToastHelper.showSuccess(context,
                      'Claim updated successfully!');
                }
                print('result23 $result');
              },
              onDelete: () async {
                final prefs = await SharedPreferences.getInstance();
                final token = prefs.getString('token');
                print('token $token');
                print(expense);
                DeleteConfirmationDialog.show(
                    context: context,
                    itemName: 'consultant',
                    onConfirm: () async {
                      final deleteResponse = await ref
                          .read(
                          consultantProvider
                              .notifier)
                          .deleteClaim(
                          expense[
                          'id'], token!, widget.selectedMonth!,
                          widget.selectedYear!);
                      print('deleteResponse $deleteResponse');

                      if (deleteResponse[
                      'success'] ==
                          true) {
                        await _getConsultantTimeSheet();
                        ToastHelper
                            .showSuccess(
                          context,
                          deleteResponse[
                          'message'] ??
                              'Consultancy deleted successfully',
                        );

                        context.pop();
                      } else {
                        ToastHelper
                            .showError(
                          context,
                          deleteResponse[
                          'message'] ??
                              'Failed to delete consultancy',
                        );
                      }
                    });
              },
            ),
          );
        },
      ),
    );
  }


// Expense row widget
  Widget expenseRow({
    required context,
    required expense,

    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      if(!widget.isFromHrScreen) Row(
      mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: onEdit,
            child: CustomIconContainer(
                path: 'assets/icons/edit_pen.svg',
                bgColor:
                Color(0xffF5230C)),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: onDelete,
            child: CustomIconContainer(
                path: 'assets/icons/red_delete_icon.svg'),
          ),

        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: labelValue("Date & Time", expense['date'])),
          const SizedBox(width: 20),
          Expanded(child: labelValue("Expense Type", expense['expenseType'])),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: labelValue("Amount", "\$${expense['amount']}")),
          const SizedBox(width: 20),
          Expanded(child: labelValue("Particulars", expense['particulars'])),
        ],
      ),
      const SizedBox(height: 10),
      labelValue("Remarks", expense['remarks']),

      const SizedBox(height: 5),
      Column(
        children: [
          SvgPicture.asset("assets/icons/addInvoice.svg", height: 40,),
          const SizedBox(height: 4),
          const Text("Add Invoice"),
        ],
      ),
      ],
    ),);

  }

  Widget labelValue(String label, String value) {
    return RichText(
      text: TextSpan(
        text: "$label\n",
        style: GoogleFonts.montserrat(fontWeight: FontWeight.w700,
            fontSize: 14,
            color: const Color(0xff1D212D)),
        children: [
          TextSpan(
            text: value,
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w500,
                fontSize: 12,
                color: const Color(0xff1D212D)),

          ),
        ],
      ),
    );
  }
}