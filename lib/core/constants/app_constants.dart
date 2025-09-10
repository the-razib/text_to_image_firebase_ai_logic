class AppConstants {
  // Firebase AI Models
  static const String geminiImageModel = 'gemini-2.5-flash-image-preview';
  static const String geminiFlashModel =
      'gemini-2.0-flash-preview-image-generation';

  // App Information
  static const String appName = 'AI Image Generator';
  static const String appVersion = '1.0.0';

  // Image Generation Constants
  static const int maxImageDimension = 1024;
  static const String defaultImageFormat = 'image/png';

  // Prompt Examples
  static const List<String> promptExamples = [
    'Generate a beautiful sunset over mountains with soft colors',
    'Create a futuristic city with neon lights and flying cars',
  ];

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double neumorphismBlurRadius = 10.0;
  static const double neumorphismSpreadRadius = 2.0;
}
