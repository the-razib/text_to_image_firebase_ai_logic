import 'package:logger/logger.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AppLogger {
  static Logger? _logger;
  static File? _logFile;

  static Logger get instance {
    _logger ??= Logger(
      filter: ProductionFilter(),
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      output: MultiOutput([
        ConsoleOutput(),
        if (_logFile != null) FileOutput(file: _logFile!),
      ]),
    );
    return _logger!;
  }

  static Future<void> initialize() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logDir = Directory('${directory.path}/logs');
      if (!await logDir.exists()) {
        await logDir.create(recursive: true);
      }

      final now = DateTime.now();
      final fileName =
          'app_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}.log';
      _logFile = File('${logDir.path}/$fileName');

      // Initialize logger after setting up file
      _logger = Logger(
        filter: ProductionFilter(),
        printer: PrettyPrinter(
          methodCount: 2,
          errorMethodCount: 8,
          lineLength: 120,
          colors: true,
          printEmojis: true,
          dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
        ),
        output: MultiOutput([ConsoleOutput(), FileOutput(file: _logFile!)]),
      );

      instance.i('Logger initialized successfully');
    } catch (e) {
      // Fallback to console-only logging
      _logger = Logger(
        printer: PrettyPrinter(
          methodCount: 2,
          errorMethodCount: 8,
          lineLength: 120,
          colors: true,
          printEmojis: true,
          dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
        ),
      );
      _logger!.w('Failed to initialize file logging: $e');
    }
  }

  // Convenience methods
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    instance.d(message, error: error, stackTrace: stackTrace);
  }

  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    instance.i(message, error: error, stackTrace: stackTrace);
  }

  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    instance.w(message, error: error, stackTrace: stackTrace);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    instance.e(message, error: error, stackTrace: stackTrace);
  }

  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    instance.f(message, error: error, stackTrace: stackTrace);
  }

  // Image Generation specific logging
  static void logImageGeneration({
    required String prompt,
    required String model,
    String? status,
    int? duration,
  }) {
    instance.i(
      'Image Generation Request',
      error: {
        'prompt': prompt,
        'model': model,
        'status': status ?? 'started',
        'duration_ms': duration,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  static void logImageGenerationSuccess({
    required String prompt,
    required int duration,
    required int imageSizeBytes,
  }) {
    instance.i(
      'Image Generation Success',
      error: {
        'prompt': prompt,
        'duration_ms': duration,
        'image_size_bytes': imageSizeBytes,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  static void logImageGenerationError({
    required String prompt,
    required String error,
    int? duration,
  }) {
    instance.e(
      'Image Generation Failed',
      error: {
        'prompt': prompt,
        'error': error,
        'duration_ms': duration,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }
}

class FileOutput extends LogOutput {
  final File file;

  FileOutput({required this.file});

  @override
  void output(OutputEvent event) {
    try {
      final timestamp = DateTime.now().toIso8601String();
      final logEntry = '$timestamp: ${event.lines.join('\n')}\n';
      file.writeAsStringSync(logEntry, mode: FileMode.append);
    } catch (e) {
      // Ignore file write errors to prevent infinite loops
    }
  }
}
