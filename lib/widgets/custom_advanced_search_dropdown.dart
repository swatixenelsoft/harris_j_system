import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/screens/finance/finance_edit_group_screen.dart';

class CustomClientDropdown3 extends StatefulWidget {
  final List<Map<String, dynamic>> clients;
  final Function(String clientName, String? clientId, String? groupName) onChanged;
  final String? initialClientName;
  final String? initialGroupName;

  const CustomClientDropdown3({
    required this.clients,
    required this.onChanged,
    this.initialClientName,
    this.initialGroupName,
    super.key,
  });

  @override
  State<CustomClientDropdown3> createState() => _CustomClientDropdown3State();
}

class _CustomClientDropdown3State extends State<CustomClientDropdown3> {
  final TextEditingController _controller = TextEditingController();
  bool _showDropdown = false;
  List<Map<String, dynamic>> filteredClients = [];
  String? selectedClient;
  Map<String, bool> clientExpanded = {};

  @override
  void initState() {
    super.initState();
    filteredClients = widget.clients;
    if (widget.initialClientName != null) {
      _controller.text = widget.initialClientName!;
      selectedClient = widget.initialClientName;
      clientExpanded[widget.initialClientName!] = true;
    } else if (widget.clients.isNotEmpty) {
      final first = widget.clients.first;
      _controller.text = first['serving_client'];
      selectedClient = first['serving_client'];
      clientExpanded[first['serving_client']] = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onChanged(first['serving_client'], first['id'].toString(), null);
      });
    }
    for (var client in widget.clients) {
      clientExpanded[client['serving_client']] = clientExpanded[client['serving_client']] ?? false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _filterClients(String query) {
    setState(() {
      filteredClients = widget.clients
          .where((client) =>
          client['serving_client'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _selectClient(Map<String, dynamic> client) {
    _controller.text = client['serving_client'];
    selectedClient = client['serving_client'];
    widget.onChanged(client['serving_client'], client['id'].toString(), null);
    setState(() => _showDropdown = false);
  }

  void _selectGroup(Map<String, dynamic> group) {
    _controller.text = '${selectedClient}/${group['group_name']}';
    widget.onChanged(selectedClient!, null, group['group_name']);
    setState(() => _showDropdown = false);
  }

  void _toggleClientExpansion(String clientName) {
    setState(() {
      clientExpanded[clientName] = !(clientExpanded[clientName] ?? false);
    });
  }

  void _navigateToEditGroupScreen(Map<String, dynamic> group) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FinanceEditGroupScreen(
          groupName: group['group_name'],
          groupData: group,
        ),
      ),
    );
  }

  Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'in progress':
        return const Color(0xFFFFEFBE);
      case 'ready to bill':
        return const Color.fromRGBO(172, 249, 190, 0.34);
      case 'completed':
        return const Color.fromRGBO(229, 241, 255, 1);
      default:
        return const Color(0xffF5F5F5);
    }
  }

  Color getStatusTextColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'in progress':
        return const Color.fromRGBO(255, 193, 7, 1);
      case 'ready to bill':
        return const Color.fromRGBO(40, 167, 69, 1);
      case 'completed':
        return const Color.fromRGBO(0, 123, 255, 1);
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    final maxDropdownHeight = (screenHeight * 0.55 - viewInsets).clamp(150.0, 400.0);

    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _showDropdown = !_showDropdown),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color.fromRGBO(141, 145, 160, 0.5)),
                borderRadius: BorderRadius.circular(12),
              ),
              height: 50,
              child: Row(
                children: [
                  SvgPicture.asset('assets/icons/search_icon.svg'),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: _filterClients,
                      onTap: () => setState(() => _showDropdown = true),
                      decoration: const InputDecoration(
                        hintText: 'Encore Films',
                        hintStyle: TextStyle(
                          color: Color.fromRGBO(141, 145, 160, 0.5),
                        ),
                        border: InputBorder.none,
                      ),
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Icon(
                    _showDropdown ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: const Color(0xff8D91A0),
                  ),
                ],
              ),
            ),
          ),
          if (_showDropdown) const SizedBox(height: 8),
          if (_showDropdown)
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: maxDropdownHeight,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  itemCount: filteredClients.length,
                  itemBuilder: (context, index) {
                    final client = filteredClients[index];
                    final isExpanded = clientExpanded[client['serving_client']] ?? false;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => _selectClient(client),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.black,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    client['initials'] ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    client['serving_client'],
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: '( ',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 10, fontWeight: FontWeight.w700, color: Colors.black)),
                                      TextSpan(
                                          text: client['inactive'].toString(),
                                          style: GoogleFonts.montserrat(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xffFF1901))),
                                      TextSpan(
                                          text: ', ',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 10, fontWeight: FontWeight.w700, color: Colors.black)),
                                      TextSpan(
                                          text: client['active'].toString(),
                                          style: GoogleFonts.montserrat(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xff007BFF))),
                                      TextSpan(
                                          text: ', ',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 10, fontWeight: FontWeight.w700, color: Colors.black)),
                                      TextSpan(
                                          text: client['notice'].toString(),
                                          style: GoogleFonts.montserrat(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xff8D91A0))),
                                      TextSpan(
                                          text: ' ) / ${client['all']}',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 10, fontWeight: FontWeight.w700, color: Colors.black)),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _toggleClientExpansion(client['serving_client']),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 10), // ← adds spacing before arrow
                                      Icon(
                                        isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                        size: 30, // ← bigger arrow
                                        color: const Color(0xff8D91A0),
                                      ),
                                    ],
                                  ),
                                ),


                              ],
                            ),
                          ),
                        ),
                        if (client['groups'] != null && isExpanded)
                          ...client['groups'].map<Widget>((group) {
                            final color = getStatusColor(group['status']);
                            return GestureDetector(// Gesture Button  should be changed
                              onTap: () => _selectGroup(group),
                              onLongPress: () => _navigateToEditGroupScreen(group),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                height: 50,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            group['group_name'],
                                            style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 11,
                                            ),
                                          ),
                                          if (group['status'] != null)
                                            Container(
                                              margin: const EdgeInsets.only(top: 3),
                                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                group['status'],
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.w600,
                                                  color: getStatusTextColor(group['status']),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text: '( ',
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 9, fontWeight: FontWeight.w700, color: Colors.black)),
                                          TextSpan(
                                              text: group['inactive'].toString(),
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w700,
                                                  color: const Color(0xffFF1901))),
                                          TextSpan(
                                              text: ', ',
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 9, fontWeight: FontWeight.w700, color: Colors.black)),
                                          TextSpan(
                                              text: group['active'].toString(),
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w700,
                                                  color: const Color(0xff007BFF))),
                                          TextSpan(
                                              text: ', ',
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 9, fontWeight: FontWeight.w700, color: Colors.black)),
                                          TextSpan(
                                              text: group['notice'].toString(),
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w700,
                                                  color: const Color(0xff8D91A0))),
                                          TextSpan(
                                              text: ' ) / ${group['all']}',
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 9, fontWeight: FontWeight.w700, color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                      ],
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
