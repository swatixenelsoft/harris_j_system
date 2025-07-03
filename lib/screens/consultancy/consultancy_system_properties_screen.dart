import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/static_system_provider.dart';
import 'package:harris_j_system/screens/consultancy/add_lookup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SystemPropertyScreen extends ConsumerStatefulWidget {
  const SystemPropertyScreen({super.key});

  @override
  ConsumerState<SystemPropertyScreen> createState() => _SystemPropertyScreenState();
}

class _SystemPropertyScreenState extends ConsumerState<SystemPropertyScreen> {
  int? _expandedRowIndex;


  getSystemPropertyList() async {
    ref.read(staticSettingProvider.notifier).setLoading(true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final  userId = prefs.getInt('userId');

    await ref.read(staticSettingProvider.notifier).getSystemProperty(userId.toString(),token!);

    ref.read(staticSettingProvider.notifier).setLoading(false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.microtask(() {
      getSystemPropertyList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final staticSettingState = ref.watch(staticSettingProvider);


    final isLoading = staticSettingState.isLoading;
    print('isLoading $isLoading');
    final lookupList=staticSettingState.lookupList??[];
    print('lookupList $lookupList');

    return Column(
      children: [
        // Header Row
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          color: const Color.fromRGBO(242, 242, 242, 1),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  "Property Name",
                  style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Status",
                  style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Actions",
                  style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xffE8E8E8), thickness: 1.0),
        // List of Properties
        Expanded(
          child: ListView.builder(
            itemCount: lookupList!.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final item = lookupList[index];
              final bool isActive = item['status'] == 1;
              final bool isExpanded = _expandedRowIndex == index;
              final List<dynamic>? options = item['lookup_options'];
              return Column(
                children: [
                  // Property Row
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            item['property_name'] ?? '',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 12,
                              color: const Color(0xff1D212D),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                            decoration: BoxDecoration(
                              color: isActive ? const Color(0xFFEBF9F1) : const Color(0xFFFBE7E8),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: isActive ? const Color(0xFF1F9254) : const Color(0xFFA30D11),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isActive ? 'Active' : 'Inactive',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isActive ? const Color(0xFF1F9254) : const Color(0xFFA30D11),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 40),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _expandedRowIndex = isExpanded ? null : index;
                                  });
                                },
                                child: SvgPicture.asset(
                                  isExpanded ? 'assets/icons/drop_up.svg' : 'assets/icons/drop_down.svg',
                                  width: 20,
                                ),
                              ),
                              const SizedBox(width: 14),
                              GestureDetector(
                                onTap: () {

                                  showDialog(
                                    context: context,
                                    builder: (context) => AddLookupPopup(lookupItem:item),
                                  );

                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   SnackBar(content: Text('Edit ${item['property_name']}')),
                                  // );
                                },
                                child: SvgPicture.asset('assets/icons/pen2.svg', width: 20),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xffE4E4EF), thickness: 1.0),

                  // Expanded lookup_options
                  if (isExpanded)
                    Container(
                      color: const Color(0xFFF9F9F9),
                      child: Column(
                        children: [
                          // Header
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                            color: const Color(0xFFF2F2F2),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Option Name',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Option Value',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Actions',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1, color: Color(0xffE4E4EF), thickness: 1.0),

                          // Lookup options list
                          (options != null && options .isNotEmpty)
                              ? Column(
                            children: List.generate(options.length, (optIndex) {
                              final option = options[optIndex];
                              print('optionnnn ${option}');
                              return Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
                                    color: Colors.white,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            option['option_name'] ?? '',
                                            style: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            option['option_value'] ?? '',
                                            style: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => AddLookupPopup(lookupItem:item,optionItem:option,index:optIndex),
                                                  );
                                                },
                                                child: SvgPicture.asset('assets/icons/pen2.svg', width: 20),
                                              ),
                                              const SizedBox(width: 12),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    item['lookup_options'].removeAt(optIndex);
                                                  });
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Deleted ${option['option_name']}')),
                                                  );
                                                },
                                                child: SvgPicture.asset('assets/icons/dustbin.svg', width: 20),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (optIndex < item['lookup_options'].length - 1)
                                    const Divider(height: 1, color: Color(0xffE4E4EF), thickness: 1.0),
                                ],
                              );
                            }),
                          )
                              : Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'No options available',
                              style: GoogleFonts.spaceGrotesk(fontSize: 13, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),

      ],
    );

  }
}