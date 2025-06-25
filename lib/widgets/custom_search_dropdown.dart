import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomClientDropdown extends StatefulWidget {
  final List<Map<String, dynamic>> clients;
  final Function(String clientName, String? clientId) onChanged;
  final String? initialClientName;

  const CustomClientDropdown({
    required this.clients,
    required this.onChanged,
    required this.initialClientName,
    super.key,
  });

  @override
  State<CustomClientDropdown> createState() => _CustomClientDropdownState();
}

class _CustomClientDropdownState extends State<CustomClientDropdown> {
  final TextEditingController _controller = TextEditingController();
  bool _showDropdown = false;
  List<Map<String, dynamic>> filteredClients = [];

  @override
  void initState() {
    super.initState();
    filteredClients = widget.clients;
print('tev d ${widget.initialClientName}');
    if (widget.initialClientName != null) {
      _controller.text = widget.initialClientName!;
    } else if (widget.clients.isNotEmpty) {
      // fallback
      final first = widget.clients.first;
      _controller.text = first['serving_client'];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onChanged(first['serving_client'], first['id'].toString());
      });
    }

    print('_controller.text ${_controller.text}');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _filterClients(String query) {
    setState(() {
      filteredClients = widget.clients
          .where((client) => client['serving_client']
          .toLowerCase()
          .contains(query.toLowerCase()))
          .toList();
    });
  }

  void _selectClient(Map<String, dynamic> client) {
    _controller.text = client['serving_client'];
    widget.onChanged(client['serving_client'], client['id'].toString());
    setState(() => _showDropdown = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => setState(() => _showDropdown = !_showDropdown),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color.fromRGBO(141, 145, 160, 0.5)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
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
                            hintText: 'Start typing or click to see clients/consultants',
                            hintStyle: TextStyle(color: Color.fromRGBO(141, 145, 160, 0.5)),
                            border: InputBorder.none,
                          ),
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color.fromRGBO(141, 145, 160, 0.5),
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
                if (_showDropdown)
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.2,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredClients.length,
                      itemBuilder: (context, index) {
                        final client = filteredClients[index];
                        return GestureDetector(
                          onTap: () => _selectClient(client),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xffF5F5F5),
                              borderRadius: BorderRadius.circular(3),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.25),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.shade200,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    client["initials"] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    client["serving_client"],
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: '( ',
                                          style: GoogleFonts.montserrat(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 10)),
                                      TextSpan(
                                          text: client['inactive'].toString(),
                                          style: GoogleFonts.montserrat(
                                              color: const Color(0xffFF1901),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 10)),
                                      TextSpan(
                                          text: ', ',
                                          style: GoogleFonts.montserrat(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 10)),
                                      TextSpan(
                                          text: client['active'].toString(),
                                          style: GoogleFonts.montserrat(
                                              color: const Color(0xff007BFF),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 10)),
                                      TextSpan(
                                          text: ', ',
                                          style: GoogleFonts.montserrat(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 10)),
                                      TextSpan(
                                          text:  client['notice'].toString(),
                                          style: GoogleFonts.montserrat(
                                              color: const Color(0xff8D91A0),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 10)),
                                      TextSpan(
                                          text: ' ) / ${client['all'].toString()}',
                                          style: GoogleFonts.montserrat(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 10)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

