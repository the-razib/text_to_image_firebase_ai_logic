Generate images using Gemini (aka "nano banana")

bookmark_border


Preview: Using the Firebase AI Logic SDKs to generate images with Gemini models is a feature that's in Preview, which means that it isn't subject to any SLA or deprecation policy and could change in backwards-incompatible ways.



You can ask a Gemini model to generate images and edit images using both text-only and text-and-image prompts. When you use Firebase AI Logic, you can make this request directly from your app.

With this capability, you can do things like:

Iteratively generate images through conversation with natural language, adjusting images while maintaining consistency and context.

Generate images with high-quality text rendering, including long strings of text.

Generate interleaved text-image output. For example, a blog post with text and images in a single turn. Previously, this required stringing together multiple models.

Generate images using Gemini's world knowledge and reasoning capabilities.

You can find a complete list of supported modalities and capabilities (along with example prompts) later on this page.

Important: When using a Gemini model for image generation, the model cannot return only images; it always returns both text and images. Also note that you must include responseModalities: ["TEXT", "IMAGE"] in your model configuration.
arrow_downward Jump to code for text-to-image arrow_downward Jump to code for interleaved text & images

arrow_downward Jump to code for image editing arrow_downward Jump to code for iterative image editing



See other guides for additional options for working with images
Analyze images Analyze images on-device Generate structured output
Choosing between Gemini and Imagen models
The Firebase AI Logic SDKs support image generation using either a Gemini model or an Imagen model. For most use cases, start with Gemini, and then choose Imagen for specialized tasks where image quality is critical.

Note that the Firebase AI Logic SDKs do not yet support image input (like for editing) with Imagen models. So, if you want to work with input images, you can use a Gemini model instead.

Choose Gemini when you want:

To use world knowledge and reasoning to generate contextually relevant images.
To seamlessly blend text and images or to interleave text and image output.
To embed accurate visuals within long text sequences.
To edit images conversationally while maintaining context.
Choose Imagen when you want:

To prioritize image quality, photorealism, artistic detail, or specific styles (for example, impressionism or anime).
To explicitly specify the aspect ratio or format of generated images.
Before you begin

Click your Gemini API provider to view provider-specific content and code on this page.

Gemini Developer API Vertex AI Gemini API
If you haven't already, complete the getting started guide, which describes how to set up your Firebase project, connect your app to Firebase, add the SDK, initialize the backend service for your chosen Gemini API provider, and create a GenerativeModel instance.


This guide assumes you're using the latest Firebase AI Logic SDKs. If you're still using the "Vertex AI in Firebase" SDKs, see the migration guide.
For testing and iterating on your prompts and even getting a generated code snippet, we recommend using Google AI Studio.
Models that support this capability
gemini-2.5-flash-image-preview (aka "nano banana")
gemini-2.0-flash-preview-image-generation
Take note that the segment order is different between the 2.0 model name and the 2.5 model name. Also, image-output from Gemini is not supported by the standard Flash models like gemini-2.5-flash or gemini-2.0-flash.

Note that the SDKs also support image generation using Imagen models.

Generate and edit images
You can generate and edit images using a Gemini model.

Generate images (text-only input)

Before trying this sample, complete the Before you begin section of this guide to set up your project and app.
In that section, you'll also click a button for your chosen Gemini API provider so that you see provider-specific content on this page.
You can ask a Gemini model to generate images by prompting with text.

Make sure to create a GenerativeModel instance, include responseModalities: ["TEXT", "IMAGE"] in your model configuration, and call generateContent.

Swift
Kotlin
Java
Web
Dart
Unity


import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

// Initialize the Gemini Developer API backend service
// Create a `GenerativeModel` instance with a Gemini model that supports image output
final model = FirebaseAI.googleAI().generativeModel(
  model: 'gemini-2.5-flash-image-preview',
  // Configure the model to respond with text and images (required)
  generationConfig: GenerationConfig(responseModalities: [ResponseModalities.text, ResponseModalities.image]),
);

// Provide a text prompt instructing the model to generate an image
final prompt = [Content.text('Generate an image of the Eiffel Tower with fireworks in the background.')];

// To generate an image, call `generateContent` with the text input
final response = await model.generateContent(prompt);
if (response.inlineDataParts.isNotEmpty) {
  final imageBytes = response.inlineDataParts[0].bytes;
  // Process the image
} else {
  // Handle the case where no images were generated
  print('Error: No images were generated.');
}
Generate interleaved images and text

Before trying this sample, complete the Before you begin section of this guide to set up your project and app.
In that section, you'll also click a button for your chosen Gemini API provider so that you see provider-specific content on this page.
You can ask a Gemini model to generate interleaved images with its text responses. For example, you can generate images of what each step of a generated recipe might look like along with the step's instructions, and you don't have to make separate requests to the model or different models.

Make sure to create a GenerativeModel instance, include responseModalities: ["TEXT", "IMAGE"] in your model configuration, and call generateContent.

Swift
Kotlin
Java
Web
Dart
Unity


import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

// Initialize the Gemini Developer API backend service
// Create a `GenerativeModel` instance with a Gemini model that supports image output
final model = FirebaseAI.googleAI().generativeModel(
  model: 'gemini-2.5-flash-image-preview',
  // Configure the model to respond with text and images (required)
  generationConfig: GenerationConfig(responseModalities: [ResponseModalities.text, ResponseModalities.image]),
);

// Provide a text prompt instructing the model to generate interleaved text and images
final prompt = [Content.text(
  'Generate an illustrated recipe for a paella\n ' +
  'Create images to go alongside the text as you generate the recipe'
)];

// To generate interleaved text and images, call `generateContent` with the text input
final response = await model.generateContent(prompt);

// Handle the generated text and image
final parts = response.candidates.firstOrNull?.content.parts
if (parts.isNotEmpty) {
  for (final part in parts) {
    if (part is TextPart) {
      // Do something with text part
      final text = part.text
    }
    if (part is InlineDataPart) {
      // Process image
      final imageBytes = part.bytes
    }
  }
} else {
  // Handle the case where no images were generated
  print('Error: No images were generated.');
}
Edit images (text-and-image input)

Before trying this sample, complete the Before you begin section of this guide to set up your project and app.
In that section, you'll also click a button for your chosen Gemini API provider so that you see provider-specific content on this page.
You can ask a Gemini model to edit images by prompting with text and one or more images.

Make sure to create a GenerativeModel instance, include responseModalities: ["TEXT", "IMAGE"] in your model configuration, and call generateContent.

Swift
Kotlin
Java
Web
Dart
Unity


import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

// Initialize the Gemini Developer API backend service
// Create a `GenerativeModel` instance with a Gemini model that supports image output
final model = FirebaseAI.googleAI().generativeModel(
  model: 'gemini-2.5-flash-image-preview',
  // Configure the model to respond with text and images (required)
  generationConfig: GenerationConfig(responseModalities: [ResponseModalities.text, ResponseModalities.image]),
);

// Prepare an image for the model to edit
final image = await File('scones.jpg').readAsBytes();
final imagePart = InlineDataPart('image/jpeg', image);

// Provide a text prompt instructing the model to edit the image
final prompt = TextPart("Edit this image to make it look like a cartoon");

// To edit the image, call `generateContent` with the image and text input
final response = await model.generateContent([
  Content.multi([prompt,imagePart])
]);

// Handle the generated image
if (response.inlineDataParts.isNotEmpty) {
  final imageBytes = response.inlineDataParts[0].bytes;
  // Process the image
} else {
  // Handle the case where no images were generated
  print('Error: No images were generated.');
}
Iterate and edit images using multi-turn chat

Before trying this sample, complete the Before you begin section of this guide to set up your project and app.
In that section, you'll also click a button for your chosen Gemini API provider so that you see provider-specific content on this page.
Using multi-turn chat, you can iterate with a Gemini model on the images that it generates or that you supply.

Make sure to create a GenerativeModel instance, include responseModalities: ["TEXT", "IMAGE"] in your model configuration, and call startChat() and sendMessage() to send new user messages.

Important: If you're not familiar with the chat capability of the SDKs, we recommend reviewing the text-only chat example.
Swift
Kotlin
Java
Web
Dart
Unity


import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

// Initialize the Gemini Developer API backend service
// Create a `GenerativeModel` instance with a Gemini model that supports image output
final model = FirebaseAI.googleAI().generativeModel(
  model: 'gemini-2.5-flash-image-preview',
  // Configure the model to respond with text and images (required)
  generationConfig: GenerationConfig(responseModalities: [ResponseModalities.text, ResponseModalities.image]),
);

// Prepare an image for the model to edit
final image = await File('scones.jpg').readAsBytes();
final imagePart = InlineDataPart('image/jpeg', image);

// Provide an initial text prompt instructing the model to edit the image
final prompt = TextPart("Edit this image to make it look like a cartoon");

// Initialize the chat
final chat = model.startChat();

// To generate an initial response, send a user message with the image and text prompt
final response = await chat.sendMessage([
  Content.multi([prompt,imagePart])
]);

// Inspect the returned image
if (response.inlineDataParts.isNotEmpty) {
  final imageBytes = response.inlineDataParts[0].bytes;
  // Process the image
} else {
  // Handle the case where no images were generated
  print('Error: No images were generated.');
}

// Follow up requests do not need to specify the image again
final followUpResponse = await chat.sendMessage([
  Content.text("But make it old-school line drawing style")
]);

// Inspect the returned image
if (followUpResponse.inlineDataParts.isNotEmpty) {
  final followUpImageBytes = response.inlineDataParts[0].bytes;
  // Process the image
} else {
  // Handle the case where no images were generated
  print('Error: No images were generated.');
}


Supported features, limitations, and best practices
Supported modalities and capabilities
The following are supported modalities and capabilities for image-output from a Gemini model. Each capability shows an example prompt and has an example code sample above.

Text arrow_forward Image(s) (text-only to image)

Generate an image of the Eiffel tower with fireworks in the background.
Text arrow_forward Image(s) (text rendering within image)

Generate a cinematic photo of a large building with this giant text projection mapped on the front of the building.
Text arrow_forward Image(s) & Text (interleaved)

Generate an illustrated recipe for a paella. Create images alongside the text as you generate the recipe.

Generate a story about a dog in a 3D cartoon animation style. For each scene, generate an image.

Image(s) & Text arrow_forward Image(s) & Text (interleaved)

[image of a furnished room] + What other color sofas would work in my space? Can you update the image?
Image editing (text-and-image to image)

[image of scones] + Edit this image to make it look like a cartoon

[image of a cat] + [image of a pillow] + Create a cross stitch of my cat on this pillow.

Multi-turn image editing (chat)

[image of a blue car] + Turn this car into a convertible., then Now change the color to yellow.
Limitations and best practices
The following are limitations and best practices for image-output from a Gemini model.

Image-generating Gemini models support the following:

Generating PNG images with a maximum dimension of 1024 px.
Generating and editing images of people.
Using safety filters that provide a flexible and less restrictive user experience.
Image-generating Gemini models do not support the following:

Including audio or video inputs.
Generating only images.
The models will always return both text and images, and you must include responseModalities: ["TEXT", "IMAGE"] in your model configuration.
For best performance, use the following languages: en, es-mx, ja-jp, zh-cn, hi-in.

Image generation may not always trigger. Here are some known issues:

The model may output text only.
Try asking for image outputs explicitly (for example, "generate an image", "provide images as you go along", "update the image").

The model may stop generating partway through.
Try again or try a different prompt.

The model may generate text as an image.
Try asking for text outputs explicitly. For example, "generate narrative text along with illustrations."

When generating text for an image, Gemini works best if you first generate the text and then ask for an image with the text.