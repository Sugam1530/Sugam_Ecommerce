import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugam_ecommerce/Utils/SnackbarUtils.dart';
import 'package:sugam_ecommerce/View-Model/ProductListViewModel.dart';

class ProductDetailsPage extends StatelessWidget {
  final int id;
  final String imageUrl;
  final String name;
  final double price;
  final String description;

  ProductDetailsPage({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.description,
  });

  final ProductListViewModel productListController =
      Get.put(ProductListViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProductDetailsAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductImageWidget(),
              const SizedBox(height: 20),
              ProductNameWidget(),
              const SizedBox(height: 10),
              ProductPriceWidget(),
              const SizedBox(height: 20),
              const Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ProductDescriptionWidget(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar ProductDetailsAppBar() {
    return AppBar(
      title: const Text('Product Name'),
      actions: [
        Obx(
              () => productListController.isLoading.value
              ? const Center()
              : IconButton(
            icon: productListController.wishList.contains(id)
                ? const Icon(
              Icons.favorite_outlined,
              color: Colors.red,
            )
                : const Icon(Icons.favorite_border),
            onPressed: () {
              if (productListController.wishList.contains(id)) {
                productListController.removeFromWishlist(id);
                SnackbarUtils.showFloatingSnackbar('Wishlist', 'Product removed from your wishlist');
              } else {
                productListController.addToWishlist(id);
                SnackbarUtils.showFloatingSnackbar('Wishlist', 'Product added in your wishlist');
              }
            },
          ),
        ),
      ],
    );
  }

  Widget ProductImageWidget() {
    return Center(
      child: Image.network(
        imageUrl,
        height: 200,
        width: 200,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget ProductNameWidget() {
    return Text(
      name,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget ProductPriceWidget() {
    return Text(
      '₹$price',
      style: const TextStyle(fontSize: 20, color: Colors.green),
    );
  }

  Widget ProductDescriptionWidget() {
    return Text(
      description,
      style: const TextStyle(fontSize: 16),
    );
  }
}
