import 'dart:typed_data';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_ai_logic/core/constants/app_constants.dart';
import 'package:firebase_ai_logic/core/utils/app_logger.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseAIService {
  static FirebaseAIService? _instance;
  static FirebaseAIService get instance => _instance ??= FirebaseAIService._();

  FirebaseAIService._();

  GenerativeModel? _model;

  /// Initialize the Firebase AI service
  Future<void> initialize() async {
    try {
      AppLogger.info('Initializing Firebase AI Service');

      // Ensure Firebase is initialized
      if (Firebase.apps.isEmpty) {
        throw Exception('Firebase not initialized');
      }

      // Create model with image generation capabilities
      _model = FirebaseAI.googleAI().generativeModel(
        model: AppConstants.geminiFlashModel,
        generationConfig: GenerationConfig(
          candidateCount: 1,
          responseModalities: [
            ResponseModalities.text,
            ResponseModalities.image,
          ],
        ),
      );

      AppLogger.info('Firebase AI Service initialized successfully');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to initialize Firebase AI Service',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Generate image from text prompt
  Future<ImageGenerationResult> generateImage(String prompt) async {
    if (_model == null) {
      throw Exception('Firebase AI Service not initialized');
    }

    final startTime = DateTime.now();

    try {
      AppLogger.logImageGeneration(
        prompt: prompt,
        model: AppConstants.geminiFlashModel,
        status: 'started',
      );

      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);

      final duration = DateTime.now().difference(startTime).inMilliseconds;

      // Extract images from response
      final images = <Uint8List>[];
      String? responseText;

      if (response.candidates.isNotEmpty) {
        final candidate = response.candidates.first;
        final parts = candidate.content.parts;

        for (final part in parts) {
          if (part is TextPart) {
            responseText = part.text;
          } else if (part is InlineDataPart) {
            images.add(part.bytes);
          }
        }
      }

      // Also check inlineDataParts for backward compatibility
      if (response.inlineDataParts.isNotEmpty) {
        for (final inlineData in response.inlineDataParts) {
          images.add(inlineData.bytes);
        }
      }

      if (images.isEmpty) {
        throw Exception('No images were generated from the model');
      }

      final totalImageSize = images.fold<int>(
        0,
        (sum, image) => sum + image.length,
      );

      AppLogger.logImageGenerationSuccess(
        prompt: prompt,
        duration: duration,
        imageSizeBytes: totalImageSize,
      );

      return ImageGenerationResult(
        images: images,
        responseText: responseText,
        prompt: prompt,
        duration: duration,
        model: AppConstants.geminiFlashModel,
      );
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      AppLogger.logImageGenerationError(
        prompt: prompt,
        error: e.toString(),
        duration: duration,
      );

      AppLogger.error('Image generation failed', e, stackTrace);
      rethrow;
    }
  }

  /// Generate interleaved text and images
  Future<ImageGenerationResult> generateInterleavedContent(
    String prompt,
  ) async {
    if (_model == null) {
      throw Exception('Firebase AI Service not initialized');
    }

    final startTime = DateTime.now();

    try {
      AppLogger.logImageGeneration(
        prompt: prompt,
        model: AppConstants.geminiFlashModel,
        status: 'interleaved_started',
      );

      final content = [
        Content.text(
          '$prompt\nCreate images to go alongside the text as you generate the content.',
        ),
      ];
      final response = await _model!.generateContent(content);

      final duration = DateTime.now().difference(startTime).inMilliseconds;

      final images = <Uint8List>[];
      final textParts = <String>[];

      if (response.candidates.isNotEmpty) {
        final candidate = response.candidates.first;
        final parts = candidate.content.parts;

        for (final part in parts) {
          if (part is TextPart) {
            textParts.add(part.text);
          } else if (part is InlineDataPart) {
            images.add(part.bytes);
          }
        }
      }

      // Also check inlineDataParts for backward compatibility
      if (response.inlineDataParts.isNotEmpty) {
        for (final inlineData in response.inlineDataParts) {
          images.add(inlineData.bytes);
        }
      }

      final responseText = textParts.join('\n\n');
      final totalImageSize = images.fold<int>(
        0,
        (sum, image) => sum + image.length,
      );

      AppLogger.logImageGenerationSuccess(
        prompt: prompt,
        duration: duration,
        imageSizeBytes: totalImageSize,
      );

      return ImageGenerationResult(
        images: images,
        responseText: responseText.isNotEmpty ? responseText : null,
        prompt: prompt,
        duration: duration,
        model: AppConstants.geminiFlashModel,
      );
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      AppLogger.logImageGenerationError(
        prompt: prompt,
        error: e.toString(),
        duration: duration,
      );

      AppLogger.error('Interleaved content generation failed', e, stackTrace);
      rethrow;
    }
  }
}

/// Result class for image generation
class ImageGenerationResult {
  final List<Uint8List> images;
  final String? responseText;
  final String prompt;
  final int duration;
  final String model;

  ImageGenerationResult({
    required this.images,
    this.responseText,
    required this.prompt,
    required this.duration,
    required this.model,
  });

  bool get hasImages => images.isNotEmpty;
  bool get hasText => responseText != null && responseText!.isNotEmpty;
  int get imageCount => images.length;

  @override
  String toString() {
    return 'ImageGenerationResult('
        'imageCount: $imageCount, '
        'hasText: $hasText, '
        'duration: ${duration}ms, '
        'model: $model'
        ')';
  }
}
