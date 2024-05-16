import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_text_recognition_app/features/add/view/add_view.dart';
import 'package:flutter_text_recognition_app/features/detail/view/detail_view.dart';
import 'package:flutter_text_recognition_app/features/home/viewModel/home_view_model.dart';
import 'package:flutter_text_recognition_app/product/constant/product_box_decorations.dart';
import 'package:flutter_text_recognition_app/product/constant/product_padding.dart';
import 'package:flutter_text_recognition_app/product/constant/product_strings.dart';
import 'package:flutter_text_recognition_app/product/util/custom_snackbar.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: Text(ProductStrings.homeAppBar),
        ),
        floatingActionButton: _addFAButton(context),
        body: _bodyBuild(width, height));
  }

  Widget _addFAButton(BuildContext context) {
    return FloatingActionButton.extended(
      label: Text(ProductStrings.addButtonText),
      icon: const Icon(Icons.add),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddView(),
            ));
      },
    );
  }

  Widget _bodyBuild(double width, double height) {
    return Padding(
        padding: const ProductPadding.allHigh(),
        child: Consumer<HomeViewModel>(
          builder: (context, viewModel, _) {
            viewModel.getImages();
            return _buildImagesBuilder(viewModel, width, height);
          },
        ));
  }

  Widget _buildImagesBuilder(
      HomeViewModel viewModel, double width, double height) {
    return ListView.builder(
      itemCount: viewModel.images?.length ?? 0,
      itemBuilder: (context, index) {
        return Padding(
          padding: const ProductPadding.bottomLow(),
          child: _buildImageContainer(width, height, viewModel, index, context),
        );
      },
    );
  }

  Widget _buildImageContainer(double width, double height,
      HomeViewModel viewModel, int index, BuildContext context) {
    return SizedBox(
      width: width,
      height: height * 0.15,
      child: Container(
        decoration: ProductBoxDecorations.addWarningDecoration,
        child: Padding(
          padding: const ProductPadding.allMoreLow(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildImage(width, height, viewModel, index),
              _buildDeleteButton(width, height, context, viewModel, index),
              _buildGoDetailButton(width, height, context, viewModel, index),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoDetailButton(double width, double height, BuildContext context,
      HomeViewModel viewModel, int index) {
    return SizedBox(
      width: width * 0.15,
      height: height * 0.08,
      child: Card(
        color: Colors.grey[400],
        elevation: 2,
        child: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailView(
                      image: viewModel.images?[index].file ?? File(""),
                    ),
                  ));
            },
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
            )),
      ),
    );
  }

  Widget _buildDeleteButton(double width, double height, BuildContext context,
      HomeViewModel viewModel, int index) {
    return SizedBox(
      width: width * 0.15,
      height: height * 0.08,
      child: Card(
        color: Colors.grey[400],
        elevation: 2,
        child: IconButton(
            onPressed: () async {
              var result = await context
                  .read<HomeViewModel>()
                  .imageDelete(viewModel.images?[index].id ?? 0);

              if (result != 0) {
                if (context.mounted) {
                  CustomSnackbar.show(context,
                      message: ProductStrings.deleteSuccess,
                      backgroundColor: Colors.red);
                }
              }
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.black,
            )),
      ),
    );
  }

  Widget _buildImage(
      double width, double height, HomeViewModel viewModel, int index) {
    return SizedBox(
      width: width * 0.25,
      height: height,
      child: Image.file(viewModel.images?[index].file ?? File("")),
    );
  }
}
