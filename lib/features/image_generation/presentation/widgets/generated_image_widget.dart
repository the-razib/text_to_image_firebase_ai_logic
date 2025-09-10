import 'package:firebase_ai_logic/core/constants/app_constants.dart';
import 'package:firebase_ai_logic/core/theme/app_colors.dart';
import 'package:firebase_ai_logic/core/utils/app_logger.dart';
import 'package:firebase_ai_logic/shared/widgets/Neumorphic_button_widget.dart';
import 'package:firebase_ai_logic/shared/widgets/neumorphic_card_widget.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';

class GeneratedImageWidget extends StatefulWidget {
  final Uint8List imageData;
  final int imageIndex;
  final int totalImages;
  final String prompt;

  const GeneratedImageWidget({
    super.key,
    required this.imageData,
    required this.imageIndex,
    required this.totalImages,
    required this.prompt,
  });

  @override
  State<GeneratedImageWidget> createState() => _GeneratedImageWidgetState();
}

class _GeneratedImageWidgetState extends State<GeneratedImageWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isSaving = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _saveImage() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final result = await ImageGallerySaver.saveImage(
        widget.imageData,
        quality: 95,
        name: 'generated_image_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (result['isSuccess']) {
        AppLogger.info('Image saved to gallery successfully: ${result["filePath"]}');
        if (mounted) {
          _showSnackBar('Image saved to Gallery');
        }
      } else {
        throw Exception('Failed to save image to gallery');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to save image', e, stackTrace);
      if (mounted) {
        _showSnackBar('Failed to save image: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _copyToClipboard() {
    _showSnackBar('Image saved to gallery instead of clipboard.');
    _saveImage();
  }

  Future<void> _shareImage() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(widget.imageData);

      final xFile = XFile(file.path);

      await Share.shareXFiles(
        [xFile],
        text: 'Generated with AI: "${widget.prompt}"'
      );
    } catch (e, stackTrace) {
      AppLogger.error('Failed to share image', e, stackTrace);
      if (mounted) {
        _showSnackBar('Failed to share image: ${e.toString()}');
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: NeumorphicCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageHeader(),
            const SizedBox(height: 12),
            _buildImageContainer(),
            const SizedBox(height: 12),
            _buildActionButtons(),
            if (_isExpanded) ...[
              const SizedBox(height: 12),
              _buildImageDetails(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImageHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Image ${widget.imageIndex + 1}/${widget.totalImages}',
            style: const TextStyle(
              color: AppColors.primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          icon: Icon(
            _isExpanded ? Icons.expand_less : Icons.expand_more,
            color: AppColors.textSecondary,
          ),
          label: Text(
            _isExpanded ? 'Less' : 'Details',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageContainer() {
    return GestureDetector(
      onTap: () => _showFullScreenImage(context),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxHeight: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkShadow.withValues(alpha: 0.1),
              offset: const Offset(2, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          child: Hero(
            tag: 'image_${widget.imageIndex}',
            child: Image.memory(
              widget.imageData,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                AppLogger.error('Failed to display image', error, stackTrace);
                return Container(
                  height: 200,
                  color: AppColors.surfaceColor,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: AppColors.errorColor,
                        size: 48,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Failed to display image',
                        style: TextStyle(color: AppColors.errorColor),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          icon: Icons.save_alt,
          label: 'Save',
          onTap: _isSaving ? null : _saveImage,
          isLoading: _isSaving,
        ),
        _buildActionButton(
          icon: Icons.copy,
          label: 'Copy',
          onTap: _copyToClipboard,
        ),
        _buildActionButton(
          icon: Icons.share,
          label: 'Share',
          onTap: _shareImage,
        ),
        _buildActionButton(
          icon: Icons.fullscreen,
          label: 'View',
          onTap: () => _showFullScreenImage(context),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return Expanded(
      child: NeumorphicButton(
        onPressed: onTap,
        backgroundColor: AppColors.surfaceColor,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primaryColor,
                ),
              )
            else
              Icon(icon, color: AppColors.textPrimary, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageDetails() {
    final imageSizeKB = (widget.imageData.length / 1024).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Image Details',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          _buildDetailRow('Prompt', widget.prompt),
          _buildDetailRow('Size', '${imageSizeKB} KB'),
          _buildDetailRow('Format', 'PNG'),
          _buildDetailRow('Generated', DateTime.now().toString().split('.')[0]),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: Stack(
                  children: [
                    Center(
                      child: Hero(
                        tag: 'image_${widget.imageIndex}',
                        child: InteractiveViewer(
                          child: Image.memory(
                            widget.imageData,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: NeumorphicButton(
                        onPressed: () => Navigator.of(context).pop(),
                        backgroundColor: AppColors.surfaceColor.withValues(
                          alpha: 0.9,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
