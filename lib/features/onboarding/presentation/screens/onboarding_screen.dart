import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickscan_pro/core/navigation/shared_axis_route.dart';
import 'package:quickscan_pro/core/theme/colors.dart';
import 'package:quickscan_pro/core/theme/text_styles.dart';
import 'package:quickscan_pro/core/constants/strings.dart';
import 'package:quickscan_pro/core/widgets/press_scale.dart';
import 'package:quickscan_pro/features/onboarding/logic/onboarding_provider.dart';
import 'package:quickscan_pro/features/onboarding/presentation/widgets/onboarding_page.dart';
import 'package:quickscan_pro/features/home/presentation/screens/home_screen.dart';
import 'package:quickscan_pro/core/services/notification_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: AppStrings.onboarding1Title,
      description: AppStrings.onboarding1Desc,
      icon: Icons.bolt_rounded,
    ),
    OnboardingData(
      title: AppStrings.onboarding2Title,
      description: AppStrings.onboarding2Desc,
      icon: Icons.auto_awesome_rounded,
    ),
    OnboardingData(
      title: AppStrings.onboarding3Title,
      description: AppStrings.onboarding3Desc,
      icon: Icons.history_rounded,
    ),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _complete();
    }
  }

  Future<void> _complete() async {
    await ref.read(onboardingProvider.notifier).completeOnboarding();
    
    // Schedule a daily reminder to keep the user engaged
    await NotificationService.scheduleDailyNotification();
    
    if (!mounted) return;
    pushReplacementSharedAxis(
      context,
      const HomeScreen(),
      type: SharedAxisTransitionType.scaled,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return OnboardingPage(
                title: _pages[index].title,
                description: _pages[index].description,
                icon: _pages[index].icon,
              );
            },
          ),

          // Skip Button
          Positioned(
            top: 64,
            right: 24,
            child: GestureDetector(
              onTap: _complete,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    child: Text(
                      AppStrings.skip,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Navigation Bottom
          Positioned(
            bottom: 64,
            left: 32,
            right: 32,
            child: Column(
              children: [
                // Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => _buildIndicator(index == _currentPage),
                  ),
                ),
                const SizedBox(height: 48),
                // Next/Get Started Button
                PressScale(
                  onTap: _onNext,
                  child: Container(
                    height: 64,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1)
                              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.02),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _currentPage == _pages.length - 1 ? AppStrings.getStarted : AppStrings.next,
                        style: AppTextStyles.labelLarge.copyWith(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 6,
      width: isActive ? 32 : 6,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(3),
        boxShadow: isActive
            ? [
                BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.black.withValues(alpha: 0.4) 
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
    ]
            : null,
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
  });
}
