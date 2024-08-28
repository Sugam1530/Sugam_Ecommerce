import 'package:get/get.dart';
import '../Models/ProductModel.dart';
import '../Repository/ProductRepository.dart';

class ProductListViewModel extends GetxController {
  var products = <ProductModel>[].obs;
  var filteredProducts = <ProductModel>[].obs;
  var isLoading = false.obs;
  var hasMoreProducts = true.obs;
  var currentPage = 1.obs;
  var pageSize = 10.obs;
  List<int> wishList = <int>[].obs;
  var searchQuery = ''.obs;

  final ProductRepository _repository = ProductRepository();

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts({int page = 1}) async {
    if (isLoading.value) return;

    isLoading(true);
    try {
      final productList = await _repository.fetchProducts();
      final int startIndex = (page - 1) * pageSize.value;

      final newProducts = productList
          .skip(startIndex)
          .take(pageSize.value)
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
    } catch (e) {
      print('An error occurred: $e');
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
          .where((product) =>
          product.title.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }
  }
}
