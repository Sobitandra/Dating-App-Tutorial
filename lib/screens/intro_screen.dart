import 'package:carousel_slider/carousel_slider.dart';
import 'package:dating_app_yt/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int currentIndex = 0;
  static const String imageUrl =
      "https://images.unsplash.com/photo-1494790108377-be9c29b29330?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZSUyMGltYWdlfGVufDB8fDB8fHww";

  List<String> images = [imageUrl, imageUrl, imageUrl];
  CarouselSliderController carouselController = CarouselSliderController();

  List<String> titles = ["Algorithmic Matching", "Real-time Chat", "Privacy Focused"];
  List<String> descriptions = [
    "Find your perfect match with our advanced algorithm that learns your preferences.",
    "Connect instantly with matches through our secure real-time chat feature.",
    "Your privacy is our priority. Enjoy a safe and secure dating experience.",
  ];

  onPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      currentIndex = index;
    });
  }

  double width = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    width = MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Gap(20),
            SizedBox(
              width: double.infinity,
              child: CarouselSlider(
                carouselController: carouselController,
                items: images.map((e) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(e, fit: BoxFit.cover),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: width,
                  autoPlay: false,
                  onPageChanged: onPageChanged,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.68,
                ),
              ),
            ),
            Gap(50),
            HandleTextAnimation(
              index: currentIndex,
              child: Text(
                titles[currentIndex],
                style: TextStyle(color: AppColors.primaryColor, fontSize: 22, fontWeight: FontWeight.w700),
              ),
            ),
            Gap(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: HandleTextAnimation(
                index: currentIndex,
                child: Text(
                  descriptions[currentIndex],
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Gap(25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: images.asMap().entries.map((e) {
                bool isActive = e.key == currentIndex;
                return GestureDetector(
                  onTap: () {
                    carouselController.animateToPage(e.key, duration: 300.milliseconds, curve: Curves.easeInOut);
                  },
                  child: AnimatedContainer(
                    duration: 300.milliseconds,
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primaryColor : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: isActive ? 24 : 10,
                    height: 8,
                    margin: EdgeInsets.symmetric(horizontal: 2),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  ),
                  child: Text(
                    "Create an Account",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            Gap(16),
            RichText(
              text: TextSpan(
                text: "Already have an account? ",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                children: [
                  TextSpan(
                    text: "Sign In",
                    style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w600),
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

class HandleTextAnimation extends StatelessWidget {
  const HandleTextAnimation({super.key, required this.child, required this.index});
  final Widget child;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: 300.milliseconds,
      transitionBuilder: (Widget c, Animation<double> a) {
        return FadeTransition(
          opacity: a,
          child: SizeTransition(sizeFactor: a, axis: Axis.horizontal, axisAlignment: 0.0, child: c),
        );
      },
      child: SizedBox(key: ValueKey(index), child: child),
    );
  }
}
