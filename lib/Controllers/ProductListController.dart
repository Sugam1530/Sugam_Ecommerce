import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sugam_ecommerce/Utils/AppUtils.dart';
import 'package:sugam_ecommerce/Utils/SnackbarUtils.dart';
import 'dart:convert';

import '../Models/ProductModel.dart';

class ProductListController extends GetxController {
  var products = <ProductModel>[].obs;
  var filteredProducts = <ProductModel>[].obs;
  var isLoading = false.obs;
  var hasMoreProducts = true.obs;
  var currentPage = 1.obs;
  var pageSize = 10.obs;
  var searchQuery = ''.obs;

  List<int> wishList = <int>[].obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts({int page = 1}) async {
    if (isLoading.value) return;

    isLoading(true);
    try {
      final response = await http.get(Uri.parse(AppConstants.PRODUCT_LIST));

      if (response.statusCode == 200) {
        final List<dynamic> productList = json.decode(response.body);
        final int startIndex = (page - 1) * pageSize.value;

        final List<ProductModel> newProducts = productList
            .skip(startIndex)
            .take(pageSize.value)
            .map((json) => ProductModel.fromJson(json))
            .toList();

        if (newProducts.isEmpty) {
          hasMoreProducts(false);
        } else {
          if (page == 1) {
            products.value = newProducts;
          } else {
            products.addAll(newProducts);
          }
          currentPage(page);
        }
        _filterProducts();
      } else {
        SnackbarUtils.showFloatingSnackbar('Error', 'Failed to load products');
      }
    } catch (e) {
      debugPrint('An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  void addToWishlist(int productId) {
    wishList.add(productId);
    update();
  }

  void removeFromWishlist(int productId) {
    wishList.remove(productId);
    update();
  }

  void updateSearchQuery(String query) {
    searchQuery(query);
    _filterProducts();
  }

  void _filterProducts() {
    if (searchQuery.value.isEmpty) {
      filteredProducts.value = products;
    } else {
      filteredProducts.value = products
          .where((product) => product.title
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase()))
          .toList();
    }
  }
}
