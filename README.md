# Firebase AI Image Generator

A Flutter app that generates images using Firebase AI (Gemini) with a beautiful neumorphism design and comprehensive logging.

## Features

### 🎨 Image Generation
- **Text-to-Image**: Generate images from text prompts using Gemini 2.5 Flash
- **Interleaved Content**: Generate both text and images together
- **Multiple Images**: Support for generating multiple images per request
- **Image Actions**: Save, copy, share, and view generated images

### 🎯 UI/UX
- **Neumorphism Design**: Soft, elegant design with depth and shadows
- **Responsive Layout**: Works on different screen sizes
- **Smooth Animations**: Fade-in effects and smooth transitions
- **Loading States**: Beautiful loading indicators and progress feedback

### 📱 User Experience
- **Prompt Suggestions**: Pre-built examples to get started quickly
- **Real-time Feedback**: Live updates during image generation
- **Error Handling**: Graceful error messages and recovery
- **Image Gallery**: View generated images in full screen with zoom

### 🔧 Technical Features
- **Comprehensive Logging**: Detailed logging with file output and console
- **Clean Architecture**: Well-organized folder structure following Flutter best practices
- **Error Recovery**: Robust error handling and user feedback
- **Performance Tracking**: Duration tracking for all operations

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart           # App-wide constants
│   ├── theme/
│   │   ├── app_colors.dart              # Color palette
│   │   └── app_theme.dart               # App theme configuration
│   └── utils/
│       └── app_logger.dart              # Logging utility
├── features/
│   └── image_generation/
│       ├── data/
│       │   └── services/
│       │       └── firebase_ai_service.dart  # Firebase AI integration
│       └── presentation/
│           ├── pages/
│           │   └── image_generation_page.dart # Main UI page
│           └── widgets/
│               ├── generated_image_widget.dart # Image display widget
│               └── prompt_suggestions_widget.dart # Suggestions UI
├── shared/
│   └── widgets/
│       └── neumorphic_widgets.dart      # Reusable neumorphic components
└── main.dart                            # App entry point
```

## Design System

### Colors
- **Background**: Soft gray gradients (#F0F2F5 to #E8ECEF)
- **Primary**: Soft blue (#6B73FF)
- **Accent**: Soft purple (#9C88FF)
- **Surface**: Clean whites and light grays
- **Text**: Dark grays for optimal readability

### Neumorphism Components
- **NeumorphicContainer**: Base container with soft shadows
- **NeumorphicButton**: Interactive button with press feedback
- **NeumorphicTextField**: Input field with inset appearance
- **NeumorphicCard**: Content cards with elevated appearance

## Setup Instructions

### Prerequisites
- Flutter SDK (latest stable version)
- Firebase project with AI enabled
- iOS Simulator or Android Emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd firebase_ai_logic
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Ensure `firebase_options.dart` is properly configured
   - Add your Firebase project configuration
   - Enable Firebase AI in your project

4. **Run the app**
   ```bash
   flutter run
   ```

## Usage

### Generating Images

1. **Enter a Prompt**: Type a description of the image you want to generate
2. **Use Suggestions**: Tap on suggestion chips for quick prompts
3. **Generate**: Tap the "Generate" button to create your image
4. **View Results**: See the generated image(s) with response text
5. **Save/Share**: Use action buttons to save or share images

### Example Prompts
- "Generate a beautiful sunset over mountains with soft colors"
- "Create a futuristic city with neon lights and flying cars"
- "Design a cozy coffee shop interior with warm lighting"
- "Generate a fantasy forest with magical creatures"

## Logging

The app includes comprehensive logging that captures:
- **App Lifecycle**: Initialization and major events
- **Image Generation**: Request details, duration, and outcomes
- **Errors**: Detailed error information with stack traces
- **Performance**: Timing information for all operations

Logs are output to both console and files in the app's documents directory.

## Technical Details

### Firebase AI Integration
- Uses `gemini-2.5-flash-image-preview` model
- Configured for both text and image output
- Handles multiple response formats
- Includes proper error handling and retries

### State Management
- Uses Flutter's built-in `StatefulWidget`
- Local state management for UI interactions
- Proper loading states and error handling

### Performance Optimizations
- Lazy loading of images
- Efficient memory management for image data
- Smooth animations with proper disposal

## Dependencies

### Core Dependencies
- `firebase_core`: Firebase integration
- `firebase_ai`: AI model access
- `flutter`: Framework

### Utility Dependencies
- `logger`: Comprehensive logging
- `path_provider`: File system access

## Contributing

1. Follow the existing code structure
2. Add proper logging for new features
3. Include error handling
4. Follow the neumorphism design guidelines
5. Test on multiple devices

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
1. Check the logs for detailed error information
2. Ensure Firebase is properly configured
3. Verify network connectivity
4. Check Firebase AI quota and limits

---

Built with ❤️ using Flutter and Firebase AI
