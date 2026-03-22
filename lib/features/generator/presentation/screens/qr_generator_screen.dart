import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:quickscan_pro/core/theme/colors.dart';
import 'package:quickscan_pro/core/theme/text_styles.dart';
import 'package:quickscan_pro/core/widgets/press_scale.dart';
import 'package:quickscan_pro/core/utils/content_analyzer.dart';
import 'package:quickscan_pro/core/utils/action_url_builder.dart';
import 'package:quickscan_pro/features/generator/logic/generator_provider.dart';
import 'package:quickscan_pro/features/generator/presentation/widgets/qr_preview_card.dart';
import 'package:quickscan_pro/features/generator/presentation/widgets/qr_type_selector.dart';

class QRGeneratorScreen extends ConsumerStatefulWidget {
  const QRGeneratorScreen({super.key});

  @override
  ConsumerState<QRGeneratorScreen> createState() => _QRGeneratorScreenState();
}

class _QRGeneratorScreenState extends ConsumerState<QRGeneratorScreen> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _upiPaController = TextEditingController();
  final TextEditingController _upiPnController = TextEditingController();
  final TextEditingController _upiAmController = TextEditingController();
  final TextEditingController _upiTnController = TextEditingController();
  final GlobalKey _qrKey = GlobalKey();

  Future<Uint8List?> _capturePng() async {
    try {
      final context = _qrKey.currentContext;
      if (context == null) return null;
      final renderObject = context.findRenderObject();
      if (renderObject is! RenderRepaintBoundary) return null;
      final RenderRepaintBoundary boundary = renderObject;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing QR: $e');
      return null;
    }
  }

  Future<void> _saveToGallery() async {
    if (_contentController.text.isEmpty) return;

    final Uint8List? imageBytes = await _capturePng();
    if (imageBytes == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to capture QR image')),
        );
      }
      return;
    }

    try {
      final permissionGranted = await _requestGalleryPermission();
      if (!permissionGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gallery permission denied')),
          );
        }
        return;
      }

      final fileName = 'quickscan_qr_${DateTime.now().millisecondsSinceEpoch}.png';
      final result = await SaverGallery.saveImage(
        imageBytes,
        quality: 100,
        name: fileName,
        androidRelativePath: 'Pictures/QuickScan',
        androidExistNotSave: false,
      );
      final isSuccess = result.isSuccess;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isSuccess
                  ? 'QR Code saved to gallery'
                  : 'Failed to save QR code to gallery',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save QR code')),
        );
      }
    }
  }

  Future<bool> _requestGalleryPermission() async {
    if (Platform.isAndroid) {
      // Android 13+ uses scoped media permissions; image_gallery_saver can
      // usually persist through MediaStore without broad storage grants.
      return true;
    }

    if (Platform.isIOS) {
      final status = await Permission.photosAddOnly.request();
      return status.isGranted || status.isLimited;
    }

    return true;
  }

  Future<void> _shareQR() async {
    if (_contentController.text.isEmpty) return;

    final Uint8List? imageBytes = await _capturePng();
    if (imageBytes == null) return;

    try {
      final directory = await getTemporaryDirectory();
      final file = File(
          '${directory.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles([XFile(file.path)], text: 'My QR Code');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to share QR code')),
        );
      }
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _upiPaController.dispose();
    _upiPnController.dispose();
    _upiAmController.dispose();
    _upiTnController.dispose();
    super.dispose();
  }

  void _updateUpiContent() {
    final payload = ActionUrlBuilder.buildUpiPayload(
      pa: _upiPaController.text,
      pn: _upiPnController.text,
      am: _upiAmController.text,
      tn: _upiTnController.text,
    );
    _contentController.text = payload;
    ref.read(generatorProvider.notifier).setContent(payload);
  }

  @override
  Widget build(BuildContext context) {
    final generatorState = ref.watch(generatorProvider);
    final generatorNotifier = ref.read(generatorProvider.notifier);
    final hasContent = generatorState.content.trim().isNotEmpty;
    final bottomSafePadding = MediaQuery.of(context).padding.bottom + 100;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildGlassHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(0, 12, 0, bottomSafePadding),
              child: Column(
                children: [
                  QRTypeSelector(
                    selectedType: generatorState.type,
                    onTypeSelected: (type) => generatorNotifier.setType(type),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      child: RepaintBoundary(
                        key: _qrKey,
                        child: QRPreviewCard(
                          key: ValueKey('${generatorState.content}_${generatorState.eyeShape}_${generatorState.dataModuleShape}_${generatorState.foregroundColor.toARGB32()}_${generatorState.backgroundColor.toARGB32()}'),
                          data: generatorState.content,
                          foregroundColor: generatorState.foregroundColor,
                          backgroundColor: generatorState.backgroundColor,
                          eyeShape: generatorState.eyeShape,
                          dataModuleShape: generatorState.dataModuleShape,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (generatorState.content.trim().isEmpty)
                    _buildEmptyStateHints(generatorNotifier, generatorState.type),
                  const SizedBox(height: 24),
                  _buildCustomizationOptions(generatorState, generatorNotifier),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Content', style: AppTextStyles.labelMedium.copyWith(color: Theme.of(context).colorScheme.onSurface)),
                        const SizedBox(height: 12),
                        if (generatorState.type == ScanType.upi)
                          _buildUpiInputForm()
                        else
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Theme.of(context).dividerColor),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _contentController,
                              maxLines: 4,
                              onChanged: (value) => generatorNotifier.setContent(value),
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                height: 1.5,
                              ),
                              cursorColor: AppColors.primary,
                              decoration: InputDecoration(
                                hintText: _getHintText(generatorState.type),
                                hintStyle: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textDimmed.withValues(alpha: 0.5),
                                ),
                                filled: false,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                suffixIcon: _contentController.text.isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: IconButton(
                                          icon: const Icon(Icons.clear_rounded, color: AppColors.textDimmed, size: 20),
                                          onPressed: () {
                                            _contentController.clear();
                                            generatorNotifier.setContent('');
                                            setState(() {});
                                          },
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionButton(
                                label: 'Save',
                                icon: Icons.download_rounded,
                                onTap: hasContent ? _saveToGallery : null,
                                isPrimary: true,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildActionButton(
                                label: 'Share',
                                icon: Icons.share_rounded,
                                onTap: hasContent ? _shareQR : null,
                                isPrimary: false,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Generate', style: AppTextStyles.h2),
        ],
      ),
    );
  }

  Widget _buildActionButton({required String label, required IconData icon, required VoidCallback? onTap, required bool isPrimary}) {
    return PressScale(
      onTap: onTap != null ? () { HapticFeedback.lightImpact(); onTap(); } : () {},
      child: Opacity(
        opacity: onTap != null ? 1.0 : 0.4,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: isPrimary ? AppColors.primaryGradient : null,
            color: isPrimary ? null : Theme.of(context).colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isPrimary ? [
              BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 5)),
            ] : null,
            border: isPrimary ? null : Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isPrimary ? Colors.white : AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(label, style: AppTextStyles.labelMedium.copyWith(color: isPrimary ? Colors.white : Theme.of(context).colorScheme.onSurface)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomizationOptions(GeneratorState state, GeneratorNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Customization', style: AppTextStyles.labelMedium.copyWith(color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 16),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildOptionChip('Square Eyes', state.eyeShape == QrEyeShape.square, () => notifier.setEyeShape(QrEyeShape.square)),
                const SizedBox(width: 10),
                _buildOptionChip('Circle Eyes', state.eyeShape == QrEyeShape.circle, () => notifier.setEyeShape(QrEyeShape.circle)),
                const SizedBox(width: 20),
                _buildOptionChip('Square Dots', state.dataModuleShape == QrDataModuleShape.square, () => notifier.setDataModuleShape(QrDataModuleShape.square)),
                const SizedBox(width: 10),
                _buildOptionChip('Circle Dots', state.dataModuleShape == QrDataModuleShape.circle, () => notifier.setDataModuleShape(QrDataModuleShape.circle)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildColorPicker('Foreground Color', state.foregroundColor, (color) => notifier.setForegroundColor(color)),
          const SizedBox(height: 20),
          _buildColorPicker('Background Color', state.backgroundColor, (color) => notifier.setBackgroundColor(color)),
        ],
      ),
    );
  }

  Widget _buildEmptyStateHints(GeneratorNotifier notifier, ScanType type) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Text('Quick Start', style: AppTextStyles.labelMedium.copyWith(color: Theme.of(context).colorScheme.onSurface)),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _suggestionsFor(type).map((value) {
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    _contentController.text = value;
                    notifier.setContent(value);
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: Text(value, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textDimmed)),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ).animate().fade(duration: 400.ms).slideY(begin: 0.05, end: 0),
    );
  }

  Widget _buildOptionChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primary.withValues(alpha: 0.3) : Theme.of(context).dividerColor),
        ),
        child: Center(child: Text(label, style: AppTextStyles.labelSmall.copyWith(color: isSelected ? AppColors.primary : AppColors.textDimmed))),
      ),
    );
  }

  Widget _buildColorPicker(String label, Color color, Function(Color) onColorSelected) {
    final colors = [Colors.black, Colors.white, AppColors.primary, AppColors.secondary, Colors.red, Colors.blue, Colors.green];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textDimmed)),
        const SizedBox(height: 12),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: colors.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final c = colors[index];
              final isSelected = c.toARGB32() == color.toARGB32();
              return GestureDetector(
                onTap: () => onColorSelected(c),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: Border.all(color: isSelected ? AppColors.primary : Colors.white.withValues(alpha: 0.1), width: isSelected ? 2 : 1),
                  ),
                  child: isSelected ? Icon(Icons.check, size: 18, color: c == Colors.white ? Colors.black : Colors.white) : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUpiInputForm() {
    return Column(
      children: [
        _buildUpiField(
          controller: _upiPaController,
          label: 'UPI ID / VPA',
          hint: 'e.g. user@abc',
          icon: Icons.alternate_email_rounded,
        ),
        const SizedBox(height: 12),
        _buildUpiField(
          controller: _upiPnController,
          label: 'Payee Name',
          hint: 'e.g. John Doe',
          icon: Icons.person_outline_rounded,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildUpiField(
                controller: _upiAmController,
                label: 'Amount (Optional)',
                hint: '0.00',
                icon: Icons.currency_rupee_rounded,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildUpiField(
                controller: _upiTnController,
                label: 'Note (Optional)',
                hint: 'For dinner',
                icon: Icons.note_add_outlined,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUpiField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: TextField(
        controller: controller,
        onChanged: (_) => _updateUpiContent(),
        keyboardType: keyboardType,
        style: AppTextStyles.bodyMedium.copyWith(color: Theme.of(context).colorScheme.onSurface),
        cursorColor: AppColors.primary,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.labelSmall.copyWith(color: AppColors.textDimmed),
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  String _getHintText(ScanType type) {
    switch (type) {
      case ScanType.url: return 'https://example.com';
      case ScanType.email: return 'example@mail.com';
      case ScanType.phone: return '+1234567890';
      case ScanType.wifi: return 'WIFI:T:WPA;S:NetworkName;P:password;;';
      case ScanType.contact: return 'BEGIN:VCARD...';
      case ScanType.sms: return 'SMSTO:+1234567890:Message';
      case ScanType.geo: return 'geo:37.7749,-122.4194';
      default: return 'Enter your text here...';
    }
  }

  List<String> _suggestionsFor(ScanType type) {
    switch (type) {
      case ScanType.url: return ['https://example.com', 'https://myportfolio.com'];
      case ScanType.email: return ['hello@example.com', 'support@quickscan.app'];
      case ScanType.phone: return ['+14155552671', '+442071838750'];
      case ScanType.wifi: return ['WIFI:T:WPA;S:OfficeNet;P:secure123;;'];
      case ScanType.contact: return ['BEGIN:VCARD\nFN:John Doe\nTEL:+14155552671\nEND:VCARD'];
      case ScanType.sms: return ['SMSTO:+14155552671:Hello from QuickScan'];
      case ScanType.geo: return ['geo:40.7128,-74.0060', 'geo:51.5072,-0.1276'];
      case ScanType.text: return ['Welcome to QuickScan', 'Scan smart. Move fast.'];
      default: return ['Enter your text here...'];
    }
  }
}
