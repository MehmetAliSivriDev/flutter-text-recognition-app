import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_text_recognition_app/product/util/image_extract_text_manager.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class DetailViewModel extends ChangeNotifier {
  late File image;

  String? textFromMedia;
  double? mediaWidth;

  List<TextBlock> textBlocks = [];
  List<Widget> textBlocksWidgets = [];

  Future<void> imageProcessing({required File selectedImage}) async {
    image = selectedImage;
    Size imageSize = await getImageSize(image);
    mediaWidth = imageSize.width;
    textFromMediaExtraction(image);
    textBlocksFromMediaExtraction(image);
  }

  Future<void> textFromMediaExtraction(File file) async {
    String? getTextFromManager =
        await ImageExtractTextManager().extractText(file);

    textFromMedia = getTextFromManager;
    notifyListeners();
  }

  Future<void> textBlocksFromMediaExtraction(File file) async {
    List<TextBlock> getTextBlocksFromManager =
        await ImageExtractTextManager().extractTextBlocks(file);

    textBlocks = getTextBlocksFromManager;
    notifyListeners();
  }

  Future<Size> getImageSize(File imageFile) async {
    if (!(await imageFile.exists())) {
      throw ArgumentError("Belirtilen dosya bulunamadı!");
    }

    final size = await imageFile.readAsBytes();
    final decodedImage = await decodeImageFromList(size);

    final double width = decodedImage.width.toDouble();
    final double height = decodedImage.height.toDouble();

    return Size(width, height);
  }
}
