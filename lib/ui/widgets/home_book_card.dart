import 'package:flutter/material.dart';
import 'package:palmmobilechalenge/shared/theme.dart';

class HomeBookCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final bool isSelected;
  final VoidCallback? onTap;
  const HomeBookCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(
          top: 20,
        ),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: whiteColor,
          border: Border.all(
            width: 2,
            color: isSelected ? blueColor : whiteColor,
          ),
        ),
        child: Row(
          children: [
            Image.network(
              imageUrl,
              width: 50,
              height: 50,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/img_logo_dark.png',
                    width: 50, height: 50);
              },
            ),
            const Spacer(),
            Column(
              children: [
                Text(
                  title,
                  style: blackTextStyle.copyWith(
                    fontWeight: medium,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  subtitle,
                  style: greyTextStyle.copyWith(
                    fontSize: 12,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}