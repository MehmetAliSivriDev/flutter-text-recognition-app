import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_text_recognition_app/features/home/view/home_view.dart';
import 'package:flutter_text_recognition_app/product/constant/product_box_decorations.dart';
import 'package:flutter_text_recognition_app/product/constant/product_padding.dart';
import 'package:flutter_text_recognition_app/product/constant/product_strings.dart';
import 'package:flutter_text_recognition_app/product/util/custom_snackbar.dart';
import 'package:provider/provider.dart';

import '../viewModel/add_view_model.dart';

class AddView extends StatelessWidget {
  const AddView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AddViewModel>().selectedMedia = null;
    var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(ProductStrings.addButtonText),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: _buildGalleryFAButton(context),
      body: _buildBody(width),
    );
  }

  Widget _buildGalleryFAButton(BuildContext context) {
    return FloatingActionButton.extended(
      label: Text(
        ProductStrings.pickUpFromGallery,
      ),
      icon: const Icon(Icons.collections_sharp),
      onPressed: () {
        context.read<AddViewModel>().imageUpload();
      },
    );
  }

  Widget _buildBody(double width) {
    return SingleChildScrollView(
      child: Consumer<AddViewModel>(
        builder: (context, viewModel, _) {
          return viewModel.selectedMedia == null
              ? _buildSelectPhotoContainer(context)
              : _buildtextsFromImage(viewModel, width, context);
        },
      ),
    );
  }

  Widget _buildtextsFromImage(
      AddViewModel viewModel, double width, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImage(viewModel, width, context),
        _buildTitleAndSaveButton(context),
        _buildText(width, viewModel),
      ],
    );
  }

  Widget _buildImage(
      AddViewModel viewModel, double width, BuildContext context) {
    return Stack(
      children: [
        Image.file(
          viewModel.selectedMedia!,
        ),
        ...viewModel.textBlocks.map((block) {
          final List<Point<int>> cornerPoints = block.cornerPoints;
          final double left = cornerPoints[0].x.toDouble();
          final double top = cornerPoints[0].y.toDouble();

          double scale = 0;

          if (viewModel.mediaWidth != null) {
            scale = (width / viewModel.mediaWidth!.toDouble());
          } else {
            scale = 0.9;
          }

          return Positioned(
            left: left * scale,
            top: top * scale,
            child: Container(
              color: Colors.white,
              child: SelectableText(
                block.text,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildText(double width, AddViewModel viewModel) {
    return Padding(
      padding: const ProductPadding.allLow(),
      child: SizedBox(
        child: Container(
          width: width,
          decoration: ProductBoxDecorations.addWarningDecoration,
          child: Padding(
            padding: const ProductPadding.allLow(),
            child: SelectableText(viewModel.textFromMedia ?? ""),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndSaveButton(BuildContext context) {
    return Padding(
      padding: const ProductPadding.allLow(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            ProductStrings.photoContent,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          ElevatedButton(
              onPressed: () async {
                var result =
                    await context.read<AddViewModel>().addImagetoLocal();
                if (context.mounted) {
                  if (result != 0) {
                    CustomSnackbar.show(context,
                        message: ProductStrings.addSuccess,
                        backgroundColor: Colors.green);
                  } else {
                    CustomSnackbar.show(context,
                        message: ProductStrings.addError,
                        backgroundColor: Colors.red);
                  }
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const HomeView()));
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(Icons.save),
                  Text(ProductStrings.saveLocalButtonText)
                ],
              ))
        ],
      ),
    );
  }

  Widget _buildSelectPhotoContainer(BuildContext context) {
    return Padding(
      padding: const ProductPadding.allHigh(),
      child: Container(
          decoration: ProductBoxDecorations.addWarningDecoration,
          child: Padding(
            padding: const ProductPadding.allHigh(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.warning),
                Text(
                  ProductStrings.selectPhoto,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          )),
    );
  }
}
