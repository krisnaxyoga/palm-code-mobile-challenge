import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:palmmobilechalenge/shared/theme.dart';
import 'package:palmmobilechalenge/ui/widgets/buttons.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int currentIndex = 0;
  CarouselController carouselController = CarouselController();
  List<String> titles = [
    'Grow Your \n Financial Today',
    'Build From\n Zero to Freedom',
    'Start Together'
  ];

  List<String> subtitles = [
    'Our system is helping you to \n achieve a better goal',
    'We provide tips for you so that\nyou can adapt easier',
    'We will guide you to where\nyou wanted it too'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: lightBackgoundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                CarouselSlider(
                  items: [
                    Image.asset(
                      'assets/img_onboarding1.png',
                      height: 250,
                    ),
                    Image.asset(
                      'assets/img_onboarding2.png',
                      height: 250,
                    ),
                    Image.asset(
                      'assets/img_onboarding3.png',
                      height: 250,
                    ),
                  ],
                  options: CarouselOptions(
                      onPageChanged: (index, reason) => {
                            setState(() {
                              currentIndex = index;
                            })
                          },
                      height: 250,
                      viewportFraction: 1,
                      enableInfiniteScroll: false),
                  carouselController: carouselController,
                ),
                const SizedBox(
                  height: 60,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        titles[currentIndex],
                        style: blackTextStyle.copyWith(
                          fontSize: 15,
                          fontWeight: bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 26,
                      ),
                      Text(
                        subtitles[currentIndex],
                        style: greyTextStyle.copyWith(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: currentIndex == 2 ? 30 : 40,
                      ),
                      currentIndex == 2
                          ? Column(
                              children: [
                                CustomsFilledButton(
                                  title: 'Get Start',
                                  onPressed: () {
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        '/home-page', (route) => false);
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: currentIndex == 0
                                          ? blueColor
                                          : lightBackgroundColor),
                                ),
                                Container(
                                  width: 10,
                                  height: 10,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: currentIndex == 1
                                          ? blueColor
                                          : lightBackgroundColor),
                                ),
                                Container(
                                  width: 10,
                                  height: 10,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: currentIndex == 2
                                          ? blueColor
                                          : lightBackgroundColor),
                                ),
                                const Spacer(),
                                CustomsFilledButton(
                                  title: 'Continue',
                                  onPressed: () {
                                    carouselController.nextPage();
                                  },
                                  width: 125,
                                  height: 45,
                                ),
                              ],
                            )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
