import 'package:flutter/material.dart';
import 'package:palmmobilechalenge/shared/theme.dart';

class HomeBookCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final bool isSelected;
  final VoidCallback? onTap;

  const HomeBookCard({
    Key? key, // Perbaiki deklarasi key
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.onTap,
    this.isSelected = false,
  }) : super(key: key);

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
            const SizedBox(
              width: 14,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: blackTextStyle.copyWith(
                      fontWeight: semiBold,
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    subtitle,
                    style: greyTextStyle.copyWith(
                      fontWeight: medium,
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
