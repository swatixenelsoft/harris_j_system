import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomClientDropDownClaimInvoice extends StatefulWidget {
  final List<Map<String, dynamic>> clients;
  final String? initialClientName;
  const CustomClientDropDownClaimInvoice({super.key,
  required this.clients,
  required this.initialClientName,
  });

  @override
  State<CustomClientDropDownClaimInvoice> createState() => _CustomClientDropDownClaimInvoiceState();
}

class _CustomClientDropDownClaimInvoiceState extends State<CustomClientDropDownClaimInvoice> {
  bool _showDropdown = false;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> filteredClients = [];
  int? expandedClientIndex;


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
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   widget.onChanged(first['serving_client'], first['id'].toString());
      // });
    }

    print('_controller.text ${_controller.text}');
  }

  void _filterClients(String query) {
    setState(() {
      filteredClients = widget.clients
          .where((client) =>
          client["serving_client"]
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  void _selectClient(Map<String, dynamic> client) {
    // Handle selection
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
              border:
              Border.all(color: const Color.fromRGBO(141, 145, 160, 0.5)),
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
                            hintText:
                            'Start typing or click to see clients/consultants',
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(141, 145, 160, 0.5)),
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
                        _showDropdown
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: const Color(0xff8D91A0),
                      ),
                    ],
                  ),
                ),
                if (_showDropdown)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.34,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredClients.length,
                      itemBuilder: (context, index) {
                        final client = filteredClients[index];
                        final isExpanded = expandedClientIndex == index;

                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () => _selectClient(client),
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                padding:
                                const EdgeInsets.symmetric(horizontal: 5),
                                height: 50,
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
                                          const TextSpan(
                                            text: '( ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 10),
                                          ),
                                          TextSpan(
                                            text: client['inactive'].toString(),
                                            style: const TextStyle(
                                                color: Color(0xffFF1901),
                                                fontWeight: FontWeight.w700,
                                                fontSize: 10),
                                          ),
                                          const TextSpan(
                                            text: ', ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 10),
                                          ),
                                          TextSpan(
                                            text: client['active'].toString(),
                                            style: const TextStyle(
                                                color: Color(0xff007BFF),
                                                fontWeight: FontWeight.w700,
                                                fontSize: 10),
                                          ),
                                          const TextSpan(
                                            text: ', ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 10),
                                          ),
                                          TextSpan(
                                            text: client['notice'].toString(),
                                            style: const TextStyle(
                                                color: Color(0xff8D91A0),
                                                fontWeight: FontWeight.w700,
                                                fontSize: 10),
                                          ),
                                          TextSpan(
                                            text: ' ) / ${client['all']}',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(isExpanded
                                          ? Icons.expand_less
                                          : Icons.expand_more,color: Colors.black,),
                                      onPressed: () {
                                        setState(() {
                                          expandedClientIndex = isExpanded
                                              ? null
                                              : index;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (isExpanded && client['consultants'].isNotEmpty)
                                SizedBox(
                                  height: 80, // Set the scrollable height here as needed
                                  width: double.infinity,
                                  child: Scrollbar(
                                    thumbVisibility: true, // Show scrollbar thumb
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: List.generate(
                                          client['consultants'].length,
                                              (i) => Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          '${client['consultants'][i]['emp_name']}',
                                                          style: GoogleFonts.montserrat(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            const TextSpan(
                                                              text: '( ',
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 10),
                                                            ),
                                                            TextSpan(
                                                              text: client['inactive'].toString(),
                                                              style: const TextStyle(
                                                                  color: Color(0xffFF1901),
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 10),
                                                            ),
                                                            const TextSpan(
                                                              text: ', ',
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 10),
                                                            ),
                                                            TextSpan(
                                                              text: client['active'].toString(),
                                                              style: const TextStyle(
                                                                  color: Color(0xff007BFF),
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 10),
                                                            ),
                                                            const TextSpan(
                                                              text: ', ',
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 10),
                                                            ),
                                                            TextSpan(
                                                              text: client['notice'].toString(),
                                                              style: const TextStyle(
                                                                  color: Color(0xff8D91A0),
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 10),
                                                            ),
                                                            TextSpan(
                                                              text: ' ) / ${client['all']}',
                                                              style: const TextStyle(
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 10),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (i != client['consultants'].length - 1)
                                                  const Divider(thickness: 1, color: Color(0xffE4E4EF)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),


                          ],
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
