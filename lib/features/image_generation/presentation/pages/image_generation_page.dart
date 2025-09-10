import 'package:firebase_ai_logic/core/constants/app_constants.dart';
import 'package:firebase_ai_logic/core/theme/app_colors.dart';
import 'package:firebase_ai_logic/core/utils/app_logger.dart';
import 'package:firebase_ai_logic/features/image_generation/data/services/firebase_ai_service.dart';
import 'package:firebase_ai_logic/features/image_generation/presentation/widgets/generated_image_widget.dart';
import 'package:firebase_ai_logic/features/image_generation/presentation/widgets/prompt_suggestions_widget.dart';
import 'package:firebase_ai_logic/shared/widgets/Neumorphic_button_widget.dart';
import 'package:firebase_ai_logic/shared/widgets/neumorphic_card_widget.dart';
import 'package:firebase_ai_logic/shared/widgets/neumorphic_textfield_widget.dart';
import 'package:flutter/material.dart';

class ImageGenerationPage extends StatefulWidget {
  const ImageGenerationPage({super.key});

  @override
  State<ImageGenerationPage> createState() => _ImageGenerationPageState();
}

class _ImageGenerationPageState extends State<ImageGenerationPage>
    with TickerProviderStateMixin {
  final TextEditingController _promptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _isInitialized = false;
  String? _error;
  ImageGenerationResult? _result;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeService();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initializeService() async {
    try {
      await FirebaseAIService.instance.initialize();
      setState(() {
        _isInitialized = true;
      });
      _fadeController.forward();
      AppLogger.info('Image Generation Page initialized successfully');
    } catch (e, stackTrace) {
      setState(() {
        _error = 'Failed to initialize AI service: $e';
      });
      AppLogger.error(
        'Failed to initialize Image Generation Page',
        e,
        stackTrace,
      );
    }
  }

  Future<void> _generateImage() async {
    final prompt = _promptController.text.trim();

    if (prompt.isEmpty) {
      _showSnackBar('Please enter a prompt');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });

    try {
      final result = await FirebaseAIService.instance.generateImage(prompt);

      setState(() {
        _result = result;
      });

      // Scroll to show results
      _scrollToBottom();

      _showSnackBar('Image generated successfully!');
      AppLogger.info('Image generation completed for prompt: $prompt');
    } catch (e, stackTrace) {
      setState(() {
        _error = e.toString();
      });

      _showSnackBar('Failed to generate image: ${e.toString()}');
      AppLogger.error('Image generation failed', e, stackTrace);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
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

  void _clearResults() {
    setState(() {
      _result = null;
      _error = null;
      _promptController.clear();
    });
  }

  void _usePromptSuggestion(String suggestion) {
    _promptController.text = suggestion;
    setState(() {});
  }

  @override
  void dispose() {
    _promptController.dispose();
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.withValues(alpha: 0.8),
      appBar: AppBar(
        title: const Text(
          'AI Image Generator',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: !_isInitialized
              ? _buildLoadingState()
              : FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildMainContent(),
                ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primaryColor),
          SizedBox(height: 16),
          Text(
            'Initializing AI Service...',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildPromptSection(),
              const SizedBox(height: 20),
              PromptSuggestionsWidget(onSuggestionTap: _usePromptSuggestion),
              const SizedBox(height: 20),
              _buildActionButtons(),
              const SizedBox(height: 20),
              if (_isLoading) _buildLoadingSection(),
              if (_error != null) _buildErrorSection(),
              if (_result != null) _buildResultSection(),
              const SizedBox(height: 20),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildPromptSection() {
    return NeumorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Describe the image you want to generate',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          NeumorphicTextField(
            controller: _promptController,
            hintText:
                'e.g., A beautiful sunset over mountains with soft colors',
            maxLines: 4,
            keyboardType: TextInputType.multiline,
            onChanged: (value) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: NeumorphicButton(
            onPressed: _isLoading ? null : _generateImage,
            isLoading: _isLoading,
            backgroundColor: AppColors.primaryColor,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                SizedBox(width: 6),
                Text(
                  'Generate',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: NeumorphicButton(
            onPressed: _result != null || _error != null ? _clearResults : null,
            backgroundColor: AppColors.accentColor,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.clear, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  'Clear',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingSection() {
    return NeumorphicCard(
      child: Column(
        children: [
          const CircularProgressIndicator(color: AppColors.primaryColor),
          const SizedBox(height: 16),
          Text(
            'Generating your image...',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'This may take a few moments',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorSection() {
    return NeumorphicCard(
      backgroundColor: AppColors.errorColor.withValues(alpha: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.error_outline, color: AppColors.errorColor),
              SizedBox(width: 8),
              Text(
                'Error',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.errorColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _error!,
            style: const TextStyle(color: AppColors.errorColor, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildResultSection() {
    if (_result == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NeumorphicCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.successColor),
                  const SizedBox(width: 8),
                  const Text(
                    'Generated Successfully',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_result!.duration}ms',
                    style: const TextStyle(
                      color: AppColors.textHint,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Prompt: ${_result!.prompt}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              if (_result!.hasText) ...[
                const SizedBox(height: 12),
                Text(
                  _result!.responseText!,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...(_result!.images.asMap().entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GeneratedImageWidget(
              imageData: entry.value,
              imageIndex: entry.key,
              totalImages: _result!.images.length,
              prompt: _result!.prompt,
            ),
          ),
        )),
      ],
    );
  }
}
