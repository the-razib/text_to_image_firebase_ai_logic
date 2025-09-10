Get started with the Gemini API using the Firebase AI Logic SDKs

bookmark_border
This guide shows you how to get started making calls to the Gemini API directly from your app using the Firebase AI Logic client SDKs for your chosen platform.

You can also use this guide to get started with accessing Imagen models using the Firebase AI Logic SDKs.


Firebase AI Logic and its client SDKs were formerly called "Vertex AI in Firebase". In May 2025, we renamed and repackaged our services into Firebase AI Logic to better reflect our expanded services and features — for example, we now support the Gemini Developer API!
Prerequisites
Swift
Kotlin
Java
Web
Dart
Unity
This guide assumes that you're familiar with developing apps with Flutter.

Make sure that your development environment and Flutter app meet these requirements:

Dart 3.2.0+
Check out helpful resources
Swift
Kotlin
Java
Web
Dart
Unity
Try out the quickstart app
Use the quickstart app to try out the SDK quickly and see a complete implementation of various use cases. Or use the quickstart app if don't have your own Flutter app. To use the quickstart app, you'll need to connect it to a Firebase project.

Go to the quickstart app

Watch a video tutorial

This video demonstrates how to get started with Firebase AI Logic by building a real-world AI-powered meal planning app that generates recipes from a text prompt.

You can also download and explore the codebase for the app in the video.

View the codebase for the video's app




Step 1: Set up a Firebase project and connect your app
Sign into the Firebase console, and then select your Firebase project.

Don't already have a Firebase project?

In the Firebase console, go to the Firebase AI Logic page.

Click Get started to launch a guided workflow that helps you set up the required APIs and resources for your project.

Select the "Gemini API" provider that you'd like to use with the Firebase AI Logic SDKs. Gemini Developer API is recommended for first-time users. You can always add billing or set up Vertex AI Gemini API later, if you'd like.

Gemini Developer API — billing optional (available on the no-cost Spark pricing plan, and you can upgrade later if desired)
The console will enable the required APIs and create a Gemini API key in your project.
Do not add this Gemini API key into your app's codebase. Learn more.

Vertex AI Gemini API — billing required (requires the pay-as-you-go Blaze pricing plan)
The console will help you set up billing and enable the required APIs in your project.

If prompted in the console's workflow, follow the on-screen instructions to register your app and connect it to Firebase.

Continue to the next step in this guide to add the SDK to your app.

Note: In the Firebase console, you're strongly encouraged to set up Firebase App Check. If you're just trying out the Gemini API, you don't need to set up App Check right away; however, we recommend setting it up as soon as you start seriously developing your app.
Step 2: Add the SDK
With your Firebase project set up and your app connected to Firebase (see previous step), you can now add the Firebase AI Logic SDK to your app.

Swift
Kotlin
Java
Web
Dart
Unity
The Firebase AI Logic plugin for Flutter (firebase_ai) provides access to the APIs for interacting with Gemini and Imagen models.

From your Flutter project directory, run the following command to install the core plugin and the Firebase AI Logic plugin:


flutter pub add firebase_core firebase_ai
In your lib/main.dart file, import the Firebase core plugin, the Firebase AI Logic plugin, and the configuration file you generated earlier:


import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'firebase_options.dart';
Also in your lib/main.dart file, initialize Firebase using the DefaultFirebaseOptions object exported by the configuration file:


await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
Rebuild your Flutter application:


flutter run
Step 3: Initialize the service and create a model instance

Click your Gemini API provider to view provider-specific content and code on this page.

Gemini Developer API Vertex AI Gemini API
When using the Firebase AI Logic client SDKs with the Gemini Developer API, you do NOT add your Gemini API key into your app's codebase. Learn more.
Before sending a prompt to a Gemini model, initialize the service for your chosen API provider and create a GenerativeModel instance.

Swift
Kotlin
Java
Web
Dart
Unity


import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Initialize FirebaseApp
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

// Initialize the Gemini Developer API backend service
// Create a `GenerativeModel` instance with a model that supports your use case
final model =
      FirebaseAI.googleAI().generativeModel(model: 'gemini-2.5-flash');

Note that depending on the capability you're using, you might not always create a GenerativeModel instance.

To access an Imagen model, create an ImagenModel instance.
To stream input and output using the Gemini Live API, create a LiveModel instance.
Also, after you finish this getting started guide, learn how to choose a model for your use case and app.

Step 4: Send a prompt request to a model
You're now set up to send a prompt request to a Gemini model.

You can use generateContent() to generate text from a prompt that contains text:

Swift
Kotlin
Java
Web
Dart
Unity


import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Initialize FirebaseApp
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

// Initialize the Gemini Developer API backend service
// Create a `GenerativeModel` instance with a model that supports your use case
final model =
      FirebaseAI.googleAI().generativeModel(model: 'gemini-2.5-flash');

// Provide a prompt that contains text
final prompt = [Content.text('Write a story about a magic backpack.')];

// To generate text output, call generateContent with the text input
final response = await model.generateContent(prompt);
print(response.text);
The Gemini API can also stream responses for faster interactions, as well as handle multimodal prompts that include content like images, video, audio, and PDFs. Later on this page, find links to guides for various capabilities of the Gemini API.
If you get an error, make sure that your Firebase project is set up correctly with the Blaze pricing plan and required APIs enabled. To enable additional logging, add -GoogleGenerativeAIDebugLogEnabled as a launch argument in Xcode.
What else can you do?

Learn more about the supported models
Learn about the models available for various use cases and their quotas and pricing.

Try out other capabilities
Learn more about generating text from text-only prompts, including how to stream the response.
Generate text by prompting with various file types, like images, PDFs, video, and audio.
Build multi-turn conversations (chat).
Generate structured output (like JSON) from both text and multimodal prompts.
Generate images from text prompts (Gemini or Imagen).
Stream input and output (including audio) using the Gemini Live API.
Use tools (like function calling and grounding with Google Search) to connect a Gemini model to other parts of your app and external systems and information.

Learn how to control content generation
Understand prompt design, including best practices, strategies, and example prompts.
Configure model parameters like temperature and maximum output tokens (for Gemini) or aspect ratio and person generation (for Imagen).
Use safety settings to adjust the likelihood of getting responses that may be considered harmful.
You can also experiment with prompts and model configurations and even get a generated code snippet using Google AI Studio.


Give feedback about your experience with Firebase AI Logic