// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sugam_ecommerce/Controllers/ProductListController.dart';
import 'package:sugam_ecommerce/Pages/productDetailsPage.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ProductListController productListController = Get.put(ProductListController());
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    productListController.fetchProducts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (!productListController.isLoading.value && productListController.hasMoreProducts.value) {
          productListController.fetchProducts(page: productListController.currentPage.value + 1);
        }
      }
    });

    _searchController.addListener(() {
      productListController.updateSearchQuery(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Listing'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Products',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(
                  () => productListController.isLoading.value && productListController.filteredProducts.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                controller: _scrollController,
                itemCount: productListController.filteredProducts.length + 1, // Add one for the loading indicator
                itemBuilder: (context, index) {
                  if (index < productListController.filteredProducts.length) {
                    final product = productListController.filteredProducts[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: ProductDetailsPage(
                              id: product.id,
                              imageUrl: product.image,
                              price: product.price,
                              name: product.title,
                              description: product.description,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: ListTile(
                          leading: Image.network(
                            product.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(product.title),
                          subtitle: Text('₹${product.price}'),
                        ),
                      ),
                    );
                  } else {
                    return productListController.hasMoreProducts.value
                        ? const Center(child: CircularProgressIndicator())
                        : const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
