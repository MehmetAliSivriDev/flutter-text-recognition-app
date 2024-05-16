import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_text_recognition_app/product/constant/product_box_decorations.dart';
import 'package:flutter_text_recognition_app/product/constant/product_padding.dart';
import 'package:provider/provider.dart';
import '../viewModel/detail_view_model.dart';

class DetailView extends StatelessWidget {
  const DetailView({super.key, required this.image});

  final File image;

  @override
  Widget build(BuildContext context) {
    context.read<DetailViewModel>().imageProcessing(selectedImage: image);

    var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
      ),
      body: _buildBody(width),
    );
  }

  Widget _buildBody(double width) {
    return SingleChildScrollView(
      child: Consumer<DetailViewModel>(
        builder: (context, viewModel, _) {
          return _buildtextsFromImage(viewModel, width, context);
        },
      ),
    );
  }

  Widget _buildtextsFromImage(
      DetailViewModel viewModel, double width, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImage(viewModel, width, context),
        _buildTitle(context),
        _buildText(width, viewModel),
      ],
    );
  }

  Widget _buildImage(
      DetailViewModel viewModel, double width, BuildContext context) {
    return Stack(
      children: [
        Image.file(
          viewModel.image,
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

  Widget _buildText(double width, DetailViewModel viewModel) {
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

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const ProductPadding.allLow(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Photo Content",
            style: Theme.of(context).textTheme.titleLarge,
          )
        ],
      ),
    );
  }
}
