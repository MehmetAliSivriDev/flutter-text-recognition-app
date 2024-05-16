import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ImageExtractTextManager {
  Future<String?> extractText(File file) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final InputImage inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    String text = recognizedText.text;
    textRecognizer.close();

    return text;
  }

  Future<List<TextBlock>> extractTextBlocks(File file) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final InputImage inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    List<TextBlock> textBlocks = recognizedText.blocks;

    textRecognizer.close();

    return textBlocks;
  }
}
