import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/screens/navigation/constant.dart';
import 'package:harris_j_system/screens/navigation/go_router.dart';
import 'package:harris_j_system/widgets/leave_log_widget.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<WalkthroughPage> pages = [
    WalkthroughPage(
      imageUrl: 'assets/images/banner1.png',
      title: 'Automated Billings',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ',
    ),
    WalkthroughPage(
      imageUrl: 'assets/images/banner2.png',
      title: ' Role-Based Access',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ',
    ),
    WalkthroughPage(
      imageUrl: 'assets/images/banner3.png',
      title: 'Real time reporting',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ',
    ),
  ];

  void _onSkip() {
    context.push(Constant.login);
  }
  void _onNext() {
    if (_currentPage == pages.length - 1) {
      // Last page => "Done"
      _onSkip(); // or navigate to next screen
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              // PageView to swipe between walkthrough pages
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return WalkthroughPageWidget(page: pages[index]);
                },
              ),
            ),
            const SizedBox(height: 8),
            // Dots indicator (optional)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 7,
                  width: _currentPage == index ? 43 : 7,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? const Color(0xffD94B2B)
                        : const Color(0xffD1D7E0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const Spacer(),
            // Bottom buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _onSkip,
                    child: Text(
                      'SKIP TOUR',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: const Color(0xff49494999)),
                    ),
                  ),
                  TextButton(
                    onPressed: _onNext,
                    child: Text(
                      _currentPage == pages.length - 1 ? 'DONE' : 'NEXT',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: const Color(0xffD94B2B)),
                    ),
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

// Simple model class for each walkthrough page
class WalkthroughPage {
  final String imageUrl;
  final String title;
  final String description;
  WalkthroughPage({
    required this.imageUrl,
    required this.title,
    required this.description,
  });
}

// Widget to display a single walkthrough page
class WalkthroughPageWidget extends StatelessWidget {
  final WalkthroughPage page;

  const WalkthroughPageWidget({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 120),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          SizedBox(
            height: 300,
            child: Image.asset(
              page.imageUrl,
              fit: BoxFit.contain,
            ),
          ),

          // Title
          Text(
            page.title,
            style: GoogleFonts.montserrat(
                fontSize: 16, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Description
          Text(
            page.description,
            style: GoogleFonts.montserrat(
                fontSize: 12, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Example next screen after skipping or finishing
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: const Center(
        child: Text('You have reached the Home Screen!'),
      ),
    );
  }
}
