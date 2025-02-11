import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../colors/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color leadingIconColor;
  final Color trailingIconColor;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final double elevation;
  final bool centerTitle;
  final Color backgroundColor;
  final Color? titleColor;
  final AssetImage? imgTitle;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final void Function()? onPressedleading;
  final void Function()? onPressedTrailing;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leadingIconColor = Colors.black,
    this.trailingIconColor = const Color(0xFF34363C),
    this.leadingIcon,
    this.trailingIcon,
    this.elevation = 3,
    this.centerTitle = false,
    this.backgroundColor = Colors.white,
    this.titleColor = Colors.black,
    this.onPressedleading,
    this.onPressedTrailing,
    this.imgTitle,
    this.actions,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: leadingIcon != null ? 0.0 : null,
      elevation: elevation,
      backgroundColor: backgroundColor,
      shadowColor: Colors.black87,
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      leading: leadingIcon != null
          ? IconButton(
              icon: Icon(leadingIcon, color: leadingIconColor),
              onPressed: onPressedleading ?? () => {},
            )
          : null,
      actions: actions ??
          (trailingIcon != null
              ? [
                  IconButton(
                    icon: Icon(trailingIcon, color: trailingIconColor),
                    onPressed: onPressedTrailing ?? () => {},
                  ),
                ]
              : null),
      title: imgTitle != null
          ? Image(
              image: imgTitle!,
              fit: BoxFit.cover,
              height: 32,
              width: 110.12,
              color: CustomColors.blue,
            )
          : Text(
              title,
              style: GoogleFonts.workSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              
            ),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
