import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:quickscan_pro/core/navigation/shared_axis_route.dart';
import 'package:quickscan_pro/core/widgets/press_scale.dart';
import 'package:quickscan_pro/core/theme/colors.dart';
import 'package:quickscan_pro/core/theme/text_styles.dart';
import 'package:quickscan_pro/features/history/logic/history_provider.dart';
import 'package:quickscan_pro/features/history/presentation/screens/history_screen.dart';
import 'package:quickscan_pro/features/generator/presentation/screens/qr_generator_screen.dart';
import 'package:quickscan_pro/features/settings/presentation/screens/settings_screen.dart';
import 'package:quickscan_pro/features/scanner/presentation/screens/scanner_screen.dart';
import 'package:quickscan_pro/features/batch_scan/presentation/screens/batch_scanner_screen.dart';
import 'package:quickscan_pro/features/scanner/presentation/widgets/scan_result_sheet.dart';
import 'package:quickscan_pro/features/home/logic/home_tab_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final int initialTabIndex;

  const HomeScreen({super.key, this.initialTabIndex = 0});

  const HomeScreen.withInitialTab({
    super.key,
    required this.initialTabIndex,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  final MobileScannerController _scannerController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final int targetIndex = widget.initialTabIndex.clamp(0, 3);
      ref.read(homeTabProvider.notifier).state = targetIndex;
    });
  }

  void _openScanner() {
    pushSharedAxis(
      context,
      const ScannerScreen(),
      type: SharedAxisTransitionType.scaled,
    );
  }

  Future<void> _scanFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final BarcodeCapture? capture =
        await _scannerController.analyzeImage(image.path);

    if (capture != null && capture.barcodes.isNotEmpty) {
      if (mounted) {
        _showResultSheet(capture.barcodes.first);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No QR code found in image')),
        );
      }
    }
  }

  void _showResultSheet(Barcode barcode) {
    if (barcode.rawValue == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ScanResultSheet(
        content: barcode.rawValue!,
        format: barcode.format.name,
      ),
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(homeTabProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBody: true,
      body: _buildAnimatedTabBody(currentIndex),
      bottomNavigationBar: _buildGlassNavBar(
        currentIndex: currentIndex,
        onTap: (index) => ref.read(homeTabProvider.notifier).state = index,
      ),
      floatingActionButton: currentIndex == 3
          ? null
          : _buildGlassFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildGlassFAB() {
    return PressScale(
      onTap: _openScanner,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildAnimatedTabBody(int currentIndex) {
    final tabs = [
      _buildHomeContent(),
      const HistoryScreen(),
      const QRGeneratorScreen(),
      const SettingsScreen(),
    ];

    return Stack(
      children: List.generate(tabs.length, (index) {
        final isActive = index == currentIndex;
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          opacity: isActive ? 1 : 0,
          child: IgnorePointer(
            ignoring: !isActive,
            child: TickerMode(
              enabled: isActive,
              child: tabs[index],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          _buildHeroCard(),
          const SizedBox(height: 32),
          Text(
            'Insights',
            style: AppTextStyles.h3.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 16),
          _buildStatsRow(),
          const SizedBox(height: 32),
          Text(
            'Quick Actions',
            style: AppTextStyles.h3.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 16),
          _buildQuickActions(),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: AppTextStyles.h3.copyWith(fontSize: 18),
              ),
              TextButton(
                onPressed: () => ref.read(homeTabProvider.notifier).state = 1,
                child: Text('View All', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildRecentActivity(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('QuickScan', style: AppTextStyles.h1),
            Text('Ready to scan?', style: AppTextStyles.bodyMedium),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: const Icon(Icons.bolt_rounded, color: AppColors.primary, size: 24),
        ),
      ],
    );
  }

  Widget _buildHeroCard() {
    return PressScale(
      onTap: _openScanner,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.center_focus_strong_rounded, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 20),
            Text(
              'Start Instant Scan',
              style: AppTextStyles.h2.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'High-speed detection for all QR & Barcodes with AI enhancement.',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withValues(alpha: 0.8)),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Open Camera',
                style: AppTextStyles.labelLarge.copyWith(color: AppColors.primaryDim),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Consumer(builder: (context, ref, child) {
      final history = ref.watch(historyProvider);
      final favoriteCount = history.where((s) => s.isFavorite).length;

      return Row(
        children: [
          _buildStatItem('Scans', history.length.toString(), Icons.qr_code_2_rounded, AppColors.primary),
          const SizedBox(width: 16),
          _buildStatItem('Saved', favoriteCount.toString(), Icons.star_rounded, Colors.amber),
        ],
      );
    });
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 16),
            Text(value, style: AppTextStyles.h2),
            Text(label, style: AppTextStyles.labelSmall),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _buildActionCard('Gallery', Icons.image_rounded, AppColors.tertiary, _scanFromGallery),
        _buildActionCard('Clipboard', Icons.content_paste_rounded, AppColors.accent, _scanFromClipboard),
        _buildActionCard('Batch', Icons.layers_rounded, AppColors.secondary, () {
          Navigator.of(context).push(SharedAxisPageRoute(
            page: const BatchScannerScreen(),
            transitionType: SharedAxisTransitionType.vertical,
          ));
        }),
        _buildActionCard('History', Icons.history_rounded, AppColors.primary, () => ref.read(homeTabProvider.notifier).state = 1),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return PressScale(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 28),
            Text(title, style: AppTextStyles.labelMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Consumer(builder: (context, ref, child) {
      final history = ref.watch(historyProvider);
      if (history.isEmpty) return const SizedBox.shrink();
      
      final recent = history.take(3).toList();
      return Column(
        children: recent.map((scan) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.qr_code_rounded, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(scan.content, style: AppTextStyles.labelMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(scan.format, style: AppTextStyles.labelSmall),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textDimmed, size: 20),
              ],
            ),
          ),
        )).toList(),
      );
    });
  }

  Widget _buildGlassNavBar({required int currentIndex, required ValueChanged<int> onTap}) {
    final items = [
      const _NavItem(Icons.home_rounded, 'Home'),
      const _NavItem(Icons.history_rounded, 'History'),
      const _NavItem(Icons.auto_awesome_rounded, 'Generate'),
      const _NavItem(Icons.settings_rounded, 'Settings'),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      height: 72,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(36),
              border: Border.all(color: Theme.of(context).dividerColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (index) {
                final isActive = currentIndex == index;
                return Expanded(
                  child: PressScale(
                    onTap: () => onTap(index),
                    useSplash: false,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: isActive 
                            ? AppColors.primary.withValues(alpha: 0.1) 
                            : Colors.transparent,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedScale(
                            scale: isActive ? 1.1 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              items[index].icon,
                              color: isActive ? AppColors.primary : AppColors.textDimmed,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 4),
                          AnimatedSlide(
                            offset: isActive ? Offset.zero : const Offset(0, 0.5),
                            duration: const Duration(milliseconds: 200),
                            child: AnimatedOpacity(
                              opacity: isActive ? 1 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: Text(
                                items[index].label,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _scanFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null && data!.text!.isNotEmpty) {
      if (mounted) {
        ScanResultSheet.show(context, data.text!);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Clipboard is empty')),
        );
      }
    }
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}
