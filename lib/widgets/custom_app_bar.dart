import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
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
   required this.image,
    this.onBackPressed,
    this.onNotificationPressed,
    this.onProfilePressed,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: showBackButton
            ? IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: onBackPressed ?? () => Navigator.pop(context),
        )
            : const SizedBox.shrink(), // Hides if `showBackButton` is false
        title:Image.asset(image,height: 39,width: 130,),
        centerTitle: true,
        actions: [
          if (showNotificationIcon)
            SvgPicture.asset('assets/icons/notification_icon.svg',height: 29,width: 26,),
            // IconButton(
            //   icon: const Icon(Icons.notifications, color: Colors.black),
            //   onPressed: onNotificationPressed ?? () {},
            // ),
          if (showProfileIcon)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SvgPicture.asset('assets/icons/profile_icon.svg',height: 32,width: 32,),
            ),
            // IconButton(
            //   icon: const Icon(Icons.account_circle, color: Colors.black),
            //   onPressed: onProfilePressed ?? () {},
            // ),


        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50); // Adjust height if needed
}
