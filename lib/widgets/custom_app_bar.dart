import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final bool showNotificationIcon;
  final bool showProfileIcon;
  final String image;
  final VoidCallback? onBackPressed;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onProfilePressed;

  const CustomAppBar({
    super.key,
    this.showBackButton = true,
    this.showNotificationIcon = true,
    this.showProfileIcon = true,
    this.onBackPressed,
    required this.image,
    this.onNotificationPressed,
    this.onProfilePressed,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class _CustomAppBarState extends State<CustomAppBar> {
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadImageFromPrefs();
  }

  Future<void> _loadImageFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedImage = prefs.getString("consultancyLogo"); // key used when saving
    print('storedImage $storedImage');
    setState(() {
      _imageUrl = storedImage ?? 'assets/icons/cons_logo.png'; // default if not found
    });

    print('_imageUrl $_imageUrl');
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leadingWidth: widget.showBackButton ? 50 : 0,
      leading: widget.showBackButton
          ? IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
        onPressed: widget.onBackPressed ?? () => Navigator.pop(context),
      )
          : const SizedBox.shrink(),
      title: Align(
        alignment: Alignment.centerLeft,
        child: _imageUrl != null
            ? (_imageUrl!.startsWith("http")
            ? Image.network(_imageUrl!, height: 39, fit: BoxFit.contain)
            : Image.asset('assets/icons/cons_logo.png', height: 39, width: 130, fit: BoxFit.contain))
            : const SizedBox(height: 39, width: 130),
      ),
      centerTitle: false,
      actions: [
        if (widget.showNotificationIcon)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SvgPicture.asset(
              'assets/icons/notification_icon.svg',
              height: 29,
              width: 26,
            ),
          ),
        if (widget.showProfileIcon)
          GestureDetector(
            onTap: widget.onProfilePressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SvgPicture.asset(
                'assets/icons/profile_icon.svg',
                height: 32,
                width: 32,
              ),
            ),
          ),
      ],
    );
  }
}
