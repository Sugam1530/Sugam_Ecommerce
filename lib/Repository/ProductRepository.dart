import 'package:dio/dio.dart';
import 'package:sugam_ecommerce/Utils/AppUtils.dart';
import '../Models/ProductModel.dart';

class ProductRepository {
  final Dio _dio = Dio();

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await _dio.get(AppConstants.PRODUCT_LIST);
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => ProductModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      rethrow;
    }
  }
}
