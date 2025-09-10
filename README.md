# AI Image Generator with Flutter & Firebase

[![Platform](https://img.shields.io/badge/platform-flutter-blue.svg)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A beautiful, performant Flutter application that generates images from text prompts using the Firebase AI (Gemini) SDK, featuring a clean neumorphic design.

## App Preview

*(Here you can add a screenshot or GIF of the app in action)*

![App Preview Placeholder](https://user-images.githubusercontent.com/26283493/188342993-94438a9a-a239-42b2-a59a-8175a33a8e43.png)


## Features

- **AI Image Generation**: Leverages the `gemini-2.0-flash-preview-image-generation` model via the `firebase_ai` package to turn text prompts into images.
- **Single Image Generation**: Configured to generate one high-quality image per prompt for a focused user experience.
- **Neumorphic UI**: A soft, modern, and intuitive user interface built with custom neumorphic widgets.
- **Prompt Suggestions**: Includes a list of example prompts to help users get started quickly.
- **Image Management**: Easily save generated images to the device's local storage.
- **Full-Screen Viewer**: View, pan, and zoom generated images in a full-screen hero view.
- **Comprehensive Logging**: Robust logging system (`AppLogger`) that outputs to both the console and a local file for easy debugging.
- **State-Driven UI**: Built with `StatefulWidget` to provide reactive feedback, including loading indicators and error messages.

## Technology Stack

- **Framework**: Flutter
- **AI Service**: Firebase AI (Gemini)
- **Core Dependencies**:
  - `firebase_core`: For initializing Firebase services.
  - `firebase_ai`: For interacting with the generative model.
- **Utilities**:
  - `logger`: For structured and colorful console logging.
  - `path_provider`: To find the correct local path for saving images.

## Project Structure

The project follows a clean, feature-driven architecture to promote separation of concerns.

```
lib/
├── core/
│   ├── constants/         # App-wide constants
│   ├── theme/             # App theme and color palette
│   └── utils/             # Core utilities like AppLogger
├── features/
│   └── image_generation/
│       ├── data/          # Data layer (services, repositories)
│       └── presentation/  # UI layer (pages, widgets)
├── shared/
│   └── widgets/           # Reusable neumorphic widgets
└── main.dart              # App entry point
```

## Getting Started

### Prerequisites
- Flutter SDK (v3.x or higher)
- A configured Firebase project with the **Vertex AI API** enabled.
- An iOS Simulator or Android Emulator.

### Installation & Setup

1.  **Clone the repository:**
    ```bash
    git clone <your-repository-url>
    cd firebase_ai_logic
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Configure Firebase:**
    - Replace the placeholder `firebase_options.dart` with the one from your own Firebase project.
    - Ensure your `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) are correctly set up.

4.  **Run the app:**
    ```bash
    flutter run
    ```

## Contributing

Contributions are welcome! If you'd like to contribute, please feel free to fork the repository and submit a pull request.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

---

Built with ❤️ and Flutter
