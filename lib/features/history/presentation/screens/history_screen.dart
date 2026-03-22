import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickscan_pro/core/theme/colors.dart';
import 'package:quickscan_pro/core/theme/text_styles.dart';
import 'package:quickscan_pro/data/models/scan_history.dart';
import 'package:quickscan_pro/features/history/logic/history_provider.dart';
import 'package:quickscan_pro/features/history/presentation/widgets/history_card.dart';
import 'package:quickscan_pro/features/scanner/presentation/widgets/scan_result_sheet.dart';
import 'package:quickscan_pro/core/constants/strings.dart';
import 'package:share_plus/share_plus.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quickscan_pro/core/services/ad_service.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  _HistoryFilter _activeFilter = _HistoryFilter.all;
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;
  NativeAd? _nativeAd;
  bool _isNativeLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAds();
  }

  void _loadAds() {
    _bannerAd = BannerAd(
      adUnitId: AdService.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _isBannerLoaded = true),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('BannerAd failed to load: $error');
        },
      ),
    )..load();

    _nativeAd = NativeAd(
      adUnitId: AdService.nativeAdUnitId,
      factoryId: 'listTile', // Standard factory ID for list-integrated ads
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (_) => setState(() => _isNativeLoaded = true),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('NativeAd failed to load: $error');
        },
      ),
    )..load();
  }
  @override
  void dispose() {
    _searchController.dispose();
    _bannerAd?.dispose();
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(historyProvider);
    final historyNotifier = ref.read(historyProvider.notifier);
    final bottomSafePadding = MediaQuery.of(context).padding.bottom + 100;

    final filteredHistory = history.where((scan) {
      final searchMatches = scan.content.toLowerCase().contains(_searchQuery.toLowerCase());
      final now = DateTime.now();
      final isToday = scan.timestamp.year == now.year && scan.timestamp.month == now.month && scan.timestamp.day == now.day;

      final filterMatches = switch (_activeFilter) {
        _HistoryFilter.all => true,
        _HistoryFilter.favorites => scan.isFavorite,
        _HistoryFilter.today => isToday,
      };

      return searchMatches && filterMatches;
    }).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildGlassHeader(historyNotifier),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildOverviewCard(filteredHistory.length),
                _buildSearchAndFilters(),
                if (filteredHistory.isEmpty)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: _buildEmptyState(isSearching: _searchQuery.isNotEmpty, activeFilter: _activeFilter),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8).copyWith(bottom: bottomSafePadding),
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      // Only show Native Ad if we have enough items (e.g. at least 3)
                      if (index == 2 && _isNativeLoaded && filteredHistory.length >= 3) {
                        return _buildNativeAdCard();
                      }
                      
                      final scanOffset = (_isNativeLoaded && filteredHistory.length >= 3 && index > 2) ? 1 : 0;
                      final scanIndex = index - scanOffset;
                      
                      if (scanIndex < 0 || scanIndex >= filteredHistory.length) return const SizedBox.shrink();
                      
                      final scan = filteredHistory[scanIndex];
                      return HistoryCard(
                        scan: scan,
                        onTap: () => _showScanResult(context, scan),
                        onFavoriteToggle: () => historyNotifier.toggleFavoriteById(scan.id),
                        onDelete: () => historyNotifier.deleteScanById(scan.id),
                      ).animate().fade(delay: (index * 30).ms, duration: 300.ms).slideY(begin: 0.05, end: 0);
                    },
                    itemCount: (_isNativeLoaded && filteredHistory.length >= 3) ? filteredHistory.length + 1 : filteredHistory.length,
                  ),
              ],
            ),
          ),
          if (_isBannerLoaded)
            Container(
              alignment: Alignment.center,
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
        ],
      ),
    );
  }

  Widget _buildGlassHeader(HistoryNotifier notifier) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppStrings.timeline, style: AppTextStyles.h2),
          Row(
            children: [
              IconButton(
                onPressed: () => _exportHistory(ref.read(historyProvider)),
                icon: const Icon(Icons.ios_share_rounded, color: AppColors.primary, size: 24),
                tooltip: AppStrings.exportHistory,
              ),
              IconButton(
                onPressed: () => _showClearConfirmation(context, notifier),
                icon: const Icon(Icons.delete_sweep_rounded, color: AppColors.textDimmed, size: 24),
                tooltip: AppStrings.clearHistory,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.primaryDim.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.insights_rounded, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$count items', style: AppTextStyles.h3.copyWith(fontSize: 18)),
                Text('Total Scans Recorded', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textDimmed)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNativeAdCard() {
    if (!_isNativeLoaded) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Stack(
          children: [
            AdWidget(ad: _nativeAd!),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Text(
                  'AD',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              style: AppTextStyles.bodyMedium.copyWith(color: Theme.of(context).colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Search scans...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDimmed),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            children: [
              _buildFilterChip('All Scans', _activeFilter == _HistoryFilter.all, () => setState(() => _activeFilter = _HistoryFilter.all)),
              const SizedBox(width: 10),
              _buildFilterChip('Favorites', _activeFilter == _HistoryFilter.favorites, () => setState(() => _activeFilter = _HistoryFilter.favorites)),
              const SizedBox(width: 10),
              _buildFilterChip('Recent', _activeFilter == _HistoryFilter.today, () => setState(() => _activeFilter = _HistoryFilter.today)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.1) : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: selected ? AppColors.primary.withValues(alpha: 0.3) : Theme.of(context).dividerColor),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(color: selected ? AppColors.primary : AppColors.textDimmed),
        ),
      ),
    );
  }

  Widget _buildEmptyState({required bool isSearching, required _HistoryFilter activeFilter}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(isSearching ? Icons.search_off_rounded : Icons.history_rounded, size: 64, color: AppColors.textDimmed.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Text(isSearching ? 'No matches found' : 'Your history is clear', style: AppTextStyles.h3.copyWith(color: AppColors.textDimmed)),
        ],
      ),
    );
  }

  void _showScanResult(BuildContext context, ScanHistory scan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ScanResultSheet(content: scan.content, format: scan.format),
    );
  }

  void _showClearConfirmation(BuildContext context, HistoryNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppStrings.clearHistory, style: AppTextStyles.h3),
        content: Text(AppStrings.clearHistoryDesc, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDimmed)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text(AppStrings.cancel, style: TextStyle(color: AppColors.textDimmed))),
          TextButton(
            onPressed: () {
              notifier.clearAll();
              Navigator.pop(context);
            },
            child: const Text(AppStrings.clearAll, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _exportHistory(List<ScanHistory> history) async {
    if (history.isEmpty) return;
    
    try {
      final List<List<dynamic>> rows = [
        ['ID', 'Date', 'Type', 'Format', 'Content', 'Is Favorite'],
        ...history.map((s) => [
          s.id,
          s.timestamp.toIso8601String(),
          s.type,
          s.format,
          s.content,
          s.isFavorite ? 'Yes' : 'No',
        ]),
      ];

      final csvData = const ListToCsvConverter().convert(rows);
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/${AppStrings.csvFileName}';
      final file = File(path);
      await file.writeAsString(csvData);

      await Share.shareXFiles([XFile(path)], text: AppStrings.exportHistory);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.exportSuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.exportFailed)),
        );
      }
    }
  }
}

enum _HistoryFilter { all, favorites, today }
