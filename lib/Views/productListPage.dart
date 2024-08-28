import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugam_ecommerce/View-Model/ProductListViewModel.dart';
import 'package:page_transition/page_transition.dart';
import 'productDetailsPage.dart';

class ProductListPage extends StatelessWidget {
  final ProductListViewModel productListViewModel =
      Get.put(ProductListViewModel());

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!productListViewModel.isLoading.value &&
            productListViewModel.hasMoreProducts.value) {
          productListViewModel.fetchProducts(
              page: productListViewModel.currentPage.value + 1);
        }
      }
    });

    _searchController.addListener(() {
      productListViewModel.updateSearchQuery(_searchController.text);
    });

    return Scaffold(
      appBar: ProductListingAppBar(),
      body: Column(
        children: [
          SearchBar(),
          ProductList(),
        ],
      ),
    );
  }

  AppBar ProductListingAppBar() {
    return AppBar(
      title: const Text('Product Listing'),
    );
  }

  Widget SearchBar() {
    return Padding(
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
    );
  }

  Widget ProductList() {
    return Expanded(
      child: Obx(() {
        if (productListViewModel.isLoading.value &&
            productListViewModel.filteredProducts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            controller: _scrollController,
            itemCount: productListViewModel.filteredProducts.length +
                1, // Add one for the loading indicator
            itemBuilder: (context, index) {
              if (index < productListViewModel.filteredProducts.length) {
                final product =
                productListViewModel.filteredProducts[index];
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
                    margin: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 10),
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
                return productListViewModel.hasMoreProducts.value
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink();
              }
            },
          );
        }
      }),
    );
  }
}
