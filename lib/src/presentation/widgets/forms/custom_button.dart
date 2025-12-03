import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final GestureTapCallback? onTap;
  final String name;
  final Color? color;
  final double? width;
  final IconData? icon;
  const CustomButton({
    super.key,
    this.onTap,
    required this.name,
    this.color,
    this.width = double.infinity,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: Colors.white),
                const SizedBox(width: 4),
              ],
              Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCancelButton extends StatelessWidget {
  final GestureTapCallback? onTap;
  final String name;
  const CustomCancelButton({super.key, this.onTap, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final Color? backgroundColor;
  final Color? iconColor;
  final IconData icon;
  final VoidCallback onPressed;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.blue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor ?? Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}

class CustomPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final IconData? icon;

  const CustomPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color = const Color(0xFFEC407A), // Rosa predeterminado
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: icon != null
            ? Icon(icon, color: Colors.white)
            : const SizedBox.shrink(),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String iconAsset;
  final String text;
  final Color iconBackgroundColor;
  final Color textColor;
  final Color loadingColor;
  final double height;
  final double? width;
  final bool alignCenter;

  const SocialButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.iconAsset,
    required this.text,
    this.iconBackgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.loadingColor = Colors.blue,
    this.height = 50,
    this.width,
    this.alignCenter = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: isLoading
          ? Center(child: CircularProgressIndicator(color: loadingColor))
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: iconBackgroundColor,
                foregroundColor: textColor,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(iconAsset, height: 24, width: 24),
                  const SizedBox(width: 12),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
    );

    return alignCenter
        ? Align(alignment: Alignment.center, child: button)
        : button;
  }
}
